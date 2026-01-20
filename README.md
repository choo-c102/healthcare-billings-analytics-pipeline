PROJECT PROGRESS:
- Set up dockerized postgres [DONE]
- Create volumes, bind mount to local machine, set up pgdmin [DONE]
- ETL raw data: check and transform nulls and duplicates [DONE]
- Create tables, define relations and constraints [DONE]
- Connect PostgreSQL server to PowerBI [DONE]
- Migrate SAP Lumira Discovery reports to PowerBI

## Healthcare Billings Analytics: Data Engineering & RDS Setup

This is an on-going project that demonstrates a complete data analytics pipeline used in an in-depth study into hospital 'bad debt'. The report from that study can be found [here](https://www.academia.edu/146226032/Uncovering_Root_Causes_in_Hospital_Billing_to_Strengthen_Revenue_Cycle_Systems?source=swp_share).

The repo hosts the steps taken to generate the final interactive Power BI insights (previously hosted on SAP Lumira Discovery), from raw healthcare dataset ETL using Python, deploying a normalized Relational Database Service (RDS) using Docker and PostgreSQL, to SQL queries for exploration and connecting Postgres to PowerBI. 

The repo structure is set up so that the whole project can be replicated. The dataset used in this project was synthetically generated and available for download on Kaggle [here](https://www.kaggle.com/datasets/ayaasaad/synthetic-hospital-visits-and-billing-records).

### Project goals
- Data Engineering: Designing a robust ETL pipeline that handles "messy" real-world healthcare data.

- Database Architecture: Deploying a containerized PostgreSQL environment with a normalized Star Schema.

- Business Intelligence: Identifying the root causes of a $1.24M USD outstanding debt and providing data-backed and real-world strategic recommendations.

### Project Structure
```
healthcare-billing-analytics/
├── backup/
│   └── backup_and_restore.md
├── data/                      #Directory for raw data and generated split CSVs     
│   ├── split_data/
│   └──  raw_data.csv
├── notebooks/                 #Jupyter Notebook walkthrough of the data processing 
│   ├── data_splitting.ipynb
│   └──  load_raw_date.ipynb
├── sql/                       #SQL schema and initialization scripts
│   └──  init.sql
├── src/                       #Core python automation scripts
│   └── data_splitting.py 
├── .env.example
├── docker-compose.yml         #Orchestration for the PostgreSQL and pgAdmin environment
├── README.md
└── requirements.txt           #Required libraries
```

### Getting Started
1. Environment Initialization
   
First, clone the repository and set up your Python virtual environment to manage dependencies.

```sh
# Create the virtual environment
python -m venv .venv

# Activate the environment
#On Windows
.venv\Scripts\activate
#On Linux
.venv/bin/activate 

# Install required libraries
pip install -r requirements.txt
```


2. Secret Management
   
Before running the database, create a .env file in the root directory to store your credentials. You can use .env.example as a template.


3. Run the pipeline
```sh
python src/data_splitting.py  # Cleans and splits data
docker-compose up -d          # Deploys Database
```

### Data Pipeline and Database Schema
1. Data Splitting & Cleaning

The raw data is normalized into five tables: patients, payers, doctors, appointments, and billings to handle several production-level challenges:
- Entity Resolution: Created a Composite Patient ID (ID + Age + Gender) to resolve duplicate ID collisions in the source data.

- Automated ID Generation: Developed a masking logic to assign unique INS-NOREG# identifiers to insurance providers missing registration IDs, ensuring Primary Key integrity.

- Implemented a Bridge Table (doctor_specialties) to accommodate doctors practicing in multiple departments.

The database follows a normalized star-like schema to ensure data integrity and reduce redundancy:
- Primary Keys: All tables use unique IDs to ensure record uniqueness.
- Foreign Keys: Enforced ON DELETE RESTRICT to prevent accidental data loss.
- Constraints: Includes CHECK constraints to ensure strings fields are not empty.

Run the automated script:
```sh
python src/data_splitting.py
```

_💡 Note: A guided, cell-by-cell explanation of the data cleaning logic (including boolean mapping and null handling) is available in notebooks/data_exploration.ipynb. The .py script is the production version of that notebook._


2. Database Deployment

Launch the PostgreSQL database and pgAdmin interface using Docker:

```sh
docker-compose up -d
```

Once the containers are running, import the generated CSVs into the PostgreSQL tables using the COPY command found in init.sql via the terminal or pgAdmin.

## TL:DR of Business Analysis & Research Findings
The research conducted for "General Hospital" (not a real hospital) uncovered that high unpaid balances were not just a result of patient insolvency, but systemic reimbursement issues.

**1. The Payer Disparity**
While "Self-pay" patients are often blamed for hospital debt, data shows that Government and Private Insurers contribute heavily to the $1.24M debt due to:

- Reimbursement Gaps: Government programs often reimburse significantly less than the actual cost of care.

- Claim Denials: High denial rates for complex diagnoses.

**2. Billing Anomalies**
Analysis revealed significant charge spikes where certain physicians billed up to 17 times higher than the average for the same diagnosis. This indicates a need for standardized ICD-10/CPT code capture to prevent "phantom billing", ensure compliance with governing policies, and reduce fraud risks.

**Strategic Recommendations**
- Transition to AI-Assisted Coding: Implement LLM-based tools to extract ICD-10 codes from clinical notes to reduce human error and upcoding risks.

- Itemized Transparency: Move toward fully itemized billing to improve collection rates and meet federal transparency requirements.

- Revenue Cycle Audits: Use the dashboard's "Physician Outlier" report to conduct monthly internal audits on high-variance charges.


### Security & Best Practices
Accuracy and integrity: 
- All currency fields use DECIMAL(12,2) instead of FLOAT to prevent rounding errors.
- Enforced ON DELETE RESTRICT on foreign keys to prevent the accidental deletion of patient billing history.
- Converted is_emergency to native SQL BOOLEAN.
- Uses .gitignore to protect .env secrets and PostgreSQL data volumes (pg_data).
- Segregated Payer info into a dedicated table to handle insurance metadata independently.
