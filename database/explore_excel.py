#!/usr/bin/env python3
"""
Excel Explorer - Zobrazí štruktúru EFRAG IG3 Excel súboru
"""

import pandas as pd
import os

EXCEL_FILE = "database/EFRAG-IG-3-List-of-ESRS-Data-Points.xlsx"

def explore_excel():
    if not os.path.exists(EXCEL_FILE):
        print(f"❌ Excel file not found: {EXCEL_FILE}")
        return
    
    print("="*70)
    print("📂 EFRAG IG3 EXCEL EXPLORER")
    print("="*70)
    print(f"File: {EXCEL_FILE}\n")
    
    # Load Excel file
    excel_file = pd.ExcelFile(EXCEL_FILE)
    
    print(f"📋 Found {len(excel_file.sheet_names)} sheets:\n")
    
    # Explore each sheet
    for idx, sheet_name in enumerate(excel_file.sheet_names, 1):
        print(f"\n{'='*70}")
        print(f"📄 SHEET #{idx}: {sheet_name}")
        print('='*70)
        
        try:
            # Read first 5 rows
            df = pd.read_excel(EXCEL_FILE, sheet_name=sheet_name, nrows=5)
            
            print(f"Dimensions: {len(pd.read_excel(EXCEL_FILE, sheet_name=sheet_name))} rows × {len(df.columns)} columns\n")
            
            print("📊 Column Names:")
            for i, col in enumerate(df.columns, 1):
                print(f"  {i:2d}. {col}")
            
            print(f"\n📝 First 3 rows preview:")
            print("-"*70)
            
            # Show first 3 rows with limited columns
            preview_df = df.head(3)
            
            # Print each row
            for idx, row in preview_df.iterrows():
                print(f"\nRow {idx + 2}:")  # +2 because Excel starts at 1 and has header
                for col in df.columns[:5]:  # Show first 5 columns
                    value = row[col]
                    if pd.notna(value):
                        value_str = str(value)[:50]  # Limit to 50 chars
                        print(f"  {col}: {value_str}")
            
            print("\n" + "-"*70)
            
        except Exception as e:
            print(f"❌ Error reading sheet: {str(e)}")
    
    print("\n" + "="*70)
    print("✅ Exploration complete!")
    print("="*70)

if __name__ == "__main__":
    explore_excel()
