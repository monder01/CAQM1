/*users (Collection)
│
├── userId (Document)
│   ├── name
│   ├── email
│   ├── password
│   ├── role (Patient / Doctor / Admin)
│   └── phoneNumber
│
├── patients (Collection)
│   ├── patientId (Document)
│   │   ├── medicalHistory
│   │   ├── insuranceNumber
│   │   └── userRef → users/userId
│   │
│   ├── appointments (Sub-Collection)
│   ├── forms (Sub-Collection)
│   └── tokens (Sub-Collection)
│
├── doctors (Collection)
│   ├── doctorId (Document)
│   │   ├── specialization
│   │   ├── availabilitySchedule
│   │   └── userRef → users/userId
│   │
│   ├── appointments (Sub-Collection)
│   └── teleconsultations (Sub-Collection)
│
├── admins (Collection)
│   ├── adminId (Document)
│   │   ├── department
│   │   └── userRef → users/userId
│   │
│   ├── queueManagers (Sub-Collection)
│   └── reports (Sub-Collection)
│
appointments (Collection)
├── appointmentId (Document)
│   ├── patientRef → patients/patientId
│   ├── doctorRef → doctors/doctorId
│   ├── date
│   ├── time
│   ├── status (Scheduled / Completed / Canceled)
│   └── queueRef → queues/queueId
│
queues (Collection)
├── queueId (Document)
│   ├── name
│   ├── location
│   ├── currentPosition
│   └── managerRef → admins/adminId
│
tokens (Collection)
├── tokenId (Document)
│   ├── tokenNumber
│   ├── patientRef → patients/patientId
│   ├── queueRef → queues/queueId
│   └── status (Waiting / Called / Completed)
│
forms (Collection)
├── formId (Document)
│   ├── type (Insurance / MedicalHistory / Consent)
│   ├── content
│   ├── patientRef → patients/patientId
│   └── isValidated (Boolean)
│
notifications (Collection)
├── notificationId (Document)
│   ├── recipientRef → users/userId
│   ├── message
│   ├── timestamp
│   └── status (Read / Unread)
│
teleconsultations (Collection)
├── sessionId (Document)
│   ├── patientRef → patients/patientId
│   ├── doctorRef → doctors/doctorId
│   ├── startTime
│   ├── endTime
│   ├── messages (Array / Sub-Collection)
│   └── status (Active / Completed / Canceled)
*/