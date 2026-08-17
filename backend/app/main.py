from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers.ai import router as ai_router
from app.routers.appointments import router as appointments_router
from app.routers.auth import router as auth_router
from app.routers.doctors import router as doctors_router
from app.routers.health import router as health_router
from app.routers.notifications import router as notifications_router
from app.routers.patients import router as patients_router
from app.routers.records import router as records_router

app = FastAPI(title='Neuronix API', version='1.0.0')

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(health_router)
app.include_router(auth_router)
app.include_router(ai_router)
app.include_router(patients_router)
app.include_router(doctors_router)
app.include_router(appointments_router)
app.include_router(notifications_router)
app.include_router(records_router)


@app.get('/')
def root():
    return {'message': 'Neuronix API is running'}
