-- Create all tables
CREATE TABLE patients (
    patient_id INT NOT NULL PRIMARY KEY,
    age INT,
    gender VARCHAR(7), 
    insurance_id VARCHAR(20),
    payer_name VARCHAR(50),
    payer_type VARCHAR(50)
);

CREATE TABLE doctors (
    physician_id INT NOT NULL PRIMARY KEY,
    department VARCHAR(50)
);

CREATE TABLE appointments (
    appointment_id INT NOT NULL PRIMARY KEY,
    patient_id INT NOT NULL FOREIGN KEY REFERENCES patients(patient_id),
    visit_date DATE,
    visit_type VARCHAR(50),
    is_emergency VARCHAR(5),
    visit_reason VARCHAR(50),
    diagnosis VARCHAR(50),
    physician_id INT NOT NULL FOREIGN KEY REFERENCES doctors(physician_id)
);

CREATE TABLE billings (
    patient_id INT NOT NULL FOREIGN KEY REFERENCES patients(patient_id),
    appointment_id INT NOT NULL FOREIGN KEY REFERENCES appointments(appointment_id),
    admission_date DATE,
    discharge_date DATE,
    charge_amount_USD DECIMAL(10,2),
    claim_status VARCHAR(50),
    payment_amount_USD DECIMAL(10,2)
);