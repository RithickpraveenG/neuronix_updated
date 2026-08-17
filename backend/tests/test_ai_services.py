from app.services.ocr_service import extract_text_from_report
from app.services.nlp_service import extract_symptoms_and_keywords


def test_extract_text_from_report_returns_content():
    text = extract_text_from_report('blood pressure 140/90 and headache')
    assert 'blood' in text.lower()


def test_extract_symptoms_and_keywords_returns_medical_terms():
    result = extract_symptoms_and_keywords('headache fever cough')
    assert 'fever' in result['symptoms']
    assert 'headache' in result['symptoms']
