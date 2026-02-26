#!/usr/bin/env python3
# ============================================================================
# XBRL Taxonomy Parser & Mapper for ESRS
# ============================================================================
# Cieľ: Parsovať EFRAG XBRL elementy a mapovať ich na ESRS datapoints
#
# Inputy:
# 1. EFRAG XBRL XSD súbory (budúcnosť - keď budú dostupné od EFRAG)
# 2. IG3 CSV tabuľky (teraz - fallback ak XBRL nie sú dostupní)
#
# Outputy:
# 1. SQL INSERT statements
# 2. JSON mappingy
# 3. Priamy Supabase import (flag -s)
#
# Ako spustiť:
#   python parse_xbrl_taxonomy.py --input IG3\ csv/ --output mappings.sql
#   python parse_xbrl_taxonomy.py --input IG3\ csv/ --supabase (priamy import)
# ============================================================================

import os
import sys
import json
import csv
import re
import argparse
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass, asdict
from datetime import datetime
import xml.etree.ElementTree as ET

# Výber: supabase alebo inou knižnicou (podľa dostupnosti)
try:
    import supabase
    SUPABASE_AVAILABLE = True
except ImportError:
    SUPABASE_AVAILABLE = False
    print("⚠️  Warning: supabase-py not installed. Use --output to generate SQL instead.")

# ============================================================================
# DATA CLASSES
# ============================================================================

@dataclass
class XBRLElement:
    """XBRL element z taxonomie"""
    element_id: str
    tag: str
    label_en: str
    label_sk: Optional[str] = None
    data_type: str = 'string'
    period_type: str = 'instant'
    unit_ref: Optional[str] = None
    is_required: bool = False
    is_monetary: bool = False
    is_numeric: bool = False
    documentation: Optional[str] = None

@dataclass
class ESRSDatapoint:
    """ESRS datapoint z IG3"""
    datapoint_id: str  # E1-1_01
    esrs_standard: str  # E1, S1, etc.
    esrs_disclosure_req: str  # E1-1, S1-1, etc.
    name: str
    data_type: str  # 'narrative', 'numeric', etc.
    is_conditional: bool = False
    applies_to_vsme: List[int] = None  # [1, 2, 3] - ktoré roky
    
    def __post_init__(self):
        if self.applies_to_vsme is None:
            self.applies_to_vsme = [1, 2, 3]

@dataclass
class Mapping:
    """Mapovanie ESRS <-> XBRL"""
    datapoint_id: str
    xbrl_element_id: str
    esrs_standard: str
    mapping_type: str = 'direct'  # direct, split, merged, calculated
    description: Optional[str] = None
    applies_to: List[str] = None
    
    def __post_init__(self):
        if self.applies_to is None:
            self.applies_to = ['full', 'vsme']

# ============================================================================
# PARSER - IG3 CSV (fallback kým EFRAG nevydá XBRL)
# ============================================================================

