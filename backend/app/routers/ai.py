from typing import Any, Dict, List, Optional
from fastapi import APIRouter, Body

from app.services.cds_service import ClinicalDecisionSupportService
from app.services.ml_service import DiseaseRiskService
from app.services.nlp_service import extract_symptoms_and_keywords, summarize_medical_report
from app.services.ocr_service import extract_text_from_report

router = APIRouter(prefix='/ai', tags=['ai'])
cds_engine = ClinicalDecisionSupportService()
ml_engine = DiseaseRiskService()


@router.post('/analyze-report')
def analyze_report(payload: Dict[str, Any] = Body(...)):
    """Run OCR, spaCy NLP entity extraction, summarization, and disease prediction on report text."""
    report_text = payload.get('report_text', '')
    text = extract_text_from_report(report_text)
    nlp_result = extract_symptoms_and_keywords(text)
    summary = summarize_medical_report(text)
    prediction = ml_engine.predict(nlp_result.get('symptoms', []))

    return {
        'extracted_text': text,
        'summary': summary,
        'nlp_entities': nlp_result,
        'symptoms': nlp_result.get('symptoms', []),
        'keywords': nlp_result.get('keywords', []),
        'prediction': prediction,
        'note': 'AI suggestions are for clinician review only.',
    }


@router.post('/symptom-check')
def symptom_check(payload: Dict[str, Any] = Body(...)):
    """Predict disease risk and recommended department using Scikit-learn classifier."""
    symptoms = payload.get('symptoms', [])
    if isinstance(symptoms, str):
        symptoms = [s.strip() for s in symptoms.split(',') if s.strip()]
    
    prediction = ml_engine.predict(symptoms)
    return {
        'input_symptoms': symptoms,
        'prediction': prediction
    }


@router.post('/cds')
def clinical_decision_support(payload: Dict[str, Any] = Body(...)):
    """Generate comprehensive Clinical Decision Support (CDS) assessment combining OCR, spaCy NLP, ML, and Patient History."""
    report_text = payload.get('report_text', '')
    symptoms = payload.get('symptoms', [])
    patient_history = payload.get('patient_history', {})

    if isinstance(symptoms, str):
        symptoms = [s.strip() for s in symptoms.split(',') if s.strip()]

    assessment = cds_engine.evaluate(
        report_text=report_text,
        symptoms=symptoms,
        patient_history=patient_history
    )
    return assessment
