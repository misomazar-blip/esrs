from supabase import create_client
from dotenv import load_dotenv
import os

load_dotenv()
supabase = create_client(
    os.getenv('NEXT_PUBLIC_SUPABASE_URL'),
    os.getenv('SUPABASE_SERVICE_ROLE_KEY')
)

version_id = 'd3c509a5-3f23-41b4-b902-e171c136c645'

# Check E2 datapoints
result = supabase.table('disclosure_question')\
    .select('datapoint_id,question_text')\
    .eq('version_id', version_id)\
    .like('datapoint_id', 'E2%')\
    .limit(10)\
    .execute()

print("E2 datapoints in database:")
for d in result.data:
    print(f"  {d['datapoint_id']}: {d['question_text'][:80]}")

# Check CSV file
import pandas as pd
csv_path = 'database/IG3 csv/ESRS E2.csv'

# Find first data row
data_start_row = None
with open(csv_path, 'r', encoding='utf-8') as f:
    for line_num, line in enumerate(f):
        if line and len(line) > 3 and line[0] in 'ESGAS' and ('.' in line[:10] or '-' in line[:10]):
            if ';' in line:
                data_start_row = line_num
                break

column_names = ['ID', 'ESRS', 'DR', 'Paragraph', 'Related AR', 'Name', 
              'Data Type', 'Conditional or alternative DP', 'May [V]', 
              'Appendix B', 'Appendix C - <750', 'Appendix C - All']

df = pd.read_csv(csv_path, sep=';', encoding='utf-8', 
               skiprows=data_start_row, names=column_names, header=None)

print(f"\nE2 CSV file has {len(df)} rows")
print(f"First 5 IDs in CSV:")
for idx in range(min(5, len(df))):
    print(f"  {df.iloc[idx]['ID']}: {str(df.iloc[idx]['Name'])[:80]}")
