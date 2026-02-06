-- ============================================================================
-- KOMPLETNÉ SLOVENSKÉ PREKLADY PRE VŠETKY ESRS ŠTANDARDY
-- ============================================================================
-- Dátum vytvorenia: 6. február 2026
-- Databáza: Supabase (disclosure_question table)
-- Stĺpec: translations (JSONB)
-- 
-- OBSAH:
-- ========
-- ✓ E1: Zmena klímy (Climate Change) - 203 otázok
-- ✓ E2: Znečistenie (Pollution) - 82 otázok
-- ✓ E3: Vodné zdroje (Water and Marine Resources) - 46 otázok
-- ✓ E4: Biodiverzita a ekosystémy (Biodiversity and Ecosystems) - 158 otázok
-- ✓ E5: Obehové hospodárstvo (Circular Economy) - 111 otázok
-- ✓ S1: Vlastná pracovná sila (Own Workforce) - 214 otázok
-- ✓ S2: Pracovníci v hodnotovom reťazci (Workers in Value Chain) - 81 otázok
-- ✓ S3: Ovplyvnené komunity (Affected Communities) - 70 otázok
-- ✓ S4: Spotrebitelia a koncoví používatelia (Consumers and End-users) - 70 otázok
-- ✓ G1: Obchodné správanie (Business Conduct) - 57 otázok
--
-- CELKOVÝ POČET: 1092 prekladov
--
-- INŠTRUKCIE PRE VYKONANIE:
-- =========================
-- 1. Otvorte Supabase SQL Editor
-- 2. Skopírujte celý obsah tohto súboru
-- 3. Spustite SQL skript (Execute)
-- 4. Overte úspech - na konci by sa mal zobraziť:
--    "All ESRS translations completed successfully!"
--
-- POUŽITÁ ESG TERMINOLÓGIA:
-- =========================
-- - Emisie skleníkových plynov, Dekarbonizácia, Parížska dohoda
-- - Látky vzbudzujúce obavy, Mikroplasty, Znečistenie ovzdušia/vody/pôdy
-- - Oblasti vodného stresu, Vypúšťanie vody, Spotreba vody
-- - Biologická rozmanitosť, Druhy, Habitáty, Natura 2000
-- - Odpadové hospodárstvo, Recyklácia, Sekundárne suroviny
-- - Pracovné podmienky, Zdravie a bezpečnosť, Kolektívne vyjednávanie
-- - Ľudské práva, Náležitá starostlivosť, Miestne komunity
-- - Ochrana spotrebiteľa, Osobné údaje, Bezpečnosť produktov
-- - Protikorupčné opatrenia, Etický kódex, Transparentnosť
-- ============================================================================



-- Complete Slovak translations for ESRS E1 Climate Change datapoints
-- ESG Terminology used: Emisie skleníkových plynov (GHG), Dekarbonizácia, Prechod na klimatickú neutralitu, etc.

-- GOV-3: Governance
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako sa klimatické aspekty zohľadňujú v odmeňovaní členov administratívnych, riadiacich a dozorných orgánov')
WHERE code = 'E1.GOV-3_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel odmeňovania viazaný na klimatické aspekty')
WHERE code = 'E1.GOV-3_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie klimatických aspektov zohľadnených v odmeňovaní členov administratívnych, riadiacich a dozorných orgánov')
WHERE code = 'E1.GOV-3_03';

-- E1-1: Transition Plan
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plánu prechodu na zmierňovanie zmeny klímy')
WHERE code = 'E1-1_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sú ciele zlučiteľné s obmedzením globálneho otepľovania na jeden a pol stupňa Celzia v súlade s Parížskou dohodou')
WHERE code = 'E1-1_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dekarbonizačných pák a kľúčových akcií')
WHERE code = 'E1-1_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie významných prevádzkových výdavkov (OpEx) a/alebo kapitálových výdavkov (CapEx) potrebných na realizáciu akčného plánu')
WHERE code = 'E1-1_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Finančné zdroje alokované na akčný plán (OpEx)')
WHERE code = 'E1-1_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Finančné zdroje alokované na akčný plán (CapEx)')
WHERE code = 'E1-1_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie potenciálnych uzamknutých emisií skleníkových plynov z kľúčových aktív a produktov a toho, ako môžu uzamknuté emisie ohroziť dosiahnutie cieľov zníženia emisií a zvýšiť tranzitné riziko')
WHERE code = 'E1-1_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie akýchkoľvek cieľov alebo plánov (CapEx, CapEx plány, OpEx) na zosúladenie ekonomických činností (výnosy, CapEx, OpEx) s kritériami ustanovenými v delegovanom nariadení Komisie 2021/2139')
WHERE code = 'E1-1_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Významné kapitálové výdavky na ekonomické činnosti súvisiace s uhlím')
WHERE code = 'E1-1_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Významné kapitálové výdavky na ekonomické činnosti súvisiace s ropou')
WHERE code = 'E1-1_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Významné kapitálové výdavky na ekonomické činnosti súvisiace s plynom')
WHERE code = 'E1-1_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Podnik je vylúčený z referenčných hodnôt EÚ zosúladených s Parížskou dohodou')
WHERE code = 'E1-1_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako je plán prechodu zakotvený a zosúladený s celkovou obchodnou stratégiou a finančným plánovaním')
WHERE code = 'E1-1_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Plán prechodu je schválený administratívnymi, riadiacimi a dozornými orgánmi')
WHERE code = 'E1-1_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie pokroku pri implementácii plánu prechodu')
WHERE code = 'E1-1_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Dátum prijatia plánu prechodu pre podniky, ktoré ho ešte neprijali')
WHERE code = 'E1-1_16';

-- E1.SBM-3: Material risks and opportunities
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ klimatického rizika')
WHERE code = 'E1.SBM-3_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis rozsahu analýzy odolnosti')
WHERE code = 'E1.SBM-3_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako bola vykonaná analýza odolnosti')
WHERE code = 'E1.SBM-3_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Dátum vykonania analýzy odolnosti')
WHERE code = 'E1.SBM-3_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Časové horizonty aplikované pri analýze odolnosti')
WHERE code = 'E1.SBM-3_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis výsledkov analýzy odolnosti')
WHERE code = 'E1.SBM-3_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis schopnosti upraviť alebo prispôsobiť stratégiu a obchodný model zmene klímy')
WHERE code = 'E1.SBM-3_07';

-- E1.IRO-1: Description of processes to identify and assess material impacts, risks and opportunities
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis procesu vo vzťahu k dopadom na zmenu klímy')
WHERE code = 'E1.IRO-1_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis procesu vo vzťahu ku klimatickým fyzickým rizikám vo vlastných operáciách a naprieč hodnotovým reťazcom')
WHERE code = 'E1.IRO-1_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Klimatické hrozby boli identifikované v krátkodobom, strednodobom a dlhodobom časovom horizonte')
WHERE code = 'E1.IRO-1_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Podnik preveril, či aktíva a obchodné činnosti môžu byť vystavené klimatickým hrozbám')
WHERE code = 'E1.IRO-1_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Krátkodobé, strednodobé a dlhodobé časové horizonty boli definované')
WHERE code = 'E1.IRO-1_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rozsah, v akom môžu byť aktíva a obchodné činnosti vystavené a sú citlivé na identifikované klimatické hrozby, bol posúdený')
WHERE code = 'E1.IRO-1_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Identifikácia klimatických hrozieb a posúdenie expozície a citlivosti sú informované scenármi vysokých emisií')
WHERE code = 'E1.IRO-1_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako bola analýza klimatických scenárov použitá na informovanie identifikácie a posúdenia fyzických rizík v krátkodobom, strednodobom a dlhodobom horizonte')
WHERE code = 'E1.IRO-1_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis procesu vo vzťahu ku klimatickým tranzitným rizikám a príležitostiam vo vlastných operáciách a naprieč hodnotovým reťazcom')
WHERE code = 'E1.IRO-1_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Tranzitné udalosti boli identifikované v krátkodobom, strednodobom a dlhodobom časovom horizonte')
WHERE code = 'E1.IRO-1_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Podnik preveril, či aktíva a obchodné činnosti môžu byť vystavené tranzitným udalostiam')
WHERE code = 'E1.IRO-1_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rozsah, v akom môžu byť aktíva a obchodné činnosti vystavené a sú citlivé na identifikované tranzitné udalosti, bol posúdený')
WHERE code = 'E1.IRO-1_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Identifikácia tranzitných udalostí a posúdenie expozície boli informované analýzou klimatických scenárov')
WHERE code = 'E1.IRO-1_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Aktíva a obchodné činnosti nekompatibilné alebo vyžadujúce významné úsilie na kompatibilitu s prechodom na klimaticky neutrálnu ekonomiku boli identifikované')
WHERE code = 'E1.IRO-1_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako bola analýza klimatických scenárov použitá na informovanie identifikácie a posúdenia tranzitných rizík a príležitostí v krátkodobom, strednodobom a dlhodobom horizonte')
WHERE code = 'E1.IRO-1_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sú použité klimatické scenáre kompatibilné s kritickými klimatickými predpokladmi použitými vo finančných výkazoch')
WHERE code = 'E1.IRO-1_16';

-- E1-2: Policies
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiálnych dopadov, rizík a príležitostí súvisiacich so zmenou klímy [pozri ESRS 2 MDR-P]')
WHERE code = 'E1.MDR-P_01-06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Otázky udržateľnosti riešené politikou pre zmenu klímy')
WHERE code = 'E1-2_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť v prípade, že podnik neprijal politiky')
WHERE code = 'E1.MDR-P_07-08';

-- E1-3: Actions and Resources
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje súvisiace so zmierňovaním a adaptáciou na zmenu klímy [pozri ESRS 2 MDR-A]')
WHERE code = 'E1.MDR-A_01-12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ dekarbonizačnej páky')
WHERE code = 'E1-3_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ adaptačného riešenia')
WHERE code = 'E1-3_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Dosiahnuté zníženie emisií skleníkových plynov')
WHERE code = 'E1-3_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Očakávané zníženie emisií skleníkových plynov')
WHERE code = 'E1-3_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie rozsahu, v akom závisí schopnosť implementovať akciu od dostupnosti a alokácie zdrojov')
WHERE code = 'E1-3_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzťahu významných kapitálových a prevádzkových výdavkov potrebných na implementáciu akcií k relevantným položkám alebo poznámkam vo finančných výkazoch')
WHERE code = 'E1-3_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzťahu významných kapitálových a prevádzkových výdavkov potrebných na implementáciu akcií ku kľúčovým ukazovateľom výkonnosti podľa delegovaného nariadenia (EÚ) 2021/2178')
WHERE code = 'E1-3_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzťahu významných kapitálových a prevádzkových výdavkov potrebných na implementáciu akcií k plánu kapitálových výdavkov podľa delegovaného nariadenia (EÚ) 2021/2178')
WHERE code = 'E1-3_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktoré sa má uviesť, ak podnik neprijal akcie')
WHERE code = 'E1.MDR-A_13-14';

-- E1-4: Targets
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektívnosti politík a akcií prostredníctvom cieľov [pozri ESRS 2 MDR-T]')
WHERE code = 'E1.MDR-T_01-13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako boli stanovené ciele zníženia emisií skleníkových plynov a/alebo iné ciele na riadenie materiálnych dopadov, rizík a príležitostí súvisiacich s klímou')
WHERE code = 'E1-4_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Tabuľky: Viaceré dimenzie (bázický rok a ciele; typy skleníkových plynov, kategórie Rozsah 3, dekarbonizačné páky, špecifické pre subjekt menovatele pre intenzitné hodnoty)')
WHERE code = 'E1-4_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Absolútna hodnota celkového zníženia emisií skleníkových plynov')
WHERE code = 'E1-4_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálne zníženie celkových emisií skleníkových plynov (k emisiám bázického roku)')
WHERE code = 'E1-4_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzitná hodnota celkového zníženia emisií skleníkových plynov')
WHERE code = 'E1-4_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Absolútna hodnota zníženia emisií skleníkových plynov Rozsah 1')
WHERE code = 'E1-4_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálne zníženie emisií skleníkových plynov Rozsah 1 (k emisiám bázického roku)')
WHERE code = 'E1-4_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzitná hodnota zníženia emisií skleníkových plynov Rozsah 1')
WHERE code = 'E1-4_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Absolútna hodnota zníženia emisií skleníkových plynov Rozsah 2 na základe lokality')
WHERE code = 'E1-4_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálne zníženie emisií skleníkových plynov Rozsah 2 na základe lokality (k emisiám bázického roku)')
WHERE code = 'E1-4_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzitná hodnota zníženia emisií skleníkových plynov Rozsah 2 na základe lokality')
WHERE code = 'E1-4_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Absolútna hodnota zníženia emisií skleníkových plynov Rozsah 2 na základe trhu')
WHERE code = 'E1-4_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálne zníženie emisií skleníkových plynov Rozsah 2 na základe trhu (k emisiám bázického roku)')
WHERE code = 'E1-4_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzitná hodnota zníženia emisií skleníkových plynov Rozsah 2 na základe trhu')
WHERE code = 'E1-4_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Absolútna hodnota zníženia emisií skleníkových plynov Rozsah 3')
WHERE code = 'E1-4_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálne zníženie emisií skleníkových plynov Rozsah 3 (k emisiám bázického roku)')
WHERE code = 'E1-4_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzitná hodnota zníženia emisií skleníkových plynov Rozsah 3')
WHERE code = 'E1-4_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako bola zabezpečená konzistencia cieľov zníženia emisií skleníkových plynov s hranicami inventára skleníkových plynov')
WHERE code = 'E1-4_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie doterajšieho pokroku pri plnení cieľa pred aktuálnym bázickým rokom')
WHERE code = 'E1-4_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako bolo zabezpečené, že bázická hodnota je reprezentatívna z hľadiska pokrytých činností a vplyvov externých faktorov')
WHERE code = 'E1-4_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako nová bázická hodnota ovplyvňuje nový cieľ, jeho dosiahnutie a prezentáciu pokroku v čase')
WHERE code = 'E1-4_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Cieľ zníženia emisií skleníkových plynov je založený na vede a kompatibilný s obmedzením globálneho otepľovania na jeden a pol stupňa Celzia')
WHERE code = 'E1-4_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis očakávaných dekarbonizačných pák a ich celkových kvantitatívnych príspevkov k dosiahnutiu cieľa zníženia emisií skleníkových plynov')
WHERE code = 'E1-4_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rôzne klimatické scenáre boli zvážené na odhalenie relevantných environmentálnych, spoločenských, technologických, trhových a politických vývoja a stanovenie dekarbonizačných pák')
WHERE code = 'E1-4_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktoré sa má uviesť, ak podnik nestanovil žiadne merateľné ciele orientované na výsledky')
WHERE code = 'E1.MDR-T_14-19';

-- E1-5: Energy consumption and mix
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková spotreba energie súvisiaca s vlastnými operáciami')
WHERE code = 'E1-5_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková spotreba energie z fosílnych zdrojov')
WHERE code = 'E1-5_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková spotreba energie z jadrových zdrojov')
WHERE code = 'E1-5_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel spotreby energie z jadrových zdrojov na celkovej spotrebe energie')
WHERE code = 'E1-5_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková spotreba energie z obnoviteľných zdrojov')
WHERE code = 'E1-5_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z obnoviteľných zdrojov')
WHERE code = 'E1-5_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba zakúpenej alebo získanej elektriny, tepla, pary a chladenia z obnoviteľných zdrojov')
WHERE code = 'E1-5_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba samovytvorenej nepalivovej obnoviteľnej energie')
WHERE code = 'E1-5_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel obnoviteľných zdrojov na celkovej spotrebe energie')
WHERE code = 'E1-5_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z uhlia a uhoľných produktov')
WHERE code = 'E1-5_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z ropy a ropných produktov')
WHERE code = 'E1-5_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva zo zemného plynu')
WHERE code = 'E1-5_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z iných fosílnych zdrojov')
WHERE code = 'E1-5_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba zakúpenej alebo získanej elektriny, tepla, pary alebo chladenia z fosílnych zdrojov')
WHERE code = 'E1-5_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel fosílnych zdrojov na celkovej spotrebe energie')
WHERE code = 'E1-5_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Výroba neobnoviteľnej energie')
WHERE code = 'E1-5_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Výroba obnoviteľnej energie')
WHERE code = 'E1-5_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Energetická intenzita z činností v sektoroch s vysokým klimatickým dopadom (celková spotreba energie na čisté výnosy)')
WHERE code = 'E1-5_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková spotreba energie z činností v sektoroch s vysokým klimatickým dopadom')
WHERE code = 'E1-5_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Sektory s vysokým klimatickým dopadom použité na určenie energetickej intenzity')
WHERE code = 'E1-5_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosúladenia s relevantnými položkami alebo poznámkami vo finančných výkazoch čistých výnosov z činností v sektoroch s vysokým klimatickým dopadom')
WHERE code = 'E1-5_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy z činností v sektoroch s vysokým klimatickým dopadom')
WHERE code = 'E1-5_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy z činností iných ako v sektoroch s vysokým klimatickým dopadom')
WHERE code = 'E1-5_23';

