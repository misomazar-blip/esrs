# 🔧 KROK ZA KROKOM NÁVOD - VSME + XBRL IMPLEMENTÁCIA

## 📌 DNES (13.2.2026)

Tento návod ťa vedie cez všetko čo treba urobiť teraz, aby VSME platforma fungovala.

---

## BLOK 1: Database Migrácie (20 minút) ⏱️

### KROK 1: Otvoriť Supabase SQL Editor

1. Choď na https://supabase.com a prihlás sa
2. Vyber svoj projekt (esrs-sme-platform)
3. V **ľavom menu** → klikni **SQL Editor**
4. Vidíš prázdny editor

**✅ Hotovo?** Pokračuj. Nevidíš SQL Editor? Refreshni stránku.

---

### KROK 2: Spusti XBRL Taxonomy Migráciu

1. Otvori v editori súbor: `database/add_xbrl_taxonomy.sql`
   - Klikni v editori: **File** (alebo Ctrl+O)
   - Vyber `add_xbrl_taxonomy.sql` z tvojho projektu

2. Skopíruj **VŠETOK** obsah súboru:
   - Ctrl+A (vyber všetko)
   - Ctrl+C (skopíruj)

3. V Supabase SQL Editor:
   - Vymaž čo tam je (Ctrl+A → Delete)
   - Vlož nový kód: Ctrl+V

4. Klikni **Run** gombík (alebo Ctrl+Enter)

**Čakaj na odpoveď...**

✅ **Správne:** "Success. No rows returned." alebo "Tables created successfully"

❌ **Chyba?** Pozri spodok obrazovky - čo hovorí error?

**Je hotovo? Pokľadaj v Database Browser (ľavo):**
- Rozviň → public → Tables
- Mal by si vidieť: `xbrl_taxonomy`, `xbrl_element`, `esrs_to_xbrl_mapping`, ...

---

### KROK 3: Spusti VSME Extensions Migráciu

1. Otvori súbor: `database/add_vsme_extensions.sql`

2. Skopíruj všetko (Ctrl+A, Ctrl+C)

3. V SQL Editore:
   - Vymaž starý kód
   - Vlož nový
   - Klikni **Run**

✅ **Správne:** Bude chvíľu trvať (~5 sekúnd), potom "Success"

**Skontroluj v Database Browser:**
- `company` tabuľka: má nový stĺpec `employee_count` ✅
- `report` tabuľka: má nový stĺpec `reporting_year_sequence` ✅
- `disclosure_question` tabuľka: má `applies_to_vsme_year`, `is_phased_in_for_vsme`, `vsme_note` ✅

---

### KROK 4: Test Migácií

Spusti tieto query-ky, aby si overil všetko je OK:

**Query 1 - VSME tabuľky:**
```sql
-- Skontroluj že všetky VSME stĺpce existujú
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'company' 
  AND column_name IN ('employee_count', 'is_vsme', 'employee_size_category')
ORDER BY column_name;
```

Mal by si vidieť:
```
column_name              | data_type
------------------------+-----------
employee_count          | integer
employee_size_category  | text
is_vsme                 | boolean
```

**Query 2 - XBRL tabuľky:**
```sql
-- Skontroluj že XBRL tabuľky existujú a sú prázdne
SELECT table_name, (SELECT COUNT(*) FROM information_schema.tables 
  WHERE table_schema = 'public') as tables_exist
FROM information_schema.tables
WHERE table_name LIKE 'xbrl_%'
  AND table_schema = 'public'
ORDER BY table_name;
```

Mal by si vidieť cca 8-9 riadkov (xbrl_taxonomy, xbrl_element, xbrl_context, atď...)

**Query 3 - VSME Views:**
```sql
-- Skontroluj že views sú vytvorené
SELECT table_name 
FROM information_schema.views
WHERE table_schema = 'public' 
  AND table_name LIKE 'v_vsme%'
ORDER BY table_name;
```

Mal by si vidieť:
```
v_vsme_applicable_questions
v_vsme_question_categories
v_vsme_questions_by_year_and_company
v_vsme_report_progress
```

✅ **Všetko vidíš?** Pokračuj na BLOK 2.

---

## BLOK 2: Kód do Projektu - TypeScript

### KROK 5: Verifikuj že TypeScript súbory sú na mieste

1. Otvori svoj projekt v VS Code

2. Skontroluj že tieto súbory existujú:
   - ✅ `lib/vsmeQuestions.ts` (je vytvorený)
   - ✅ `components/VSMESetupWizard.tsx` (je vytvorený)
   - ✅ `database/parse_xbrl_taxonomy.py` (je vytvorený)

---

### KROK 6: Nainštaluj Python Dependencies (ak chceš XBRL mappingy)

**Otvori terminál PowerShell v VS Code:**

```powershell
# Presun do adresára database
cd database

# Skontroluj či máš Python
python --version
# Mal by si vidieť: Python 3.x.x

# Nainštaluj potrebné balíčky
pip install python-dotenv

# (Supabase bude nainštalovaný neskôr)
```

