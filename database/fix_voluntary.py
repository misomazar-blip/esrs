#!/usr/bin/env python3
"""Quick update of voluntary flags from all CSV files"""
import os
import pandas as pd
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

CSV_FOLDER = "database/IG3 csv"
CSV_FILES = ['ESRS E1.csv', 'ESRS E2.csv', 'ESRS E3.csv', 'ESRS E4.csv', 'ESRS E5.csv',
             'ESRS S1.csv', 'ESRS S2.csv', 'ESRS S3.csv', 'ESRS S4.csv', 'ESRS G1.csv']

supabase = create_client(
    os.getenv("NEXT_PUBLIC_SUPABASE_URL"),
    os.getenv("SUPABASE_SERVICE_ROLE_KEY")
)

version = supabase.table("esrs_version").select("id").eq("version_code", "EFRAG-IG3-2024").single().execute()
version_id = version.data["id"]

# Collect all voluntary IDs from all CSVs
all_voluntary_ids = []

for filename in CSV_FILES:
    filepath = os.path.join(CSV_FOLDER, filename)
    df = pd.read_csv(filepath, sep=';', encoding='utf-8', header=None)
    
    # Find first data row
    first_data_idx = None
    for idx, row in df.iterrows():
        first_col = str(row[0]).strip() if pd.notna(row[0]) else ''
        if (('.' in first_col or '-' in first_col) and 
            '_' in first_col and 
            len(first_col) > 5 and
            first_col and first_col[0] in 'ESGAS'):
            first_data_idx = idx
            break
    
    if first_data_idx is None:
        continue
    
    df = df.iloc[first_data_idx:].reset_index(drop=True)
    df = df.iloc[:, :12]
    column_names = ['ID', 'ESRS', 'DR', 'Paragraph', 'Related AR', 'Name', 
                   'Data Type', 'Conditional or alternative DP', 'May [V]', 
                   'Appendix B', 'Appendix C - <750', 'Appendix C - All']
    df.columns = column_names
    
    # Find voluntary
    for idx, row in df.iterrows():
        datapoint_id = str(row['ID']).strip() if pd.notna(row['ID']) else None
        may_v = str(row.get('May [V]', '')).strip()
        if may_v.upper() == 'V':
            all_voluntary_ids.append(datapoint_id)
    
    print(f"{filename}: {sum(1 for idx, row in df.iterrows() if str(row.get('May [V]', '')).strip().upper() == 'V')} voluntary")

print(f"\nTotal voluntary datapoints: {len(all_voluntary_ids)}")

# Set all to mandatory
supabase.table('disclosure_question').update({'is_mandatory': True}).eq('version_id', version_id).execute()
print("Set all 994 to mandatory")

# Set voluntary ones
if all_voluntary_ids:
    result = supabase.table('disclosure_question').update({
        'is_mandatory': False
    }).eq('version_id', version_id).in_('code', all_voluntary_ids).execute()
    print(f"Set {len(result.data)} to voluntary")

print("\nDone!")
