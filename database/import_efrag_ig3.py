#!/usr/bin/env python3
"""
EFRAG IG3 Datapoints Import Script
===================================

This script imports EFRAG IG3 datapoints from Excel into Supabase database.

Prerequisites:
- pip install pandas openpyxl python-dotenv supabase

Usage:
1. Set environment variables in .env file:
   SUPABASE_URL=your_supabase_url
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

2. Place Excel file at: database/EFRAG_IG3_DataPoints.xlsx

3. Run: python database/import_efrag_ig3.py
"""

import os
import sys
import pandas as pd
from datetime import datetime
from dotenv import load_dotenv
from supabase import create_client, Client
import re
from typing import Dict, List, Optional, Tuple

# Load environment variables
load_dotenv()

# Configuration
EXCEL_FILE = "database/EFRAG-IG-3-List-of-ESRS-Data-Points.xlsx"
SUPABASE_URL = os.getenv("NEXT_PUBLIC_SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

# Topic mapping - maps ESRS codes to topic IDs
TOPIC_MAPPING = {
    'E1': 'Climate change',
    'E2': 'Pollution',
    'E3': 'Water and marine resources',
    'E4': 'Biodiversity and ecosystems',
    'E5': 'Resource use and circular economy',
    'S1': 'Own workforce',
    'S2': 'Workers in the value chain',
    'S3': 'Affected communities',
    'S4': 'Consumers and end-users',
    'G1': 'Business conduct',
}

# Data type mapping
DATA_TYPE_MAPPING = {
    'narrative': 'narrative',
    'text': 'narrative',
    'percentage': 'percentage',
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


class ESRSImporter:
    def __init__(self):
        """Initialize Supabase client and load topics"""
        if not SUPABASE_URL or not SUPABASE_KEY:
            raise ValueError("SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set in .env file")
        
        self.supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
        self.topics: Dict[str, str] = {}  # code -> id
        self.version_id: Optional[str] = None
        self.stats = {
            'sheets_processed': 0,
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
            'is_active': False,  # Don't make active yet
            'description': 'Complete ESRS datapoints from EFRAG Implementation Guidance 3',
            'source_url': 'https://www.efrag.org/lab3'
        }
        
        try:
            response = self.supabase.table('esrs_version').insert(version_data).execute()
            self.version_id = response.data[0]['id']
            print(f"✅ Created version: {version_data['version_code']} (ID: {self.version_id})\n")
        except Exception as e:
            if 'duplicate key' in str(e):
                print("⚠️  Version already exists, fetching existing...")
                response = self.supabase.table('esrs_version').select('id').eq('version_code', 'EFRAG-IG3-2024').execute()
                self.version_id = response.data[0]['id']
                print(f"✅ Using existing version ID: {self.version_id}\n")
            else:
                raise
    
    def extract_topic_code(self, datapoint_id: str) -> Optional[str]:
        """Extract topic code from datapoint ID (e.g., 'E1-1' -> 'E1')"""
        match = re.match(r'^([A-Z]\d+)', datapoint_id)
        return match.group(1) if match else None
    
    def normalize_data_type(self, data_type: str) -> str:
        """Normalize data type to standard format"""
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
        return str_val in ['yes', 'true', '1', 'y', 'mandatory', 'x']
    
    def process_sheet(self, sheet_name: str, df: pd.DataFrame) -> int:
        """Process one Excel sheet and return count of imported rows"""
        print(f"\n📄 Processing sheet: {sheet_name}")
        print(f"   Rows: {len(df)}, Columns: {len(df.columns)}")
        
        # Display column names (first 10)
        print(f"   Columns: {', '.join(df.columns[:10])}")
        
        # Try to identify key columns (flexible matching)
        col_mapping = self.identify_columns(df.columns)
        
        if not col_mapping.get('datapoint_id'):
            print(f"⚠️  Skipping sheet '{sheet_name}' - no datapoint ID column found")
            self.stats['skipped'] += len(df)
            return 0
        
        created_count = 0
        
        for idx, row in df.iterrows():
            try:
                datapoint = self.parse_row(row, col_mapping)
                
                if not datapoint:
                    self.stats['skipped'] += 1
                    continue
                
                # Insert into database
                self.supabase.table('disclosure_question').insert(datapoint).execute()
                created_count += 1
                
                if created_count % 50 == 0:
                    print(f"   ✓ Processed {created_count} datapoints...")
                
            except Exception as e:
                self.stats['errors'] += 1
                print(f"   ❌ Error on row {idx + 2}: {str(e)[:100]}")
        
        print(f"✅ Imported {created_count} datapoints from '{sheet_name}'")
        return created_count
    
    def identify_columns(self, columns: List[str]) -> Dict[str, str]:
        """Identify column names (case-insensitive, flexible matching)"""
        col_map = {}
        
        column_patterns = {
            'datapoint_id': ['datapoint', 'dp', 'id', 'code'],
            'question_text': ['description', 'question', 'datapoint description', 'text'],
            'esrs_paragraph': ['paragraph', 'esrs paragraph', 'reference'],
            'disclosure_requirement': ['disclosure requirement', 'dr', 'requirement'],
            'data_type': ['data type', 'type', 'format'],
            'unit': ['unit', 'measurement'],
            'is_mandatory': ['mandatory', 'required', 'obligation'],
            'is_phase_in': ['phase', 'phase-in', 'phase in'],
            'applies_to': ['applies to', 'applicability', 'scope'],
        }
        
        columns_lower = [col.lower() for col in columns]
        
        for key, patterns in column_patterns.items():
            for col_idx, col in enumerate(columns_lower):
                if any(pattern in col for pattern in patterns):
                    col_map[key] = columns[col_idx]
                    break
        
        return col_map
    
    def parse_row(self, row: pd.Series, col_mapping: Dict[str, str]) -> Optional[Dict]:
        """Parse one row into datapoint dictionary"""
        
        # Extract datapoint ID
        datapoint_id = row.get(col_mapping.get('datapoint_id', ''), '')
        if pd.isna(datapoint_id) or not str(datapoint_id).strip():
            return None
        
        datapoint_id = str(datapoint_id).strip()
        
        # Extract topic code (E1, E2, etc.)
        topic_code = self.extract_topic_code(datapoint_id)
        if not topic_code or topic_code not in self.topics:
            return None
        
        topic_id = self.topics[topic_code]
        
        # Extract question text
        question_text = row.get(col_mapping.get('question_text', ''), '')
        if pd.isna(question_text) or not str(question_text).strip():
            return None
        
        # Build datapoint object
        datapoint = {
            'topic_id': topic_id,
            'version_id': self.version_id,
            'code': datapoint_id,
            'datapoint_id': datapoint_id,
            'question_text': str(question_text).strip(),
            'data_type': self.normalize_data_type(row.get(col_mapping.get('data_type', ''), '')),
            'is_mandatory': self.parse_boolean(row.get(col_mapping.get('is_mandatory', ''), False)),
            'is_phase_in': self.parse_boolean(row.get(col_mapping.get('is_phase_in', ''), False)),
            'valid_from': '2024-01-01',
        }
        
        # Optional fields
        if col_mapping.get('esrs_paragraph'):
            val = row.get(col_mapping['esrs_paragraph'], '')
            if not pd.isna(val):
                datapoint['esrs_paragraph'] = str(val).strip()
        
        if col_mapping.get('disclosure_requirement'):
            val = row.get(col_mapping['disclosure_requirement'], '')
            if not pd.isna(val):
                datapoint['disclosure_requirement'] = str(val).strip()
        
        if col_mapping.get('unit'):
            val = row.get(col_mapping['unit'], '')
            if not pd.isna(val):
                datapoint['unit'] = str(val).strip()
        
        if col_mapping.get('applies_to'):
            val = row.get(col_mapping['applies_to'], '')
            if not pd.isna(val) and str(val).strip():
                datapoint['applies_to'] = [str(val).strip()]
        
        return datapoint
    
    def import_excel(self):
        """Main import function - processes all sheets"""
        if not os.path.exists(EXCEL_FILE):
            raise FileNotFoundError(f"Excel file not found: {EXCEL_FILE}")
        
        print(f"📂 Loading Excel file: {EXCEL_FILE}")
        excel_file = pd.ExcelFile(EXCEL_FILE)
        
        print(f"📋 Found {len(excel_file.sheet_names)} sheets:")
        for sheet_name in excel_file.sheet_names:
            print(f"   - {sheet_name}")
        
        print("\n" + "="*60)
        
        # Process each sheet
        for sheet_name in excel_file.sheet_names:
            try:
                df = pd.read_excel(EXCEL_FILE, sheet_name=sheet_name)
                count = self.process_sheet(sheet_name, df)
                self.stats['sheets_processed'] += 1
                self.stats['datapoints_created'] += count
            except Exception as e:
                print(f"❌ Failed to process sheet '{sheet_name}': {str(e)}")
                self.stats['errors'] += 1
        
        # Print summary
        print("\n" + "="*60)
        print("📊 IMPORT SUMMARY")
        print("="*60)
        print(f"✅ Sheets processed: {self.stats['sheets_processed']}")
        print(f"✅ Datapoints created: {self.stats['datapoints_created']}")
        print(f"⚠️  Skipped: {self.stats['skipped']}")
        print(f"❌ Errors: {self.stats['errors']}")
        print("="*60)
    
    def run(self):
        """Run the full import process"""
        try:
            print("="*60)
            print("🚀 EFRAG IG3 DATAPOINTS IMPORT")
            print("="*60)
            
            self.load_topics()
            self.create_version()
            self.import_excel()
            
            print("\n✅ Import completed successfully!")
            
        except Exception as e:
            print(f"\n❌ Import failed: {str(e)}")
            import traceback
            traceback.print_exc()
            sys.exit(1)


if __name__ == "__main__":
    importer = ESRSImporter()
    importer.run()