class IG3Parser:
    """Parsov IG3 CSV súbory a extrahuj datapoints"""
    
    CSV_FILES = {
        'ESRS2.csv': 'ESRS 2',
        'ESRS E1.csv': 'E1',
        'ESRS E2.csv': 'E2',
        'ESRS E3.csv': 'E3',
        'ESRS E4.csv': 'E4',
        'ESRS E5.csv': 'E5',
        'ESRS S1.csv': 'S1',
        'ESRS S2.csv': 'S2',
        'ESRS S3.csv': 'S3',
        'ESRS S4.csv': 'S4',
        'ESRS G1.csv': 'G1',
        'ESRS 2 MDR.csv': 'ESRS 2 MDR',
    }
    
    VSME_PHASING = {
        # Determináciaoakoé roky sa vzťahujú pre VSME
        'E1': [1, 2, 3],           # E1:  Scope 3 je R2+
        'E2': [1, 2, 3],
        'E3': [1, 2, 3],
        'E4': [2, 3],              # E4:  Whole thing is R2+
        'E5': [1, 2, 3],
        'S1': [2, 3],              # S1:  R2+ (teraz je R1 len 50% povinné)
        'S2': [3],                 # S2:  R3+ (fáza 2 roky)
        'S3': [3],                 # S3:  R3+ (fáza 2 roky)
        'S4': [3],                 # S4:  R3+ (fáza 2 roky)
        'G1': [1, 2, 3],
        'ESRS 2': [1, 2, 3],       # ESRS 2 vždy
    }
    
    def __init__(self, csv_dir: str):
        self.csv_dir = Path(csv_dir)
        self.datapoints: List[ESRSDatapoint] = []
    
    def parse_all(self) -> List[ESRSDatapoint]:
        """Parsuj všetky IG3 CSV súbory"""
        for csv_file, standard in self.CSV_FILES.items():
            csv_path = self.csv_dir / csv_file
            if csv_path.exists():
                print(f"📖 Parsing {csv_file}...")
                self.parse_csv(csv_path, standard)
            else:
                print(f"⚠️  Skipping {csv_file} (not found)")
        
        return self.datapoints
    
    def parse_csv(self, csv_path: Path, standard: str):
        """Parsuj jeden CSV súbor"""
        try:
            with open(csv_path, 'r', encoding='utf-8-sig') as f:
                # Preskočí linky s inštrukciami a prázdne
                reader = csv.reader(f, delimiter=';', quotechar='"')
                rows = list(reader)
                
                # Nájdi header (zvyčajne riadok s "ID")
                header_idx = 0
                for i, row in enumerate(rows):
                    if row and len(row) > 0 and row[0].strip().upper() == 'ID':
                        header_idx = i
                        break
                
                if header_idx >= len(rows):
                    print(f"❌ Header not found in {csv_path}")
                    return
                
                # Stĺpce sú fixné: ID, ESRS, DR, Paragraph, Related AR, Name, Data Type, ...
                # col 0 = ID, col 5 = Name, col 6 = Data Type
                col_id = 0
                col_name = 5
                col_data_type = 6
                
                # Parsuj dáta
                for row in rows[header_idx + 1:]:
                    if not row or len(row) < 7 or not row[col_id].strip():
                        continue
                    
                    dp_id = row[col_id].strip()
                    name = row[col_name].strip() if col_name < len(row) else dp_id
                    data_type = row[col_data_type].strip().lower() if col_data_type < len(row) else 'narrative'
                    
                    # Parse datapoint ID: E1-1_01 -> E1, E1-1
                    match = re.match(r'([A-Z]\d+)(?:-(\d+))?(?:\.|\.)?\s*([A-Z0-9_-]+)?', dp_id)
                    if not match:
                        continue
                    
                    esrs_std = match.group(1)  # E1, S1, etc.
                    esrs_disc = f"{esrs_std}-{match.group(2)}" if match.group(2) else esrs_std
                    
                    datapoint = ESRSDatapoint(
                        datapoint_id=dp_id,
                        esrs_standard=esrs_std,
                        esrs_disclosure_req=esrs_disc,
                        name=name,
                        data_type=data_type,
                        applies_to_vsme=self.VSME_PHASING.get(esrs_std, [1, 2, 3])
                    )
                    
                    self.datapoints.append(datapoint)
        
        except Exception as e:
            print(f"❌ Error parsing {csv_path}: {e}")

# ============================================================================
# XBRL ELEMENT GENERATOR (fallback)
# ============================================================================

class XBRLElementGenerator:
    """Generuj XBRL elementy na základe ESRS datapoints (fallback keď nemáme XSD)"""
    
    def __init__(self):
        self.elements: Dict[str, XBRLElement] = {}
    
    def generate_from_datapoints(self, datapoints: List[ESRSDatapoint]) -> List[XBRLElement]:
        """Vygeneruj XBRL elementy z ESRS datapoints"""
        for dp in datapoints:
            element_id = f"esrs_{dp.esrs_standard}_{dp.esrs_disclosure_req.replace('-', '_')}_{dp.datapoint_id.split('_')[-1]}"
            
            # Urči dátový typ
            xbrl_data_type = self._map_data_type(dp.data_type)
            
            element = XBRLElement(
                element_id=element_id,
                tag=self._generate_tag(element_id),
                label_en=dp.name,
                label_sk=None,
                data_type=xbrl_data_type,
                period_type='duration',  # Väčšina ESRS je za obdobie
                is_numeric=dp.data_type in ['numeric', 'percentage', 'monetary'],
                is_monetary=dp.data_type == 'monetary',
                unit_ref=self._get_unit_ref(dp.data_type)
            )
            
            self.elements[dp.datapoint_id] = element
        
        return list(self.elements.values())
    
    def _map_data_type(self, ig3_type: str) -> str:
        """Mapuj IG3 data type na XBRL data type"""
        mapping = {
            'narrative': 'xbrli:stringItemType',
            'text': 'xbrli:stringItemType',
            'numeric': 'xbrli:decimalItemType',
            'integer': 'xbrli:integerItemType',
            'percentage': 'xbrli:decimalItemType',
            'percent': 'xbrli:decimalItemType',
            'monetary': 'xbrli:monetaryItemType',
            'date': 'xbrli:dateItemType',
            'boolean': 'xbrli:booleanItemType',
        }
        return mapping.get(ig3_type, 'xbrli:stringItemType')
    
    def _generate_tag(self, element_id: str) -> str:
        """Generuj čitateľný tag"""
        return element_id.lower().replace('_', '-')
    
    def _get_unit_ref(self, ig3_type: str) -> Optional[str]:
        """Urči jednotku na základe dátového typu"""
        units = {
            'monetary': 'iso4217:EUR',
            'percentage': 'xbrli:pure',
            'percent': 'xbrli:pure',
            'numeric': None,  # bez jednotky
        }
        return units.get(ig3_type)

