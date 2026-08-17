from typing import Any, Dict
from fastapi import APIRouter, Body

from app.firebase_service import repository

router = APIRouter(prefix='/appointments', tags=['appointments'])


@router.get('/')
def list_appointments():
    return repository.list('appointments')


@router.post('/')
def create_appointment(payload: Dict[str, Any] = Body(...)):
    return repository.upsert('appointments', payload)
