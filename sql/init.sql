-- Create all tables and define constraints, in line with dataset provided
CREATE TABLE payers (
    insurance_id VARCHAR(20) PRIMARY KEY,
    payer_name VARCHAR(50), 
    payer_type VARCHAR(50) NOT NULL,
    CONSTRAINT check_payer_type_not_empty CHECK (payer_type <> '')
);

CREATE TABLE doctors (
    physician_id INT PRIMARY KEY
);

CREATE TABLE patients (
    patient_mrn VARCHAR(10) PRIMARY KEY,
    age INT NOT NULL,
    gender VARCHAR(7) NOT NULL,
    CONSTRAINT check_patient_gender_not_empty CHECK (gender <> '')
);

CREATE TABLE doctor_specialties (
    id SERIAL PRIMARY KEY,
    physician_id INT NOT NULL,
    department VARCHAR(50) NOT NULL,
    CONSTRAINT check_doctor_department_not_empty CHECK (department <> '')
);

CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_mrn VARCHAR(10) NOT NULL REFERENCES patients(patient_mrn) ON DELETE RESTRICT,
    physician_id INT NOT NULL REFERENCES doctors(physician_id) ON DELETE RESTRICT,
    visit_date DATE NOT NULL,
    visit_type VARCHAR(50) NOT NULL,
    is_emergency BOOLEAN DEFAULT FALSE,
    visit_reason VARCHAR(100),
    diagnosis VARCHAR(100),
    CONSTRAINT check_appointment_id_not_empty CHECK (appointment_id <> ''),
    CONSTRAINT check_visit_type_not_empty CHECK (visit_type <> '')
);

CREATE TABLE billings (
    billing_id SERIAL PRIMARY KEY,
    appointment_id VARCHAR(10) NOT NULL UNIQUE REFERENCES appointments(appointment_id) ON DELETE RESTRICT,
    insurance_id VARCHAR(20) NOT NULL REFERENCES payers(insurance_id) ON DELETE RESTRICT,
    admission_date DATE,
    discharge_date DATE,
    charge_amount_USD DECIMAL(10,2) NOT NULL,
    claim_status VARCHAR(50) NOT NULL,
    payment_amount_USD DECIMAL(10,2) NOT NULL,
    CONSTRAINT check_claim_status_not_empty CHECK (claim_status <> '')
);

-- Load csv data into tables
COPY payers (insurance_id, payer_name, payer_type)
FROM '/data/payers.csv' 
DELIMITER ',' 
CSV HEADER;

COPY doctors (physician_id)
FROM '/data/doctors.csv' 
DELIMITER ',' 
CSV HEADER;

COPY doctor_specialties (physician_id, department)
FROM '/data/doctor_specialties.csv' 
DELIMITER ',' 
CSV HEADER;

COPY patients(patient_mrn, age, gender)
FROM '/data/patients.csv' 
DELIMITER ',' 
CSV HEADER;

COPY appointments (appointment_id, patient_mrn, physician_id, visit_date, visit_type, is_emergency, visit_reason, diagnosis)
FROM '/data/appointments.csv' 
DELIMITER ',' 
CSV HEADER;

COPY billings (appointment_id, insurance_id, admission_date, discharge_date, charge_amount_USD, claim_status, payment_amount_USD)
FROM '/data/billings.csv' 
DELIMITER ',' 
CSV HEADER;