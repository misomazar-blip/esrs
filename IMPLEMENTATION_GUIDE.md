# EFRAG IG3 Datapoints - Implementačný Návod

## ✅ FÁZA 1: Spustenie SQL Migrácií

### Krok 1: Otvor Supabase SQL Editor

1. Choď na https://supabase.com
2. Prihlás sa do svojho projektu
3. V ľavom menu klikni na **"SQL Editor"**

### Krok 2: Spusti migrácie v tomto poradí

#### 2.1 Company Info Fields (ak ešte nebola spustená)

```sql
-- Skopíruj obsah z: database/add_company_info_fields.sql
```

**Kroky:**
- Otvor súbor `database/add_company_info_fields.sql`
- Skopíruj celý obsah (Ctrl+A, Ctrl+C)
- V Supabase SQL Editor vlož kód (Ctrl+V)
- Klikni **"Run"** (alebo Ctrl+Enter)
- ✅ Mal by si vidieť: "Success. No rows returned"

#### 2.2 Access Management Schema (ak ešte nebola spustená)

```sql
-- Skopíruj obsah z: database/access_management_schema.sql
```

**Kroky:**
- Otvor súbor `database/access_management_schema.sql`
- Skopíruj celý obsah
- V Supabase SQL Editor vlož kód
- Klikni **"Run"**
- ✅ Mal by si vidieť úspešné vytvorenie tabuliek

#### 2.3 Get Members Function (ak ešte nebola spustená)

```sql
-- Skopíruj obsah z: database/add_get_members_with_emails.sql
```

**Kroky:**
- Otvor súbor `database/add_get_members_with_emails.sql`
- Skopíruj celý obsah
- V Supabase SQL Editor vlož kód
- Klikni **"Run"**
- ✅ Funkcia vytvorená

#### 2.4 ESRS Versioning (NOVÉ - hlavná migrácia!)

```sql
-- Skopíruj obsah z: database/add_esrs_versioning.sql
```

**Kroky:**
- Otvor súbor `database/add_esrs_versioning.sql`
- Skopíruj celý obsah (všetkých ~309 riadkov)
- V Supabase SQL Editor vlož kód
- Klikni **"Run"**
- ⏱️ Trvá ~5-10 sekúnd
- ✅ Mal by si vidieť:
  - Vytvorená tabuľka `esrs_version`
  - Rozšírená tabuľka `report` (nový stĺpec `esrs_version_id`)
  - Rozšírená tabuľka `disclosure_question` (20+ nových stĺpcov)
  - Rozšírená tabuľka `disclosure_answer` (10+ nových stĺpcov)
  - Vytvorená tabuľka `datapoint_version_mapping`
  - Vytvorené funkcie a views
  - Vložená inicializačná verzia '2024-base'

### Krok 3: Overenie migrácie

Spusti tento kontrolný dotaz:

```sql
-- Over, že verzia bola vytvorená
SELECT * FROM esrs_version;

-- Over, že existujúce otázky majú priradenú verziu
SELECT 
  dq.code,
  dq.version_id,
  ev.version_code
FROM disclosure_question dq
LEFT JOIN esrs_version ev ON ev.id = dq.version_id
LIMIT 5;

-- Over nové stĺpce v disclosure_question
SELECT 
  column_name, 
  data_type 
FROM information_schema.columns 
WHERE table_name = 'disclosure_question' 
  AND column_name IN ('version_id', 'datapoint_id', 'data_type', 'unit')
ORDER BY column_name;
```

**Očakávaný výsledek:**
- ✅ 1 riadok v `esrs_version` s version_code = '2024-base'
- ✅ Existujúce otázky majú `version_id` = ID verzie '2024-base'
- ✅ 4+ nových stĺpcov viditeľných v informačnej schéme

---

## 🔄 FÁZA 2: Stiahnutie EFRAG IG3 Excel

### Krok 1: Stiahni oficiálny EFRAG IG3 dokument

**URL:** https://www.efrag.org/sites/default/files/media/document/2025-06/EFRAG%20IG%203%20List%20of%20ESRS%20Data%20Points%20%281%29%20%281%29.xlsx

**Alternatívna cesta:**
1. Choď na https://www.efrag.org/
2. Hľadaj "IG3" alebo "Implementation Guidance 3"
3. Stiahni Excel súbor "List of ESRS Data Points"

### Krok 2: Ulož súbor

Ulož do:
```
database/EFRAG_IG3_DataPoints.xlsx
```

### Krok 3: Prezri štruktúru Excel súboru

