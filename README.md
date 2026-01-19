PROGRESS UPDATE
- Set up pgadmin [DONE]
- Create volume and sync data folder to local machine to container [DONE]
- Change insurance_id to payer_id [DONE]
- Change is_emergency to Boolean instead of Yes/No [DONE]
- Create tables and their relations [DONE]
- Create constraints [DONE]
- Load CSV into tables [DONE]
- Create a business problem and write queries
- Export query outputs to PowerBI
- Create PowerBI presentation
- Add new role to pgadmin to allow viewers. Currently admin has already been added with my credentials
- Check security weak points
- Create setup and environment files if properly required
- Clean up folder to commit to git
- Write up a good README.md
- Push to GitHub

Healthcare Billings Analytics: Data Engineering & RDS Setup
This project demonstrates a complete data engineering pipeline: from processing a raw healthcare dataset using Python to deploying a normalized Relational Database Service (RDS) using Docker and PostgreSQL.

📁 Project Structure
src/: Contains the core Python automation scripts.

notebooks/: Includes a Jupyter Notebook version of the data processing for a step-by-step guided walkthrough.

sql/: SQL schema and initialization scripts.

data/: Directory for raw data and generated split CSVs (Note: pg_data is ignored via .gitignore).

docker-compose.yml: Orchestration for the PostgreSQL and pgAdmin environment.

🚀 Getting Started
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

```sh
cp .env.example .env
```

# Edit .env with your preferred database credentials
🛠️ Data Pipeline
Step 1: Data Splitting & Cleaning
The raw data is normalized into five tables: patients, payers, doctors, appointments, and billings.

Run the automated script:
```sh
python src/data_splitting.py
```

💡 Note: If you prefer a guided, cell-by-cell explanation of the data cleaning logic (including boolean mapping and null handling), please refer to notebooks/data_exploration.ipynb. The .py script is the production version of that notebook.

Step 2: Database Deployment
Launch the PostgreSQL database and pgAdmin interface using Docker:

```sh
docker-compose up -d
```

Step 3: Loading Data
Once the containers are running, you can import the generated CSVs into the PostgreSQL tables using the COPY command via the terminal or pgAdmin.

📊 Database Schema
The database follows a normalized star-like schema to ensure data integrity and reduce redundancy.

Primary Keys: All tables use unique IDs to ensure record uniqueness.

Foreign Keys: Enforced ON DELETE RESTRICT to prevent accidental data loss.

Constraints: Includes CHECK constraints to ensure column data is not empty.

🛡️ Security & Best Practices
.gitignore: Configured to exclude .env secrets, .venv binaries, and raw PostgreSQL data volumes.

Normalization: Segregated Payer info into a dedicated table to handle insurance metadata independently.

Type Safety: Converted is_emergency to native SQL BOOLEAN and used DECIMAL for financial accuracy.
