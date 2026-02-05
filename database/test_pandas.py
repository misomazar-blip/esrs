import pandas as pd

csv_path = 'database/IG3 csv/ESRS E2.csv'

# Find data start
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
                print(f"Data start row: {line_num} - ID: {first_col}")
                break

# Define columns
column_names = ['ID', 'ESRS', 'DR', 'Paragraph', 'Related AR', 'Name', 
              'Data Type', 'Conditional or alternative DP', 'May [V]', 
              'Appendix B', 'Appendix C - <750', 'Appendix C - All']

# Read with skiprows
df = pd.read_csv(csv_path, sep=';', encoding='utf-8', 
               skiprows=data_start_row, names=column_names, header=None)

print(f"\nDataFrame info:")
print(f"Shape: {df.shape}")
print(f"First 5 IDs:")
for i in range(min(5, len(df))):
    print(f"  Row {i}: ID='{df.iloc[i]['ID']}'  Name='{str(df.iloc[i]['Name'])[:60]}'")
