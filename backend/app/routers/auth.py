from typing import Any, Dict
from fastapi import APIRouter, Body

from app.firebase_service import repository

router = APIRouter(prefix='/auth', tags=['auth'])


@router.post('/login')
def login(payload: Dict[str, Any] = Body(...)):
    email = payload.get('email', '')
    role = 'doctor' if 'doctor' in email.lower() else payload.get('role', 'patient')
    user_id = f"user-{email.replace('@', '_').replace('.', '_')}"
    
    user_record = {
        'id': user_id,
        'email': email,
        'role': role,
        'status': 'active'
    }
    repository.upsert('users', user_record)
    
    return {
        'message': 'login success',
        'email': email,
        'role': role,
        'token': f'firebase-auth-token-{user_id}',
        'user': user_record
    }


@router.post('/register')
def register(payload: Dict[str, Any] = Body(...)):
    email = payload.get('email', '')
    role = payload.get('role', 'patient')
    user_id = f"user-{email.replace('@', '_').replace('.', '_')}"

    user_record = {
        'id': user_id,
        'email': email,
        'role': role,
        'status': 'active'
    }
    repository.upsert('users', user_record)

    # Automatically seed patient or doctor collection
    if role == 'doctor':
        repository.upsert('doctors', {'id': user_id, 'name': email.split('@')[0], 'email': email, 'specialization': 'General Practice'})
    else:
        repository.upsert('patients', {'id': user_id, 'name': email.split('@')[0], 'email': email, 'status': 'stable'})

    return {
        'message': 'registration success',
        'email': email,
        'role': role,
        'token': f'firebase-auth-token-{user_id}',
        'user': user_record
    }
