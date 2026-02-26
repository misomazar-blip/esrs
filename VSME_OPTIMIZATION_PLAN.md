# VSME Optimizačný Plán - ESRS Platforma

## 🎯 Cieľ
Transformovať platformu zo všeobecného ESRS riešenia na **špecializovanú platformu pre malé firmy a mikropodnikánie** s maximálnym zjednodušením a inteligentnými automatizáciami.

## 📊 VSME Špecifiká z EFRAG

### Definícia
- **Maksimálne 750 zamestnancov** (v priemere počas finančného roka)
- Môžu mať **oveľa menej informácií** ako veľké firmy
- Často **bez dedikovaného ESG oddelenia** (1 osoba alebo funkcionár naviac)

### Fázované zavádzanie (Phase-in)
Firmy s <750 zamestnancami majú **predĺžené lehoty**:

| Doména | Rok 1 | Rok 2+ | Poznámka |
|--------|-------|--------|----------|
| **E1 (Klíma)** | Vynechať Scope 3, IRO-1 povinné | Všetko povinné | Fázovanie o 1 rok |
| **S1 (Pracovníci)** | Presunúť do R2 | Všetko povinné | Fázovanie o 1 rok |
| **S2 (V-chain pracovníci)** | Presunúť do R3 | Presunúť | Fázovanie o 2 roky |
| **S3 (Postihnuté komunity)** | Presunúť do R3 | Presunúť | Fázovanie o 2 roky |
| **S4 (Spotrebielia)** | Presunúť do R3 | Presunúť | Fázovanie o 2 roky |
| **E4 (Biodiverzita)** | Presunúť do R3 | Presunúť | Fázovanie o 2 roky |

### Minimum Disclosure Requirements (MDR)
- Povinné iba ak je doména **materiálna** podľa vlastného hodnotenia
- Nie: všeobecné otázky z ESRS 2 (SBM-1, SBM-3 vždy povinné)

---

## 🔴 AKTUÁLNE PROBLÉMY

1. **Nezjednoduené otázky** - aplikácia ukazuje rovnaký počet otázok ako pre veľké firmy
2. **Chýba inteligentné filtrovanie** - nič sa neberie ohľad na veľkosť firmy
3. **Nerozlišuje rok reportingu** - všetky otázky dostupné aj v R1 (kedy sú niektoré ešte "povinne dobrovoľné")
4. **Chýba AI asistent** - používateľ musí sám vymýšľať odpovede
5. **Export je preplnený** - zahŕňa údaje, ktoré VSME vôbec nemusí mať
6. **UX nie je intuitívny** - bez sprievodcu a vzdelávania

---

## ✅ ODPORÚČENÍ RIEŠENIA

### FÁZA 1: Základná Logika VSME (P1 - KRITICKÉ)

#### 1.1 Rozšíriť databázový model
```sql
-- V tabuľke 'company': 
ALTER TABLE company ADD COLUMN IF NOT EXISTS employee_count INTEGER;
ALTER TABLE company ADD COLUMN IF NOT EXISTS is_vsme BOOLEAN GENERATED ALWAYS AS (employee_count IS NULL OR employee_count <= 750) STORED;

-- V tabuľke 'report':
ALTER TABLE report ADD COLUMN IF NOT EXISTS is_first_reporting_year BOOLEAN DEFAULT true;
ALTER TABLE report ADD COLUMN IF NOT EXISTS reporting_year_sequence INTEGER; -- 1, 2, 3+

-- V tabuľke 'disclosure_question':
ALTER TABLE disclosure_question ADD COLUMN IF NOT EXISTS applies_to_vsme_year INTEGER[]; -- [1,2,3] = od ktorého roku
ALTER TABLE disclosure_question ADD COLUMN IF NOT EXISTS vsme_phasedin_year INTEGER; -- kedy sa pre VSME stáva povinný
```

#### 1.2 Inteligentné Filtrovanie Otázok
- Keď sa berie otázka z `disclosure_question`:
  - Filtruj podľa `is_vsme` firmy
  - Skontroluj `applies_to_vsme_year` vs `reporting_year_sequence`
  - Preskakuj (skry) otázky ktoré nie sú ešte povinné

### FÁZA 2: UX/UI pre VSME (P1 - KRITICKÉ)

#### 2.1 Nová Dopytovacia Komponenta (Question Assistant)
```tsx
// components/VSMEQuestionFlow.tsx
- Sprievodca cez otázky (wizard-style)
- Vyžiadaj najskôr: počet zamestnancov, rok reportingu
- Automaticky skry irelevantné otázky
- Ukáž jasne: "Povinné v tomto roku", "Dobrovoľné", "Bude povinné v ďalšom roku"
- Tip tlačidlo s vysvetlením każdej otázky
```

#### 2.2 Novo Sekcie v Dashboarde
```tsx
// app/[locale]/page.tsx
- "🚀 Spustenie" → Informácie o firme (počet zamestnancov)
- "📋 Povinné dokonay" → Iba to čo je v tomto roku povinné
- "📅 Na budúci rok" → Čo sa bude musieť robit neskôr
- "❓ Dobrovoľné" → Čo je voliteľné
```