✅ **OK?** Pokračuj.

---

### KROK 7: Generuj XBRL SQL z IG3 CSV-iek

**V termináli (pokiaľ si stále v `database/`):**

```powershell
# Spusti Python script
python parse_xbrl_taxonomy.py `
  --input "IG3 csv/" `
  --output xbrl_mappings.sql `
  --json xbrl_mappings.json
```

**Čakaj na výstup...**

Mal by si vidieť:
```
======================================================================
🚀 XBRL Taxonomy Parser for ESRS
======================================================================

📖 Parsing ESRS2.csv...
📖 Parsing ESRS E1.csv...
[... ďalšie CSV-ky ...]

✅ Parsed 350 ESRS datapoints
✅ Generated 350 XBRL elements
✅ Generated 350 XBRL mappings

✅ SQL written to xbrl_mappings.sql
✅ JSON written to xbrl_mappings.json

======================================================================
✅ XBRL Taxonomy generation complete!
======================================================================
```

✅ **Vidíš to?** Skončilo bez chýb.

❌ **Error?**
- Skontroluj že `IG3 csv/` adresár existuje a obsahuje `.csv` súbory
- Skontroluj Python verziu: `python --version` musí byť 3.7+

---

### KROK 8: Učitaj XBRL Mappingy do Databázy

1. Otvori VS Code a nájdi vygenerovaný súbor: `xbrl_mappings.sql`

2. Skopíruj **CELÝ OBSAH** (Ctrl+A, Ctrl+C)

3. Choď späť do **Supabase SQL Editor**

4. Vymaž starý kód, vlož nový (Ctrl+V)

5. Klikni **Run**

✅ **Správne:** "Success. X rows inserted" (mal by si vidieť INSERT statements)

**Skontroluj:**
```sql
-- Koľko mappingov je v databáze?
SELECT COUNT(*) as total_mappings FROM esrs_to_xbrl_mapping;
```

Mal by si vidieť: ~350 (počet datapoints z IG3)

---

## BLOK 3: Update Existujúceho Kódu

### KROK 9: Aktualizuj Question Loading API

**V súbore:** `app/api/report-topic/[reportId]/route.ts` (alebo kdekoľvek sa nachádzajú otázky)

**STARÉ:**
```typescript
const { data: questions } = await supabase
  .from('disclosure_question')
  .select('*')
  .order('code');
```

**NOVÉ:**
```typescript
// Načítaj VSME otázky podľa roku reportingu
const { data: report } = await supabase
  .from('report')
  .select('reporting_year_sequence')
  .eq('id', reportId)
  .single();

const { data: questions } = await supabase
  .from('disclosure_question')
  .select(`
    id,
    code,
    question_text,
    description,
    answer_type,
    is_mandatory,
    is_conditional,
    is_voluntary,
    applies_to_vsme_year,
    vsme_note,
    topic:topic_id (
      id,
      code,
      name,
      category
    )
  `)
  .filter('applies_to_vsme_year', 'cs', `[${report.reporting_year_sequence}]`)
  .order('topic_id')
  .order('order_index');
```

Čím sa liší?
- Filtruje otázky podľa `reporting_year_sequence`
- Vracia len otázky relevantné pre daný rok

---

### KROK 10: Integruj VSMESetupWizard do Homepage

**V súbore:** `app/[locale]/page.tsx` (homepage)

**Na začiatok súboru pridaj import:**
```typescript
import VSMESetupWizard from "@/components/VSMESetupWizard";
```

**V komponente pridaj state:**
```typescript
const [showVSMEWizard, setShowVSMEWizard] = useState(false);
```

**V useEffect keď sa načíta company, pridaj:**
```typescript
useEffect(() => {
  if (company && company.employee_count === null) {
    // Firmu nemá zadaný počet zamestnancov
    setShowVSMEWizard(true);
  }
}, [company]);
```

**Na vrátenie komponentu (return statement), pridaj na začiatok:**
```typescript
if (showVSMEWizard) {
  return (
    <VSMESetupWizard
      companyId={selectedCompanyId!}
      currentEmployeeCount={company?.employee_count || null}
      onComplete={(count) => {
        console.log(`✅ Počet zamestnancov: ${count}`);
        setShowVSMEWizard(false);
        // Refreshni company dáta
        if (userId) {
          loadCompanies(userId);
        }
      }}
      onSkip={() => {
        setShowVSMEWizard(false);
      }}
    />
  );
}
```

---

### KROK 11: Aktualizuj TypeScript Types

**V súbore:** `types/esrs.ts`

Pridaj do existujúceho interfacu `VersionedQuestion`:

```typescript
export interface VersionedQuestion {
  id: string;
  topic_id: string;
  code: string;
  question_text: string;
  // ... ostatné existujúce polia ...

