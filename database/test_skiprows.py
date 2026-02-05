import pandas as pd

csv_path = 'database/IG3 csv/ESRS E2.csv'

# Test 1: skiprows=11
print("Test 1: skiprows=11")
df1 = pd.read_csv(csv_path, sep=';', encoding='utf-8', skiprows=11, header=None)
print(f"First cell: '{df1.iloc[0, 0]}'")

# Test 2: skiprows=range(0, 11)
print("\nTest 2: skiprows=range(0, 11)")
df2 = pd.read_csv(csv_path, sep=';', encoding='utf-8', skiprows=range(0, 11), header=None)
print(f"First cell: '{df2.iloc[0, 0]}'")

# Test 3: skiprows=list(range(11))
print("\nTest 3: skiprows=list(range(11))")
df3 = pd.read_csv(csv_path, sep=';', encoding='utf-8', skiprows=list(range(11)), header=None)
print(f"First cell: '{df3.iloc[0, 0]}'")
