import pandas as pd

csv_path = 'database/IG3 csv/ESRS E2.csv'

# Test current logic
data_start_row = None
with open(csv_path, 'r', encoding='utf-8') as f:
    for line_num, line in enumerate(f):
        if ';' in line and len(line) > 10:
            first_col = line.split(';')[0].strip()
            print(f"Line {line_num}: '{first_col}' - has dot/dash: {('.' in first_col or '-' in first_col)}, has underscore: {'_' in first_col}, len>5: {len(first_col) > 5}, starts E/S/G: {first_col[0] in 'ESGAS' if first_col else False}")
            
            if (('.' in first_col or '-' in first_col) and 
                '_' in first_col and 
                len(first_col) > 5 and
                first_col and first_col[0] in 'ESGAS'):
                data_start_row = line_num
                print(f">>> FOUND DATA START at line {line_num}: {first_col}")
                break
        
        if line_num > 20:
            break

print(f"\nData start row: {data_start_row}")
