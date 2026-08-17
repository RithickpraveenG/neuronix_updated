"""Comprehensive automated unit & integration test suite for Neuronix backend services."""

import sys
import os
import pytest
from fastapi.testclient import TestClient

# Ensure backend root is on sys.path for test discovery
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.main import app
from app.services.ocr_service import extract_text_from_report, extract_text_from_file
from app.services.nlp_service import extract_symptoms_and_keywords, summarize_medical_report
from app.services.ml_service import DiseaseRiskService
from app.services.cds_service import ClinicalDecisionSupportService
from app.firebase_service import repository

client = TestClient(app)


# --- 1. OCR Service Tests ---
def test_ocr_text_normalization():
    raw_text = "  Patient   presents  with   fever  and   cough.  "
    cleaned = extract_text_from_report(raw_text)
    assert cleaned == "Patient presents with fever and cough."


def test_ocr_file_auto_detection():
    txt_file = extract_text_from_file(b"Sample medical text report", "lab_report.txt")
    assert txt_file['source_type'] == 'text'
    assert "Sample medical text report" in txt_file['extracted_text']


# --- 2. spaCy NLP Service Tests ---
def test_spacy_nlp_entity_extraction():
    text = "Patient complains of chest pain, shortness of breath, and cough. History of hypertension."
    nlp_res = extract_symptoms_and_keywords(text)

    assert "chest pain" in nlp_res['symptoms']
    assert "shortness of breath" in nlp_res['symptoms']
    assert "hypertension" in nlp_res['diagnoses']
    assert len(nlp_res['keywords']) > 0


def test_spacy_report_summarization():
    long_report = (
        "Patient is a 55-year-old male presenting with chest pain and shortness of breath. "
        "Blood pressure is elevated at 150/90 mmHg. Heart rate is 88 bpm. "
        "EKG shows sinus rhythm with no acute ST changes. "
        "Recommend follow-up cardiology evaluation."
    )
    summary = summarize_medical_report(long_report, max_sentences=2)
    assert len(summary) > 0
    assert "chest pain" in summary or "cardiology" in summary


# --- 3. Scikit-learn ML Disease Prediction Tests ---
def test_scikit_learn_prediction_cardiology():
    ml_service = DiseaseRiskService()
    result = ml_service.predict(["chest pain", "shortness of breath", "dizziness"])

    assert result['prediction'] is not None
    assert 0.0 <= result['confidence'] <= 1.0
    assert result['recommended_department'] == 'Cardiology'
    assert result['risk_level'] in ['Critical', 'High', 'Moderate', 'Low']


def test_scikit_learn_prediction_pulmonology():
    ml_service = DiseaseRiskService()
    result = ml_service.predict(["fever", "cough", "chills", "shortness of breath"])

    assert result['recommended_department'] == 'Pulmonology'
    assert result['prediction'] is not None


# --- 4. Clinical Decision Support (CDS) Tests ---
def test_cds_service_evaluation():
    cds_service = ClinicalDecisionSupportService()
    assessment = cds_service.evaluate(
        report_text="Patient exhibits acute chest pain and elevated blood pressure.",
        symptoms=["chest pain", "dizziness"],
        patient_history={"past_conditions": ["hypertension"], "age": 62}
    )

    assert assessment['triage_code'] in ['URGENT', 'PRIORITY', 'ROUTINE']
    assert assessment['recommended_department'] == 'Cardiology'
    assert len(assessment['suggested_diagnostic_tests']) > 0
    assert len(assessment['patient_history_alerts']) > 0


# --- 5. Firebase Admin SDK Repository Tests ---
def test_firebase_repository_crud():
    test_patient = {"id": "test-p-100", "name": "Testing Patient", "status": "stable"}
    upserted = repository.upsert("patients", test_patient)
    assert upserted['id'] == "test-p-100"

    retrieved = repository.get("patients", "test-p-100")
    assert retrieved is not None
    assert retrieved['name'] == "Testing Patient"


# --- 6. FastAPI Router Integration Tests ---
def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["message"] == "Neuronix API is running"


def test_ai_analyze_report_endpoint():
    response = client.post(
        "/ai/analyze-report",
        json={"report_text": "Patient has severe headache, fever, and stiffness."}
    )
    assert response.status_code == 200
    data = response.json()
    assert "extracted_text" in data
    assert "nlp_entities" in data
    assert "prediction" in data


def test_ai_symptom_check_endpoint():
    response = client.post(
        "/ai/symptom-check",
        json={"symptoms": ["cough", "fever", "chest pain"]}
    )
    assert response.status_code == 200
    data = response.json()
    assert data["prediction"]["recommended_department"] in ["Pulmonology", "Cardiology", "General Medicine"]


def test_ai_cds_endpoint():
    response = client.post(
        "/ai/cds",
        json={
            "report_text": "Chest radiograph indicates mild pulmonary congestion.",
            "symptoms": ["shortness of breath", "cough"],
            "patient_history": {"past_conditions": ["asthma"], "age": 48}
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert "triage_code" in data
    assert "suggested_diagnostic_tests" in data
