# System Architecture

## Architectural Style

Neuronix follows a modular, service-oriented architecture built around:

- Flutter frontend for patient, doctor, and admin experiences
- FastAPI backend for business logic and API orchestration
- Firebase for authentication, storage, and notification services
- AI services for OCR, NLP, prediction, and decision support

## High-Level Components

- Client Layer: Flutter mobile/web application
- API Layer: FastAPI routers and controllers
- Service Layer: authentication, appointment, report, notification, and AI services
- Data Layer: Firestore collections + object storage
- AI Layer: symptom interpretation, report parsing, risk scoring

## Flow

```mermaid
flowchart TD
    A[Patient / Doctor / Admin] --> B[Flutter UI]
    B --> C[FastAPI Backend]
    C --> D[Firebase Auth]
    C --> E[Firestore Database]
    C --> F[Firebase Storage]
    C --> G[AI Engine]
    G --> H[Clinical Insights]
    H --> B
```

## Design Principles

- Clean architecture
- MVVM for UI state management
- SOLID principles
- Secure by default
- Explainable AI outputs
