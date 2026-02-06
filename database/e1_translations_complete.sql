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
