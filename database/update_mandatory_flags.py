#!/usr/bin/env python3
"""
Update is_mandatory flags for existing EFRAG datapoints
"""
import os
import pandas as pd
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

CSV_FOLDER = "database/IG3 csv"
SUPABASE_URL = os.getenv("NEXT_PUBLIC_SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

CSV_FILES = {
    'E1': 'ESRS E1.csv',
    'E2': 'ESRS E2.csv',
    'E3': 'ESRS E3.csv',
    'E4': 'ESRS E4.csv',
    'E5': 'ESRS E5.csv',
    'S1': 'ESRS S1.csv',
    'S2': 'ESRS S2.csv',
    'S3': 'ESRS S3.csv',
    'S4': 'ESRS S4.csv',
    'G1': 'ESRS G1.csv',
}

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Get version ID
version = supabase.table("esrs_version").select("id").eq("version_code", "EFRAG-IG3-2024").single().execute()
version_id = version.data["id"]

print("🔄 Updating is_mandatory flags for EFRAG datapoints...")
print(f"Version ID: {version_id}\n")

total_updated = 0
total_voluntary = 0

for topic_code, filename in CSV_FILES.items():
    filepath = os.path.join(CSV_FOLDER, filename)
    print(f"📄 Processing {filename}...")
    
    # Read CSV
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
        print(f"  ⚠️  No data found\n")
        continue
    
    # Extract data
    df = df.iloc[first_data_idx:].reset_index(drop=True)
    if len(df.columns) >= 12:
        df = df.iloc[:, :12]
    
    column_names = ['ID', 'ESRS', 'DR', 'Paragraph', 'Related AR', 'Name', 
                   'Data Type', 'Conditional or alternative DP', 'May [V]', 
                   'Appendix B', 'Appendix C - <750', 'Appendix C - All']
    df.columns = column_names
    
    # Update each datapoint
    voluntary_count = 0
    for idx, row in df.iterrows():
        datapoint_id = str(row['ID']).strip() if pd.notna(row['ID']) else None
        if not datapoint_id:
            continue
        
        # Check if voluntary
        may_v = str(row.get('May [V]', '')).strip()
        is_voluntary = may_v.upper() == 'V'
        is_mandatory = not is_voluntary
        
        if is_voluntary:
            voluntary_count += 1
        
        # Update in database
        try:
            supabase.table('disclosure_question').update({
                'is_mandatory': is_mandatory
            }).eq('code', datapoint_id).eq('version_id', version_id).execute()
        except Exception as e:
            print(f"  ⚠️  Failed to update {datapoint_id}: {e}")
    
    total_updated += len(df)
    total_voluntary += voluntary_count
    print(f"  ✅ Updated {len(df)} datapoints ({voluntary_count} voluntary)\n")

print("="*70)
print(f"✅ Total datapoints updated: {total_updated}")
print(f"📊 Total voluntary: {total_voluntary}")
print(f"📊 Total mandatory: {total_updated - total_voluntary}")
print("="*70)
