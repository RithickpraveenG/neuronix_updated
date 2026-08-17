# Database Schema

## Collections / Tables

### Patient

- id: string
- fullName: string
- email: string
- phone: string
- dateOfBirth: string
- gender: string
- address: string
- createdAt: timestamp
- updatedAt: timestamp

### Doctor

- id: string
- fullName: string
- email: string
- specialization: string
- licenseNumber: string
- hospital: string
- createdAt: timestamp

### Appointment

- id: string
- patientId: string
- doctorId: string
- appointmentDate: timestamp
- status: string
- notes: string

### Medical Report

- id: string
- patientId: string
- reportType: string
- uploadedAt: timestamp
- fileUrl: string
- extractedText: string
- aiSummary: string

### Prescription

- id: string
- patientId: string
- doctorId: string
- medication: string
- dosage: string
- instructions: string
- issuedAt: timestamp

### Health History

- id: string
- patientId: string
- eventType: string
- description: string
- createdAt: timestamp

### AI Prediction

- id: string
- patientId: string
- modelType: string
- prediction: string
- confidence: float
- createdAt: timestamp

### Notification

- id: string
- userId: string
- title: string
- body: string
- isRead: boolean
- createdAt: timestamp