Excel obsahuje tieto stĺpce (približne):
- **Datapoint ID**: E1-1, E1-2, G1-1...
- **ESRS Paragraph**: ESRS 2.GOV-1.AR 16(a)
- **Disclosure Requirement**: GOV-1, E1-1
- **Datapoint Description**: Text otázky
- **Data Type**: Narrative, Percentage, Date, Monetary...
- **Mandatory/Voluntary**: Yes/No
- **Phase-in**: Áno/Nie
- **Applies to**: Large undertaking, Listed SME...

---

## 🐍 FÁZA 3: Python Import Script

Vytvoríme script, ktorý:
1. Načíta Excel súbor
2. Parsuje všetky datapoints
3. Vytvorí SQL INSERT príkazy
4. Priradí datapoints k správnym topics (E1-E5, S1-S4, G1)
5. Vloží do databázy s `version_id` = 'EFRAG-IG3-2024'

**Súbor:** `database/import_efrag_ig3.py`

Pokračovať s vytvorením Python scriptu? (Najprv over, že SQL migrácie prešli úspešne)

---

## 📝 FÁZA 4: TypeScript Typy

Aktualizujeme typy pre nové polia:

```typescript
// types/esrs.ts
export interface Question {
  // Existujúce polia
  id: string;
  code: string;
  question_text: string;
  help_text: string | null;
  topic_id: string;
  order_index: number | null;
  
  // NOVÉ - Versioning
  version_id: string | null;
  datapoint_id: string | null;
  valid_from: string | null;
  valid_to: string | null;
  
  // NOVÉ - EFRAG metadata
  esrs_paragraph: string | null;
  disclosure_requirement: string | null;
  is_mandatory: boolean;
  is_phase_in: boolean;
  phase_in_year: number | null;
  applies_to: string[] | null;
  
  // NOVÉ - Data types
  data_type: 'narrative' | 'percentage' | 'date' | 'monetary' | 'boolean' | 'integer';
  unit: string | null;
  value_options: string[] | null;
  
  // NOVÉ - Hierarchia
  parent_question_id: string | null;
  level: number;
  
  // NOVÉ - Guidance
  guidance_text: string | null;
  example_answer: string | null;
}

export interface Answer {
  // Existujúce
  id: string;
  report_id: string;
  question_id: string;
  value_text: string | null;
  
  // NOVÉ - Multiple value types
  value_numeric: number | null;
  value_integer: number | null;
  value_date: string | null;
  value_boolean: boolean | null;
  value_json: any | null;
  
  // NOVÉ - Metadata
  unit: string | null;
  data_quality: 'verified' | 'estimated' | 'calculated' | 'third-party' | null;
  confidence_level: 'high' | 'medium' | 'low' | null;
  notes: string | null;
}
```

---

## 🎨 FÁZA 5: Dynamické UI Komponenty

Vytvoríme komponenty, ktoré renderujú správny input podľa `data_type`:

```typescript
// components/DynamicQuestionInput.tsx
function DynamicQuestionInput({ question, value, onChange }) {
  switch(question.data_type) {
    case 'percentage':
      return <input type="number" min="0" max="100" step="0.1" suffix="%" />;
    
    case 'date':
      return <input type="date" />;
    
    case 'monetary':
      return <input type="number" step="0.01" prefix={question.unit || 'EUR'} />;
    
    case 'boolean':
      return <select><option value="true">Yes</option><option value="false">No</option></select>;
    
    case 'integer':
      return <input type="number" step="1" />;
    
    case 'narrative':
    default:
      return <textarea />;
  }
}
```

---

## 🚀 STAV IMPLEMENTÁCIE

- [ ] Fáza 1: SQL migrácie
- [ ] Fáza 2: Download EFRAG IG3 Excel
- [ ] Fáza 3: Python import script
- [ ] Fáza 4: TypeScript typy
- [ ] Fáza 5: UI komponenty

---

## ❓ AK SA NIEČO POKAZÍ

### Migrácia zlyhala

```sql
-- Rollback (vrátiť zmeny)
-- Pozor: Toto zmaže nové stĺpce!
ALTER TABLE disclosure_question 
  DROP COLUMN IF EXISTS version_id,
  DROP COLUMN IF EXISTS datapoint_id,
  -- ... atď
```

### Chcem vidieť aktuálnu verziu

```sql
SELECT * FROM esrs_version WHERE is_active = TRUE;
```

### Chcem vidieť všetky otázky pre aktívnu verziu

```sql
SELECT * FROM current_questions LIMIT 10;
```