### FÁZA 3: AI Asistent (P2 - DÔLEŽITÉ)

#### 3.1 Integrácia AI
```
- Pomôcť s odpoveďami na otázky
- "Podľa tvojich údajov (počet zamestnancov, svektor, ...), tu je návrh odpovědi"
- Kontrola konzistentnosti (ak v Q1 napíš "100 zamestnancov", a v inej otázke napíš "500", asistent varuje)
```

### FÁZA 4: Zjednodušený Export (P1 - KRITICKÉ)

#### 4.1 VSME Report
```
- Exportuj iba: otázky ktoré boli povinné v tomto roku
- Inklúduj: vysvetlivky, definície, citácie ESRS
- Vylúč: komplexné tabuľky, nepotrebné details
- Formáty: PDF (pre rég. autority), Excel (pre archiváciu), HTML (web čítanie)
```

### FÁZA 5: Dátová Správa a Cieľa (P2 - DÔLEŽITÉ)

#### 5.1 Longitudinal Data Storage
```
- Uchováj dáta aj ciele z minulého roku
- "Letos si deklaroval, že máš 50 zamestnancov - chceš zmeniť?"
- Tracking progrésu: "Lani si uviedol emisie 100t CO2, teraz máš 95t - to je zlepšenie o 5%"
```

---

## 📈 Implementačný Plán

### PRIORITA 1 (Týždeň 1-2): MVP
- [ ] Pridať `employee_count` a `is_first_reporting_year` do DB
- [ ] Vytvoriť `getApplicableQuestions()` funkciu s filtrom VSME
- [ ] Vytvoriť jednoduchuý "Konfig Sprievodca" (SetupWizard namiesto dlhého formulára)
- [ ] Testovať s 3-5 VSME prípadmi

### PRIORITA 2 (Týždeň 3-4): UX
- [ ] Vytvoriť VSMEQuestionFlow komponentu
- [ ] Redesign dashboarde pre VSME (4 sekcie: Povinné/Budúce/Voliteľné)
- [ ] Zjednodušený export v TXT/Excel

### PRIORITA 3 (Týždeň 5+): AI
- [ ] Integracia s LLM API (OpenAI/Anthropic)
- [ ] Question Suggestions
- [ ] Consistency Checks
- [ ] Chat asistent

---

## 🎨 Návrh UX Premennej

### Hlavný Dashboard (VSME verzia)

```
┌─────────────────────────────────────────────────┐
│         🏢 ABC Consulting Ltd. (50 emp.)        │
│              Reporting Year 2025 (R1)            │
└─────────────────────────────────────────────────┘

┌──────────────┬──────────────┬──────────────┐
│   🟢 TERAZ   │  🔵 BUDÚCE   │  🟡 VOLITEĽNÉ │
│   POVINNÉ    │     ROKY      │               │
├──────────────┼──────────────┼──────────────┤
│ 12/45 úloh   │ 20/45 úloh   │  13/45 úloh   │
│ (27%)        │              │               │
│              │              │               │
│ [ZAČAŤ]      │ [NÁHĽAD]     │ [VIDIEŤ]      │
└──────────────┴──────────────┴──────────────┘

┌─────────────────────────────────────────────────┐
│            Návrat na minulý rok                  │
├─────────────────────────────────────────────────┤
│ Lani si deklaroval: 45 zamestnancov             │
│ Lani si uviedol cieľ: Znížiť emisie o 10%      │
│                                                  │
│ [↻ Prevziať z minula]                          │
└─────────────────────────────────────────────────┘
```

### Question Flow (Sprievodca)

```
┌─────────────────────────────────────────────────┐
│  Otázka 1/12: Počet zamestnancov                │
├─────────────────────────────────────────────────┤
│                                                  │
│ Koľko máte aproximátne zamestnancov?            │
│ (Priemer počas finančného roka)                 │
│                                                  │
│ [____________] zamestnancov                     │
│                                                  │
│ ℹ️  Toto určuje, ktoré otázky sú pre vás       │
│    relevantné (VSME priveľa < 750)             │
│                                                  │
│  [← Späť]  [Ďalej →]                           │
└─────────────────────────────────────────────────┘
```

---

## 🔐 Bezpečnosť & Compliance

1. **RLS (Row Level Security)** - Supabase bereits has
2. **Tenis Dát** - Uchovať údaje z viacerých rokov
3. **Audit Trail** - Kto, kedy, čo zmenil
4. **GDPR** - Len potrebné dáta, export možnosť

---

## 📞 Ďalšie Kroky

1. **Rozhovor s VSME** - Porozumieť ich frustráciam (e.g. "príliš veľa otázok")
2. **Prototyp** - Rýchlo vytvoriť MVP s filtrom
3. **Testovanie** - 5-10 VSME používateľov
4. **Iterácia** - Zlepšovanie na základe feedback

---

## 📚 Referencias

- EFRAG ESRS 1: Appendix C (Phase-in provisions for <750 employees)
- EFRAG IG3: ESRS datapoints with VSME flags
- DIRECTIVE (EU) 2024/1175 - Recent CSRD amendments for SMEs
