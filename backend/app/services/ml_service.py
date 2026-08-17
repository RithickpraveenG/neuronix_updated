"""Scikit-learn disease prediction service with confidence scores and department recommendations."""

import logging
from typing import Any, Dict, List
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline

logger = logging.getLogger(__name__)

# Representative training corpus mapping clinical symptom descriptions to diagnoses & departments
TRAINING_DATA = [
    # Pulmonology
    ("fever cough shortness of breath chest pain chills", "Pneumonia", "Pulmonology", "High"),
    ("cough wheezing shortness of breath chest tightness", "Asthma / Bronchitis", "Pulmonology", "Moderate"),
    ("cough sore throat fever chills fatigue body ache", "Viral Respiratory Infection", "General Medicine", "Moderate"),
    
    # Cardiology
    ("chest pain shortness of breath dizziness palpitations sweating", "Coronary Artery Disease / Angina", "Cardiology", "Critical"),
    ("palpitations dizziness shortness of breath fatigue chest tightness", "Cardiac Arrhythmia", "Cardiology", "High"),
    ("headache dizziness elevated blood pressure chest pressure", "Hypertensive Concern", "Cardiology", "Moderate"),

    # Neurology
    ("headache dizziness nausea sensitivity to light numbness", "Migraine / Neurological Assessment", "Neurology", "Moderate"),
    ("severe headache weakness numbness dizziness vision loss", "Cerebrovascular Risk / Stroke Warning", "Neurology", "Critical"),

    # Gastroenterology
    ("abdominal pain nausea vomiting diarrhea fever", "Gastroenteritis / Acute Gastritis", "Gastroenterology", "Moderate"),
    ("heartburn abdominal pain nausea chest tightness", "Gastroesophageal Reflux", "Gastroenterology", "Low"),

    # General Medicine
    ("fatigue dizziness dehydration weakness chills", "Systemic Exhaustion / Dehydration", "General Medicine", "Low"),
    ("joint pain fever rash fatigue swelling", "Inflammatory / Rheumatic Assessment", "Rheumatology", "Moderate"),
]


class DiseaseRiskService:
    """Production Scikit-learn disease prediction pipeline."""

    def __init__(self) -> None:
        self._corpus = [item[0] for item in TRAINING_DATA]
        self._labels = [item[1] for item in TRAINING_DATA]
        
        self.dept_map = {item[1]: item[2] for item in TRAINING_DATA}
        self.risk_map = {item[1]: item[3] for item in TRAINING_DATA}

        # Fit Scikit-learn Pipeline
        self.pipeline = Pipeline([
            ('vectorizer', CountVectorizer(binary=True)),
            ('classifier', MultinomialNB(alpha=0.5))
        ])
        self.pipeline.fit(self._corpus, self._labels)

    def predict(self, symptoms: List[str]) -> Dict[str, Any]:
        """Predict condition, confidence score, risk severity, and target clinical department."""
        if not symptoms:
            return {
                'prediction': 'Routine Health Evaluation',
                'confidence': 0.50,
                'risk_score': 0.20,
                'risk_level': 'Low',
                'recommended_department': 'General Medicine',
                'differentials': []
            }

        symptom_str = " ".join(symptoms).lower()
        
        # Predict probabilities across classes
        classes = self.pipeline.classes_
        probs = self.pipeline.predict_proba([symptom_str])[0]

        # Top prediction
        top_idx = int(np.argmax(probs))
        top_prediction = str(classes[top_idx])
        top_confidence = round(float(probs[top_idx]), 2)

        # Build differential diagnosis list
        differentials = []
        sorted_indices = np.argsort(probs)[::-1]
        for idx in sorted_indices[:3]:
            cls_name = str(classes[idx])
            differentials.append({
                'condition': cls_name,
                'probability': round(float(probs[idx]), 2),
                'department': self.dept_map.get(cls_name, 'General Medicine')
            })

        dept = self.dept_map.get(top_prediction, 'General Medicine')
        risk_level = self.risk_map.get(top_prediction, 'Moderate')
        
        risk_score_numeric = {
            'Low': 0.25,
            'Moderate': 0.55,
            'High': 0.80,
            'Critical': 0.95
        }.get(risk_level, 0.50)

        # Adjust score slightly based on confidence
        final_risk_score = round(min(0.99, risk_score_numeric * (0.8 + 0.2 * top_confidence)), 2)

        return {
            'prediction': top_prediction,
            'confidence': top_confidence,
            'risk_score': final_risk_score,
            'risk_level': risk_level,
            'recommended_department': dept,
            'differentials': differentials
        }
