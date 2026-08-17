"""Production medical NLP service using spaCy for entity extraction and report summarization."""

import logging
from typing import Any, Dict, List
import spacy

logger = logging.getLogger(__name__)

# Initialize spaCy pipeline with graceful fallback
try:
    nlp = spacy.load("en_core_web_sm")
except Exception:
    nlp = spacy.blank("en")

# Clinical terms dictionary for medical NER enrichment
SYMPTOM_DICTIONARY = {
    'headache', 'fever', 'cough', 'fatigue', 'dizziness', 'chest pain',
    'shortness of breath', 'nausea', 'vomiting', 'abdominal pain', 'back pain',
    'joint pain', 'palpitations', 'rash', 'sore throat', 'chills', 'sweats',
    'diarrhea', 'constipation', 'swelling', 'numbness', 'weakness'
}

DIAGNOSIS_DICTIONARY = {
    'hypertension', 'pneumonia', 'diabetes', 'arrhythmia', 'bronchitis',
    'migraine', 'asthma', 'gastritis', 'coronary artery disease', 'infection',
    'influenza', 'anemia', 'hypothyroidism', 'stroke'
}

MEDICATION_DICTIONARY = {
    'aspirin', 'amoxicillin', 'metformin', 'lisinopril', 'ibuprofen',
    'paracetamol', 'atorvastatin', 'albuterol', 'omeprazole', 'losartan',
    'azithromycin', 'insulin', 'hydrochlorothiazide'
}

LAB_KEYWORDS = {
    'blood pressure', 'glucose', 'hemoglobin', 'wbc', 'rbc', 'platelets',
    'cholesterol', 'creatinine', 'heart rate', 'spo2', 'pulse', 'troponin'
}

ANATOMY_KEYWORDS = {
    'chest', 'head', 'abdomen', 'lungs', 'heart', 'liver', 'kidney', 'brain',
    'stomach', 'spine', 'joint', 'throat', 'artery'
}


def extract_symptoms_and_keywords(text: str) -> Dict[str, Any]:
    """Extract clinical entities (symptoms, diagnoses, medications, lab values, anatomy) using spaCy."""
    if not text or not text.strip():
        return {
            'symptoms': [],
            'diagnoses': [],
            'medications': [],
            'lab_values': [],
            'anatomical_sites': [],
            'keywords': [],
            'entities': []
        }

    doc = nlp(text)
    normalized_text = text.lower()

    # Rule & dictionary matched entities
    symptoms = [s for s in SYMPTOM_DICTIONARY if s in normalized_text]
    diagnoses = [d for d in DIAGNOSIS_DICTIONARY if d in normalized_text]
    medications = [m for m in MEDICATION_DICTIONARY if m in normalized_text]
    labs = [l for l in LAB_KEYWORDS if l in normalized_text]
    anatomy = [a for a in ANATOMY_KEYWORDS if a in normalized_text]

    # spaCy Named Entities
    spacy_entities = []
    for ent in doc.ents:
        spacy_entities.append({
            'text': ent.text,
            'label': ent.label_
        })

    # Extracted keywords (nouns, proper nouns, adjectives)
    keywords = list({
        token.text.lower()
        for token in doc
        if not token.is_stop and token.is_alpha and len(token.text) > 3
    })

    return {
        'symptoms': symptoms,
        'diagnoses': diagnoses,
        'medications': medications,
        'lab_values': labs,
        'anatomical_sites': anatomy,
        'keywords': sorted(keywords)[:20],
        'entities': spacy_entities
    }


def summarize_medical_report(text: str, max_sentences: int = 3) -> str:
    """Generate an extractive medical report summary based on clinical entity importance."""
    if not text or not text.strip():
        return 'No report content available to summarize.'

    doc = nlp(text)
    sentences = [sent.text.strip() for sent in doc.sents if len(sent.text.strip()) > 10]

    if not sentences:
        sentences = [s.strip() for s in text.split('.') if len(s.strip()) > 10]

    if len(sentences) <= max_sentences:
        return ' '.join(sentences)

    # Score sentences based on medical keyword frequency
    sentence_scores = []
    for sent in sentences:
        sent_lower = sent.lower()
        score = 0
        for collection in [SYMPTOM_DICTIONARY, DIAGNOSIS_DICTIONARY, MEDICATION_DICTIONARY, LAB_KEYWORDS]:
            for term in collection:
                if term in sent_lower:
                    score += 2
        sentence_scores.append((score, sent))

    # Rank and select top sentences maintaining narrative order
    ranked = sorted(sentence_scores, key=lambda x: x[0], reverse=True)[:max_sentences]
    top_sentences = [item[1] for item in ranked]

    # Preserve original order
    ordered_summary = [s for s in sentences if s in top_sentences]
    return ' '.join(ordered_summary)