# ============================================================================
# MAPPINGS GENERATOR
# ============================================================================

class MappingsGenerator:
    """Generuj mappingy ESRS <-> XBRL"""
    
    def __init__(self, datapoints: List[ESRSDatapoint], elements: List[XBRLElement]):
        self.datapoints = {dp.datapoint_id: dp for dp in datapoints}
        self.elements = {e.element_id: e for e in elements}
        self.mappings: List[Mapping] = []
    
    def generate_direct_mappings(self) -> List[Mapping]:
        """Generuj 1:1 mappingy"""
        for dp_id, dp in self.datapoints.items():
            # Nájdi príslušný XBRL element
            # Pretože sme ich vygenerovali, majú štandardnu nomenklatúru
            xbrl_id = f"esrs_{dp.esrs_standard}_{dp.esrs_disclosure_req.replace('-', '_')}_01"
            
            if xbrl_id in self.elements:
                mapping = Mapping(
                    datapoint_id=dp_id,
                    xbrl_element_id=xbrl_id,
                    esrs_standard=dp.esrs_standard,
                    mapping_type='direct',
                    applies_to=['full', 'vsme']
                )
                self.mappings.append(mapping)
        
        return self.mappings

# ============================================================================
# SQL GENERATOR
# ============================================================================

class SQLGenerator:
    """Generuj SQL INSERT statements"""
    
    def __init__(self, taxonomy_id: str = 'esrs-2024-full'):
        self.taxonomy_id = taxonomy_id
        self.sql_lines: List[str] = []
    
    def generate_insert_taxonomy(self) -> str:
        """Generuj INSERT pre xbrl_taxonomy"""
        sql = f"""
-- XBRL Taxonomy definition
INSERT INTO xbrl_taxonomy (taxonomy_code, taxonomy_name, version, namespace, entry_point, applies_to, effective_date, is_active)
SELECT 
  '{self.taxonomy_id}',
  'ESRS 2024 Full XBRL Taxonomy',
  '1.0',
  'http://xbrl.ifrs.org/taxonomy/{self.taxonomy_id}',
  '{self.taxonomy_id}.xsd',
  ARRAY['full', 'vsme'],
  '2024-01-01',
  true
WHERE NOT EXISTS (
  SELECT 1 FROM xbrl_taxonomy WHERE taxonomy_code = '{self.taxonomy_id}'
);
"""
        return sql
    
    def generate_insert_elements(self, elements: List[XBRLElement]) -> str:
        """Generuj INSERT pre xbrl_element"""
        lines = [
            "-- XBRL Elements insert",
            "INSERT INTO xbrl_element (taxonomy_id, xbrl_element_id, xbrl_tag, label_en, element_type, data_type, period_type, is_numeric, is_monetary, unit_ref)",
            "SELECT",
            f"  (SELECT id FROM xbrl_taxonomy WHERE taxonomy_code = '{self.taxonomy_id}'),",
            "  data.element_id,",
            "  data.tag,",
            "  data.label,",
            "  data.element_type,",
            "  data.data_type,",
            "  data.period_type,",
            "  data.is_numeric,",
            "  data.is_monetary,",
            "  data.unit",
            "FROM (VALUES"
        ]
        
        for i, elem in enumerate(elements):
            is_numeric = 'true' if elem.is_numeric else 'false'
            is_monetary = 'true' if elem.is_monetary else 'false'
            unit = f"'{elem.unit_ref}'" if elem.unit_ref else 'NULL'
            
            lines.append(
                f"  ('{elem.element_id}', '{elem.tag}', {self._sql_string(elem.label_en)}, "
                f"'Concept', '{elem.data_type}', '{elem.period_type}', {is_numeric}, {is_monetary}, {unit})"
                + ("," if i < len(elements) - 1 else "")
            )
        
        lines.extend([
            ") AS data(element_id, tag, label, element_type, data_type, period_type, is_numeric, is_monetary, unit)",
            "ON CONFLICT (taxonomy_id, xbrl_element_id) DO NOTHING;",
            ""
        ])
        
        return "\n".join(lines)
    
    def generate_insert_mappings(self, mappings: List[Mapping]) -> str:
        """Generuj INSERT pre esrs_to_xbrl_mapping"""
        lines = [
            "-- ESRS to XBRL Mappings insert",
            "INSERT INTO esrs_to_xbrl_mapping (datapoint_id, xbrl_element_id, taxonomy_id, esrs_standard, mapping_type, applies_to, valid_from_version)",
            "SELECT",
            "  data.datapoint_id,",
            f"  (SELECT id FROM xbrl_element WHERE xbrl_element_id = data.xbrl_element_id),",
            f"  (SELECT id FROM xbrl_taxonomy WHERE taxonomy_code = '{self.taxonomy_id}'),",
            "  data.esrs_standard,",
            "  data.mapping_type,",
            "  data.applies_to,",
            "  '2024-01'",
            "FROM (VALUES"
        ]
        
        for i, m in enumerate(mappings):
            applies_to = "ARRAY['{}']".format("','".join(m.applies_to))
            lines.append(
                f"  ('{m.datapoint_id}', '{m.xbrl_element_id}', '{m.esrs_standard}', '{m.mapping_type}', {applies_to})"
                + ("," if i < len(mappings) - 1 else "")
            )
        
        lines.extend([
            ") AS data(datapoint_id, xbrl_element_id, esrs_standard, mapping_type, applies_to)",
            "ON CONFLICT (datapoint_id, taxonomy_id, valid_from_version) DO NOTHING;",
            ""
        ])
        
        return "\n".join(lines)
    
    @staticmethod
    def _sql_string(s: str) -> str:
        """Escape SQL string"""
        return "'" + s.replace("'", "''") + "'"

