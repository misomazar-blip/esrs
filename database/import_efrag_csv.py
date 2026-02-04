#!/usr/bin/env python3
"""
EFRAG IG3 CSV Import Script
============================
Importuje EFRAG IG3 datapoints z CSV súborov do Supabase databázy.

Prerequisites:
- pip install pandas python-dotenv supabase

Usage:
1. Nastaviť .env premenné:
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

2. CSV súbory v: database/IG3 csv/

3. Spustiť: python database/import_efrag_csv.py
"""

import os
import sys
import pandas as pd
from datetime import datetime
from dotenv import load_dotenv
from supabase import create_client, Client
import re
from typing import Dict, List, Optional

# Load environment variables
load_dotenv()

# Configuration
CSV_FOLDER = "database/IG3 csv"
SUPABASE_URL = os.getenv("NEXT_PUBLIC_SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

# CSV files to process (topic code -> filename)
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

# Data type mapping
DATA_TYPE_MAPPING = {
    'narrative': 'narrative',
    'semi-narrative': 'narrative',
    'text': 'narrative',
    'percentage': 'percentage',
    'percent': 'percentage',
    '%': 'percentage',
    'date': 'date',
    'monetary': 'monetary',
    'currency': 'monetary',
    'number': 'numeric',
    'numeric': 'numeric',
    'integer': 'integer',
    'boolean': 'boolean',
    'yes/no': 'boolean',
}


class CSVImporter:
    def __init__(self):
        """Initialize Supabase client"""
        if not SUPABASE_URL or not SUPABASE_KEY:
            raise ValueError("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in .env")
        
        self.supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
        self.topics: Dict[str, str] = {}  # code -> id
        self.version_id: Optional[str] = None
        self.stats = {
            'files_processed': 0,
            'datapoints_created': 0,
            'errors': 0,
            'skipped': 0
        }
    
    def load_topics(self):
        """Load existing topics from database"""
        print("📚 Loading topics from database...")
        response = self.supabase.table('topic').select('id, code, name').execute()
        
        for topic in response.data:
            self.topics[topic['code']] = topic['id']
            print(f"  ✓ {topic['code']}: {topic['name']} ({topic['id']})")
        
        print(f"\n✅ Loaded {len(self.topics)} topics\n")
    
    def create_version(self):
        """Create new ESRS version for imported datapoints"""
        print("📦 Creating new ESRS version...")
        
        version_data = {
            'version_code': 'EFRAG-IG3-2024',
            'version_name': 'EFRAG IG3 - Full ESRS Datapoints',
            'effective_date': '2024-01-01',
            'is_active': False,
            'description': 'Complete ESRS datapoints from EFRAG Implementation Guidance 3',
            'source_url': 'https://www.efrag.org/lab3'
        }
        
        try:
            response = self.supabase.table('esrs_version').insert(version_data).execute()
            self.version_id = response.data[0]['id']
            print(f"✅ Created version: {version_data['version_code']} (ID: {self.version_id})\n")
        except Exception as e:
            if 'duplicate key' in str(e):
                print("⚠️  Version already exists, fetching...")
                response = self.supabase.table('esrs_version').select('id').eq('version_code', 'EFRAG-IG3-2024').execute()
                self.version_id = response.data[0]['id']
                print(f"✅ Using existing version ID: {self.version_id}\n")
            else:
                raise
    
    def normalize_data_type(self, data_type: str) -> str:
        """Normalize data type"""
        if not data_type or pd.isna(data_type):
            return 'narrative'
        
        data_type_lower = str(data_type).lower().strip()
        
        for key, value in DATA_TYPE_MAPPING.items():
            if key in data_type_lower:
                return value
        
        return 'narrative'
    
    def parse_boolean(self, value) -> bool:
        """Parse boolean from various formats"""
        if pd.isna(value):
            return False
        str_val = str(value).lower().strip()
        return str_val in ['yes', 'true', '1', 'y', 'mandatory', 'x', 'conditional']
    
    def clean_text(self, text) -> Optional[str]:
        """Clean and validate text field"""
        if pd.isna(text):
            return None
        text = str(text).strip()
        return text if text else None
    
    def process_csv(self, topic_code: str, filename: str) -> int:
        """Process one CSV file"""
        filepath = os.path.join(CSV_FOLDER, filename)
        
        if not os.path.exists(filepath):
            print(f"⚠️  File not found: {filepath}")
            return 0
        
        print(f"\n📄 Processing: {filename}")
        
        try:
            # Find the first data row (after multiline header)
            # Look for a line with actual datapoint ID pattern (like "E1.GOV-3_01", "E1-1_01", etc.)
            data_start_row = None
            with open(filepath, 'r', encoding='utf-8') as f:
                for line_num, line in enumerate(f):
                    # Data rows have pattern: E1.XXX-X_XX or E1-X_XX or S1.XXX-X_XX
                    # Must have both a dot/dash AND underscore in first 15 chars
                    if ';' in line and len(line) > 10:
                        first_col = line.split(';')[0].strip()
                        # Check if it looks like a real datapoint ID
                        if (('.' in first_col or '-' in first_col) and 
                            '_' in first_col and 
                            len(first_col) > 5 and
                            first_col[0] in 'ESGAS'):
                            data_start_row = line_num
                            break
            
            if data_start_row is None:
                print(f"   [!] Data rows not found, skipping file")
                return 0
            
            print(f"   DEBUG: data_start_row = {data_start_row}")
            
            # Define column names manually (based on EFRAG IG3 structure)
            column_names = ['ID', 'ESRS', 'DR', 'Paragraph', 'Related AR', 'Name', 
                          'Data Type', 'Conditional or alternative DP', 'May [V]', 
                          'Appendix B', 'Appendix C - <750', 'Appendix C - All']
            
            # Read entire CSV, then filter rows manually
            # This is more reliable than skiprows with quoted multiline blocks
            df = pd.read_csv(filepath, sep=';', encoding='utf-8', header=None)
            
            # Find first valid data row in DataFrame
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
                print(f"   [!] No valid data rows found in DataFrame")
                return 0
            
            # Keep only data rows and assign column names
            df = df.iloc[first_data_idx:].reset_index(drop=True)
            
            # Dynamically assign column names based on actual column count
            num_cols = len(df.columns)
            if num_cols >= 12:
                # Use first 12 column names, ignore extra columns
                df = df.iloc[:, :12]  # Keep only first 12 columns
            df.columns = column_names
            
            print(f"   Rows: {len(df)}, Columns: {len(df.columns)}")
            print(f"   First ID: {df['ID'].iloc[0] if len(df) > 0 else 'N/A'}")
            
            # Get topic ID
            topic_id = self.topics.get(topic_code)
            if not topic_id:
                print(f"[X] Topic {topic_code} not found in database")
                return 0
            
            # Parse all rows into batch
            datapoints_batch = []
            for idx, row in df.iterrows():
                try:
                    datapoint = self.parse_row(row, topic_code, topic_id)
                    
                    if not datapoint:
                        self.stats['skipped'] += 1
                        continue
                    
                    datapoints_batch.append(datapoint)
                    
                except Exception as e:
                    self.stats['errors'] += 1
                    self.stats['skipped'] += 1
            
            # Batch insert all datapoints at once
            if datapoints_batch:
                try:
                    self.supabase.table('disclosure_question').insert(datapoints_batch).execute()
                    created_count = len(datapoints_batch)
                    print(f"   [OK] Inserted {created_count} datapoints")
                except Exception as e:
                    self.stats['errors'] += 1
                    error_msg = str(e)[:200]
                    print(f"   [X] Batch insert failed: {error_msg}")
                    return 0
            else:
                created_count = 0
            
            print(f"[OK] Imported {created_count} datapoints from {topic_code}")
            return created_count
            
        except Exception as e:
            print(f"❌ Failed to process {filename}: {str(e)}")
            return 0
    
    def parse_row(self, row: pd.Series, topic_code: str, topic_id: str) -> Optional[Dict]:
        """Parse one CSV row into datapoint dictionary"""
        
        # Extract ID
        datapoint_id = self.clean_text(row.get('ID', ''))
        if not datapoint_id:
            return None
        
        # Extract name/question text
        question_text = self.clean_text(row.get('Name', ''))
        if not question_text:
            return None
        
        # Normalize data type
        data_type = self.normalize_data_type(row.get('Data Type', 'narrative'))
        
        # Map data_type to answer_type (for old schema compatibility)
        answer_type_mapping = {
            'narrative': 'text',
            'text': 'text',
            'percentage': 'number',
            'percent': 'number',
            'monetary': 'number',
            'numeric': 'number',
            'integer': 'number',
            'date': 'date',
            'boolean': 'boolean',
        }
        answer_type = answer_type_mapping.get(data_type, 'text')
        
        # Build datapoint
        datapoint = {
            'topic_id': topic_id,
            'version_id': self.version_id,
            'code': datapoint_id,
            'datapoint_id': datapoint_id,
            'question_text': question_text,
            'answer_type': answer_type,
            'data_type': data_type,
            'valid_from': '2024-01-01',
        }
        
        # Optional: DR (disclosure requirement)
        dr = self.clean_text(row.get('DR', ''))
        if dr:
            datapoint['disclosure_requirement'] = dr
        
        # Optional: Paragraph
        paragraph = self.clean_text(row.get('Paragraph', ''))
        if paragraph:
            datapoint['esrs_paragraph'] = paragraph
        
        # Optional: Conditional
        is_conditional = self.parse_boolean(row.get('Conditional or alternative DP', ''))
        if is_conditional:
            datapoint['is_conditional'] = True
        
        # Optional: May [V] - voluntary
        is_voluntary = self.parse_boolean(row.get('May \n[V]', ''))
        if is_voluntary:
            datapoint['is_mandatory'] = False
        else:
            datapoint['is_mandatory'] = True
        
        return datapoint
    
    def run(self):
        """Run the import process"""
        try:
            print("="*70)
            print("🚀 EFRAG IG3 CSV DATAPOINTS IMPORT")
            print("="*70)
            
            self.load_topics()
            self.create_version()
            
            print("\n" + "="*70)
            print("📁 Processing CSV files...")
            print("="*70)
            
            for topic_code, filename in CSV_FILES.items():
                count = self.process_csv(topic_code, filename)
                if count > 0:
                    self.stats['files_processed'] += 1
                    self.stats['datapoints_created'] += count
            
            # Summary
            print("\n" + "="*70)
            print("📊 IMPORT SUMMARY")
            print("="*70)
            print(f"✅ Files processed: {self.stats['files_processed']}/{len(CSV_FILES)}")
            print(f"✅ Datapoints created: {self.stats['datapoints_created']}")
            print(f"⚠️  Skipped: {self.stats['skipped']}")
            print(f"❌ Errors: {self.stats['errors']}")
            print("="*70)
            
            print("\n✅ Import completed successfully!")
            
        except Exception as e:
            print(f"\n❌ Import failed: {str(e)}")
            import traceback
            traceback.print_exc()
            sys.exit(1)


if __name__ == "__main__":
    importer = CSVImporter()
    importer.run()
