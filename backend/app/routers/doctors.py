from typing import Any, Dict
from fastapi import APIRouter, Body

from app.firebase_service import repository

router = APIRouter(prefix='/doctors', tags=['doctors'])


@router.get('/')
def list_doctors():
    return repository.list('doctors')


@router.post('/')
def create_doctor(payload: Dict[str, Any] = Body(...)):
    return repository.upsert('doctors', payload)
