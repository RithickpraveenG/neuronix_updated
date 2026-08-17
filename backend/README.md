# Neuronix Backend

This backend provides the REST API for the Neuronix healthcare platform.

## Run locally

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\\Scripts\\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```
