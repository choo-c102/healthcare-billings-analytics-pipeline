import pandas as pd
from pathlib import Path
import sys

def get_project_cwd():
    return Path(__file__).resolve().parent.parent


# Loads raw_data.csv, cleans it, and exports splits to CSVs
def process_and_split_data():    
    # Define paths
    root = get_project_cwd()
    input_file = root / 'data' / 'raw_data.csv'
    output_dir = root / 'data' / 'split_data'
    
    if not input_file.exists():
        print(f"Error: Could not find {input_file}")
        return

    # Load data
    print("Loading raw data...")
    df = pd.read_csv(input_file)

    # Clean and transform data      
    # Convert NULLs for insurance_id column to set 'INS_NULL'
    df['insurance_id'] = df['insurance_id'].fillna('INS_NULL')

    # Identify and resolve inregistered insurance_id
    mask = (df['insurance_id'] == 'INS_NULL') & (df['payer_name'] != 'Self-pay')
    no_reg_ids = [f'INS-NOREG{i+1}' for i in range(mask.sum())]
    df.loc[mask, 'insurance_id'] = no_reg_ids
    
    # Convert Yes/No to Boolean
    bool_map = {'Yes': True, 'No': False}
    df['is_emergency'] = df['is_emergency'].map(bool_map)

    #Define tables 
    tables = {
        'patients': df[['patient_id', 'age', 'gender']].drop_duplicates(),
        'payers': df[['insurance_id', 'payer_name', 'payer_type']].drop_duplicates(),
        'doctors': df[['physician_id', 'department']].drop_duplicates(),
        'doctor_specialties': df[['physician_id', 'department']].drop_duplicates(),
        'appointments': df[['appointment_id', 'patient_id', 'physician_id', 'visit_date', 'visit_type', 'is_emergency', 'visit_reason', 'diagnosis']],
        'billings': df[['appointment_id', 'insurance_id', 'admission_date', 'discharge_date', 'charge_amount_USD', 'claim_status', 'payment_amount_USD']]
    }

    # Save outputs
    output_dir.mkdir(parents=True, exist_ok=True)
    
    for name, table_df in tables.items():
        file_path = output_dir / f'{name}.csv'
        table_df.to_csv(file_path, index=False)
        print(f"Saved: {name}.csv ({len(table_df)} rows)")

    print(f"\nAll files saved to: {output_dir}")

if __name__ == "__main__":
    process_and_split_data()