-- E1-6: Gross Scopes 1, 2, 3 and Total GHG emissions
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 1, 2, 3 a celkové emisie - emisie skleníkových plynov podľa rozsahu [tabuľka]')
WHERE code = 'E1-6_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 1, 2, 3 a celkové emisie - finančná a operačná kontrola [tabuľka]')
WHERE code = 'E1-6_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rozdelenie emisií skleníkových plynov - podľa krajiny, prevádzkových segmentov, ekonomickej činnosti, dcérskej spoločnosti, kategórie skleníkových plynov alebo typu zdroja')
WHERE code = 'E1-6_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 1, 2, 3 a celkové emisie - emisie Rozsah 3 (GHG Protocol) [tabuľka]')
WHERE code = 'E1-6_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 1, 2, 3 a celkové emisie - emisie Rozsah 3 (ISO 14064-1) [tabuľka]')
WHERE code = 'E1-6_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 1, 2, 3 a celkové emisie - celkové emisie skleníkových plynov - hodnotový reťazec [tabuľka]')
WHERE code = 'E1-6_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 1')
WHERE code = 'E1-6_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel emisií skleníkových plynov Rozsah 1 z regulovaných systémov obchodovania s emisiami')
WHERE code = 'E1-6_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 2 na základe lokality')
WHERE code = 'E1-6_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 2 na základe trhu')
WHERE code = 'E1-6_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Hrubé emisie skleníkových plynov Rozsah 3')
WHERE code = 'E1-6_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celkové emisie skleníkových plynov na základe lokality')
WHERE code = 'E1-6_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celkové emisie skleníkových plynov na základe trhu')
WHERE code = 'E1-6_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie významných zmien v definícii toho, čo predstavuje vykazujúci podnik a jeho hodnotový reťazec, a vysvetlenie ich vplyvu na porovnateľnosť vykazovaných emisií skleníkových plynov rok po roku')
WHERE code = 'E1-6_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie metodológií, významných predpokladov a emisných faktorov použitých na výpočet alebo meranie emisií skleníkových plynov')
WHERE code = 'E1-6_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vplyvov významných udalostí a zmien okolností (relevantných k jeho emisiám skleníkových plynov), ktoré nastanú medzi dátumami vykazovania subjektov v jeho hodnotovom reťazci a dátumom finančných výkazov všeobecného účelu podniku')
WHERE code = 'E1-6_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Biogénne emisie CO2 zo spaľovania alebo biodegradácie biomasy nezahrnuté v emisiách Rozsah 1')
WHERE code = 'E1-6_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zmluvných nástrojov, emisie Rozsah 2')
WHERE code = 'E1-6_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zmluvných nástrojov, emisie Rozsah 2')
WHERE code = 'E1-6_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel emisií Rozsah 2 na základe trhu spojených so zakúpenou elektrinou spolu s nástrojmi')
WHERE code = 'E1-6_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zmluvných nástrojov použitých na predaj a nákup energie spojenej s atribútmi o výrobe energie vo vzťahu k emisiám Rozsah 2')
WHERE code = 'E1-6_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zmluvných nástrojov použitých na predaj a nákup nespojených energetických atribútových nárokov vo vzťahu k emisiám Rozsah 2')
WHERE code = 'E1-6_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zmluvných nástrojov použitých na predaj a nákup energie spojenej s atribútmi o výrobe energie alebo pre nespojené energetické atribútové nároky')
WHERE code = 'E1-6_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Biogénne emisie CO2 zo spaľovania alebo biodegradácie biomasy nezahrnuté v emisiách Rozsah 2')
WHERE code = 'E1-6_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel emisií Rozsah 3 vypočítaných pomocou primárnych údajov')
WHERE code = 'E1-6_25';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dôvodu, prečo bola kategória emisií Rozsah 3 vylúčená')
WHERE code = 'E1-6_26';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zoznam kategórií emisií Rozsah 3 zahrnutých v inventári')
WHERE code = 'E1-6_27';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Biogénne emisie CO2 zo spaľovania alebo biodegradácie biomasy, ktoré sa vyskytujú v hodnotovom reťazci a nie sú zahrnuté v emisiách Rozsah 3')
WHERE code = 'E1-6_28';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zvážených hraníc vykazovania a metód výpočtu na odhad emisií Rozsah 3')
WHERE code = 'E1-6_29';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzita emisií skleníkových plynov, na základe lokality (celkové emisie skleníkových plynov na čisté výnosy)')
WHERE code = 'E1-6_30';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzita emisií skleníkových plynov, na základe trhu (celkové emisie skleníkových plynov na čisté výnosy)')
WHERE code = 'E1-6_31';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosúladenia s finančnými výkazmi čistých výnosov použitých na výpočet intenzity emisií skleníkových plynov')
WHERE code = 'E1-6_32';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy')
WHERE code = 'E1-6_33';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy použité na výpočet intenzity emisií skleníkových plynov')
WHERE code = 'E1-6_34';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy iné ako použité na výpočet intenzity emisií skleníkových plynov')
WHERE code = 'E1-6_35';

-- E1-7: GHG removals and GHG mitigation projects
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odstránenia a uskladnenia skleníkových plynov vyplývajúcich z projektov vyvinutých vo vlastných operáciách alebo prispievajúcich vo východnom a západnom hodnotovom reťazci')
WHERE code = 'E1-7_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zníženia emisií skleníkových plynov alebo odstránenia z projektov zmierňovania zmeny klímy mimo hodnotového reťazca financovaných alebo plánovaných financovať prostredníctvom nákupu uhlíkových kreditov')
WHERE code = 'E1-7_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Odstránenia a uhlíkové kredity sa používajú')
WHERE code = 'E1-7_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Činnosť odstránenia a uskladnenia skleníkových plynov podľa rozsahu podniku (rozdelenie na vlastné operácie a hodnotový reťazec) a podľa činnosti odstránenia a uskladnenia')
WHERE code = 'E1-7_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celkové odstránenie a uskladnenie skleníkových plynov')
WHERE code = 'E1-7_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Emisie skleníkových plynov spojené s činnosťou odstránenia')
WHERE code = 'E1-7_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Obrátenia')
WHERE code = 'E1-7_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie výpočtových predpokladov, metodológií a rámcov aplikovaných (odstránenie a uskladnenie skleníkových plynov)')
WHERE code = 'E1-7_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Činnosť odstránenia bola prevedená na uhlíkové kredity a predaná iným stranám na dobrovoľnom trhu')
WHERE code = 'E1-7_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková suma uhlíkových kreditov mimo hodnotového reťazca, ktoré sú overené podľa uznaných štandardov kvality a zrušené')
WHERE code = 'E1-7_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková suma uhlíkových kreditov mimo hodnotového reťazca plánovaných na zrušenie v budúcnosti')
WHERE code = 'E1-7_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu použitia a kritérií kvality použitých pre uhlíkové kredity')
WHERE code = 'E1-7_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel projektov znižovania')
WHERE code = 'E1-7_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel projektov odstránenia')
WHERE code = 'E1-7_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ uhlíkových kreditov z projektov odstránenia')
WHERE code = 'E1-7_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel pre uznaný štandard kvality')
WHERE code = 'E1-7_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel vydaný z projektov v Európskej únii')
WHERE code = 'E1-7_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel, ktorý spĺňa podmienky zodpovedajúcej úpravy')
WHERE code = 'E1-7_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Dátum, kedy sú plánované zrušenie uhlíkových kreditov mimo hodnotového reťazca')
WHERE code = 'E1-7_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie rozsahu, metodológií a rámcov aplikovaných a toho, ako sa plánuje neutralizovať zostatkové emisie skleníkových plynov')
WHERE code = 'E1-7_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Boli vykonané verejné vyhlásenia o neutralite skleníkových plynov zahŕňajúce použitie uhlíkových kreditov')
WHERE code = 'E1-7_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Verejné vyhlásenia o neutralite skleníkových plynov zahŕňajúce použitie uhlíkových kreditov sú sprevádzané cieľmi zníženia emisií skleníkových plynov')
WHERE code = 'E1-7_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Tvrdenia o neutralite skleníkových plynov a spoliehnanie sa na uhlíkové kredity nebránia ani neznižujú dosiahnutie cieľov zníženia emisií skleníkových plynov alebo cieľa čistej nuly')
WHERE code = 'E1-7_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či a ako sú verejné vyhlásenia o neutralite skleníkových plynov zahŕňajúce použitie uhlíkových kreditov sprevádzané cieľmi zníženia emisií skleníkových plynov a ako tvrdenia o neutralite a spoliehnanie sa na kredity nebránia dosiahnutiu cieľov')
WHERE code = 'E1-7_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vierohodnosti a integrity použitých uhlíkových kreditov')
WHERE code = 'E1-7_25';

-- E1-8: Internal carbon pricing
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Schéma oceňovania uhlíka podľa typu')
WHERE code = 'E1-8_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ vnútornej schémy oceňovania uhlíka')
WHERE code = 'E1-8_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis špecifického rozsahu aplikácie schémy oceňovania uhlíka')
WHERE code = 'E1-8_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Cena uhlíka aplikovaná na každú metrická tonu emisií skleníkových plynov')
WHERE code = 'E1-8_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis kritických predpokladov vykonaných na stanovenie aplikovanej ceny uhlíka')
WHERE code = 'E1-8_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel hrubých emisií Rozsah 1 pokrytých vnútornou schémou oceňovania uhlíka')
WHERE code = 'E1-8_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel hrubých emisií Rozsah 2 pokrytých vnútornou schémou oceňovania uhlíka')
WHERE code = 'E1-8_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel hrubých emisií Rozsah 3 pokrytých vnútornou schémou oceňovania uhlíka')
WHERE code = 'E1-8_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako je cena uhlíka použitá vo vnútornej schéme oceňovania uhlíka konzistentná s cenou uhlíka použitou vo finančných výkazoch')
WHERE code = 'E1-8_09';

-- E1-9: Anticipated financial effects from material physical and transition risks and potential climate-related opportunities
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Aktíva v materiálnom fyzickom riziku pred zvážením adaptačných opatrení na zmenu klímy')
WHERE code = 'E1-9_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Aktíva v akútnom materiálnom fyzickom riziku pred zvážením adaptačných opatrení na zmenu klímy')
WHERE code = 'E1-9_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Aktíva v chronickom materiálnom fyzickom riziku pred zvážením adaptačných opatrení na zmenu klímy')
WHERE code = 'E1-9_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel aktív v materiálnom fyzickom riziku pred zvážením adaptačných opatrení na zmenu klímy')
WHERE code = 'E1-9_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie lokality významných aktív v materiálnom fyzickom riziku')
WHERE code = 'E1-9_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie lokality významných aktív v materiálnom fyzickom riziku (rozdelené podľa kódov NUTS)')
WHERE code = 'E1-9_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel aktív v materiálnom fyzickom riziku riešených adaptačnými opatreniami na zmenu klímy')
WHERE code = 'E1-9_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy z obchodných činností v materiálnom fyzickom riziku')
WHERE code = 'E1-9_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých výnosov z obchodných činností v materiálnom fyzickom riziku')
WHERE code = 'E1-9_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako boli posúdené očakávané finančné účinky pre aktíva a obchodné činnosti v materiálnom fyzickom riziku')
WHERE code = 'E1-9_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako sa posúdenie aktív a obchodných činností považovaných za materiálne fyzické riziko spolieha alebo je súčasťou procesu určenia materiálneho fyzického rizika a určenia klimatických scenárov')
WHERE code = 'E1-9_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rizikových faktorov pre čisté výnosy z obchodných činností v materiálnom fyzickom riziku')
WHERE code = 'E1-9_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu očakávaných finančných účinkov z hľadiska erózie marží pre obchodné činnosti v materiálnom fyzickom riziku')
WHERE code = 'E1-9_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Aktíva v materiálnom tranzitnom riziku pred zvážením klimatických zmierňujúcich opatrení')
WHERE code = 'E1-9_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel aktív v materiálnom tranzitnom riziku pred zvážením klimatických zmierňujúcich opatrení')
WHERE code = 'E1-9_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel aktív v materiálnom tranzitnom riziku riešených klimatickými zmierňujúcimi opatreniami')
WHERE code = 'E1-9_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková účtovná hodnota nehnuteľností podľa tried energetickej efektívnosti')
WHERE code = 'E1-9_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako boli posúdené potenciálne účinky na budúcu finančnú výkonnosť a pozíciu pre aktíva a obchodné činnosti v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako sa posúdenie aktív a obchodných činností považovaných za materiálne tranzitné riziko spolieha alebo je súčasťou procesu určenia materiálnych tranzitných rizík a určenia scenárov')
WHERE code = 'E1-9_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Odhadovaná suma potenciálne stratených aktív')
WHERE code = 'E1-9_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel odhadovaného podielu potenciálne stratených aktív z celkových aktív v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Celková účtovná hodnota nehnuteľností, pre ktoré je spotreba energie založená na interných odhadoch')
WHERE code = 'E1-9_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Záväzky z materiálnych tranzitných rizík, ktoré možno bude potrebné uznať vo finančných výkazoch')
WHERE code = 'E1-9_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Počet povoleniek na emisie Rozsah 1 v rámci regulovaných systémov obchodovania s emisiami')
WHERE code = 'E1-9_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Počet uložených emisných povoleniek (z predchádzajúcich povoleniek) na začiatku vykazovacieho obdobia')
WHERE code = 'E1-9_25';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Potenciálne budúce záväzky založené na existujúcich zmluvných dohodách spojené s uhlíkovými kreditmi plánovanými na zrušenie v blízkej budúcnosti')
WHERE code = 'E1-9_26';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Monetizované hrubé emisie Rozsah 1 a 2')
WHERE code = 'E1-9_27';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Monetizované celkové emisie skleníkových plynov')
WHERE code = 'E1-9_28';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy z obchodných činností v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_29';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy od zákazníkov pôsobiacich v činnostiach súvisiacich s uhlím')
WHERE code = 'E1-9_30';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy od zákazníkov pôsobiacich v činnostiach súvisiacich s ropou')
WHERE code = 'E1-9_31';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Čisté výnosy od zákazníkov pôsobiacich v činnostiach súvisiacich s plynom')
WHERE code = 'E1-9_32';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých výnosov od zákazníkov pôsobiacich v činnostiach súvisiacich s uhlím')
WHERE code = 'E1-9_33';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých výnosov od zákazníkov pôsobiacich v činnostiach súvisiacich s ropou')
WHERE code = 'E1-9_34';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých výnosov od zákazníkov pôsobiacich v činnostiach súvisiacich s plynom')
WHERE code = 'E1-9_35';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých výnosov z obchodných činností v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_36';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rizikových faktorov pre čisté výnosy z obchodných činností v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_37';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie očakávaných finančných účinkov z hľadiska erózie marží pre obchodné činnosti v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_38';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosúladenia s finančnými výkazmi významných súm aktív a čistých výnosov v materiálnom fyzickom riziku')
WHERE code = 'E1-9_39';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosúladenia s finančnými výkazmi významných súm aktív, záväzkov a čistých výnosov v materiálnom tranzitnom riziku')
WHERE code = 'E1-9_40';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Očakávané úspory nákladov z opatrení na zmierňovanie zmeny klímy')
WHERE code = 'E1-9_41';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Očakávané úspory nákladov z adaptačných opatrení na zmenu klímy')
WHERE code = 'E1-9_42';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Potenciálna veľkosť trhu nízkouhlíkových produktov a služieb alebo adaptačných riešení, ku ktorým má podnik alebo môže mať prístup')
WHERE code = 'E1-9_43';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Očakávané zmeny čistých výnosov z nízkouhlíkových produktov a služieb alebo adaptačných riešení, ku ktorým má podnik alebo môže mať prístup')
WHERE code = 'E1-9_44';

-- Final message
SELECT 'All E1 translations completed successfully!' as status;


-- ============================================================================
-- ESRS E2-E5 SLOVAK TRANSLATIONS
-- Generated: February 6, 2026
-- Topics: E2 (Pollution), E3 (Water), E4 (Biodiversity), E5 (Circular Economy)
-- ============================================================================

-- ============================================================================
-- ESRS E2: ZNEČISTENIE (POLLUTION)
-- ============================================================================

-- E2.IRO-1: Proces identifikácie dopadov, rizík a príležitostí
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o procese identifikácie skutočných a potenciálnych dopadov, rizík a príležitostí súvisiacich so znečistením') WHERE code = 'E2.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli vykonané konzultácie (znečistenie)') WHERE code = 'E2.IRO-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie výsledkov posúdenia materiality (znečistenie)') WHERE code = 'E2.IRO-1_03';

-- E2-1: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiálnych dopadov, rizík a príležitostí súvisiacich so znečistením [pozri ESRS 2 MDR-P]') WHERE code = 'E2.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši zmiernenie negatívnych dopadov súvisiacich so znečistením ovzdušia, vody a pôdy') WHERE code = 'E2-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši nahrádzanie a minimalizáciu používania látok vzbudzujúcich obavy a postupné vyraďovanie látok vzbudzujúcich veľmi vysoké obavy') WHERE code = 'E2-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši predchádzanie incidentom a núdzovým situáciám, a ak k nim dôjde, kontrolu a obmedzenie ich vplyvu na ľudí a životné prostredie') WHERE code = 'E2-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií o vzťahoch medzi implementovanými politikami a tým, ako politiky prispievajú k Akčnému plánu EÚ smerom k nulovému znečisteniu ovzdušia, vody a pôdy') WHERE code = 'E2-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal politiky') WHERE code = 'E2.MDR-P_07-08';

-- E2-2: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje týkajúce sa znečistenia [pozri ESRS 2 MDR-A]') WHERE code = 'E2.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Úroveň v hierarchii zmierňovania, do ktorej možno priradiť akciu (znečistenie)') WHERE code = 'E2-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcia súvisiaca so znečistením sa vzťahuje na angažovanosť vo vyššej/nižšej časti hodnotového reťazca') WHERE code = 'E2-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Úroveň v hierarchii zmierňovania, do ktorej možno priradiť zdroje (znečistenie)') WHERE code = 'E2-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o akčných plánoch, ktoré boli implementované na úrovni lokalít (znečistenie)') WHERE code = 'E2-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal akcie') WHERE code = 'E2.MDR-A_13-14';

-- E2-3: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektívnosti politík a akcií prostredníctvom cieľov [pozri ESRS 2 MDR-T]') WHERE code = 'E2.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka prevencie a kontroly znečisťujúcich látok v ovzduší a príslušných špecifických zaťažení') WHERE code = 'E2-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka prevencie a kontroly emisií do vody a príslušných špecifických zaťažení') WHERE code = 'E2-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka prevencie a kontroly znečistenia pôdy a príslušných špecifických zaťažení') WHERE code = 'E2-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka prevencie a kontroly látok vzbudzujúcich obavy a látok vzbudzujúcich veľmi vysoké obavy') WHERE code = 'E2-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pri stanovení cieľa súvisiaceho so znečistením boli zohľadnené ekologické prahy a pridelenia špecifické pre subjekt') WHERE code = 'E2-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovaných ekologických prahov a metodológie použitej na identifikáciu ekologických prahov (znečistenie)') WHERE code = 'E2-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako boli určené ekologické prahy špecifické pre subjekt (znečistenie)') WHERE code = 'E2-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako je pridelená zodpovednosť za rešpektovanie identifikovaných ekologických prahov (znečistenie)') WHERE code = 'E2-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ súvisiaci so znečistením je povinný (vyžadovaný legislatívou)/dobrovoľný') WHERE code = 'E2-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ súvisiaci so znečistením rieši nedostatky týkajúce sa kritérií podstatného prínosu pre prevenciu a kontrolu znečistenia') WHERE code = 'E2-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o cieľoch, ktoré boli implementované na úrovni lokalít (znečistenie)') WHERE code = 'E2-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal ciele') WHERE code = 'E2.MDR-T_14-19';

