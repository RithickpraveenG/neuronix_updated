# Installation

## Prerequisites

- Flutter SDK
- Python 3.10+
- Firebase project
- Render account for backend hosting

## Frontend Setup

```bash
flutter create .
flutter pub get
flutter run
```

## Backend Setup

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\\Scripts\\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

## Firebase Setup

1. Create a Firebase project
2. Enable Authentication
3. Enable Firestore
4. Enable Storage
5. Download service account and config files
