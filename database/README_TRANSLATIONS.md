# Question Translations Guide

## Prehľad

Systém podporuje viacjazyčné otázky pomocou JSONB stľpca `translations` v tabuľke `disclosure_question`.

## Implementované funkcie

### 1. Databázová štruktúra
- **Tabuľka:** `disclosure_question`
- **Nový stľpec:** `translations` (JSONB)
- **Formát:** `{ "en": "English text", "sk": "Slovenský text", "de": "Deutscher Text" }`
- **Index:** GIN index pre rýchle vyhľadávanie v JSONB

### 2. Helper funkcie

```typescript
// lib/questionTranslations.ts

// Získa preložený text otázky podľa locale
getQuestionText(question, locale) 
// Príklad: getQuestionText(question, 'sk') → vracia slovenský text

// Nastaví preklad pre jazyk
setQuestionTranslation(currentTranslations, locale, text)

// Zoznam dostupných jazykov pre otázku
getAvailableLocales(question)
```

### 3. Automatické použitie v komponentoch

Komponenty automaticky používajú správny jazyk:
- `DynamicQuestionInput` - zobrazuje otázky v aktuálnom jazyku
- Topics page - vyhľadávanie funguje v aktuálnom jazyku
- Export API - exportuje v požadovanom jazyku (`?locale=sk`)

## Ako pridať preklady

### Metóda 1: Jednoduchý update

```sql
UPDATE disclosure_question 
SET translations = jsonb_build_object(
  'en', question_text,
  'sk', 'Slovenský preklad otázky'
)
WHERE code = 'E1-1';
```

### Metóda 2: Hromadný import

```sql
-- 1. Vytvor CSV s prekladmi
-- code,slovak_text
-- E1-1,Aké sú vaše environmentálne politiky?
-- E1-2,Popíšte vašu stratégiu...

-- 2. Naimportuj do dočasnej tabuľky
CREATE TEMP TABLE temp_translations (
  question_code VARCHAR(50),
  slovak_text TEXT
);

COPY temp_translations FROM '/path/to/translations.csv' CSV HEADER;

-- 3. Aktualizuj otázky
UPDATE disclosure_question vq
SET translations = vq.translations || jsonb_build_object('sk', tt.slovak_text)
FROM temp_translations tt
WHERE vq.code = tt.question_code;
```

### Metóda 3: Použitie aplikácie (budúce)

Plánované: admin rozhranie na správu prekladov priamo v aplikácii.

## Export s prekladmi

Export automaticky používa jazyk z URL:

```bash
# Slovenský export
GET /api/export/e1?reportId=xxx&locale=sk

# Anglický export
GET /api/export/e1?reportId=xxx&locale=en
```

## Kontrola prekladov

```sql
-- Otázky s prekladmi
SELECT code, translations->>'en' as english, translations->>'sk' as slovak
FROM disclosure_question
WHERE translations IS NOT NULL;

-- Otázky bez slovenského prekladu
SELECT code, question_text
FROM disclosure_question
WHERE translations->>'sk' IS NULL
ORDER BY code;

-- Štatistika prekladov
SELECT 
  COUNT(*) as total_questions,
  COUNT(translations->>'sk') as has_slovak,
  COUNT(*) - COUNT(translations->>'sk') as missing_slovak
FROM disclosure_question;
```

## Odporúčania

1. **Migrácia existujúcich textov:** Spusti `add_question_translations.sql`
2. **Pridaj preklady postupne:** Začni s najdôležitejšími topicmi (G1, E1, S1)
3. **Udržuj konzistenciu:** Používaj jednotnú terminológiu v preklade
4. **Testuj:** Po pridaní prekladov otestuj zobrazenie v UI

## Príklad workflow

```sql
-- 1. Pridaj slovenský preklad pre topic E1
UPDATE disclosure_question vq
SET translations = translations || jsonb_build_object(
  'sk', 
  CASE vq.code
    WHEN 'E1-1' THEN 'Popíšte vaše environmentálne politiky'
    WHEN 'E1-2' THEN 'Aké sú vaše ciele v oblasti emisií?'
    ELSE vq.question_text
  END
)
FROM topic t
WHERE vq.topic_id = t.id AND t.code = 'E1';

-- 2. Skontroluj výsledok
SELECT code, question_text, translations->>'sk' as slovak
FROM disclosure_question vq
JOIN topic t ON vq.topic_id = t.id
WHERE t.code = 'E1';
```

## Chybové stavy

Ak preklad chýba, systém automaticky:
1. Skúsi anglický preklad (`translations->>'en'`)
2. Ak ani ten neexistuje, použije `question_text`
3. UI vždy zobrazí nejaký text

## Budúce rozšírenia

- [ ] Admin panel na správu prekladov
- [ ] Import/export prekladov cez UI
- [ ] Automatický preklad cez AI (DeepL/OpenAI)
- [ ] Verziovanie prekladov
- [ ] Označenie kvality prekladu