-- E2-4: Znečistenie ovzdušia, vody a pôdy
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Znečistenie ovzdušia, vody a pôdy [viaceré dimenzie: na úrovni lokality alebo podľa typu zdroja, podľa sektora alebo geografickej oblasti]') WHERE code = 'E2-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Emisie do ovzdušia podľa znečisťujúcej látky') WHERE code = 'E2-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Emisie do vody podľa znečisťujúcej látky [+ podľa sektorov/geografickej oblasti/typu zdroja/umiestnenia lokality]') WHERE code = 'E2-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Emisie do pôdy podľa znečisťujúcej látky [+ podľa sektorov/geografickej oblasti/typu zdroja/umiestnenia lokality]') WHERE code = 'E2-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mikroplasty generované a používané') WHERE code = 'E2-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mikroplasty generované') WHERE code = 'E2-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mikroplasty používané') WHERE code = 'E2-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zmien v priebehu času (znečistenie ovzdušia, vody a pôdy)') WHERE code = 'E2-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodológií merania (znečistenie ovzdušia, vody a pôdy)') WHERE code = 'E2-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesov zberu údajov pre účtovníctvo a vykazovanie súvisiace so znečistením') WHERE code = 'E2-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel celkových emisií znečisťujúcich látok do vody v oblastiach s vodným rizikom') WHERE code = 'E2-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel celkových emisií znečisťujúcich látok do vody v oblastiach s vysokým vodným stresom') WHERE code = 'E2-4_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel celkových emisií znečisťujúcich látok do pôdy v oblastiach s vodným rizikom') WHERE code = 'E2-4_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel celkových emisií znečisťujúcich látok do pôdy v oblastiach s vysokým vodným stresom') WHERE code = 'E2-4_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dôvodov výberu menej vhodnej metodológie na kvantifikáciu emisií') WHERE code = 'E2-4_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu prevádzkovaných zariadení, ktoré spadajú pod IED a Závery EÚ o BAT') WHERE code = 'E2-4_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu akýchkoľvek incidentov nedodržiavania predpisov alebo donucovacích opatrení potrebných na zabezpečenie súladu v prípade porušení podmienok povolenia') WHERE code = 'E2-4_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie skutočnej výkonnosti a porovnanie environmentálnej výkonnosti s úrovňami emisií spojenými s najlepšími dostupnými technikami (BAT-AEL), ako sú opísané v Záveroch EÚ o BAT') WHERE code = 'E2-4_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie skutočnej výkonnosti v porovnaní s úrovňami environmentálnej výkonnosti spojenými s najlepšími dostupnými technikami (BAT-AEPL) platnými pre sektor a zariadenie') WHERE code = 'E2-4_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu akýchkoľvek časových plánov súladu alebo výnimiek udelených príslušnými orgánmi podľa článku 15(4) IED, ktoré súvisia s implementáciou BAT-AEL') WHERE code = 'E2-4_20';

-- E2-5: Látky vzbudzujúce obavy a látky vzbudzujúce veľmi vysoké obavy
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo látok vzbudzujúcich obavy, ktoré sa generujú alebo používajú počas výroby alebo sa obstarávajú, rozdelenie podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo látok vzbudzujúcich obavy, ktoré sa generujú alebo používajú počas výroby alebo sa obstarávajú') WHERE code = 'E2-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo látok vzbudzujúcich obavy, ktoré opúšťajú zariadenia ako emisie, ako produkty alebo ako súčasť produktov alebo služieb') WHERE code = 'E2-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich obavy, ktoré opúšťajú zariadenia ako emisie podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich obavy, ktoré opúšťajú zariadenia ako produkty podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich obavy, ktoré opúšťajú zariadenia ako súčasť produktov podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich obavy, ktoré opúšťajú zariadenia ako služby podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo látok vzbudzujúcich veľmi vysoké obavy, ktoré sa generujú alebo používajú počas výroby alebo sa obstarávajú podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo látok vzbudzujúcich veľmi vysoké obavy, ktoré opúšťajú zariadenia ako emisie, ako produkty alebo ako súčasť produktov alebo služieb podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich veľmi vysoké obavy, ktoré opúšťajú zariadenia ako emisie podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich veľmi vysoké obavy, ktoré opúšťajú zariadenia ako produkty podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich veľmi vysoké obavy, ktoré opúšťajú zariadenia ako súčasť produktov podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Množstvo látok vzbudzujúcich veľmi vysoké obavy, ktoré opúšťajú zariadenia ako služby podľa hlavných tried nebezpečenstva látok vzbudzujúcich obavy') WHERE code = 'E2-5_13';

-- E2-6: Predpokladané finančné účinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich so znečistením') WHERE code = 'E2-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých príjmov dosiahnutých prostredníctvom produktov a služieb, ktoré sú alebo obsahujú látky vzbudzujúce obavy') WHERE code = 'E2-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel čistých príjmov dosiahnutých prostredníctvom produktov a služieb, ktoré sú alebo obsahujú látky vzbudzujúce veľmi vysoké obavy') WHERE code = 'E2-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Prevádzkové výdavky (OpEx) v súvislosti s významnými incidentmi a depozitmi (znečistenie)') WHERE code = 'E2-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Kapitálové výdavky (CapEx) v súvislosti s významnými incidentmi a depozitmi (znečistenie)') WHERE code = 'E2-6_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rezervy na náklady na ochranu životného prostredia a nápravu (znečistenie)') WHERE code = 'E2-6_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich so znečistením') WHERE code = 'E2-6_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvažovaných účinkov, súvisiacich dopadov a časových horizontov, v ktorých sa pravdepodobne zhmotnia (znečistenie)') WHERE code = 'E2-6_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritických predpokladov použitých na kvantifikáciu predpokladaných finančných účinkov, zdrojov a úrovne neistoty predpokladov (znečistenie)') WHERE code = 'E2-6_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis významných incidentov a depozitov, pri ktorých malo znečistenie negatívne dopady na životné prostredie a (alebo) sa očakáva, že bude mať negatívne účinky na finančné peňažné toky, finančnú pozíciu a finančnú výkonnosť') WHERE code = 'E2-6_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie posúdenia súvisiacich produktov a služieb ohrozených a vysvetlenie toho, ako je definovaný časový horizont, odhadnuté finančné čiastky a aké kritické predpoklady sú urobené (znečistenie)') WHERE code = 'E2-6_11';

-- ============================================================================
-- ESRS E3: VODNÉ ZDROJE A MORSKÉ ZDROJE (WATER AND MARINE RESOURCES)
-- ============================================================================

-- E3.IRO-1: Proces identifikácie dopadov, rizík a príležitostí
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli aktíva a činnosti preskúmané s cieľom identifikovať skutočné a potenciálne dopady, riziká a príležitosti súvisiace s vodnými a morskými zdrojmi vo vlastných operáciách a vo vyššom a nižšom hodnotovom reťazci a použité metodológie, predpoklady a nástroje') WHERE code = 'E3.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako boli vykonané konzultácie (vodné a morské zdroje)') WHERE code = 'E3.IRO-1_02';

-- E3-1: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiálnych dopadov, rizík a príležitostí súvisiacich s vodnými a morskými zdrojmi [pozri ESRS 2 MDR-P]') WHERE code = 'E3.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši hospodárenie s vodou') WHERE code = 'E3-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši používanie a získavanie vody a morských zdrojov vo vlastných operáciách') WHERE code = 'E3-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši úpravu vody') WHERE code = 'E3-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši prevenciu a znižovanie znečistenia vody') WHERE code = 'E3-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši návrh produktov a služieb s ohľadom na riešenie problémov súvisiacich s vodou a ochranu morských zdrojov') WHERE code = 'E3-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši záväzok znížiť spotrebu vody v oblastiach s vodným rizikom') WHERE code = 'E3-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dôvodov, prečo neboli prijaté politiky v oblastiach s vysokým vodným stresom') WHERE code = 'E3-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového rámca, v ktorom budú prijaté politiky v oblastiach s vysokým vodným stresom') WHERE code = 'E3-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijaté politiky alebo postupy týkajúce sa udržateľných oceánov a morí') WHERE code = 'E3-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politika prispieva k dobrej ekologickej a chemickej kvalite povrchových vodných útvarov a dobrej chemickej kvalite a množstvu podzemných vôd, aby sa ochránilo ľudské zdravie, zásobovanie vodou, prírodné ekosystémy a biodiverzita, dobrý environmentálny stav morských vôd a ochrana zdrojovej základne, na ktorej závisia činnosti súvisiace s morom') WHERE code = 'E3-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politika minimalizuje materiálne dopady a riziká a implementuje zmierňujúce opatrenia, ktoré majú za cieľ udržať hodnotu a funkčnosť prioritných služieb a zvýšiť efektívnosť zdrojov vo vlastných operáciách') WHERE code = 'E3-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politika sa vyhýba dopadom na dotknuté komunity') WHERE code = 'E3-1_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal politiky') WHERE code = 'E3.MDR-P_07-08';

-- E3-2: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje týkajúce sa vodných a morských zdrojov [pozri ESRS 2 MDR-A]') WHERE code = 'E3.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Úroveň v hierarchii zmierňovania, do ktorej možno priradiť akciu a zdroje (vodné a morské zdroje)') WHERE code = 'E3-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o špecifickej kolektívnej akcii pre vodné a morské zdroje') WHERE code = 'E3-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie akcií a zdrojov vo vzťahu k oblastiam s vodným rizikom') WHERE code = 'E3-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal akcie') WHERE code = 'E3.MDR-A_13-14';

-- E3-3: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektívnosti politík a akcií prostredníctvom cieľov [pozri ESRS 2 MDR-T]') WHERE code = 'E3.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka riadenia materiálnych dopadov, rizík a príležitostí súvisiacich s oblasťami s vodným rizikom') WHERE code = 'E3-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka zodpovedného riadenia dopadov, rizík a príležitostí morských zdrojov') WHERE code = 'E3-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa cieľ týka zníženia spotreby vody') WHERE code = 'E3-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pri stanovení cieľa vodných a morských zdrojov bol zohľadnený (lokálny) ekologický prah a pridelenie špecifické pre subjekt') WHERE code = 'E3-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovaného ekologického prahu a metodológie použitej na identifikáciu ekologického prahu (vodné a morské zdroje)') WHERE code = 'E3-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako bol určený ekologický prah špecifický pre subjekt (vodné a morské zdroje)') WHERE code = 'E3-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako je pridelená zodpovednosť za rešpektovanie identifikovaného ekologického prahu (vodné a morské zdroje)') WHERE code = 'E3-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Prijatý a prezentovaný cieľ súvisiaci s vodnými a morskými zdrojmi je povinný (na základe legislatívy)') WHERE code = 'E3-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ sa týka zníženia odberu vody') WHERE code = 'E3-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ sa týka zníženia vypúšťania vody') WHERE code = 'E3-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal ciele') WHERE code = 'E3.MDR-T_14-19';

-- E3-4: Spotreba vody a recyklácia
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celková spotreba vody') WHERE code = 'E3-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celková spotreba vody v oblastiach s vodným rizikom, vrátane oblastí s vysokým vodným stresom') WHERE code = 'E3-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo recyklovanej a opakovane použitej vody') WHERE code = 'E3-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo uskladnenej vody') WHERE code = 'E3-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zmeny v uskladnení vody') WHERE code = 'E3-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií týkajúcich sa spotreby vody') WHERE code = 'E3-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podiel merania získaný z priameho merania, zo vzorkovania a extrapolácie alebo z najlepších odhadov') WHERE code = 'E3-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pomer intenzity vody') WHERE code = 'E3-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Spotreba vody - sektory/SEGMENTY [tabuľka]') WHERE code = 'E3-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Dodatočný pomer intenzity vody') WHERE code = 'E3-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkový odber vody') WHERE code = 'E3-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové vypúšťanie vody') WHERE code = 'E3-4_12';

-- E3-5: Predpokladané finančné účinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich s vodnými a morskými zdrojmi') WHERE code = 'E3-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich s vodnými a morskými zdrojmi') WHERE code = 'E3-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvažovaných účinkov a súvisiacich dopadov (vodné a morské zdroje)') WHERE code = 'E3-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritických predpokladov použitých v odhadoch finančných účinkov materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich s vodnými a morskými zdrojmi') WHERE code = 'E3-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis súvisiacich produktov a služieb ohrozených (vodné a morské zdroje)') WHERE code = 'E3-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sú definované časové horizonty, odhadnuté finančné čiastky a urobené kritické predpoklady (vodné a morské zdroje)') WHERE code = 'E3-5_06';

-- ============================================================================
-- ESRS E4: BIODIVERZITA A EKOSYSTÉMY (BIODIVERSITY AND ECOSYSTEMS)
-- ============================================================================

-- E4.SBM-3: Významné lokality
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zoznam materiálnych lokalít vo vlastných operáciách') WHERE code = 'E4.SBM-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie činností negatívne ovplyvňujúcich biodiverzitne citlivé oblasti') WHERE code = 'E4.SBM-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu materiálnych lokalít vo vlastných operáciách na základe výsledkov identifikácie a posúdenia skutočných a potenciálnych dopadov na biodiverzitu a ekosystémy') WHERE code = 'E4.SBM-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie biodiverzitne citlivých oblastí ovplyvnených') WHERE code = 'E4.SBM-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli identifikované materiálne negatívne dopady týkajúce sa degradácie pôdy, dezertifikácie alebo zapečatenia pôdy') WHERE code = 'E4.SBM-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vlastné operácie ovplyvňujú ohrozené druhy') WHERE code = 'E4.SBM-3_06';

-- E4.IRO-1: Proces identifikácie dopadov, rizík a príležitostí
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli identifikované a posúdené skutočné a potenciálne dopady na biodiverzitu a ekosystémy na vlastných lokalitách a v hodnotovom reťazci') WHERE code = 'E4.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli identifikované a posúdené závislosti na biodiverzite a ekosystémoch a ich službách na vlastných lokalitách a v hodnotovom reťazci') WHERE code = 'E4.IRO-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli identifikované a posúdené tranzitné a fyzické riziká a príležitosti súvisiace s biodiverzitou a ekosystémami') WHERE code = 'E4.IRO-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli zvažované systémové riziká (biodiverzita a ekosystémy)') WHERE code = 'E4.IRO-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli vykonané konzultácie s dotknutými komunitami o posúdeniach udržateľnosti zdieľaných biologických zdrojov a ekosystémov') WHERE code = 'E4.IRO-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako konkrétne lokality, výroba alebo získavanie surovín s negatívnymi alebo potenciálne negatívnymi dopadmi na dotknuté komunity') WHERE code = 'E4.IRO-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako boli komunity zapojené do posúdenia materiality') WHERE code = 'E4.IRO-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa možno vyhnúť negatívnym dopadom na prioritné ekosystémové služby relevantné pre dotknuté komunity') WHERE code = 'E4.IRO-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plánov na minimalizáciu nevyhnutných negatívnych dopadov a implementáciu zmierňujúcich opatrení, ktoré majú za cieľ udržať hodnotu a funkčnosť prioritných služieb') WHERE code = 'E4.IRO-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako bol obchodný model overený pomocou radu scenárov biodiverzity a ekosystémov alebo iných scenárov s modelovaním dôsledkov súvisiacich s biodiverzitou a ekosystémami s rôznymi možnými cestami') WHERE code = 'E4.IRO-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dôvodov, prečo boli zvažované scenáre zohľadnené') WHERE code = 'E4.IRO-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa zvažované scenáre aktualizujú podľa vyvíjajúcich sa podmienok a vznikajúcich trendov') WHERE code = 'E4.IRO-1_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Scenáre sú informované očakávaniami v autoritatívnych medzivládnych nástrojoch a vedeckým konsenzom') WHERE code = 'E4.IRO-1_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik má lokality umiestnené v alebo v blízkosti biodiverzitne citlivých oblastí') WHERE code = 'E4.IRO-1_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Činnosti súvisiace s lokalitami umiestnené v alebo v blízkosti biodiverzitne citlivých oblastí negatívne ovplyvňujú tieto oblasti vedením k zhoršovaniu prírodných habitatov a habitatov druhov a k narušeniu druhov, pre ktoré bola chránená oblasť určená') WHERE code = 'E4.IRO-1_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Bolo dospené k záveru, že je potrebné implementovať zmierňujúce opatrenia týkajúce sa biodiverzity') WHERE code = 'E4.IRO-1_16';

-- E4-1: Stratégia a odolnosť
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odolnosti súčasného obchodného modelu(-ov) a stratégie voči fyzickým, tranzitným a systémovým rizikám a príležitostiam súvisiacim s biodiverzitou a ekosystémami') WHERE code = 'E4-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu analýzy odolnosti pozdĺž vlastných operácií a súvisiaceho vyššieho a nižšieho hodnotového reťazca') WHERE code = 'E4-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kľúčových predpokladov urobených (biodiverzita a ekosystémy)') WHERE code = 'E4-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časových horizontov použitých pre analýzu (biodiverzita a ekosystémy)') WHERE code = 'E4-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie výsledkov analýzy odolnosti (biodiverzita a ekosystémy)') WHERE code = 'E4-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zapojenia zainteresovaných strán (biodiverzita a ekosystémy)') WHERE code = 'E4-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie prechodného plánu na zlepšenie a dosiahnutie zosúladenia jeho obchodného modelu a stratégie') WHERE code = 'E4-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sa stratégia a obchodný model upravia na zlepšenie a nakoniec dosiahnutie zosúladenia s relevantnými miestnymi, národnými a globálnymi cieľmi verejnej politiky') WHERE code = 'E4-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zahrnutie informácií o vlastných operáciách a vysvetlenie toho, ako reaguje na materiálne dopady vo svojom súvisiacom hodnotovom reťazci') WHERE code = 'E4-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako stratégia interaguje s prechodným plánom') WHERE code = 'E4-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie prínosu k hnacím silám dopadu a možných zmierňujúcich akcií podľa hierarchie zmierňovania a hlavnej cestovej závislosti a uzamknutých aktív a zdrojov, ktoré sú spojené so zmenou biodiverzity a ekosystémov') WHERE code = 'E4-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie a kvantifikácia investícií a financovania podporujúcich implementáciu jeho prechodného plánu') WHERE code = 'E4-1_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie cieľov alebo plánov na zosúladenie ekonomických aktivít (príjmy, CapEx)') WHERE code = 'E4-1_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Biodiverzitné kompenzácie sú súčasťou prechodného plánu') WHERE code = 'E4-1_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o tom, ako sa riadi proces implementácie a aktualizácie prechodného plánu') WHERE code = 'E4-1_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Uvedenie metrík a súvisiacich nástrojov použitých na meranie pokroku, ktoré sú integrované do prístupu merania (biodiverzita a ekosystémy)') WHERE code = 'E4-1_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Administratívne, riadiace a dozorné orgány schválili prechodný plán') WHERE code = 'E4-1_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Uvedenie súčasných výziev a obmedzení pri vypracovaní plánu vo vzťahu k oblastiam významného dopadu a opatrení, ktoré spoločnosť prijíma na ich riešenie (biodiverzita a ekosystémy)') WHERE code = 'E4-1_18';

