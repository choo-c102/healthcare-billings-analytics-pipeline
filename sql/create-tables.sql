-- Create all tables, in line with dataset provided

CREATE TABLE payers (
    payer_id VARCHAR(20) PRIMARY KEY,
    payer_name VARCHAR(50), 
    payer_type VARCHAR(50) NOT NULL
);

CREATE TABLE doctors (
    physician_id INT PRIMARY KEY,
    department VARCHAR(50) NOT NULL
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    age INT NOT NULL,
    gender VARCHAR(7) NOT NULL, 
    payer_id VARCHAR(20) NOT NULL REFERENCES payers(payer_id)
);

CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id INT NOT NULL REFERENCES patients(patient_id),
    visit_date DATE NOT NULL,
    visit_type VARCHAR(50) NOT NULL,
    is_emergency BOOLEAN DEFAULT FALSE,
    visit_reason VARCHAR(100),
    diagnosis VARCHAR(100),
    physician_id INT NOT NULL REFERENCES doctors(physician_id)
);

CREATE TABLE billings (
    billing_id SERIAL PRIMARY KEY,
    appointment_id VARCHAR(10) NOT NULL UNIQUE REFERENCES appointments(appointment_id),
    admission_date DATE,
    discharge_date DATE,
    charge_amount_USD DECIMAL(10,2) NOT NULL,
    claim_status VARCHAR(50) NOT NULL,
    payment_amount_USD DECIMAL(10,2) NOT NULL
);