from typing import Any, Dict
from fastapi import APIRouter, Body

from app.firebase_service import repository

router = APIRouter(prefix='/notifications', tags=['notifications'])


@router.get('/')
def list_notifications():
    return repository.list('notifications')


@router.post('/')
def create_notification(payload: Dict[str, Any] = Body(...)):
    return repository.upsert('notifications', payload)