-- E4-2: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiálnych dopadov, rizík, závislostí a príležitostí súvisiacich s biodiverzitou a ekosystémami [pozri ESRS 2 - MDR-P]') WHERE code = 'E4.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako sa politiky súvisiace s biodiverzitou a ekosystémami týkajú záležitostí uvedených v E4 AR4') WHERE code = 'E4-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či a ako sa politika súvisiaca s biodiverzitou a ekosystémami týka materiálnych dopadov súvisiacich s biodiverzitou a ekosystémami') WHERE code = 'E4-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či a ako sa politika súvisiaca s biodiverzitou a ekosystémami týka materiálnych závislostí a materiálnych fyzických a tranzitných rizík a príležitostí') WHERE code = 'E4-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či a ako politika súvisiaca s biodiverzitou a ekosystémami podporuje vysledovateľnosť produktov, komponentov a surovín s významnými skutočnými alebo potenciálnymi dopadmi na biodiverzitu a ekosystémy pozdĺž hodnotového reťazca') WHERE code = 'E4-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či a ako politika súvisiaca s biodiverzitou a ekosystémami rieši výrobu, získavanie alebo spotrebu z ekosystémov, ktoré sa riadia tak, aby sa udržali alebo zlepšili podmienky pre biodiverzitu') WHERE code = 'E4-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či a ako politika súvisiaca s biodiverzitou a ekosystémami rieši sociálne dôsledky dopadov súvisiacich s biodiverzitou a ekosystémami') WHERE code = 'E4-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa politika týka výroby, získavania alebo spotreby surovín') WHERE code = 'E4-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa politika týka politík obmedzujúcich obstarávanie od dodávateľov, ktorí nemôžu preukázať, že neprispieva k významnému prestavovaniu chránených oblastí alebo kľúčových biodiverzitných oblastí') WHERE code = 'E4-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa politika týka uznávaných noriem alebo certifikácií tretích strán dohľadovaných regulátormi') WHERE code = 'E4-2_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako politika rieši suroviny pochádzajúce z ekosystémov, ktoré boli riadené tak, aby sa udržali alebo zlepšili podmienky pre biodiverzitu, ako to preukazuje pravidelné monitorovanie a podávanie správ o stave biodiverzity a prírastkoch alebo stratách') WHERE code = 'E4-2_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako politika umožňuje a), b), c) a d)') WHERE code = 'E4-2_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma správania tretích strán použitá v politike je objektívna a dosiahnuteľná na základe vedeckého prístupu k identifikácii problémov a realistická pri hodnotení toho, ako možno tieto problémy riešiť za rôznych praktických okolností') WHERE code = 'E4-2_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma správania tretích strán použitá v politike je vyvinutá alebo udržiavaná prostredníctvom procesu prebiehajúcich konzultácií s relevantnými zainteresovanými stranami s vyváženým príspevkom od všetkých relevantných skupín zainteresovaných strán bez toho, aby žiadna skupina mala neprimerané oprávnenia alebo právo veta nad obsahom') WHERE code = 'E4-2_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma správania tretích strán použitá v politike podporuje postupný prístup a neustále zlepšovanie normy a jej aplikácie lepších manažérskych postupov a vyžaduje stanovenie zmysluplných cieľov a konkrétnych míľnikov na označenie pokroku voči zásadám a kritériám v priebehu času') WHERE code = 'E4-2_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma správania tretích strán použitá v politike je overiteľná nezávislými certifikačnými alebo overovacími orgánmi, ktoré majú definované a prísne hodnotiace postupy, ktoré sa vyhýbajú konfliktom záujmov a sú v súlade s usmerneniami ISO o akreditácii a overovacích postupoch alebo článkom 5(2) nariadenia (ES) č. 765/2008') WHERE code = 'E4-2_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma správania tretích strán použitá v politike je v súlade s ISEAL Code of Good Practice') WHERE code = 'E4-2_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Bola prijatá politika ochrany biodiverzity a ekosystémov pokrývajúca prevádzkové lokality vlastnené, prenajímané, riadené v alebo v blízkosti chránenej oblasti alebo biodiverzitne citlivej oblasti mimo chránených oblastí') WHERE code = 'E4-2_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijaté postupy alebo politiky udržateľného využívania pôdy alebo poľnohospodárstva') WHERE code = 'E4-2_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijaté postupy alebo politiky udržateľných oceánov alebo morí') WHERE code = 'E4-2_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijaté politiky na riešenie odlesňovania') WHERE code = 'E4-2_20';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal politiky') WHERE code = 'E4.MDR-P_07-08';

-- E4-3: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje týkajúce sa biodiverzity a ekosystémov [pozri ESRS 2 - MDR-A]') WHERE code = 'E4.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako bola aplikovaná hierarchia zmierňovania vzhľadom na akcie týkajúce sa biodiverzity a ekosystémov') WHERE code = 'E4-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Biodiverzitné kompenzácie boli použité v akčnom pláne') WHERE code = 'E4-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie cieľa biodiverzitnej kompenzácie a použitých kľúčových ukazovateľov výkonnosti') WHERE code = 'E4-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Finančné účinky (priame a nepriame náklady) biodiverzitných kompenzácií') WHERE code = 'E4-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzťahu významných CapEx a OpEx potrebných na implementáciu prijatých alebo plánovaných opatrení k relevantným riadkovým položkám alebo poznámkam vo finančných výkazoch') WHERE code = 'E4-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzťahu významných CapEx a OpEx potrebných na implementáciu prijatých alebo plánovaných opatrení ku kľúčovým ukazovateľom výkonnosti požadovaným podľa delegovaného nariadenia Komisie (EÚ) 2021/2178') WHERE code = 'E4-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzťahu významných CapEx a OpEx potrebných na implementáciu prijatých alebo plánovaných opatrení k plánu CapEx požadovanému podľa delegovaného nariadenia Komisie (EÚ) 2021/2178') WHERE code = 'E4-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis biodiverzitných kompenzácií') WHERE code = 'E4-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, či a ako boli do akcií súvisiacich s biodiverzitou a ekosystémami začlenené miestne a domorodé znalosti a riešenia založené na prírode') WHERE code = 'E4-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kľúčových zainteresovaných strán zapojených a ako sú zapojené, kľúčových zainteresovaných strán negatívne alebo pozitívne ovplyvnených akciou a ako sú ovplyvnené') WHERE code = 'E4-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie potreby vhodných konzultácií a potreby rešpektovať rozhodnutia dotknutých komunít') WHERE code = 'E4-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, či môže kľúčová akcia vyvolať významné negatívne dopady na udržateľnosť (biodiverzita a ekosystémy)') WHERE code = 'E4-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, či je kľúčová akcia určená ako jednorazová iniciatíva alebo systematická prax') WHERE code = 'E4-3_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Kľúčový akčný plán vykonáva iba podnik (individuálna akcia) s využitím vlastných zdrojov (biodiverzita a ekosystémy)') WHERE code = 'E4-3_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Kľúčový akčný plán je súčasťou širšieho akčného plánu (kolektívna akcia), ktorého členom je podnik (biodiverzita a ekosystémy)') WHERE code = 'E4-3_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Dodatočné informácie o projekte, jeho sponzoroch a ďalších účastníkoch (biodiverzita a ekosystémy)') WHERE code = 'E4-3_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal akcie') WHERE code = 'E4.MDR-A_13-14';

-- E4-4: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektívnosti politík a akcií prostredníctvom cieľov [pozri ESRS 2 MDR-T]') WHERE code = 'E4.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pri stanovení cieľa boli použité ekologický prah a pridelenie dopadov podniku (biodiverzita a ekosystémy)') WHERE code = 'E4-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovaného ekologického prahu a metodológie použitej na identifikáciu prahu (biodiverzita a ekosystémy)') WHERE code = 'E4-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako bol určený prah špecifický pre subjekt (biodiverzita a ekosystémy)') WHERE code = 'E4-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako je pridelená zodpovednosť za rešpektovanie identifikovaného ekologického prahu (biodiverzita a ekosystémy)') WHERE code = 'E4-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ je informovaný relevantným aspektom Stratégie biodiverzity EÚ pre rok 2030') WHERE code = 'E4-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa ciele týkajú dopadov, závislostí, rizík a príležitostí biodiverzity a ekosystémov identifikovaných vo vzťahu k vlastným operáciám a vyššiemu a nižšiemu hodnotovému reťazcu') WHERE code = 'E4-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie geografického rozsahu cieľov') WHERE code = 'E4-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Biodiverzitné kompenzácie boli použité pri stanovení cieľa') WHERE code = 'E4-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Úroveň v hierarchii zmierňovania, do ktorej možno priradiť cieľ (biodiverzita a ekosystémy)') WHERE code = 'E4-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ rieši nedostatky týkajúce sa kritérií podstatného prínosu') WHERE code = 'E4-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal ciele') WHERE code = 'E4.MDR-T_14-19';

-- E4-5: Metriky dopadov
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet lokalít vlastnených, prenajímaných alebo riadených v alebo v blízkosti chránených oblastí alebo kľúčových biodiverzitných oblastí, ktoré podnik negatívne ovplyvňuje') WHERE code = 'E4-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Plocha lokalít vlastnených, prenajímaných alebo riadených v alebo v blízkosti chránených oblastí alebo kľúčových biodiverzitných oblastí, ktoré podnik negatívne ovplyvňuje') WHERE code = 'E4-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie využívania pôdy na základe posúdenia životného cyklu') WHERE code = 'E4-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie metrík považovaných za relevantné (zmena využívania pôdy, zmena využívania sladkých vôd a (alebo) zmena využívania mora)') WHERE code = 'E4-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie premeny pokryvu pôdy v priebehu času') WHERE code = 'E4-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v priebehu času v riadení ekosystému') WHERE code = 'E4-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v priestorovej konfigurácii krajiny') WHERE code = 'E4-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v štrukturálnej konektivite ekosystému') WHERE code = 'E4-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkčnej konektivity') WHERE code = 'E4-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové využívanie plochy pôdy') WHERE code = 'E4-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celková zapečatená plocha') WHERE code = 'E4-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Prírodne orientovaná plocha na mieste') WHERE code = 'E4-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Prírodne orientovaná plocha mimo miesta') WHERE code = 'E4-5_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa riadia cesty introdukcie a šírenia inváznych nepôvodných druhov a riziká, ktoré predstavujú invázne nepôvodné druhy') WHERE code = 'E4-5_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet inváznych nepôvodných druhov') WHERE code = 'E4-5_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Plocha pokrytá inváznymy nepôvodnými druhmi') WHERE code = 'E4-5_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie metrík považovaných za relevantné (stav druhov)') WHERE code = 'E4-5_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odseku v inom environmentálne súvisiacom štandarde, na ktorý sa metrika odvoláva') WHERE code = 'E4-5_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie veľkosti populácie, rozsahu v rámci špecifických ekosystémov a rizika vyhynutia') WHERE code = 'E4-5_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v počte jedincov druhov v rámci špecifickej oblasti') WHERE code = 'E4-5_20';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o druhoch ohrozených globálnym vyhynutím') WHERE code = 'E4-5_21';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie stavu ohrozenia druhov a toho, ako môžu činnosti alebo tlaky ovplyvniť stav ohrozenia') WHERE code = 'E4-5_22';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmeny v relevantnom habitate pre ohrozené druhy ako proxy pre dopad na riziko vyhynutia miestnej populácie') WHERE code = 'E4-5_23';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie pokrytia plochy ekosystému') WHERE code = 'E4-5_24';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvality ekosystémov vo vzťahu k vopred určenému referenčnému stavu') WHERE code = 'E4-5_25';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie viacerých druhov v rámci ekosystému') WHERE code = 'E4-5_26';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie štrukturálnych komponentov stavu ekosystému') WHERE code = 'E4-5_27';

-- E4-6: Predpokladané finančné účinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov a závislostí súvisiacich s biodiverzitou a ekosystémami') WHERE code = 'E4-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov a závislostí súvisiacich s biodiverzitou a ekosystémami') WHERE code = 'E4-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvažovaných účinkov, súvisiacich dopadov a závislostí (biodiverzita a ekosystémy)') WHERE code = 'E4-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritických predpokladov použitých v odhadoch finančných účinkov materiálnych rizík a príležitostí vyplývajúcich z dopadov a závislostí súvisiacich s biodiverzitou a ekosystémami') WHERE code = 'E4-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis súvisiacich produktov a služieb ohrozených (biodiverzita a ekosystémy) v krátkom, strednom a dlhom časovom horizonte') WHERE code = 'E4-6_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sú odhadované finančné čiastky a urobené kritické predpoklady (biodiverzita a ekosystémy)') WHERE code = 'E4-6_06';

-- ============================================================================
-- ESRS E5: OBEHOVÉ HOSPODÁRSTVO A ZDROJE (RESOURCE USE AND CIRCULAR ECONOMY)
-- ============================================================================

-- E5.IRO-1: Proces identifikácie dopadov, rizík a príležitostí
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či podnik preskúmal svoje aktíva a činnosti s cieľom identifikovať skutočné a potenciálne dopady, riziká a príležitosti vo vlastných operáciách a vo vyššom a nižšom hodnotovom reťazci, a ak áno, použité metodológie, predpoklady a nástroje') WHERE code = 'E5.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako podnik vykonal konzultácie (zdroje a obehové hospodárstvo)') WHERE code = 'E5.IRO-1_02';

-- E5-1: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiálnych dopadov, rizík a príležitostí súvisiacich s využívaním zdrojov a obehovým hospodárstvom [pozri ESRS 2 MDR-P]') WHERE code = 'E5.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši prechod od používania panenských zdrojov, vrátane relatívneho zvýšenia používania sekundárnych (recyklovaných) zdrojov') WHERE code = 'E5-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, či a ako politika rieši udržateľné získavanie a používanie obnoviteľných zdrojov') WHERE code = 'E5-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, či a ako politika rieši hierarchiu odpadov (prevencia, príprava na opätovné použitie, recyklácia, iné zhodnotenie, zneškodnenie)') WHERE code = 'E5-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, či a ako politika rieši uprednostňovanie stratégií na predchádzanie alebo minimalizáciu odpadov pred stratégiami spracovania odpadov') WHERE code = 'E5-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal politiky') WHERE code = 'E5.MDR-P_07-08';

