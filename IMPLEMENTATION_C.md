# 🚀 VSME + XBRL Implementácia - Možnosť C

## 📋 Čo bolo vytvorené

Táto implementácia spája **VSME optimizáciu** (teraz) s **XBRL taxonomiou** (budúcnosť) bez ovplyvnenia existujúcich dát.

### ✅ Vytvorené Súčasti

#### 1. **Database Migrácie**
- `database/add_xbrl_taxonomy.sql` - XBRL schema (9 nových tabuliek, 0 zmien na existujúcich)
- `database/add_vsme_extensions.sql` - VSME logika (4 rozšírenia + views + funkcie)

#### 2. **TypeScript Utilities**
- `lib/vsmeQuestions.ts` - Query funkcie a helpers pre VSME
  - `getVSMEQuestionsForReport()` - Načítaj aplikovateľné otázky
  - `getVSMEQuestionCategories()` - Kategorizuj na "Teraz/Budúce/Voliteľné"
  - `getVSMEReportProgress()` - Počítaj progress
  - `formatVSMEProgress()` - UI formátovanie

#### 3. **React Komponenta**
- `components/VSMESetupWizard.tsx` - Setup sprievodca v 4 krokoch
  - Krok 1: Inštrukcie (čo je VSME)
  - Krok 2: Počet zamestnancov (validácia)
  - Krok 3: Potvrdenie
  - Krok 4: Hotovo!
  - Automatické uloženie do `company.employee_count`

#### 4. **Python Automation Script**
- `database/parse_xbrl_taxonomy.py` - XBRL mapping generátor
  - Parsuje IG3 CSV tabuľky
  - Generuje XBRL elementy
  - Vytvára mappingy ESRS ↔ XBRL
  - Output: SQL INSERT statements

---

## 🔧 PHASE 1: DATABASE SETUP (Teraz)

### Krok 1A: Spusti XBRL migráciu v Supabase

1. Choď na https://supabase.com
2. Otvori **SQL Editor**
3. Otvori súbor: `database/add_xbrl_taxonomy.sql`
4. Skopíruj celý obsah (Ctrl+A, Ctrl+C)
5. Vlož do SQL Editor
6. Klikni **Run** (alebo Ctrl+Enter)
7. ✅ Mal by si vidieť: Success

**Poznámka:** Tabuľky budú prázdne - naplnia sa cez Python script neskôr.

### Krok 1B: Spusti VSME migráciu v Supabase

1. Otvori súbor: `database/add_vsme_extensions.sql`
2. Skopíruj a vlož do SQL Editor
3. Klikni **Run**
4. ✅ Oba SQL-y by mali byť bez chýb

**Čo sa stalo:**
```sql
-- company tabuľka:
+ employee_count INTEGER
+ is_vsme BOOLEAN GENERATED (počítá sa automaticky)
+ employee_size_category TEXT GENERATED (micro/small/medium/large)

-- report tabuľka:
+ reporting_year_sequence INTEGER (1, 2, 3+)

-- disclosure_question tabuľka:
+ applies_to_vsme_year INTEGER[] ([1,2,3] alebo [2,3] atď)
+ is_phased_in_for_vsme BOOLEAN
+ vsme_note TEXT

-- Nové VIEWS:
v_vsme_applicable_questions
v_vsme_questions_by_year_and_company
v_vsme_report_progress
v_vsme_question_categories
```

---

## 🌐 PHASE 2: FRONTEND INTEGRATION (Kedy je DB hotová)

### Krok 2A: Integrácia Setup Wizard do Dashboard

**V** `app/[locale]/page.tsx` (homepage):

```tsx
import VSMESetupWizard from '@/components/VSMESetupWizard';

export default function HomePage() {
  const [company, setCompany] = useState<Company | null>(null);
  const [showWizard, setShowWizard] = useState(false);

  // Keď sa načíta company...
  useEffect(() => {
    // Skontroluj či company.employee_count je NULL
    if (company && company.employee_count === null) {
      setShowWizard(true);
    }
  }, [company]);

  if (showWizard) {
    return (
      <VSMESetupWizard
        companyId={company!.id}
        onComplete={(count) => {
          setShowWizard(false);
          // Refreshni company dáta
          loadCompanies(userId);
        }}
        onSkip={() => setShowWizard(false)}
      />
    );
  }

  // ... rest of dashboard
}
```

### Krok 2B: Nový Dashboard Layout (4 sekcie)

**Vytvor komponentu** `components/VSMEDashboardCards.tsx`:

```tsx
"use client";

import { VSMEQuestionCategory } from '@/lib/vsmeQuestions';

export default function VSMEDashboardCards({
  categories,
  progress,
}: {
  categories: VSMEQuestionCategory[];
  progress: { percent: number; status: string };
}) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '20px' }}>
      <Card title="🟢 Teraz Povinné" {...categories[0]} status="active" />
      <Card title="🔵 V Budúcnosti" {...categories[1]} status="pending" />
      <Card title="🟡 Voliteľné" {...categories[2]} status="optional" />
      <Card title="📊 Progress" {...progress} status="always" />
    </div>
  );
}
```

**V homepage integruj:**

```tsx
import { 
  getVSMEQuestionCategories, 
  getVSMEReportProgress 
} from '@/lib/vsmeQuestions';

// V loadDashboardData():
const categories = await getVSMEQuestionCategories(reportId, supabase);
const progress = await getVSMEReportProgress(reportId, supabase);
```

