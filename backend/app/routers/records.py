from fastapi import APIRouter

from app.firebase_service import repository

router = APIRouter(prefix='/records', tags=['records'])


@router.post('/patient')
def create_patient_record(payload: dict[str, str]):
    item = {
        'id': payload.get('id', 'patient-1'),
        'name': payload.get('name', 'Patient'),
        'email': payload.get('email', ''),
        'role': 'patient',
    }
    return repository.upsert('patients', item)


@router.post('/doctor')
def create_doctor_record(payload: dict[str, str]):
    item = {
        'id': payload.get('id', 'doctor-1'),
        'name': payload.get('name', 'Doctor'),
        'email': payload.get('email', ''),
        'role': 'doctor',
    }
    return repository.upsert('doctors', item)


@router.post('/prediction')
def create_prediction(payload: dict[str, str]):
    item = {
        'id': payload.get('id', 'prediction-1'),
        'prediction': payload.get('prediction', 'monitor'),
        'confidence': payload.get('confidence', '0.6'),
    }
    return repository.upsert('predictions', item)


@router.post('/report')
def create_report(payload: dict[str, str]):
    item = {
        'id': payload.get('id', 'report-1'),
        'text': payload.get('text', ''),
        'summary': payload.get('summary', ''),
    }
    return repository.upsert('reports', item)


@router.get('/patient')
def list_patient_records():
    return repository.list('patients')


@router.get('/doctor')
def list_doctor_records():
    return repository.list('doctors')


@router.get('/prediction')
def list_prediction_records():
    return repository.list('predictions')


@router.get('/report')
def list_report_records():
    return repository.list('reports')