# ============================================================================
# MAIN
# ============================================================================

def main():
    parser = argparse.ArgumentParser(
        description='XBRL Taxonomy Parser & Mapper for ESRS'
    )
    parser.add_argument('--input', required=True, help='Path to IG3 CSV directory')
    parser.add_argument('--output', help='Output SQL file (default: stdout)')
    parser.add_argument('--supabase', action='store_true', help='Direct Supabase import (requires env vars)')
    parser.add_argument('--json', help='Output JSON mappings file')
    
    args = parser.parse_args()
    
    # Validuj input
    input_dir = Path(args.input)
    if not input_dir.exists():
        print(f"❌ Directory not found: {args.input}")
        sys.exit(1)
    
    print("=" * 70)
    print("🚀 XBRL Taxonomy Parser for ESRS")
    print("=" * 70)
    
    # Parse IG3 CSV
    parser_ig3 = IG3Parser(str(input_dir))
    datapoints = parser_ig3.parse_all()
    print(f"\n✅ Parsed {len(datapoints)} ESRS datapoints")
    
    # Generate XBRL elements
    gen = XBRLElementGenerator()
    elements = gen.generate_from_datapoints(datapoints)
    print(f"✅ Generated {len(elements)} XBRL elements")
    
    # Generate mappings
    mapping_gen = MappingsGenerator(datapoints, elements)
    mappings = mapping_gen.generate_direct_mappings()
    print(f"✅ Generated {len(mappings)} XBRL mappings")
    
    # Generate SQL
    sql_gen = SQLGenerator()
    sql_output = "\n".join([
        "-- ============================================================================",
        "-- Auto-generated XBRL Taxonomy SQL Inserts",
        f"-- Generated: {datetime.now().isoformat()}",
        "-- ============================================================================\n",
        "BEGIN;",
        sql_gen.generate_insert_taxonomy(),
        sql_gen.generate_insert_elements(elements),
        sql_gen.generate_insert_mappings(mappings),
        "COMMIT;",
    ])
    
    # Output
    if args.output:
        output_path = Path(args.output)
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(sql_output)
        print(f"\n✅ SQL written to {output_path}")
    else:
        print("\n" + sql_output)
    
    # JSON output
    if args.json:
        json_data = {
            'generated': datetime.now().isoformat(),
            'datapoints_count': len(datapoints),
            'elements_count': len(elements),
            'mappings_count': len(mappings),
            'elements': [asdict(e) for e in elements],
            'mappings': [asdict(m) for m in mappings],
        }
        json_path = Path(args.json)
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(json_data, f, indent=2, default=str)
        print(f"✅ JSON written to {json_path}")
    
    # Supabase import
    if args.supabase:
        if not SUPABASE_AVAILABLE:
            print("❌ supabase-py not installed. Install: pip install supabase")
            sys.exit(1)
        
        print("\n⚠️  Supabase import not yet implemented in this version.")
        print("   Use --output to generate SQL and import manually.\n")
    
    print("\n" + "=" * 70)
    print("✅ XBRL Taxonomy generation complete!")
    print("=" * 70)

if __name__ == '__main__':
    main()
