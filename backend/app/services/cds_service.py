"""Clinical Decision Support (CDS) synthesis engine combining OCR, NLP, ML predictions, and Patient History."""

import logging
from typing import Any, Dict, List, Optional
from app.services.ml_service import DiseaseRiskService
from app.services.nlp_service import extract_symptoms_and_keywords, summarize_medical_report
from app.services.ocr_service import extract_text_from_report

logger = logging.getLogger(__name__)


class ClinicalDecisionSupportService:
    """Combines OCR, spaCy NLP, Scikit-learn ML, and Patient History into actionable CDS reports."""

    def __init__(self) -> None:
        self.ml_service = DiseaseRiskService()

    def evaluate(
        self,
        report_text: str = '',
        symptoms: Optional[List[str]] = None,
        patient_history: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """Synthesize multi-modal medical inputs into a structured CDS assessment."""
        symptoms = symptoms or []
        patient_history = patient_history or {}

        # 1. OCR Text Extraction & Normalization
        clean_text = extract_text_from_report(report_text)

        # 2. spaCy NLP Medical Entity Extraction & Summarization
        nlp_res = extract_symptoms_and_keywords(clean_text)
        report_summary = summarize_medical_report(clean_text)

        # Combine manually declared symptoms with NLP-discovered symptoms
        all_symptoms = list(set([s.lower() for s in symptoms] + nlp_res.get('symptoms', [])))

        # 3. Scikit-learn Disease Prediction
        prediction_res = self.ml_service.predict(all_symptoms)

        # 4. Patient History Risk Factor Integration
        history_flags = []
        past_conditions = patient_history.get('past_conditions', [])
        allergies = patient_history.get('allergies', [])
        age = patient_history.get('age', 35)

        if 'hypertension' in past_conditions and 'chest pain' in all_symptoms:
            history_flags.append('Cardiovascular Risk: Patient has prior hypertension and presenting chest pain.')
        if 'asthma' in past_conditions and ('cough' in all_symptoms or 'shortness of breath' in all_symptoms):
            history_flags.append('Respiratory Exacerbation Risk: Prior asthma history.')
        if age > 60:
            history_flags.append('Geriatric Consideration: Patient age > 60.')

        # 5. Triage Level Determination
        risk_level = prediction_res.get('risk_level', 'Moderate')
        if risk_level == 'Critical' or 'chest pain' in all_symptoms or 'numbness' in all_symptoms:
            triage_level = 'Urgent (Red)'
            triage_code = 'URGENT'
        elif risk_level == 'High' or len(history_flags) > 0:
            triage_level = 'Priority (Yellow)'
            triage_code = 'PRIORITY'
        else:
            triage_level = 'Routine (Green)'
            triage_code = 'ROUTINE'

        # 6. Actionable Clinical Guidance & Suggested Tests
        suggested_tests = []
        dept = prediction_res.get('recommended_department', 'General Medicine')

        if dept == 'Cardiology':
            suggested_tests.extend(['12-Lead ECG', 'Serum Troponin I/T', 'Echocardiogram'])
        elif dept == 'Pulmonology':
            suggested_tests.extend(['Chest X-Ray (PA View)', 'Spirometry', 'Pulse Oximetry'])
        elif dept == 'Neurology':
            suggested_tests.extend(['Non-contrast Head CT / Brain MRI', 'Neurological Reflex Exam'])
        elif dept == 'Gastroenterology':
            suggested_tests.extend(['Abdominal Ultrasound', 'Comprehensive Metabolic Panel'])
        else:
            suggested_tests.extend(['Complete Blood Count (CBC)', 'Basic Metabolic Panel'])

        clinical_guidance = (
            f"CDS Assessment: {prediction_res.get('prediction')} (Confidence: {prediction_res.get('confidence')*100:.0f}%). "
            f"Triage: {triage_level}. Recommended Specialty: {dept}. "
            f"Clinician review required before confirming treatment plan."
        )

        return {
            'triage_code': triage_code,
            'triage_level': triage_level,
            'extracted_report_text': clean_text,
            'report_summary': report_summary,
            'nlp_entities': nlp_res,
            'combined_symptoms': all_symptoms,
            'prediction': prediction_res,
            'patient_history_alerts': history_flags,
            'suggested_diagnostic_tests': suggested_tests,
            'recommended_department': dept,
            'clinical_guidance': clinical_guidance
        }
