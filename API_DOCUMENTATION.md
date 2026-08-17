# API Documentation

## Authentication Endpoints

### POST /auth/register
Registers a new patient or doctor.

### POST /auth/login
Authenticates a user and returns a token.

### POST /auth/logout
Revokes the active session.

## Patient Endpoints

### GET /patients/{id}
Returns patient profile information.

### PUT /patients/{id}
Updates patient profile.

### POST /patients/{id}/reports
Uploads a medical report.

### GET /patients/{id}/history
Returns health timeline events.

## Doctor Endpoints

### GET /doctors/{id}
Returns doctor profile.

### GET /doctors/{id}/patients
Returns assigned patient records.

### POST /doctors/{id}/prescriptions
Creates a prescription.

## AI Endpoints

### POST /ai/symptom-check
Returns predicted concerns from symptoms.

### POST /ai/report-analysis
Processes uploaded report text and returns summary.

### POST /ai/risk-score
Calculates a patient risk estimate.

## Appointment Endpoints

### POST /appointments
Creates a new appointment.

### GET /appointments/{id}
Fetches appointment details.

## Notification Endpoints

### GET /notifications/{userId}
Returns notifications for a user.

### POST /notifications
Creates a system notification.
