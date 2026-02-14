# VSME Database Contract

## Overview

This document describes the database contract for the VSME (Voluntary Sustainability and ESG Metrics for Enterprises) data model, including the `vsme_datapoint` table structure and relationships.

## Table: vsme_datapoint

The `vsme_datapoint` table serves as the master definition for all VSME reporting datapoints, extracted from the VSME-Digital-Template-1.1.1.xlsx template.

### Schema

```sql
CREATE TABLE vsme_datapoint (
  id VARCHAR(255) PRIMARY KEY,
  module VARCHAR(10),
  level VARCHAR(20),
  label_en VARCHAR(512),
  data_type VARCHAR(20),
  unit VARCHAR(50)
);
```

### Column Definitions

| Column | Type | Description |
|--------|------|-------------|
| `id` | VARCHAR(255) | Unique identifier for the datapoint (e.g., 'AddressOfSite', 'NumberOfEmployees') |
| `module` | VARCHAR(10) | VSME module code: B1-B11 (Basic Module), C1-C9 (Comprehensive Module), or NULL |
| `level` | VARCHAR(20) | Reporting level: 'core', 'comprehensive', or NULL |
| `label_en` | VARCHAR(512) | English descriptive label for the datapoint |
| `data_type` | VARCHAR(20) | Data type: 'string', 'number', 'enum', 'date', 'time', 'percent', or 'boolean' |
| `unit` | VARCHAR(50) | Unit of measurement (e.g., 'MWh', 'tCO2e', 'kg', 'm3'), or NULL if not applicable |

## Data Extraction Process

### Source Template
- **File**: VSME-Digital-Template-1.1.1.xlsx
- **Sheets**: 
  - General Information (Module B1)
  - Environmental Disclosures (Modules B2-B7, C1-C6)
  - Social Disclosures (Modules B8-B9, C7)
  - Governance Disclosures (Modules B10-B11, C8-C9)

### Extraction Methodology

1. **Named Range Extraction**: 797 defined names extracted from Excel workbook
2. **Translation Mapping**: Template labels (e.g., `template_label_b1_001`) resolved to English via Translations sheet
3. **Module Detection**: Module affiliation determined via nearest-above header row containing module code (B1-B11, C1-C9)
4. **Data Type Inference**: 
   - Data validation type → 'enum' for list validation
   - Number format + validation → 'number' for numeric fields
   - Custom format patterns → 'date', 'time', 'percent' as applicable
   - Default → 'string'
5. **Unit Extraction**: Whitelist-based extraction for explicit units (MWh, tCO2e, kg, tonne, m3, m2, EUR, %)

### Quality Assurance
- **Deduplication**: 797 named ranges deduplicated to 157 unique datapoints by id
- **Label Validation**: Labels ASCII-encoded; formula cells and reference cells skipped
- **Type Validation**: Data types verified against validation rules in template
- **Unit Assignment**: Units only assigned to numeric and percentage data types

## Seed Data

The file `database/seed_vsme_datapoint.sql` contains INSERT statements for all 157 datapoints:

```sql
INSERT INTO vsme_datapoint(id, module, level, label_en, data_type, unit) VALUES
('AddressOfSite', 'B1', 'core', 'Address', 'string', NULL),
('NumberOfEmployees', 'B1', 'core', 'Number of Employees', 'number', NULL),
...
```

## Module Structure

### Basic Module (B-Modules)
- **B1**: General Information
- **B2**: Resource Inputs
- **B3**: Resource Outputs
- **B4**: Emissions
- **B5**: Environmental Compliance & Violations
- **B6**: Water & Effluents
- **B7**: Pollutants
- **B8**: Employees & Workers
- **B9**: Vulnerable Groups
- **B10**: Business Conduct
- **B11**: Civic & Policy Participation

### Comprehensive Module (C-Modules)
- **C1**: Environmental Impact Assessment
- **C2**: Environmental Management & Standards
- **C3-C6**: Extended environmental disclosures
- **C7**: Extended social disclosures
- **C8-C9**: Extended governance disclosures

## Data Type Mappings

| Data Type | Description | Example Fields |
|-----------|-------------|-----------------|
| `string` | Text data | Address, Description |
| `number` | Numeric values | NumberOfEmployees, Amount |
| `enum` | Enumerated/dropdown values | Status, Category |
| `date` | Date values | ReportingDate |
| `time` | Time values | Duration |
| `percent` | Percentage values | PercentageCompliance |
| `boolean` | Yes/No or True/False | HasPolicy |

## Unit Reference

Common units used in VSME datapoints:
- **Energy**: MWh (megawatt-hours)
- **Emissions**: tCO2e (tonnes CO2 equivalent)
- **Mass**: kg (kilograms), tonne (metric tonnes)
- **Volume**: m3 (cubic meters)
- **Area**: m2 (square meters)
- **Currency**: EUR (euros)
- **Percentage**: % (percentage)

## Relationships

### Potential Foreign Keys
- `module`: References module definitions (B1-B11, C1-C9)
- `data_type`: References enumerable data types
- `level`: References reporting levels (core, comprehensive)

### Dependent Tables (Future)
- `vsme_responses`: User-submitted responses keyed by datapoint id
- `vsme_validations`: Validation rules and constraints per datapoint
- `vsme_units_conversion`: Unit conversion mappings

## Usage Examples

### Retrieve all B1 (General Information) datapoints
```sql
SELECT * FROM vsme_datapoint WHERE module = 'B1';
```

### Retrieve numeric datapoints with units
```sql
SELECT * FROM vsme_datapoint WHERE data_type = 'number' AND unit IS NOT NULL;
```

### Retrieve comprehensive module disclosures
```sql
SELECT * FROM vsme_datapoint WHERE module LIKE 'C%' AND level = 'comprehensive';
```

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-01-15 | Initial extraction from VSME-Digital-Template-1.1.1.xlsx; 157 datapoints |

## Notes

- This contract reflects VSME standard as implemented in EC release 30 July 2025
- Datapoint definitions are immutable once assigned; id values should not change
- Module and level assignments follow VSME standard organization
- Data types inferred from template validation rules; may require refinement based on business logic
- Unit assignments are conservative; only explicit unit matches included