  // NOVÉ - VSME polia:
  applies_to_vsme_year?: number[];        // [1,2,3] alebo [2,3]
  is_phased_in_for_vsme?: boolean;
  vsme_note?: string;
}
```

---

## BLOK 4: Test a Validácia

### KROK 12: Spusti Development Server

```powershell
# V root adresári projektu
npm run dev
```

Čakaj až vidíš:
```
> ready - started server on 0.0.0.0:3000, url: http://localhost:3000
```

---

### KROK 13: Test Homepage + Setup Wizard

1. Otvor prehliadač: http://localhost:3000

2. Prihlás sa (ak nie je automaticky)

3. **Ak je to PRVÝ raz:**
   - Mal by si vidieť **VSMESetupWizard** so 4 krokami
   - Klikni "Pokračovať"
   - Vlož počet zamestnancov: **45**
   - Skončí: "Ste VSME ✅"

4. **Ak je to ďalší raz:**
   - Wizard by sa nemal zobraziť (employee_count je uložený)
   - Vidíš normálny dashboard

---

### KROK 14: Test Otázok s Filtrom

1. Vytvoriť nový report (alebo otvoriť existujúci)

2. Choď na otázky (napr. E1 - Climate)

3. **Mahol si vidieť:**
   - Iba otázky aplikovateľné v tomto roku
   - Jestvujú vsme_note (napr. "Vo R1 nie je povinné")

4. Skontroluj otázky ktoré by mali byť "hidden" pre R1:
   ```sql
   -- Aké otázky by mali byť skryté v R1?
   SELECT code, vsme_note FROM disclosure_question
   WHERE NOT (applies_to_vsme_year @> ARRAY[1])
   LIMIT 5;
   ```

---

### KROK 15: SQL Validation Query

V Supabase SQL Editor spusti:

```sql
-- 1. Koľko firiem je VSME?
SELECT COUNT(*) as vsme_companies 
FROM company 
WHERE is_vsme = true;

-- 2. Koľko otázok je v systéme?
SELECT COUNT(*) as total_questions 
FROM disclosure_question;

-- 3. Koľko je XBRL mappingov?
SELECT COUNT(*) as mapped_datapoints 
FROM esrs_to_xbrl_mapping;

-- 4. Vzorka VSME otázok
SELECT code, applies_to_vsme_year, vsme_note 
FROM disclosure_question 
WHERE applies_to_vsme_year != ARRAY[1,2,3]
LIMIT 5;
```

---

## BLOK 5: Finalizácia & Troubleshooting

### ✅ Všetko Funguje?

Odznač si všetko čo si robil:

- ✅ XBRL migrácia spustená
- ✅ VSME migrácia spustená
- ✅ Python script vygeneroval SQL
- ✅ XBRL mappingy sú v DB
- ✅ TypeScript súbory sú v mieste
- ✅ Homepage integruje Setup Wizard
- ✅ Otázky sa filtrujú podľa roku
- ✅ Development server beží bez chýb

**JA? Všetko je hotovo! 🎉**

---

### ❌ Problémy?

#### Problem 1: "Module not found: vsmeQuestions"

**Riešenie:**
```powershell
# Restartuj development server
# Zmaž .next folder
rm -r .next
npm run dev
```

#### Problem 2: "relation 'company' does not have column 'employee_count'"

**Riešenie:**
```sql
-- Spusti VSME migráciu znovu:
-- Skopíruj celý obsah add_vsme_extensions.sql a spusti v SQL Editor
```

#### Problem 3: "VSMESetupWizard not showing"

**Skontroluj:**
```typescript
// V page.tsx:
console.log('employee_count:', company?.employee_count);
console.log('showWizard:', showVSMEWizard);
```

Sprievodca by sa mal zobraziť len ak `employee_count === null`.

#### Problem 4: "XBRL tables exist but are empty"

**To je OK!** XBRL tabuľky sú prázdne kým nespustíš Python script. Po spustení:
```sql
SELECT COUNT(*) FROM xbrl_element;  -- buď vidieť ~350
SELECT COUNT(*) FROM esrs_to_xbrl_mapping;  -- buď vidieť ~350
```

---

## 🎯 Čo Ďalej?

Keď máš všetko hotovo, príde:

1. **AI Asistent** - Pomôcť s odpoveďami na otázky
2. **Longitudinal Data** - Preberať dáta z minulého roku
3. **Dashboard Progress** - Vizualizácia 4 sekcií (Teraz/Budúce/Voliteľné)

Zatiaľ si to **uložené**, keď sa rozhodneš ďalšie.

---

## 📞 Potrebuješ Help?

Ak niečo zlyhá:

1. **Čítaj error message** - zvyčajne povie čo je zle
2. **Skontroluj typy** - databáza je case-sensitive
3. **Refreshni prehliadač** (Ctrl+Shift+R)
4. **Restartuj npm** (Ctrl+C, npm run dev)

---

**Hotovo? 🚀 Gratulujem! Tvoja VSME platforma je živá!**
