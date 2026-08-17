from typing import Any, Dict
from fastapi import APIRouter, Body

from app.firebase_service import repository

router = APIRouter(prefix='/patients', tags=['patients'])


@router.get('/')
def list_patients():
    return repository.list('patients')


@router.post('/')
def create_patient(payload: Dict[str, Any] = Body(...)):
    return repository.upsert('patients', payload)