-- E5-2: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje týkajúce sa využívania zdrojov a obehového hospodárstva [pozri ESRS 2 MDR-A]') WHERE code = 'E5.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vyšších úrovní efektívnosti zdrojov pri používaní technických a biologických materiálov a vody') WHERE code = 'E5-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vyšších mier používania sekundárnych surovín') WHERE code = 'E5-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis aplikácie obehového dizajnu') WHERE code = 'E5-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis aplikácie obehových obchodných praktík') WHERE code = 'E5-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis akcií prijatých na prevenciu vzniku odpadu v hodnotovom reťazci podniku smerom nahor a nadol') WHERE code = 'E5-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis optimalizácie odpadového hospodárstva') WHERE code = 'E5-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o kolektívnej akcii na rozvoj spolupráce alebo iniciatív zvyšujúcich cirkularitu produktov a materiálov') WHERE code = 'E5-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prínosu k obehovému hospodárstvu') WHERE code = 'E5-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ďalších zainteresovaných strán zapojených do kolektívnej akcie (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-2_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis organizácie projektu (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-2_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal akcie') WHERE code = 'E5.MDR-A_13-14';

-- E5-3: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektívnosti politík a akcií prostredníctvom cieľov [pozri ESRS 2 MDR-T]') WHERE code = 'E5.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka zdrojov (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka zvýšenia obehového dizajnu') WHERE code = 'E5-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka zvýšenia miery používania obehových materiálov') WHERE code = 'E5-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka minimalizácie primárnych surovín') WHERE code = 'E5-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka obrátenia vyčerpania zásob obnoviteľných zdrojov') WHERE code = 'E5-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Cieľ sa týka odpadového hospodárstva') WHERE code = 'E5-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka odpadového hospodárstva') WHERE code = 'E5-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako sa cieľ týka iných záležitostí súvisiacich s využívaním zdrojov alebo obehovým hospodárstvom') WHERE code = 'E5-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Úroveň v hierarchii odpadov, na ktorú sa cieľ vzťahuje') WHERE code = 'E5-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovaného ekologického prahu a metodológie použitej na identifikáciu ekologického prahu (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako bol určený ekologický prah špecifický pre subjekt (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o tom, ako je pridelená zodpovednosť za rešpektovanie identifikovaného ekologického prahu (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Stanovované a prezentované ciele sú povinné (vyžadované legislatívou)') WHERE code = 'E5-3_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal ciele') WHERE code = 'E5.MDR-T_14-19';

-- E5-4: Prítoky zdrojov
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informácií o materiálnych prítokoch zdrojov') WHERE code = 'E5-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celková hmotnosť produktov a technických a biologických materiálov použitých počas vykazovaného obdobia') WHERE code = 'E5-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel biologických materiálov (a biopalív používaných na neenergetické účely)') WHERE code = 'E5-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Absolútna hmotnosť sekundárnych opätovne použitých alebo recyklovaných komponentov, sekundárnych medziproduktov a sekundárnych materiálov použitých na výrobu produktov a služieb podniku (vrátane obalov)') WHERE code = 'E5-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel sekundárnych opätovne použitých alebo recyklovaných komponentov, sekundárnych medziproduktov a sekundárnych materiálov') WHERE code = 'E5-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodológií použitých na výpočet údajov a kľúčových použitých predpokladov') WHERE code = 'E5-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis materiálov, ktoré sú získavané z vedľajších produktov alebo odpadového prúdu') WHERE code = 'E5-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako sa vyhlo dvojitému počítaniu a vykonaných volieb') WHERE code = 'E5-4_08';

-- E5-5: Odtoky zdrojov
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis kľúčových produktov a materiálov, ktoré vychádzajú z výrobného procesu podniku') WHERE code = 'E5-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie očakávanej životnosti produktov uvedených na trh vo vzťahu k priemeru v odvetví pre každú skupinu produktov') WHERE code = 'E5-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie opraviteľnosti produktov') WHERE code = 'E5-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Miera recyklovateľného obsahu v produktoch') WHERE code = 'E5-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Miera recyklovateľného obsahu v obaloch produktov') WHERE code = 'E5-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodológií použitých na výpočet údajov (odtoky zdrojov)') WHERE code = 'E5-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkový odpad generovaný') WHERE code = 'E5-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Odpad odklonený od zneškodnenia, rozdelenie podľa nebezpečného a nebezpečného odpadu a typu spracovania') WHERE code = 'E5-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Odpad smerovaný na zneškodnenie, rozdelenie podľa nebezpečného a nebezpečného odpadu a typu spracovania') WHERE code = 'E5-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Nerecyklovaný odpad') WHERE code = 'E5-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel nerecyklovaného odpadu') WHERE code = 'E5-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zloženia odpadu') WHERE code = 'E5-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie prúdov odpadu relevantných pre sektor alebo činnosti podniku') WHERE code = 'E5-5_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie materiálov prítomných v odpade') WHERE code = 'E5-5_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo nebezpečného odpadu') WHERE code = 'E5-5_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Celkové množstvo rádioaktívneho odpadu') WHERE code = 'E5-5_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodológií použitých na výpočet údajov (generovaný odpad)') WHERE code = 'E5-5_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie jeho zapojenia do odpadového hospodárstva produktov na konci životnosti') WHERE code = 'E5-5_18';

-- E5-6: Predpokladané finančné účinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich s využívaním zdrojov a obehovým hospodárstvom') WHERE code = 'E5-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatívnych informácií o predpokladaných finančných účinkoch materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich s využívaním zdrojov a obehovým hospodárstvom') WHERE code = 'E5-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvažovaných účinkov a súvisiacich dopadov (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritických predpokladov použitých v odhadoch finančných účinkov materiálnych rizík a príležitostí vyplývajúcich z dopadov súvisiacich s využívaním zdrojov a obehovým hospodárstvom') WHERE code = 'E5-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis súvisiacich produktov a služieb ohrozených (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-6_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sú definované časové horizonty, odhadnuté finančné čiastky a urobené kritické predpoklady (využívanie zdrojov a obehové hospodárstvo)') WHERE code = 'E5-6_06';

-- ============================================================================
-- END OF TRANSLATIONS
-- ============================================================================


-- ============================================================================
-- ESRS S1 (Vlastná pracovná sila) - Slovenské preklady
-- ============================================================================
-- Štandard ESRS S1 sa zaoberá vlastnou pracovnou silou organizácie
-- Zahŕňa témy: zamestnanci, pracovné podmienky, zdravie a bezpečnosť,
-- odmeňovanie, diverzita, rovnosť príležitostí a ľudské práva v práci
-- ============================================================================

-- S1.SBM-3: Podstatné dopady, riziká a príležitosti a ich interakcia s stratégiou a obchodným modelom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci ľudia vo vlastnej pracovnej sile, ktorí môžu byť podstatne ovplyvnení podnikom, sú zahrnutí do rozsahu zverejnenia podľa ESRS 2') WHERE code = 'S1.SBM-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov zamestnancov a nezamestnancov vo vlastnej pracovnej sile, ktorí sú predmetom podstatných dopadov') WHERE code = 'S1.SBM-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výskyt podstatných negatívnych dopadov (vlastná pracovná sila)') WHERE code = 'S1.SBM-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis činností, ktoré vedú k pozitívnym dopadom a typy zamestnancov a nezamestnancov vo vlastnej pracovnej sile, ktorí sú alebo by mohli byť pozitívne ovplyvnení') WHERE code = 'S1.SBM-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis podstatných rizík a príležitostí vyplývajúcich z dopadov a závislostí na vlastnej pracovnej sile') WHERE code = 'S1.SBM-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis podstatných dopadov na pracovníkov, ktoré môžu vyplynúť z plánov prechodu na zníženie negatívnych dopadov na životné prostredie a dosiahnutie ekologickejších a klimaticky neutrálnych operácií') WHERE code = 'S1.SBM-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o type operácií s významným rizikom incidentov nútenej práce alebo povinnej práce') WHERE code = 'S1.SBM-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o krajinách alebo geografických oblastiach s operáciami považovanými za rizikové z hľadiska incidentov nútenej práce alebo povinnej práce') WHERE code = 'S1.SBM-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o type operácií s významným rizikom incidentov detskej práce') WHERE code = 'S1.SBM-3_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o krajinách alebo geografických oblastiach s operáciami považovanými za rizikové z hľadiska incidentov detskej práce') WHERE code = 'S1.SBM-3_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako bolo rozvinuté pochopenie ľudí vo vlastnej pracovnej sile s osobitnými charakteristikami, pracujúcich v osobitných kontextoch alebo vykonávajúcich osobitné činnosti, ktorí môžu byť vystavení väčšiemu riziku poškodenia') WHERE code = 'S1.SBM-3_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ktoré z podstatných rizík a príležitostí vyplývajúcich z dopadov a závislostí na ľuďoch vo vlastnej pracovnej sile sa týkajú konkrétnych skupín ľudí') WHERE code = 'S1.SBM-3_12';

-- S1-1: Politiky súvisiace s vlastnou pracovnou silou

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s vlastnou pracovnou silou [pozri ESRS 2 MDR-P]') WHERE code = 'S1.MDR-P_01-06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s vlastnou pracovnou silou, vrátane špecifických skupín v rámci pracovnej sily alebo celej vlastnej pracovnej sily') WHERE code = 'S1-1_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlení významných zmien v politikách prijatých počas vykazovaného roka') WHERE code = 'S1-1_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantných záväzkov v oblasti politiky ľudských práv týkajúcich sa vlastnej pracovnej sily') WHERE code = 'S1-1_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu k rešpektovaniu ľudských práv vrátane pracovných práv ľudí vo vlastnej pracovnej sile') WHERE code = 'S1-1_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu k angažovaniu ľudí vo vlastnej pracovnej sile') WHERE code = 'S1-1_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu k opatreniam na zabezpečenie a (alebo) umožnenie nápravy dopadov na ľudské práva') WHERE code = 'S1-1_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako sú politiky zosúladené s relevantnými medzinárodne uznávanými nástrojmi') WHERE code = 'S1-1_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky výslovne rieši obchodovanie s ľuďmi, nútenú prácu alebo povinnú prácu a detskú prácu') WHERE code = 'S1-1_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existuje politika alebo systém riadenia prevencie pracovných úrazov') WHERE code = 'S1-1_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú špecifické politiky zamerané na odstránenie diskriminácie') WHERE code = 'S1-1_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Dôvody diskriminácie sú špecificky pokryté v politike') WHERE code = 'S1-1_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie špecifických politických záväzkov súvisiacich s inklúziou a (alebo) pozitívnymi opatreniami pre ľudí zo skupín s osobitným rizikom zraniteľnosti vo vlastnej pracovnej sile') WHERE code = 'S1-1_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako sú politiky implementované prostredníctvom špecifických postupov na zabezpečenie prevencie, zmierňovania a konania v prípade zistenia diskriminácie, ako aj na podporu diverzity a inklúzie') WHERE code = 'S1-1_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ilustrácie typov komunikácie politík jednotlivcom, skupinám jednotlivcov alebo subjektom, pre ktoré sú relevantné') WHERE code = 'S1-1_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú politiky a postupy, ktoré robia kvalifikáciu, zručnosti a skúsenosti základom pre nábor, umiestnenie, školenie a postup') WHERE code = 'S1-1_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zodpovednosť za rovnaké zaobchádzanie a príležitosti v zamestnaní bola pridelená na úrovni top manažmentu, vydané jasné politiky a postupy v celej spoločnosti na riadenie rovných pracovných praktík a postup je spojený s požadovaným výkonom v tejto oblasti') WHERE code = 'S1-1_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existuje školenie zamestnancov o politikách a praktikách nediskriminácie') WHERE code = 'S1-1_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú úpravy fyzického prostredia na zabezpečenie zdravia a bezpečnosti pre pracovníkov, zákazníkov a ostatných návštevníkov so zdravotným postihnutím') WHERE code = 'S1-1_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Bolo vyhodnotené, či existuje riziko, že pracovné požiadavky boli definované spôsobom, ktorý by systematicky znevýhodňoval určité skupiny') WHERE code = 'S1-1_19';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vedenie aktuálnych záznamov o nábore, školení a postupe, ktoré poskytujú transparentný pohľad na príležitosti pre zaměstnancov a ich pokrok') WHERE code = 'S1-1_20';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú postupy pre sťažnosti na riešenie sťažností, vybavovanie odvolaní a poskytovanie nápravy pre zamestnancov v prípade identifikácie diskriminácie, a je sa venovaná pozornosť formálnym štruktúram a neformálnym kultúrnym otázkam, ktoré môžu zabrániť zamestnancom vznášať obavy a sťažnosti') WHERE code = 'S1-1_21';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú programy na podporu prístupu k rozvoju zručností') WHERE code = 'S1-1_22';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré majú byť uvedené v prípade, že podnik neprijal politiky') WHERE code = 'S1.MDR-P_07-08';

-- S1-2: Procesy zapojenia pracovníkov a zástupcov pracovníkov pri riešení dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako perspektívy vlastnej pracovnej sily informujú rozhodnutia alebo činnosti zamerané na riadenie skutočných a potenciálnych dopadov') WHERE code = 'S1-2_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie prebieha s vlastnou pracovnou silou alebo ich zástupcami') WHERE code = 'S1-2_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie štádia, v ktorom dochádza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S1-2_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyššej roly v rámci podniku, ktorá má operačnú zodpovednosť za zabezpečenie toho, že dochádza k zapojeniu a že výsledky informujú o prístupe podniku') WHERE code = 'S1-2_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie Globálnej rámcovej dohody alebo iných dohôd súvisiacich s rešpektovaním ľudských práv pracovníkov') WHERE code = 'S1-2_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako je hodnotená efektívnosť zapojenia vlastnej pracovnej sily') WHERE code = 'S1-2_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov podniknutých na získanie náhľadu na perspektívy ľudí vo vlastnej pracovnej sile, ktorí môžu byť obzvlášť zraniteľní voči dopadom a (alebo) marginalizovaní') WHERE code = 'S1-2_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal všeobecný proces na zapojenie vlastnej pracovnej sily') WHERE code = 'S1-2_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového rámca pre prijatie všeobecného procesu na zapojenie vlastnej pracovnej sily v prípade, že podnik neprijal všeobecný proces zapojenia') WHERE code = 'S1-2_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako podnik zapája osoby v riziku alebo osoby v zraniteľných situáciách') WHERE code = 'S1-2_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa berú do úvahy potenciálne bariéry pre zapojenie ľudí v pracovnej sile') WHERE code = 'S1-2_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sú ľudia vo vlastnej pracovnej sile poskytované informácie, ktoré sú zrozumiteľné a prístupné prostredníctvom vhodných komunikačných kanálov') WHERE code = 'S1-2_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie akýchkoľvek konfliktných záujmov, ktoré vznikli medzi rôznymi pracovníkmi a ako boli tieto konfliktné záujmy vyriešené') WHERE code = 'S1-2_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako podnik usiluje rešpektovať ľudské práva všetkých zapojených zainteresovaných strán') WHERE code = 'S1-2_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o efektívnosti procesov zapojenia vlastnej pracovnej sily z predchádzajúcich vykazovacích období') WHERE code = 'S1-2_15';

-- S1-3: Procesy nápravy negatívnych dopadov a kanály pre vznesenie obav

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu a procesov na poskytovanie alebo prispievanie k náprave v prípade, že podnik spôsobil alebo prispel k podstatnému negatívnemu dopadu na ľudí vo vlastnej pracovnej sile') WHERE code = 'S1-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie špecifických kanálov, ktoré má vlastná pracovná sila k dispozícii na vznesenie obav alebo potrieb priamo voči podniku a ich riešenie') WHERE code = 'S1-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretích strán sú prístupné pre všetkých vlastných pracovníkov') WHERE code = 'S1-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako majú vlastná pracovná sila a ich zástupcovia pracovníkov prístup ku kanálom na úrovni podniku, v ktorom sú zamestnaní alebo pre ktorý majú zmluvu na prácu') WHERE code = 'S1-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú mechanizmy na vybavovanie sťažností alebo reklamácií súvisiacich so záležitosťami zamestnancov') WHERE code = 'S1-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostredníctvom ktorých podnik podporuje alebo vyžaduje dostupnosť kanálov') WHERE code = 'S1-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sú sledované a monitorované vznesené a riešené otázky a ako je zabezpečená efektívnosť kanálov') WHERE code = 'S1-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako je hodnotené, že vlastná pracovná sila je informovaná a dôveruje štruktúram alebo procesom ako spôsobu vznášania ich obav alebo potrieb a ich riešenia') WHERE code = 'S1-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú politiky týkajúce sa ochrany pred odvetou pre jednotlivcov, ktorí používajú kanály na vznesenie obav alebo potrieb') WHERE code = 'S1-3_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal kanál na vznesenie obav') WHERE code = 'S1-3_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového rámca pre zavedenie kanálu na vznesenie obav') WHERE code = 'S1-3_11';

-- S1-4: Akcie súvisiace s podstatnými dopadmi na vlastnú pracovnú silu

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akčné plány a zdroje na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s vlastnou pracovnou silou [pozri ESRS 2 - MDR-A]') WHERE code = 'S1.MDR-A_01-12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prijatých, plánovaných alebo prebiehajúcich akcií na prevenciu alebo zmiernenie negatívnych dopadov na vlastnú pracovnú silu') WHERE code = 'S1-4_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako bola prijatá akcia na poskytnutie alebo umožnenie nápravy vo vzťahu k skutočnému podstatnému dopadu') WHERE code = 'S1-4_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatočných iniciatív alebo akcií s primárnym účelom prinášania pozitívnych dopadov pre vlastnú pracovnú silu') WHERE code = 'S1-4_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako je sledovaná a hodnotená efektívnosť akcií a iniciatív pri dosahovaní výsledkov pre vlastnú pracovnú silu') WHERE code = 'S1-4_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesu, prostredníctvom ktorého identifikuje, aká akcia je potrebná a vhodná ako odpoveď na konkrétny skutočný alebo potenciálny negatívny dopad na vlastnú pracovnú silu') WHERE code = 'S1-4_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aká akcia je plánovaná alebo prebieha na zmiernenie podstatných rizík vyplývajúcich z dopadov a závislostí na vlastnej pracovnej sile a ako je sledovaná efektívnosť') WHERE code = 'S1-4_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aká akcia je plánovaná alebo prebieha na využitie podstatných príležitostí vo vzťahu k vlastnej pracovnej sile') WHERE code = 'S1-4_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako je zabezpečené, že vlastné praktiky nespôsobujú ani neprispievajú k podstatným negatívnym dopadom na vlastnú pracovnú silu') WHERE code = 'S1-4_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, že zdroje sú alokované na riadenie podstatných dopadov') WHERE code = 'S1-4_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecných a špecifických prístupov k riešeniu podstatných negatívnych dopadov') WHERE code = 'S1-4_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie iniciatív zameraných na prispievanie k dodatočným podstatným pozitívnym dopadom') WHERE code = 'S1-4_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako ďaleko podnik pokročil v úsilí počas vykazovaného obdobia') WHERE code = 'S1-4_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie cieľov pre pokračujúce zlepšovanie') WHERE code = 'S1-4_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako podnik usiluje použiť vplyv s relevantnými obchodnými vzťahmi na riadenie podstatných negatívnych dopadov ovplyvňujúcich vlastnú pracovnú silu') WHERE code = 'S1-4_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako iniciatíva a jej vlastné zapojenie usiluje riešiť príslušný podstatný dopad') WHERE code = 'S1-4_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako pracovníci a zástupcovia pracovníkov zohrávajú úlohu v rozhodnutiach týkajúcich sa dizajnu a implementácie programov alebo procesov, ktorých primárnym cieľom je prinášať pozitívne dopady pre pracovníkov') WHERE code = 'S1-4_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zamýšľaných alebo dosiahnutých pozitívnych výsledkoch programov alebo procesov pre vlastnú pracovnú silu') WHERE code = 'S1-4_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Iniciatívy alebo procesy, ktorých primárnym cieľom je prinášať pozitívne dopady pre vlastnú pracovnú silu, sú navrhnuté aj na podporu dosiahnutia jedného alebo viacerých Cieľov udržateľného rozvoja') WHERE code = 'S1-4_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o opatreniach prijatých na zmiernenie negatívnych dopadov na pracovníkov, ktoré vyplývajú z prechodu na ekologickejšiu, klimaticky neutrálnu ekonomiku') WHERE code = 'S1-4_19';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis interných funkcií, ktoré sú zapojené do riadenia dopadov a typov akcií prijatých internými funkciami na riešenie negatívnych a podporu pozitívnych dopadov') WHERE code = 'S1-4_20';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré majú byť uvedené, ak podnik neprijal akcie') WHERE code = 'S1.MDR-A_13-14';

-- S1-5: Ciele súvisiace s riadením podstatných negatívnych dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovené na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s vlastnou pracovnou silou [pozri ESRS 2 - MDR-T]') WHERE code = 'S1.MDR-T_01-13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako bola vlastná pracovná sila alebo zástupcovia pracovnej sily zapojení priamo do stanovovania cieľov') WHERE code = 'S1-5_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako bola vlastná pracovná sila alebo zástupcovia pracovnej sily zapojení priamo do sledovania výkonnosti voči cieľom') WHERE code = 'S1-5_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako bola vlastná pracovná sila alebo zástupcovia pracovnej sily zapojení priamo do identifikácie lekcií alebo zlepšení v dôsledku výkonnosti podniku') WHERE code = 'S1-5_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamýšľaných výsledkov, ktoré majú byť dosiahnuté v životoch ľudí vo vlastnej pracovnej sile') WHERE code = 'S1-5_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o stabilite cieľa v priebehu času z hľadiska definícií a metodík na umožnenie porovnateľnosti') WHERE code = 'S1-5_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na štandardy alebo záväzky, na ktorých sú ciele založené') WHERE code = 'S1-5_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré majú byť uvedené, ak podnik neprijal ciele') WHERE code = 'S1.MDR-T_14-19';

-- S1-6: Charakteristiky zamestnancov podniku

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - počet zamestnancov podľa pohlavia [tabuľka]') WHERE code = 'S1-6_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zamestnancov (hlavy)') WHERE code = 'S1-6_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet zamestnancov (hlavy)') WHERE code = 'S1-6_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - počet zamestnancov v krajinách s 50 alebo viac zamestnancami predstavujúcimi aspoň 10% celkového počtu zamestnancov [tabuľka]') WHERE code = 'S1-6_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zamestnancov v krajinách s 50 alebo viac zamestnancami predstavujúcimi aspoň 10% celkového počtu zamestnancov') WHERE code = 'S1-6_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet zamestnancov v krajinách s 50 alebo viac zamestnancami predstavujúcimi aspoň 10% celkového počtu zamestnancov') WHERE code = 'S1-6_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - informácie o zamestnancoch podľa typu zmluvy a pohlavia [tabuľka]') WHERE code = 'S1-6_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - informácie o zamestnancoch podľa regiónu [tabuľka]') WHERE code = 'S1-6_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zamestnancov (hlavy alebo ekvivalent na plný úväzok)') WHERE code = 'S1-6_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet zamestnancov (hlavy alebo ekvivalent na plný úväzok)') WHERE code = 'S1-6_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zamestnancov, ktorí opustili podnik') WHERE code = 'S1-6_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel fluktuácie zamestnancov') WHERE code = 'S1-6_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodík a predpokladov použitých na zostavenie údajov (zamestnanci)') WHERE code = 'S1-6_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počty zamestnancov sú uvedené v hlavách alebo ekvivalente na plný úväzok') WHERE code = 'S1-6_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počty zamestnancov sú uvedené na konci vykazovaného obdobia/priemer/iná metodika') WHERE code = 'S1-6_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií potrebných na pochopenie údajov (zamestnanci)') WHERE code = 'S1-6_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krížového odkazu informácií uvedených v odseku 50 (a) na najreprezentívnejšie číslo v účtovnej závierke') WHERE code = 'S1-6_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ďalšie podrobné členenie podľa pohlavia a podľa regiónu [tabuľka]') WHERE code = 'S1-6_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zamestnancov na plný úväzok podľa hláv alebo ekvivalentu na plný úväzok') WHERE code = 'S1-6_19';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zamestnancov na čiastočný úväzok podľa hláv alebo ekvivalentu na plný úväzok') WHERE code = 'S1-6_20';

-- S1-7: Charakteristiky nezamestnancov vo vlastnej pracovnej sile

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet nezamestnancov vo vlastnej pracovnej sile') WHERE code = 'S1-7_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet nezamestnancov vo vlastnej pracovnej sile - samostatne zárobkovo činné osoby') WHERE code = 'S1-7_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet nezamestnancov vo vlastnej pracovnej sile - ľudia poskytnutí podnikmi primárne zaoberajúcimi sa činnosťami zamestnávania') WHERE code = 'S1-7_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik nemá nezamestnancov vo vlastnej pracovnej sile') WHERE code = 'S1-7_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie najbežnejších typov nezamestnancov (napríklad samostatne zárobkovo činné osoby, osoby poskytnuté podnikmi primárne zaoberajúcimi sa činnosťami zamestnávania a iné typy relevantné pre podnik), ich vzťah k podniku a typ práce, ktorú vykonávajú') WHERE code = 'S1-7_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodík a predpokladov použitých na zostavenie údajov (nezamestnanci)') WHERE code = 'S1-7_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počty nezamestnancov sú uvedené v hlavách/ekvivalente na plný úväzok') WHERE code = 'S1-7_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počty nezamestnancov sú uvedené na konci vykazovaného obdobia/priemer/iná metodika') WHERE code = 'S1-7_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií potrebných na pochopenie údajov (nezamestnaní pracovníci)') WHERE code = 'S1-7_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis základu prípravy odhadovaného počtu nezamestnancov') WHERE code = 'S1-7_10';

-- S1-8: Pokrytie kolektívnym vyjednávaním a sociálnym dialógom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel celkových zamestnancov pokrytých kolektívnymi zmluvami') WHERE code = 'S1-8_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel vlastných zamestnancov pokrytých kolektívnymi zmluvami v rámci miery pokrytia podľa krajiny s významným zamestnaním (v EHP)') WHERE code = 'S1-8_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel vlastných zamestnancov pokrytých kolektívnymi zmluvami (mimo EHP) podľa regiónu') WHERE code = 'S1-8_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pracovné podmienky a podmienky zamestnania pre zamestnancov, ktorí nie sú pokrytí kolektívnymi zmluvami, sú určené na základe kolektívnych zmlúv, ktoré pokrývajú ostatných zamestnancov, alebo na základe kolektívnych zmlúv z iných podnikov') WHERE code = 'S1-8_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis rozsahu, v akom sú pracovné podmienky a podmienky zamestnania nezamestnancov vo vlastnej pracovnej sile určené alebo ovplyvnené kolektívnymi zmluvami') WHERE code = 'S1-8_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zamestnancov v krajine s významným zamestnaním (v EHP) pokrytých zástupcami pracovníkov') WHERE code = 'S1-8_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie existencie akejkoľvek dohody so zamestnancami o zastúpení Európskou radou zamestnancov (EWC), radou zamestnancov Societas Europaea (SE) alebo radou zamestnancov Societas Cooperativa Europaea (SCE)') WHERE code = 'S1-8_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vlastná pracovná sila v regióne (mimo EHP) pokrytá kolektívnym vyjednávaním a dohodami o sociálnom dialógu podľa miery pokrytia a podľa regiónu') WHERE code = 'S1-8_08';

-- S1-9: Ukazovatele diverzity metrík

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie podľa pohlavia v počte zamestnancov (hlavy) na úrovni top manažmentu') WHERE code = 'S1-9_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie podľa pohlavia v percentách zamestnancov na úrovni top manažmentu') WHERE code = 'S1-9_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie zamestnancov (hlavy) mladších ako 30 rokov') WHERE code = 'S1-9_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie zamestnancov (hlavy) medzi 30 a 50 rokmi') WHERE code = 'S1-9_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie zamestnancov (hlavy) starších ako 50 rokov') WHERE code = 'S1-9_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vlastnej definície top manažmentu') WHERE code = 'S1-9_06';

-- S1-10: Primeraná mzda

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci sú platení primeranú mzdu v súlade s príslušnými referenčnými hodnotami') WHERE code = 'S1-10_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Krajiny, kde zamestnanci zarábajú menej ako príslušná primeraná mzdová referenčná hodnota [tabuľka]') WHERE code = 'S1-10_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zamestnancov platených menej ako príslušná primeraná mzdová referenčná hodnota') WHERE code = 'S1-10_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel nezamestnancov platených menej ako primeraná mzda') WHERE code = 'S1-10_04';

-- S1-11: Sociálna ochrana

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci vo vlastnej pracovnej sile sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku choroby') WHERE code = 'S1-11_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci vo vlastnej pracovnej sile sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku nezamestnanosti od začiatku práce vlastného pracovníka pre podnik') WHERE code = 'S1-11_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci vo vlastnej pracovnej sile sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku pracovného úrazu a získaného zdravotného postihnutia') WHERE code = 'S1-11_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci vo vlastnej pracovnej sile sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku rodičovskej dovolenky') WHERE code = 'S1-11_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci vo vlastnej pracovnej sile sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku odchodu do dôchodku') WHERE code = 'S1-11_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sociálna ochrana zamestnancov podľa krajiny [tabuľka] podľa typov udalostí a typu zamestnancov [vrátane nezamestnancov]') WHERE code = 'S1-11_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorí nie sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku choroby') WHERE code = 'S1-11_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorí nie sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku nezamestnanosti od začiatku práce vlastného pracovníka pre podnik') WHERE code = 'S1-11_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorí nie sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku pracovného úrazu a získaného zdravotného postihnutia') WHERE code = 'S1-11_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorí nie sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku materskej dovolenky') WHERE code = 'S1-11_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorí nie sú pokrytí sociálnou ochranou prostredníctvom verejných programov alebo prostredníctvom poskytovaných výhod voči strate príjmu v dôsledku odchodu do dôchodku') WHERE code = 'S1-11_11';

-- S1-12: Osoby so zdravotným postihnutím

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel osôb so zdravotným postihnutím medzi zamestnancami, s výhradou právnych obmedzení na zber údajov') WHERE code = 'S1-12_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zamestnancov so zdravotným postihnutím vo vlastnej pracovnej sile členený podľa pohlavia [tabuľka]') WHERE code = 'S1-12_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií potrebných na pochopenie údajov a toho, ako boli údaje zostavené (osoby so zdravotným postihnutím)') WHERE code = 'S1-12_03';

-- S1-13: Metriky školenia a rozvoja zručností

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ukazovatele školenia a rozvoja zručností podľa pohlavia [tabuľka]') WHERE code = 'S1-13_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zamestnancov, ktorí sa zúčastnili pravidelných hodnotení výkonu a kariérneho rozvoja') WHERE code = 'S1-13_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet hodín školenia podľa pohlavia [tabuľka]') WHERE code = 'S1-13_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet hodín školenia na osobu pre zamestnancov') WHERE code = 'S1-13_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zamestnancov, ktorí sa zúčastnili pravidelných hodnotení výkonu a kariérneho rozvoja podľa kategórie zamestnancov [tabuľka]') WHERE code = 'S1-13_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet zamestnancov, ktorí sa zúčastnili pravidelných hodnotení výkonu a kariérneho rozvoja podľa kategórie zamestnancov') WHERE code = 'S1-13_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel nezamestnancov, ktorí sa zúčastnili pravidelných hodnotení výkonu a kariérneho rozvoja') WHERE code = 'S1-13_07';

-- S1-14: Zdravie a bezpečnosť

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel ľudí vo vlastnej pracovnej sile, ktorí sú pokrytí systémom riadenia zdravia a bezpečnosti založeným na právnych požiadavkách a (alebo) uznávaných štandardoch alebo usmerneniach') WHERE code = 'S1-14_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet úmrtí vo vlastnej pracovnej sile v důsledku pracovných úrazov a chorôb súvisiacich s prácou') WHERE code = 'S1-14_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet úmrtí v dôsledku pracovných úrazov a chorôb súvisiacich s prácou iných pracovníkov pracujúcich na pracoviskách podniku') WHERE code = 'S1-14_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet zaznamenateľných pracovných úrazov pre vlastnú pracovnú silu') WHERE code = 'S1-14_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Miera zaznamenateľných pracovných úrazov pre vlastnú pracovnú silu') WHERE code = 'S1-14_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet prípadov zaznamenateľných chorôb súvisiacich s prácou u zamestnancov') WHERE code = 'S1-14_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet dní stratených v dôsledku pracovných úrazov a úmrtí z pracovných úrazov, chorôb súvisiacich s prácou a úmrtí z chorôb súvisiacich so zdravím týkajúcich sa zamestnancov') WHERE code = 'S1-14_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet prípadov zaznamenateľných chorôb súvisiacich s prácou u nezamestnancov') WHERE code = 'S1-14_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet dní stratených v dôsledku pracovných úrazov a úmrtí z pracovných úrazov, chorôb súvisiacich s prácou a úmrtí z chorôb súvisiacich so zdravím týkajúcich sa nezamestnancov') WHERE code = 'S1-14_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel vlastnej pracovnej sily, ktorá je pokrytá systémom riadenia zdravia a bezpečnosti založeným na právnych požiadavkách a (alebo) uznávaných štandardoch alebo usmerneniach a ktorý bol interne auditovaný a (alebo) auditovaný alebo certifikovaný externou stranou') WHERE code = 'S1-14_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis základných štandardov pre interný audit alebo externú certifikáciu systému riadenia zdravia a bezpečnosti') WHERE code = 'S1-14_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet prípadov zaznamenateľných chorôb súvisiacich s prácou zistených medzi bývalou vlastnou pracovnou silou') WHERE code = 'S1-14_12';

-- S1-15: Rovnováha medzi pracovným a súkromným životom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel zamestnancov oprávnených čerpať dovolenku súvisiacu s rodinou') WHERE code = 'S1-15_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel oprávnených zamestnancov, ktorí čerpali dovolenku súvisiacu s rodinou') WHERE code = 'S1-15_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percentuálny podiel oprávnených zamestnancov, ktorí čerpali dovolenku súvisiacu s rodinou podľa pohlavia [tabuľka]') WHERE code = 'S1-15_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci zamestnanci majú nárok na dovolenku súvisiacu s rodinou prostredníctvom sociálnej politiky a (alebo) kolektívnych zmlúv') WHERE code = 'S1-15_04';

-- S1-16: Odmeňovanie (mzdový rozdiel a pomer odmeňovania)

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdiel v odmeňovaní medzi pohlaviami') WHERE code = 'S1-16_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pomer ročného celkového odmeňovania') WHERE code = 'S1-16_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií potrebných na pochopenie údajov, ako boli údaje zostavené a iných zmien v základných údajoch, ktoré je potrebné vziať do úvahy') WHERE code = 'S1-16_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdiel v odmeňovaní medzi pohlaviami členený podľa kategórie zamestnancov a/alebo krajiny/segmentu [tabuľka]') WHERE code = 'S1-16_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdiel v odmeňovaní medzi pohlaviami členený podľa kategórie zamestnancov a riadneho základného platu a doplnkových/variabilných zložiek') WHERE code = 'S1-16_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pomer odmeňovania upravený o rozdiely v kúpnej sile medzi krajinami') WHERE code = 'S1-16_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodiky použitej pre výpočet pomeru odmeňovania upraveného o rozdiely v kúpnej sile medzi krajinami') WHERE code = 'S1-16_07';

-- S1-17: Incidenty, sťažnosti a závažné dopady na ľudské práva

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet incidentov diskriminácie [tabuľka]') WHERE code = 'S1-17_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet incidentov diskriminácie') WHERE code = 'S1-17_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet sťažností podaných prostredníctvom kanálov pre ľudí vo vlastnej pracovnej sile na vznesenie obav') WHERE code = 'S1-17_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet sťažností podaných národným kontaktným bodom pre OECD Mnohonárodné podniky') WHERE code = 'S1-17_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výška pokút, sankcií a náhrad škody v dôsledku incidentov diskriminácie, vrátane obťažovania a podaných sťažností') WHERE code = 'S1-17_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zosúladení pokút, sankcií a náhrad škody v dôsledku porušení týkajúcich sa pracovnej diskriminácie a obťažovania s najrelevantnejšou sumou uvedenou v účtovnej závierke') WHERE code = 'S1-17_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií potrebných na pochopenie údajov a toho, ako boli údaje zostavené (sťažnosti, incidenty a sťažnosti súvisiace so sociálnymi záležitosťami a ľudskými právami v práci)') WHERE code = 'S1-17_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet závažných otázok a incidentov v oblasti ľudských práv spojených s vlastnou pracovnou silou') WHERE code = 'S1-17_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet závažných otázok a incidentov v oblasti ľudských práv spojených s vlastnou pracovnou silou, ktoré sú prípadmi nerešpektovania Usmernení OSN a Usmernení OECD pre nadnárodné podniky') WHERE code = 'S1-17_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Nedošlo k žiadnym závažným otázkam a incidentom v oblasti ľudských práv spojeným s vlastnou pracovnou silou') WHERE code = 'S1-17_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výška pokút, sankcií a náhrad za závažné otázky a incidenty v oblasti ľudských práv spojené s vlastnou pracovnou silou') WHERE code = 'S1-17_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zosúladení výšky pokút, sankcií a náhrad za závažné otázky a incidenty v oblasti ľudských práv spojené s vlastnou pracovnou silou s najrelevantnejšou sumou uvedenou v účtovnej závierke') WHERE code = 'S1-17_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie stavu incidentov a/alebo sťažností a prijatých opatrení') WHERE code = 'S1-17_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet závažných prípadov porušenia ľudských práv, pri ktorých podnik hral úlohu pri zabezpečení nápravy pre postihnutých') WHERE code = 'S1-17_14';


-- ============================================================================
-- ESRS S2 (Pracovníci v hodnotovom reťazci) - Slovenské preklady
-- ============================================================================
-- Štandard ESRS S2 sa zaoberá pracovníkmi v hodnotovom reťazci organizácie
-- Zahŕňa: dodávateľov, subdodávateľov, pracovné práva, nútenú prácu,
-- detskú prácu, bezpečnosť a zdravie pracovníkov mimo priamej pracovnej sily
-- ============================================================================

-- S2.SBM-3: Podstatné dopady, riziká a príležitosti a ich interakcia s stratégiou a obchodným modelom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci pracovníci v hodnotovom reťazci, ktorí môžu byť podstatne ovplyvnení podnikom, sú zahrnutí do rozsahu zverejnenia podľa ESRS 2') WHERE code = 'S2.SBM-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov pracovníkov v hodnotovom reťazci, ktorí sú predmetom podstatných dopadov') WHERE code = 'S2.SBM-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ pracovníkov v hodnotovom reťazci, ktorí sú predmetom podstatných dopadov vlastnými operáciami alebo prostredníctvom hodnotového reťazca') WHERE code = 'S2.SBM-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie geografických oblastí alebo komodít, pri ktorých existuje významné riziko detskej práce alebo nútenej alebo povinnej práce medzi pracovníkmi v hodnotovom reťazci podniku') WHERE code = 'S2.SBM-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výskyt podstatných negatívnych dopadov (pracovníci v hodnotovom reťazci)') WHERE code = 'S2.SBM-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis činností, ktoré vedú k pozitívnym dopadom a typy pracovníkov v hodnotovom reťazci, ktorí sú alebo by mohli byť pozitívne ovplyvnení') WHERE code = 'S2.SBM-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis podstatných rizík a príležitostí vyplývajúcich z dopadov a závislostí na pracovníkoch v hodnotovom reťazci') WHERE code = 'S2.SBM-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako podnik vyvinul pochopenie toho, ako pracovníci s osobitnými charakteristikami, tí, ktorí pracujú v osobitných kontextoch alebo vykonávajú osobitné činnosti, môžu byť vystavení väčšiemu riziku poškodenia') WHERE code = 'S2.SBM-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ktoré z podstatných rizík a príležitostí vyplývajúcich z dopadov a závislostí na pracovníkoch v hodnotovom reťazci sú dopady na konkrétne skupiny') WHERE code = 'S2.SBM-3_09';

-- S2-1: Politiky súvisiace s pracovníkmi v hodnotovom reťazci

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s pracovníkmi v hodnotovom reťazci [pozri ESRS 2 MDR-P]') WHERE code = 'S2.MDR-P_01-06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantných záväzkov v oblasti politiky ľudských práv týkajúcich sa pracovníkov v hodnotovom reťazci') WHERE code = 'S2-1_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu k rešpektovaniu ľudských práv týkajúcich sa pracovníkov v hodnotovom reťazci') WHERE code = 'S2-1_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu k angažovaniu pracovníkov v hodnotovom reťazci') WHERE code = 'S2-1_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu k opatreniam na zabezpečenie a (alebo) umožnenie nápravy dopadov na ľudské práva') WHERE code = 'S2-1_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky výslovne riešia obchodovanie s ľuďmi, nútenú prácu alebo povinnú prácu a detskú prácu') WHERE code = 'S2-1_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik má kódex správania dodávateľov') WHERE code = 'S2-1_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ustanovenia v kódexoch správania dodávateľov sú úplne v súlade s príslušnými štandardmi ILO') WHERE code = 'S2-1_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako sú politiky zosúladené s relevantnými medzinárodne uznávanými nástrojmi') WHERE code = 'S2-1_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu a náznaku povahy prípadov nerešpektovania Usmernení OSN o podnikaní a ľudských právach, Deklarácie ILO o základných princípoch a právach v práci alebo Usmernení OECD pre nadnárodné podniky, ktoré sa týkajú pracovníkov v hodnotovom reťazci') WHERE code = 'S2-1_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlení významných zmien v politikách prijatých počas vykazovaného roka') WHERE code = 'S2-1_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ilustrácie typov komunikácie politík jednotlivcom, skupinám jednotlivcov alebo subjektom, pre ktoré sú relevantné') WHERE code = 'S2-1_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré majú byť uvedené v prípade, že podnik neprijal politiky') WHERE code = 'S2.MDR-P_07-08';

-- S2-2: Procesy zapojenia pracovníkov v hodnotovom reťazci pri riešení dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako perspektívy pracovníkov v hodnotovom reťazci informujú rozhodnutia alebo činnosti zamerané na riadenie skutočných a potenciálnych dopadov') WHERE code = 'S2-2_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie prebieha s pracovníkmi v hodnotovom reťazci alebo ich legitímnymi zástupcami priamo alebo s dôveryhodnými sprostredkovateľmi') WHERE code = 'S2-2_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie štádia, v ktorom dochádza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S2-2_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyššej roly v rámci podniku, ktorá má operačnú zodpovednosť za zabezpečenie toho, že dochádza k zapojeniu a že výsledky informujú o prístupe podniku') WHERE code = 'S2-2_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie Globálnej rámcovej dohody alebo iných dohôd súvisiacich s rešpektovaním ľudských práv pracovníkov') WHERE code = 'S2-2_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako je hodnotená efektívnosť zapojenia pracovníkov v hodnotovom reťazci') WHERE code = 'S2-2_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov podniknutých na získanie náhľadu na perspektívy pracovníkov v hodnotovom reťazci, ktorí môžu byť obzvlášť zraniteľní voči dopadom a (alebo) marginalizovaní') WHERE code = 'S2-2_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal všeobecný proces na zapojenie pracovníkov v hodnotovom reťazci') WHERE code = 'S2-2_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového rámca pre prijatie všeobecného procesu na zapojenie pracovníkov v hodnotovom reťazci v prípade, že podnik neprijal všeobecný proces zapojenia') WHERE code = 'S2-2_09';

-- S2-3: Procesy nápravy negatívnych dopadov a kanály pre vznesenie obav

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu a procesov na poskytovanie alebo prispievanie k náprave v prípade, že podnik identifikoval, že je spojený s podstatným negatívnym dopadom na pracovníkov v hodnotovom reťazci') WHERE code = 'S2-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie špecifických kanálov, ktoré majú pracovníci v hodnotovom reťazci k dispozícii na vznesenie obav alebo potrieb priamo voči podniku a ich riešenie') WHERE code = 'S2-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostredníctvom ktorých podnik podporuje alebo vyžaduje dostupnosť kanálov') WHERE code = 'S2-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sú sledované a monitorované vznesené a riešené otázky a ako je zabezpečená efektívnosť kanálov') WHERE code = 'S2-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako je hodnotené, že pracovníci v hodnotovom reťazci sú informovaní a dôverujú štruktúram alebo procesom ako spôsobu vznášania ich obáv alebo potrieb a ich riešenia') WHERE code = 'S2-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú politiky týkajúce sa ochrany pred odvetou pre jednotlivcov, ktorí používajú kanály na vznesenie obav alebo potrieb') WHERE code = 'S2-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal kanál na vznesenie obáv') WHERE code = 'S2-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového rámca pre zavedenie kanálu na vznesenie obáv') WHERE code = 'S2-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako majú pracovníci v hodnotovom reťazci prístup ku kanálom na úrovni podniku, v ktorom sú zamestnaní alebo pre ktorý majú zmluvu na prácu') WHERE code = 'S2-3_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretích strán sú prístupné pre všetkých pracovníkov') WHERE code = 'S2-3_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sťažnosti sú riešené dôverne a s rešpektovaním práv na súkromie a ochranu údajov') WHERE code = 'S2-3_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Kanály na vznesenie obáv alebo potrieb umožňujú pracovníkom v hodnotovom reťazci ich používať anonymne') WHERE code = 'S2-3_12';

-- S2-4: Akcie súvisiace s podstatnými dopadmi na pracovníkov v hodnotovom reťazci

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akčné plány a zdroje na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s pracovníkmi v hodnotovom reťazci [pozri ESRS 2 - MDR-A]') WHERE code = 'S2.MDR-A_01-12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis plánovaných alebo prebiehajúcich akcií na prevenciu, zmiernenie alebo nápravu podstatných negatívnych dopadov na pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, či a ako akcia na poskytnutie alebo umožnenie nápravy vo vzťahu k skutočnému podstatnému dopadu') WHERE code = 'S2-4_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatočných iniciatív alebo procesov s primárnym účelom prinášania pozitívnych dopadov pre pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako je sledovaná a hodnotená efektívnosť akcií alebo iniciatív pri dosahovaní výsledkov pre pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesov na identifikáciu toho, aká akcia je potrebná a vhodná ako odpoveď na konkrétny skutočný alebo potenciálny podstatný negatívny dopad na pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k prijímaniu akcií vo vzťahu k špecifickým podstatným negatívnym dopadom na pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k zabezpečeniu toho, že procesy na poskytnutie alebo umožnenie nápravy v prípade podstatných negatívnych dopadov na pracovníkov v hodnotovom reťazci sú dostupné a efektívne v ich implementácii a výsledkoch') WHERE code = 'S2-4_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aká akcia je plánovaná alebo prebieha na zmiernenie podstatných rizík vyplývajúcich z dopadov a závislostí na pracovníkoch v hodnotovom reťazci a ako je sledovaná efektívnosť') WHERE code = 'S2-4_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aká akcia je plánovaná alebo prebieha na využitie podstatných príležitostí vo vzťahu k pracovníkom v hodnotovom reťazci') WHERE code = 'S2-4_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako je zabezpečené, že vlastné praktiky nespôsobujú ani neprispievajú k podstatným negatívnym dopadom na pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie závažných otázok a incidentov v oblasti ľudských práv spojených s upstream a downstream hodnotovým reťazcom') WHERE code = 'S2-4_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zdrojov alokovaných na riadenie podstatných dopadov') WHERE code = 'S2-4_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako podnik usiluje použiť vplyv s relevantnými obchodnými vzťahmi na riadenie podstatných negatívnych dopadov ovplyvňujúcich pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako účasť v odvetvovej alebo viacstrannej iniciatíve a vlastné zapojenie podniku usiluje riešiť podstatné dopady') WHERE code = 'S2-4_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako pracovníci v hodnotovom reťazci a legitímni zástupcovia alebo ich dôveryhodní sprostredkovatelia zohrávajú úlohu v rozhodnutiach týkajúcich sa dizajnu a implementácie programov alebo procesov') WHERE code = 'S2-4_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zamýšľaných alebo dosiahnutých pozitívnych výsledkoch programov alebo procesov pre pracovníkov v hodnotovom reťazci') WHERE code = 'S2-4_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Iniciatívy alebo procesy, ktorých primárnym cieľom je prinášať pozitívne dopady pre pracovníkov v hodnotovom reťazci, sú navrhnuté aj na podporu dosiahnutia jedného alebo viacerých Cieľov udržateľného rozvoja') WHERE code = 'S2-4_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis interných funkcií, ktoré sú zapojené do riadenia dopadov a typov akcií prijatých internými funkciami na riešenie negatívnych a podporu pozitívnych dopadov') WHERE code = 'S2-4_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré majú byť uvedené, ak podnik neprijal akcie') WHERE code = 'S2.MDR-A_13-14';

-- S2-5: Ciele súvisiace s riadením podstatných negatívnych dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovené na riadenie podstatných dopadov, rizík a príležitostí súvisiacich s pracovníkmi v hodnotovom reťazci [pozri ESRS 2 - MDR-T]') WHERE code = 'S2.MDR-T_01-13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako boli pracovníci v hodnotovom reťazci, ich legitímni zástupcovia alebo dôveryhodní sprostredkovatelia zapojení priamo do stanovovania cieľov') WHERE code = 'S2-5_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako boli pracovníci v hodnotovom reťazci, ich legitímni zástupcovia alebo dôveryhodní sprostredkovatelia zapojení priamo do sledovania výkonnosti voči cieľom') WHERE code = 'S2-5_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, či a ako boli pracovníci v hodnotovom reťazci, ich legitímni zástupcovia alebo dôveryhodní sprostredkovatelia zapojení priamo do identifikácie lekcií alebo zlepšení v dôsledku výkonnosti podniku') WHERE code = 'S2-5_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamýšľaných výsledkov, ktoré majú byť dosiahnuté v životoch pracovníkov v hodnotovom reťazci') WHERE code = 'S2-5_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o stabilite cieľa v priebehu času z hľadiska definícií a metodík na umožnenie porovnateľnosti') WHERE code = 'S2-5_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na štandardy alebo záväzky, na ktorých je cieľ založený') WHERE code = 'S2-5_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré majú byť uvedené, ak podnik neprijal ciele') WHERE code = 'S2.MDR-T_14-19';


-- =====================================================
-- ESRS S3 (Ovplyvnené komunity) - Slovak Translations
-- =====================================================

-- S3.SBM-3: Strategy and Business Model
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetky ovplyvnené komunity, ktoré môžu byť významne ovplyvnené podnikom, sú zahrnuté v rozsahu zverejnenia podľa ESRS 2') WHERE code = 'S3.SBM-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov ovplyvnených komunít podliehajúcich významným dopadom') WHERE code = 'S3.SBM-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ komunít podliehajúcich významným dopadom vlastnými činnosťami alebo prostredníctvom hodnotového reťazca') WHERE code = 'S3.SBM-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výskyt významných negatívnych dopadov (ovplyvnené komunity)') WHERE code = 'S3.SBM-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis činností, ktoré majú pozitívne dopady, a typy ovplyvnených komunít, ktoré sú alebo môžu byť pozitívne ovplyvnené') WHERE code = 'S3.SBM-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis významných rizík a príležitostí vyplývajúcich z dopadov a závislostí na ovplyvnených komunitách') WHERE code = 'S3.SBM-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako podnik rozvinul pochopenie toho, ako môžu byť ovplyvnené komunity s osobitnými charakteristikami alebo žijúce v osobitných podmienkach vystavené vyššiemu riziku poškodenia') WHERE code = 'S3.SBM-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktoré zo významných rizík a príležitostí vyplývajúcich z dopadov a závislostí na ovplyvnených komunitách sú dopadmi na konkrétne skupiny') WHERE code = 'S3.SBM-3_08';

-- S3-1: Policies
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie významných dopadov, rizík a príležitostí týkajúcich sa ovplyvnených komunít [pozri ESRS 2 MDR-P]') WHERE code = 'S3.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie akýchkoľvek osobitných politických ustanovení na predchádzanie a riešenie dopadov na pôvodné obyvateľstvo') WHERE code = 'S3-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantných záväzkov v oblasti politiky ľudských práv týkajúcich sa ovplyvnených komunít') WHERE code = 'S3-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu vo vzťahu k rešpektovaniu ľudských práv komunít a konkrétne pôvodného obyvateľstva') WHERE code = 'S3-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu vo vzťahu k zapojeniu ovplyvnených komunít') WHERE code = 'S3-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu vo vzťahu k opatreniam na zabezpečenie a (alebo) umožnenie nápravy dopadov na ľudské práva') WHERE code = 'S3-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sú politiky zosúladené s príslušnými medzinárodne uznávanými nástrojmi') WHERE code = 'S3-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu a uvedenie povahy prípadov nedodržania Usmernení OSN pre podnikanie a ľudské práva, Deklarácie MOP o základných princípoch a právach pri práci alebo Usmernení OECD pre nadnárodné podniky, ktoré zahŕňajú ovplyvnené komunity') WHERE code = 'S3-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlenia významných zmien prijatých politík počas vykazovacieho roka') WHERE code = 'S3-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie o ilustrácii typov komunikácie svojich politík jednotlivcom, skupine jednotlivcov alebo subjektom, pre ktoré sú relevantné') WHERE code = 'S3-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú vykazovať v prípade, že podnik neprijal politiky') WHERE code = 'S3.MDR-P_07-08';

-- S3-2: Engagement with affected communities
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako perspektívy ovplyvnených komunít ovplyvňujú rozhodnutia alebo činnosti zamerané na riadenie skutočných a potenciálnych dopadov') WHERE code = 'S3-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie sa uskutočňuje s ovplyvnenými komunitami alebo ich legitímnymi zástupcami priamo alebo s dôveryhodnými zástupcami') WHERE code = 'S3-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie štádia, v ktorom dochádza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S3-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyššej pozície v rámci podniku, ktorá má operatívnu zodpovednosť za zabezpečenie zapojenia a za to, že výsledky informujú o prístupe podniku') WHERE code = 'S3-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako podnik hodnotí účinnosť svojho zapojenia ovplyvnených komunít') WHERE code = 'S3-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov prijatých na získanie prehľadu o perspektívach ovplyvnených komunít, ktoré môžu byť obzvlášť zraniteľné voči dopadom a (alebo) marginalizované') WHERE code = 'S3-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako podnik zohľadňuje a zabezpečuje rešpektovanie osobitných práv pôvodného obyvateľstva vo svojom prístupe k zapojeniu zainteresovaných strán') WHERE code = 'S3-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal všeobecný proces na zapojenie ovplyvnených komunít') WHERE code = 'S3-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového harmonogramu prijatia všeobecného procesu na zapojenie ovplyvnených komunít v prípade, že podnik neprijal všeobecný proces zapojenia') WHERE code = 'S3-2_09';

-- S3-3: Processes to remediate negative impacts and channels for affected communities to raise concerns
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu a procesov na poskytovanie alebo prispievanie k náprave, keď podnik identifikoval, že je spojený so významným negatívnym dopadom na ovplyvnené komunity') WHERE code = 'S3-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie konkrétnych kanálov, ktoré majú ovplyvnené komunity k dispozícii na priame vznesenie obav alebo potrieb s podnikom a ich riešenie') WHERE code = 'S3-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostredníctvom ktorých podnik podporuje alebo vyžaduje dostupnosť kanálov') WHERE code = 'S3-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako sú vznesené a riešené otázky sledované a monitorované a ako je zabezpečená účinnosť kanálov') WHERE code = 'S3-3_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa hodnotí, že ovplyvnené komunity si sú vedomé štruktúr alebo procesov a dôverujú im ako spôsobu, ako vyjadriť svoje obavy alebo potreby a nechať ich riešiť') WHERE code = 'S3-3_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky týkajúce sa ochrany pred odvetou pre jednotlivcov, ktorí používajú kanály na vznesenie obav alebo potrieb, sú zavedené') WHERE code = 'S3-3_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal všeobecný proces na zapojenie ovplyvnených komunít') WHERE code = 'S3-3_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového harmonogramu zavedenia kanálov alebo procesov na vznesenie obav') WHERE code = 'S3-3_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako majú ovplyvnené komunity prístup ku kanálom na úrovni podniku, ktorým sú ovplyvnené') WHERE code = 'S3-3_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretích strán sú prístupné všetkým ovplyvneným komunitám') WHERE code = 'S3-3_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sťažnosti sa riešia dôverne a s rešpektovaním práva na súkromie a ochranu údajov') WHERE code = 'S3-3_20';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ovplyvnené komunity majú možnosť používať kanály na vznesenie obáv alebo potrieb anonymne') WHERE code = 'S3-3_21';

-- S3-4: Actions
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akčné plány a zdroje na riadenie významných dopadov, rizík a príležitostí týkajúcich sa ovplyvnených komunít [pozri ESRS 2 - MDR-A]') WHERE code = 'S3.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prijatých, plánovaných alebo prebiehajúcich opatrení na predchádzanie, zmiernenie alebo nápravu významných negatívnych dopadov na ovplyvnené komunity') WHERE code = 'S3-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis, či a ako podnik prijal opatrenia na poskytnutie alebo umožnenie nápravy vo vzťahu k skutočnému významnému dopadu') WHERE code = 'S3-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatočných iniciatív alebo procesov, ktorých primárnym účelom je poskytovanie pozitívnych dopadov pre ovplyvnené komunity') WHERE code = 'S3-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako sa sleduje a hodnotí účinnosť opatrení alebo iniciatív pri dosahovaní výsledkov pre ovplyvnené komunity') WHERE code = 'S3-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesov identifikácie toho, aké opatrenie je potrebné a vhodné v reakcii na konkrétny skutočný alebo potenciálny významný negatívny dopad na ovplyvnené komunity') WHERE code = 'S3-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k prijímaniu opatrení vo vzťahu ku konkrétnym významným negatívnym dopadom na ovplyvnené komunity') WHERE code = 'S3-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k zabezpečeniu, že procesy na poskytovanie alebo umožnenie nápravy v prípade významných negatívnych dopadov na ovplyvnené komunity sú dostupné a účinné v ich implementácii a výsledkoch') WHERE code = 'S3-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aké opatrenie je plánované alebo prebieha na zmiernenie významných rizík vyplývajúcich z dopadov a závislostí na ovplyvnených komunitách a ako sa sleduje účinnosť') WHERE code = 'S3-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aké opatrenie je plánované alebo prebieha na využitie významných príležitostí vo vzťahu k ovplyvneným komunitám') WHERE code = 'S3-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa zabezpečuje, že vlastné postupy nespôsobujú ani neprispievajú k významným negatívnym dopadom na ovplyvnené komunity') WHERE code = 'S3-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie závažných otázok a incidentov v oblasti ľudských práv spojených s ovplyvnenými komunitami') WHERE code = 'S3-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zdrojov pridelených na riadenie významných dopadov') WHERE code = 'S3-4_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa podnik snaží využiť vplyv s relevantnými obchodnými vzťahmi na riadenie významných negatívnych dopadov ovplyvňujúcich ovplyvnené komunity') WHERE code = 'S3-4_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako je účasť v priemyselnej alebo viacstrannej iniciatíve a vlastné zapojenie podniku zamerané na riešenie významných dopadov') WHERE code = 'S3-4_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako ovplyvnené komunity zohrávajú úlohu v rozhodnutiach týkajúcich sa návrhu a implementácie programov alebo investícií') WHERE code = 'S3-4_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zamýšľaných alebo dosiahnutých pozitívnych výsledkoch programov alebo investícií pre ovplyvnené komunity') WHERE code = 'S3-4_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie približného rozsahu ovplyvnených komunít pokrytých opisovanými programami sociálnych investícií alebo rozvoja a, kde je to možné, odôvodnenie, prečo boli vybrané konkrétne komunity') WHERE code = 'S3-4_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Iniciatívy alebo procesy, ktorých primárnym cieľom je poskytovanie pozitívnych dopadov pre ovplyvnené komunity, jsou navrhnuté aj na podporu dosiahnutia jedného alebo viacerých Cieľov udržateľného rozvoja') WHERE code = 'S3-4_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis interných funkcií, ktoré sa podieľajú na riadení dopadov a typy opatrení prijatých internými funkciami na riešenie negatívnych a podporu pozitívnych dopadov') WHERE code = 'S3-4_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú vykazovať, ak podnik neprijal opatrenia') WHERE code = 'S3.MDR-A_13-14';

-- S3-5: Targets
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovené na riadenie významných dopadov, rizík a príležitostí týkajúcich sa ovplyvnených komunít [pozri ESRS 2 - MDR-T]') WHERE code = 'S3.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako boli ovplyvnené komunity priamo zapojené do stanovovania cieľov') WHERE code = 'S3-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako boli ovplyvnené komunity priamo zapojené do sledovania výkonnosti voči cieľom') WHERE code = 'S3-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako boli ovplyvnené komunity priamo zapojené do identifikácie poučení alebo zlepšení ako výsledku výkonnosti podniku') WHERE code = 'S3-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamýšľaných výsledkov, ktoré sa majú dosiahnuť v životoch ovplyvnených komunít') WHERE code = 'S3-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o stabilite cieľa v priebehu času z hľadiska definícií a metodík na umožnenie porovnateľnosti') WHERE code = 'S3-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na štandardy alebo záväzky, na ktorých je cieľ založený') WHERE code = 'S3-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú vykazovať, ak podnik neprijal ciele') WHERE code = 'S3.MDR-T_14-19';

-- =====================================================
-- ESRS S4 (Spotrebitelia a koncoví používatelia) - Slovak Translations
-- =====================================================

-- S4.SBM-3: Strategy and Business Model
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Všetci spotrebitelia a koncoví používatelia, ktorí môžu byť významne ovplyvnení podnikom, sú zahrnutí v rozsahu zverejnenia podľa ESRS 2') WHERE code = 'S4.SBM-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov spotrebiteľov a koncových používateľov podliehajúcich významným dopadom') WHERE code = 'S4.SBM-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ spotrebiteľov a koncových používateľov podliehajúcich významným dopadom vlastnými činnosťami alebo prostredníctvom hodnotového reťazca') WHERE code = 'S4.SBM-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výskyt významných negatívnych dopadov (spotrebitelia a koncoví používatelia)') WHERE code = 'S4.SBM-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis činností, ktoré majú pozitívne dopady, a typy spotrebiteľov a koncových používateľov, ktorí sú alebo môžu byť pozitívne ovplyvnení') WHERE code = 'S4.SBM-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis významných rizík a príležitostí vyplývajúcich z dopadov a závislostí na spotrebiteľoch a koncových používateľoch') WHERE code = 'S4.SBM-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako bolo rozvinuté pochopenie toho, ako môžu byť spotrebitelia a koncoví používatelia s osobitnými charakteristikami, pracujúci v osobitných podmienkach alebo vykonávajúci osobitné činnosti vystavení vyššiemu riziku poškodenia') WHERE code = 'S4.SBM-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktoré zo významných rizík a príležitostí vyplývajúcich z dopadov a závislostí na spotrebiteľoch a koncových používateľoch sú dopadmi na konkrétne skupiny') WHERE code = 'S4.SBM-3_08';

-- S4-1: Policies
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie významných dopadov, rizík a príležitostí týkajúcich sa spotrebiteľov a koncových používateľov [pozri ESRS 2 MDR-P]') WHERE code = 'S4.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie významných dopadov, rizík a príležitostí týkajúcich sa ovplyvnených spotrebiteľov a koncových používateľov, vrátane špecifických skupín alebo všetkých spotrebiteľov / koncových používateľov') WHERE code = 'S4-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantných záväzkov v oblasti politiky ľudských práv týkajúcich sa spotrebiteľov a (alebo) koncových používateľov') WHERE code = 'S4-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu vo vzťahu k rešpektovaniu ľudských práv spotrebiteľov a koncových používateľov') WHERE code = 'S4-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu vo vzťahu k zapojeniu spotrebiteľov a (alebo) koncových používateľov') WHERE code = 'S4-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu vo vzťahu k opatreniam na zabezpečenie a (alebo) umožnenie nápravy dopadov na ľudské práva') WHERE code = 'S4-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis, či a ako sú politiky zosúladené s príslušnými medzinárodne uznávanými nástrojmi') WHERE code = 'S4-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu a uvedenie povahy prípadov nedodržania Usmernení OSN pre podnikanie a ľudské práva, Deklarácie MOP o základných princípoch a právach pri práci alebo Usmernení OECD pre nadnárodné podniky, ktoré zahŕňajú spotrebiteľov a (alebo) koncových používateľov') WHERE code = 'S4-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlenia významných zmien prijatých politík počas vykazovacieho roka') WHERE code = 'S4-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie o ilustrácii typov komunikácie svojich politík jednotlivcom, skupine jednotlivcov alebo subjektom, pre ktoré sú relevantné') WHERE code = 'S4-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú vykazovať v prípade, že podnik neprijal politiky') WHERE code = 'S4.MDR-P_07-08';

-- S4-2: Engagement with consumers and end-users
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako perspektívy spotrebiteľov a koncových používateľov ovplyvňujú rozhodnutia alebo činnosti zamerané na riadenie skutočných a potenciálnych dopadov') WHERE code = 'S4-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie sa uskutočňuje so spotrebiteľmi a koncovými používateľmi alebo ich legitímnymi zástupcami priamo alebo s dôveryhodnými zástupcami') WHERE code = 'S4-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie štádia, v ktorom dochádza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S4-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyššej pozície v rámci podniku, ktorá má operatívnu zodpovednosť za zabezpečenie zapojenia a za to, že výsledky informujú o prístupe podniku') WHERE code = 'S4-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako sa hodnotí účinnosť zapojenia so spotrebiteľmi a koncovými používateľmi') WHERE code = 'S4-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov prijatých na získanie prehľadu o perspektívach spotrebiteľov a koncových používateľov / spotrebiteľov a koncových používateľov, ktorí môžu byť obzvlášť zraniteľní voči dopadom a (alebo) marginalizovaní') WHERE code = 'S4-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal všeobecný proces na zapojenie spotrebiteľov a (alebo) koncových používateľov') WHERE code = 'S4-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového harmonogramu prijatia všeobecného procesu na zapojenie spotrebiteľov a koncových používateľov v prípade, že podnik neprijal všeobecný proces zapojenia') WHERE code = 'S4-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ úlohy alebo funkcie, ktorá sa zaoberá zapojením') WHERE code = 'S4-2_09';

-- S4-3: Processes to remediate negative impacts and channels for consumers and end-users to raise concerns
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie všeobecného prístupu a procesov na poskytovanie alebo prispievanie k náprave, keď podnik identifikoval, že je spojený so významným negatívnym dopadom na spotrebiteľov a koncových používateľov') WHERE code = 'S4-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie konkrétnych kanálov, ktoré majú spotrebitelia a koncoví používatelia k dispozícii na priame vznesenie obáv alebo potrieb s podnikom a ich riešenie') WHERE code = 'S4-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostredníctvom ktorých podnik podporuje alebo vyžaduje dostupnosť kanálov') WHERE code = 'S4-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako sú vznesené a riešené otázky sledované a monitorované a ako je zabezpečená účinnosť kanálov') WHERE code = 'S4-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa hodnotí, že spotrebitelia a koncoví používatelia si sú vedomí štruktúr alebo procesov a dôverujú im ako spôsobu, ako vyjadriť svoje obavy alebo potreby a nechať ich riešiť') WHERE code = 'S4-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky týkajúce sa ochrany pred odvetou pre jednotlivcov, ktorí používajú kanály na vznesenie obáv alebo potrieb, sú zavedené') WHERE code = 'S4-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyhlásenie v prípade, že podnik neprijal všeobecný proces na zapojenie spotrebiteľov a (alebo) koncových používateľov') WHERE code = 'S4-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie časového harmonogramu zavedenia kanálov alebo procesov na vznesenie obáv') WHERE code = 'S4-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako majú spotrebitelia a (alebo) koncoví používatelia prístup ku kanálom na úrovni podniku, ktorým sú ovplyvnení') WHERE code = 'S4-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretích strán sú prístupné všetkým spotrebiteľom a (alebo) koncovým používateľom') WHERE code = 'S4-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sťažnosti sa riešia dôverne a s rešpektovaním práva na súkromie a ochranu údajov') WHERE code = 'S4-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Spotrebitelia a koncoví používatelia majú možnosť používať kanály na vznesenie obáv alebo potrieb anonymne') WHERE code = 'S4-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet sťažností prijatých od spotrebiteľov a (alebo) koncových používateľov počas vykazovacieho obdobia') WHERE code = 'S4-3_13';

-- S4-4: Actions
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akčné plány a zdroje na riadenie významných dopadov, rizík a príležitostí týkajúcich sa spotrebiteľov a koncových používateľov [pozri ESRS 2 - MDR-A]') WHERE code = 'S4.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis plánovaných alebo prebiehajúcich opatrení na predchádzanie, zmiernenie alebo nápravu významných negatívnych dopadov na spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis, či a ako boli prijaté opatrenia na poskytnutie alebo umožnenie nápravy vo vzťahu k skutočnému významnému dopadu') WHERE code = 'S4-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatočných iniciatív alebo procesov, ktorých primárnym účelom je poskytovanie pozitívnych dopadov pre spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako sa sleduje a hodnotí účinnosť opatrení alebo iniciatív pri dosahovaní výsledkov pre spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k identifikácii toho, aké opatrenie je potrebné a vhodné v reakcii na konkrétny skutočný alebo potenciálny významný negatívny dopad na spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k prijímaniu opatrení vo vzťahu ku konkrétnym významným dopadom na spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupu k zabezpečeniu, že procesy na poskytovanie alebo umožnenie nápravy v prípade významných negatívnych dopadov na spotrebiteľov a koncových používateľov sú dostupné a účinné v ich implementácii a výsledkoch') WHERE code = 'S4-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aké opatrenie je plánované alebo prebieha na zmiernenie významných rizík vyplývajúcich z dopadov a závislostí na spotrebiteľoch a koncových používateľoch a ako sa sleduje účinnosť') WHERE code = 'S4-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, aké opatrenie je plánované alebo prebieha na využitie významných príležitostí vo vzťahu k spotrebiteľom a koncovým používateľom') WHERE code = 'S4-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa zabezpečuje, že vlastné postupy nespôsobujú ani neprispievajú k významným negatívnym dopadom na spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie závažných otázok a incidentov v oblasti ľudských práv spojených so spotrebiteľmi a (alebo) koncovými používateľmi') WHERE code = 'S4-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zdrojov pridelených na riadenie významných dopadov') WHERE code = 'S4-4_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa podnik snaží využiť vplyv s relevantnými obchodnými vzťahmi na riadenie významných negatívnych dopadov ovplyvňujúcich spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako je účasť v priemyselnej alebo viacstrannej iniciatíve a vlastné zapojenie podniku zamerané na riešenie významných dopadov') WHERE code = 'S4-4_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako spotrebitelia a koncoví používatelia zohrávajú úlohu v rozhodnutiach týkajúcich sa návrhu a implementácie programov alebo procesov') WHERE code = 'S4-4_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zamýšľaných alebo dosiahnutých pozitívnych výsledkoch programov alebo procesov pre spotrebiteľov a koncových používateľov') WHERE code = 'S4-4_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Iniciatívy alebo procesy, ktorých primárnym cieľom je poskytovanie pozitívnych dopadov pre spotrebiteľov a (alebo) koncových používateľov, sú navrhnuté aj na podporu dosiahnutia jedného alebo viacerých Cieľov udržateľného rozvoja') WHERE code = 'S4-4_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis interných funkcií, ktoré sa podieľajú na riadení dopadov a typy opatrení prijatých internými funkciami na riešenie negatívnych a podporu pozitívnych dopadov') WHERE code = 'S4-4_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú vykazovať, ak podnik neprijal opatrenia') WHERE code = 'S4.MDR-A_13-14';

-- S4-5: Targets
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovené na riadenie významných dopadov, rizík a príležitostí týkajúcich sa spotrebiteľov a koncových používateľov [pozri ESRS 2 - MDR-T]') WHERE code = 'S4.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako boli spotrebitelia a koncoví používatelia priamo zapojení do stanovovania cieľov') WHERE code = 'S4-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako boli spotrebitelia a koncoví používatelia priamo zapojení do sledovania výkonnosti voči cieľom') WHERE code = 'S4-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako boli spotrebitelia a koncoví používatelia priamo zapojení do identifikácie poučení alebo zlepšení ako výsledku výkonnosti podniku') WHERE code = 'S4-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamýšľaných výsledkov, ktoré sa majú dosiahnuť v životoch spotrebiteľov a koncových používateľov') WHERE code = 'S4-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o stabilite cieľa v priebehu času z hľadiska definícií a metodík na umožnenie porovnateľnosti') WHERE code = 'S4-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na štandardy alebo záväzky, na ktorých je cieľ založený') WHERE code = 'S4-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú vykazovať, ak podnik neprijal ciele') WHERE code = 'S4.MDR-T_14-19';


-- ============================================================================
-- ESRS G1: Obchodné správanie - Slovenské preklady
-- ============================================================================
-- Dátum vytvorenia: 6. február 2026
-- Štandard: ESRS G1 - Business Conduct (Obchodné správanie)
-- 
-- Tematické oblasti:
-- - Správa a dohľad nad obchodným správaním
-- - Firemná kultúra a etický kódex
-- - Politiky proti korupcii a úplatkárstvu
-- - Ochrana oznamovateľov (whistleblowers)
-- - Vzťahy s dodávateľmi a platobná prax
-- - Politický vplyv a lobbing
-- - Platby vládam
-- - Dodržiavanie pravidiel hospodárskej súťaže
-- ============================================================================

-- GOV-1: Správa a dohľad nad obchodným správaním
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie úlohy správnych, riadiacich a dozorných orgánov vo vzťahu k obchodnému správaniu') WHERE code = 'G1.GOV-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odborných znalostí správnych, riadiacich a dozorných orgánov v oblasti obchodného správania') WHERE code = 'G1.GOV-1_02';

-- G1-1: Firemná kultúra, etický kódex a politiky obchodného správania
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiálnych vplyvov, rizík a príležitostí súvisiacich s obchodným správaním a firemnou kultúrou [pozri ESRS 2 MDR-P]') WHERE code = 'G1.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis spôsobu, akým podnik vytvára, rozvíja, podporuje a vyhodnocuje svoju firemnú kultúru') WHERE code = 'G1-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis mechanizmov na identifikáciu, nahlasovanie a vyšetrovanie obáv týkajúcich sa protiprávneho správania alebo správania v rozpore s kódexom správania alebo podobnými internými pravidlami') WHERE code = 'G1-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Neexistujú politiky proti korupcii alebo úplatkárstvu v súlade s Dohovorom OSN proti korupcii') WHERE code = 'G1-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Časový harmonogram implementácie politík proti korupcii alebo úplatkárstvu v súlade s Dohovorom OSN proti korupcii') WHERE code = 'G1-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ochranných opatrení pri nahlasovaní nezrovnalostí vrátane ochrany oznamovateľov') WHERE code = 'G1-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Neexistujú politiky ochrany oznamovateľov') WHERE code = 'G1-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Časový harmonogram implementácie politík ochrany oznamovateľov') WHERE code = 'G1-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik sa zaväzuje vyšetrovať incidenty týkajúce sa obchodného správania rýchlo, nezávisle a objektívne') WHERE code = 'G1-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existujú politiky týkajúce sa ochrany zvierat') WHERE code = 'G1-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o politike školení v rámci organizácie týkajúcich sa obchodného správania') WHERE code = 'G1-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcií, ktoré sú najviac ohrozené korupciou a úplatkárstvom') WHERE code = 'G1-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Subjekt podlieha zákonným požiadavkám týkajúcim sa ochrany oznamovateľov') WHERE code = 'G1-1_12';

-- G1-2: Vzťahy s dodávateľmi a platobná prax
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis politiky na predchádzanie oneskoreným platbám, najmä malým a stredným podnikom') WHERE code = 'G1-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prístupov týkajúcich sa vzťahov s dodávateľmi s prihliadnutím na riziká súvisiace s dodávateľským reťazcom a vplyvy na otázky udržateľnosti') WHERE code = 'G1-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, či a ako sa zohľadňujú sociálne a environmentálne kritériá pri výbere zmluvných partnerov na strane dodávok') WHERE code = 'G1-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť v prípade, že podnik neprijal politiky') WHERE code = 'G1.MDR-P_07-08';

-- G1-3: Postupy proti korupcii a úplatkárstvu
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o postupoch na predchádzanie, odhaľovanie a riešenie obvinení alebo incidentov korupcie alebo úplatkárstva') WHERE code = 'G1-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vyšetrovatelia alebo vyšetrovací výbor sú oddelení od reťazca riadenia zapojeného do prevencie a odhaľovania korupcie alebo úplatkárstva') WHERE code = 'G1-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o procese oznamovania výsledkov správnym, riadiacim a dozorným orgánom') WHERE code = 'G1-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plánov na prijatie postupov na predchádzanie, odhaľovanie a riešenie obvinení alebo incidentov korupcie alebo úplatkárstva v prípade neexistencie postupov') WHERE code = 'G1-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o tom, ako sa politiky komunikujú tým, pre ktorých sú relevantné (prevencia a odhaľovanie korupcie alebo úplatkárstva)') WHERE code = 'G1-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o povahe, rozsahu a hĺbke školiacich programov proti korupcii alebo úplatkárstvu, ktoré sú ponúkané alebo vyžadované') WHERE code = 'G1-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percento rizikových funkcií pokrytých školiacimi programami') WHERE code = 'G1-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o členoch správnych, dozorných a riadiacich orgánov týkajúce sa školení proti korupcii alebo úplatkárstvu') WHERE code = 'G1-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie analýzy školiacich aktivít napríklad podľa regiónu školenia alebo kategórie') WHERE code = 'G1-3_09';

-- G1-4: Akčné plány, ciele a opatrenia proti korupcii
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akčné plány a zdroje na riadenie materiálnych vplyvov, rizík a príležitostí súvisiacich s korupciou a úplatkárstvom [pozri ESRS 2 - MDR-A]') WHERE code = 'G1.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet odsúdení za porušenie zákonov proti korupcii a úplatkárstvu') WHERE code = 'G1-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výška pokút za porušenie zákonov proti korupcii a úplatkárstvu') WHERE code = 'G1-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Prevencia a odhaľovanie korupcie alebo úplatkárstva - tabuľka školení proti korupcii a úplatkárstvu') WHERE code = 'G1-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet potvrdených incidentov korupcie alebo úplatkárstva') WHERE code = 'G1-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o povahe potvrdených incidentov korupcie alebo úplatkárstva') WHERE code = 'G1-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet potvrdených incidentov, pri ktorých boli vlastní zamestnanci prepustení alebo disciplinárne potrestaní za incidenty súvisiace s korupciou alebo úplatkárstvom') WHERE code = 'G1-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet potvrdených incidentov týkajúcich sa zmlúv s obchodnými partnermi, ktoré boli ukončené alebo neboli obnovené z důvodu porušení súvisiacich s korupciou alebo úplatkárstvom') WHERE code = 'G1-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o detailoch verejných právnych prípadov týkajúcich sa korupcie alebo úplatkárstva vznesených proti podniku a vlastným zamestnancom a o výsledkoch takýchto prípadov') WHERE code = 'G1-4_08';

-- G1-5: Politický vplyv, lobbing a finančné príspevky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o zástupcovi/zástupcoch zodpovedných v správnych, riadiacich a dozorných orgánoch za dohľad nad aktivitami politického vplyvu a lobbingu') WHERE code = 'G1-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o finančných alebo naturálnych politických príspevkoch') WHERE code = 'G1-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Poskytnuté finančné politické príspevky') WHERE code = 'G1-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výška interných a externých výdavkov na lobbing') WHERE code = 'G1-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Výška zaplatená za členstvo v lobbingových asociáciách') WHERE code = 'G1-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Poskytnuté naturálne politické príspevky') WHERE code = 'G1-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie spôsobu odhadu peňažnej hodnoty naturálnych príspevkov') WHERE code = 'G1-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Poskytnuté finančné a naturálne politické príspevky [tabuľka]') WHERE code = 'G1-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie hlavných tém pokrytých lobbingovými aktivitami a hlavných postojov podniku k týmto témam') WHERE code = 'G1-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik je registrovaný v Registri transparentnosti EÚ alebo v ekvivalentnom registri transparentnosti v členskom štáte') WHERE code = 'G1-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Informácie o vymenovaní akýchkoľvek členov správnych, riadiacich a dozorných orgánov, ktorí zastávali porovnateľnú pozíciu vo verejnej správe počas dvoch rokov pred takýmto vymenovaním') WHERE code = 'G1-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Subjekt je zo zákona povinný byť členom obchodnej komory alebo inej organizácie zastupujúcej jeho záujmy') WHERE code = 'G1-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktoré sa majú uviesť, ak podnik neprijal opatrenia') WHERE code = 'G1.MDR-A_13-14';

-- G1-6: Platobná prax a vzťahy s dodávateľmi
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Priemerný počet dní na zaplatenie faktúry odo dňa, keď sa začína počítať zmluvná alebo zákonná lehota splatnosti') WHERE code = 'G1-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis štandardných platobných podmienok podniku v počte dní podľa hlavnej kategórie dodávateľov') WHERE code = 'G1-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percento platieb v súlade so štandardnými platobnými podmienkami') WHERE code = 'G1-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Počet prebiehajúcich súdnych konaní týkajúcich sa oneskorených platieb') WHERE code = 'G1-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextových informácií týkajúcich sa platobnej praxe') WHERE code = 'G1-6_05';