---

## 🐍 PHASE 3: XBRL MAPPING (Paralelne - Nepovinné teraz)

### Krok 3A: Spusti Python Script

```bash
# Nainštaluj dependencies (ak chýbajú)
pip install supabase dotenv

# Spusti script
cd database/
python parse_xbrl_taxonomy.py \
  --input "IG3 csv/" \
  --output xbrl_mappings.sql \
  --json xbrl_mappings.json
```

**Output:**
- `xbrl_mappings.sql` - SQL INSERT statements
- `xbrl_mappings.json` - JSON s mapovaniami

### Krok 3B: Import do Supabase

1. Otvori `xbrl_mappings.sql`
2. Skopíruj a vlož do SQL Editor
3. Klikni **Run**
4. ✅ XBRL tabuľky sú naplnené!

---

## 🧪 PHASE 4: TESTING

### Test 1: VSME Filtrovaní Otázok

```sql
-- Skontroluj že otázky majú applies_to_vsme_year
SELECT code, applies_to_vsme_year FROM disclosure_question LIMIT 10;

-- Otázky aplikovateľné v R1
SELECT code FROM disclosure_question 
WHERE applies_to_vsme_year @> ARRAY[1]
ORDER BY code;

-- Otázky fázované (R2+)
SELECT code, vsme_note FROM disclosure_question 
WHERE is_phased_in_for_vsme = true;
```

### Test 2: VSME Dashboard Progress

```sql
-- Progress report
SELECT * FROM fn_get_vsme_report_progress('REPORT-ID-HERE');
```

### Test 3: XBRL Mappings

```sql
-- Koľko mappingov je hotových
SELECT COUNT(*) as mapping_count FROM esrs_to_xbrl_mapping;

-- Existujúce mappingy
SELECT datapoint_id, xbrl_element_id, mapping_type 
FROM esrs_to_xbrl_mapping LIMIT 20;
```

---

## 📚 INTEGRÁCIA S EXISTUJÚCYM KODOM

### Na existujúce query:

**STARÉ (Full data bez filtringu):**
```tsx
const { data } = await supabase
  .from('disclosure_question')
  .select('*')
  .order('code');
```

**NOVÉ (S VSME filtrami):**
```tsx
import { getVSMEQuestionsForReport } from '@/lib/vsmeQuestions';

const questions = await getVSMEQuestionsForReport(reportId, supabase);
```

### Na existujúce komponenty:

**Setup Wizard je voliteľný** - stará homepage pôjde aj bez neho.

Ale odporúčame:
1. Zobrazí sprievodcu pri prvom logine
2. Skryte je v `localStorage` aby nebol obtlačován

---

## 🎯 PRIORITA IMPLEMENTÁCIE

### 🔴 MVP (Nutnosť - Týždeň 1)
- [ ] Spustiť obe migrácie (XBRL + VSME) v Supabase
- [ ] Otestovať že `apply_to_vsme_year` sa sčítava správne
- [ ] Integrovať `getVSMEQuestionsForReport()` do súčasného question API

### 🟡 V Tomto Týždni (Týždeň 2)
- [ ] Vytvoriť VSMEDashboardCards komponentu
- [ ] Integrujte Setup Wizard do existujúceho dashboards
- [ ] Testovať filter otázok podľa roku (R1, R2, R3...)

### 🟢 Voliteľne (Weeks 3-4)
- [ ] Spustiť Python script na XBRL mappings
- [ ] Vytvoriť XBRL export (keď bude potrebný)
- [ ] Vytvoriť XBRL validáciu

---

## 📞 CHYBA BUDÚCNOSTI?

### 1. "ModuleNotFoundError: No module named 'supabase'"

Riešenie:
```bash
pip install supabase python-dotenv
```

### 2. "views neexistujú keď spustím query"

Skontroluj:
```sql
SELECT * FROM information_schema.views WHERE table_schema = 'public';
```

Ak chýbajú, znovu spusti `add_vsme_extensions.sql`.

### 3. Setup Wizard sa nezobrazuje

Skontroluj:
```tsx
// V employee_count NULL?
const { data } = await supabase.from('company').select('employee_count').eq('id', companyId);
console.log(data); // měl by být null
```

---

## 📖 DOKUMENTÁCIA

### Database
- `VSME_OPTIMIZATION_PLAN.md` - Stratégia
- `database/add_vsme_extensions.sql` - SQL komentáre
- `database/add_xbrl_taxonomy.sql` - XBRL dokumentácia

### Code
- `lib/vsmeQuestions.ts` - JSDoc komentáre
- `components/VSMESetupWizard.tsx` - Inline komentáre

### Scripts
- `database/parse_xbrl_taxonomy.py` - Docstrings + --help

---

## ✨ ĎALEJ?

Keď bude MVP hotový, nasledujú:
1. **AI Asistent** - Pomôcť s odpoveďami
2. **Longitudinal Data** - Prevzatie z minulého roku
3. **XBRL Export** - Keď EU požiadá

---

## 👤 Autor & Verzia

- **Vytvorené:** 13.2.2026
- **Verzia:** 1.0 (Initial VSME + XBRL Schema)
- **Status:** 🟢 Ready for Staging
