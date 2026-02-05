from supabase import create_client
from dotenv import load_dotenv
import os
import pandas as pd

load_dotenv()
supabase = create_client(
    os.getenv('NEXT_PUBLIC_SUPABASE_URL'),
    os.getenv('SUPABASE_SERVICE_ROLE_KEY')
)

# Test E2 parsing
csv_path = 'database/IG3 csv/ESRS E2.csv'

# Find data start (same logic as import script)
data_start_row = None
with open(csv_path, 'r', encoding='utf-8') as f:
    for line_num, line in enumerate(f):
        if ';' in line and len(line) > 10:
            first_col = line.split(';')[0].strip()
            if (('.' in first_col or '-' in first_col) and 
                '_' in first_col and 
                len(first_col) > 5 and
                first_col and first_col[0] in 'ESGAS'):
                data_start_row = line_num
                print(f"Found data_start_row: {line_num}")
                print(f"First col: '{first_col}'")
                break

# Read with same method as import script
column_names = ['ID', 'ESRS', 'DR', 'Paragraph', 'Related AR', 'Name', 
              'Data Type', 'Conditional or alternative DP', 'May [V]', 
              'Appendix B', 'Appendix C - <750', 'Appendix C - All']

df = pd.read_csv(csv_path, sep=';', encoding='utf-8', 
               skiprows=range(0, data_start_row) if data_start_row > 0 else None,
               names=column_names, header=None)

print(f"\nDataFrame shape: {df.shape}")
print(f"First 5 IDs from DataFrame:")
for i in range(min(5, len(df))):
    print(f"  {i}: ID='{df.iloc[i]['ID']}', Name='{str(df.iloc[i]['Name'])[:60]}'")
