-- Complete Slovak translations for ESRS E1 Climate Change datapoints
-- ESG Terminology used: Emisie sklenĂ­kovĂ˝ch plynov (GHG), DekarbonizĂˇcia, Prechod na klimatickĂş neutralitu, etc.

-- GOV-3: Governance
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako sa klimatickĂ© aspekty zohÄľadĹujĂş v odmeĹovanĂ­ ÄŤlenov administratĂ­vnych, riadiacich a dozornĂ˝ch orgĂˇnov')
WHERE code = 'E1.GOV-3_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel odmeĹovania viazanĂ˝ na klimatickĂ© aspekty')
WHERE code = 'E1.GOV-3_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie klimatickĂ˝ch aspektov zohÄľadnenĂ˝ch v odmeĹovanĂ­ ÄŤlenov administratĂ­vnych, riadiacich a dozornĂ˝ch orgĂˇnov')
WHERE code = 'E1.GOV-3_03';

-- E1-1: Transition Plan
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plĂˇnu prechodu na zmierĹovanie zmeny klĂ­my')
WHERE code = 'E1-1_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sĂş ciele zluÄŤiteÄľnĂ© s obmedzenĂ­m globĂˇlneho otepÄľovania na jeden a pol stupĹa Celzia v sĂşlade s ParĂ­Ĺľskou dohodou')
WHERE code = 'E1-1_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dekarbonizaÄŤnĂ˝ch pĂˇk a kÄľĂşÄŤovĂ˝ch akciĂ­')
WHERE code = 'E1-1_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĂ˝znamnĂ˝ch prevĂˇdzkovĂ˝ch vĂ˝davkov (OpEx) a/alebo kapitĂˇlovĂ˝ch vĂ˝davkov (CapEx) potrebnĂ˝ch na realizĂˇciu akÄŤnĂ©ho plĂˇnu')
WHERE code = 'E1-1_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'FinanÄŤnĂ© zdroje alokovanĂ© na akÄŤnĂ˝ plĂˇn (OpEx)')
WHERE code = 'E1-1_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'FinanÄŤnĂ© zdroje alokovanĂ© na akÄŤnĂ˝ plĂˇn (CapEx)')
WHERE code = 'E1-1_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie potenciĂˇlnych uzamknutĂ˝ch emisiĂ­ sklenĂ­kovĂ˝ch plynov z kÄľĂşÄŤovĂ˝ch aktĂ­v a produktov a toho, ako mĂ´Ĺľu uzamknutĂ© emisie ohroziĹĄ dosiahnutie cieÄľov znĂ­Ĺľenia emisiĂ­ a zvĂ˝ĹˇiĹĄ tranzitnĂ© riziko')
WHERE code = 'E1-1_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie akĂ˝chkoÄľvek cieÄľov alebo plĂˇnov (CapEx, CapEx plĂˇny, OpEx) na zosĂşladenie ekonomickĂ˝ch ÄŤinnostĂ­ (vĂ˝nosy, CapEx, OpEx) s kritĂ©riami ustanovenĂ˝mi v delegovanom nariadenĂ­ Komisie 2021/2139')
WHERE code = 'E1-1_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'VĂ˝znamnĂ© kapitĂˇlovĂ© vĂ˝davky na ekonomickĂ© ÄŤinnosti sĂşvisiace s uhlĂ­m')
WHERE code = 'E1-1_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'VĂ˝znamnĂ© kapitĂˇlovĂ© vĂ˝davky na ekonomickĂ© ÄŤinnosti sĂşvisiace s ropou')
WHERE code = 'E1-1_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'VĂ˝znamnĂ© kapitĂˇlovĂ© vĂ˝davky na ekonomickĂ© ÄŤinnosti sĂşvisiace s plynom')
WHERE code = 'E1-1_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Podnik je vylĂşÄŤenĂ˝ z referenÄŤnĂ˝ch hodnĂ´t EĂš zosĂşladenĂ˝ch s ParĂ­Ĺľskou dohodou')
WHERE code = 'E1-1_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako je plĂˇn prechodu zakotvenĂ˝ a zosĂşladenĂ˝ s celkovou obchodnou stratĂ©giou a finanÄŤnĂ˝m plĂˇnovanĂ­m')
WHERE code = 'E1-1_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PlĂˇn prechodu je schvĂˇlenĂ˝ administratĂ­vnymi, riadiacimi a dozornĂ˝mi orgĂˇnmi')
WHERE code = 'E1-1_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie pokroku pri implementĂˇcii plĂˇnu prechodu')
WHERE code = 'E1-1_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'DĂˇtum prijatia plĂˇnu prechodu pre podniky, ktorĂ© ho eĹˇte neprijali')
WHERE code = 'E1-1_16';

-- E1.SBM-3: Material risks and opportunities
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ klimatickĂ©ho rizika')
WHERE code = 'E1.SBM-3_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis rozsahu analĂ˝zy odolnosti')
WHERE code = 'E1.SBM-3_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako bola vykonanĂˇ analĂ˝za odolnosti')
WHERE code = 'E1.SBM-3_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'DĂˇtum vykonania analĂ˝zy odolnosti')
WHERE code = 'E1.SBM-3_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚasovĂ© horizonty aplikovanĂ© pri analĂ˝ze odolnosti')
WHERE code = 'E1.SBM-3_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis vĂ˝sledkov analĂ˝zy odolnosti')
WHERE code = 'E1.SBM-3_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis schopnosti upraviĹĄ alebo prispĂ´sobiĹĄ stratĂ©giu a obchodnĂ˝ model zmene klĂ­my')
WHERE code = 'E1.SBM-3_07';

-- E1.IRO-1: Description of processes to identify and assess material impacts, risks and opportunities
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis procesu vo vzĹĄahu k dopadom na zmenu klĂ­my')
WHERE code = 'E1.IRO-1_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis procesu vo vzĹĄahu ku klimatickĂ˝m fyzickĂ˝m rizikĂˇm vo vlastnĂ˝ch operĂˇciĂˇch a naprieÄŤ hodnotovĂ˝m reĹĄazcom')
WHERE code = 'E1.IRO-1_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'KlimatickĂ© hrozby boli identifikovanĂ© v krĂˇtkodobom, strednodobom a dlhodobom ÄŤasovom horizonte')
WHERE code = 'E1.IRO-1_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Podnik preveril, ÄŤi aktĂ­va a obchodnĂ© ÄŤinnosti mĂ´Ĺľu byĹĄ vystavenĂ© klimatickĂ˝m hrozbĂˇm')
WHERE code = 'E1.IRO-1_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'KrĂˇtkodobĂ©, strednodobĂ© a dlhodobĂ© ÄŤasovĂ© horizonty boli definovanĂ©')
WHERE code = 'E1.IRO-1_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rozsah, v akom mĂ´Ĺľu byĹĄ aktĂ­va a obchodnĂ© ÄŤinnosti vystavenĂ© a sĂş citlivĂ© na identifikovanĂ© klimatickĂ© hrozby, bol posĂşdenĂ˝')
WHERE code = 'E1.IRO-1_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IdentifikĂˇcia klimatickĂ˝ch hrozieb a posĂşdenie expozĂ­cie a citlivosti sĂş informovanĂ© scenĂˇrmi vysokĂ˝ch emisiĂ­')
WHERE code = 'E1.IRO-1_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako bola analĂ˝za klimatickĂ˝ch scenĂˇrov pouĹľitĂˇ na informovanie identifikĂˇcie a posĂşdenia fyzickĂ˝ch rizĂ­k v krĂˇtkodobom, strednodobom a dlhodobom horizonte')
WHERE code = 'E1.IRO-1_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis procesu vo vzĹĄahu ku klimatickĂ˝m tranzitnĂ˝m rizikĂˇm a prĂ­leĹľitostiam vo vlastnĂ˝ch operĂˇciĂˇch a naprieÄŤ hodnotovĂ˝m reĹĄazcom')
WHERE code = 'E1.IRO-1_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'TranzitnĂ© udalosti boli identifikovanĂ© v krĂˇtkodobom, strednodobom a dlhodobom ÄŤasovom horizonte')
WHERE code = 'E1.IRO-1_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Podnik preveril, ÄŤi aktĂ­va a obchodnĂ© ÄŤinnosti mĂ´Ĺľu byĹĄ vystavenĂ© tranzitnĂ˝m udalostiam')
WHERE code = 'E1.IRO-1_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rozsah, v akom mĂ´Ĺľu byĹĄ aktĂ­va a obchodnĂ© ÄŤinnosti vystavenĂ© a sĂş citlivĂ© na identifikovanĂ© tranzitnĂ© udalosti, bol posĂşdenĂ˝')
WHERE code = 'E1.IRO-1_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IdentifikĂˇcia tranzitnĂ˝ch udalostĂ­ a posĂşdenie expozĂ­cie boli informovanĂ© analĂ˝zou klimatickĂ˝ch scenĂˇrov')
WHERE code = 'E1.IRO-1_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AktĂ­va a obchodnĂ© ÄŤinnosti nekompatibilnĂ© alebo vyĹľadujĂşce vĂ˝znamnĂ© Ăşsilie na kompatibilitu s prechodom na klimaticky neutrĂˇlnu ekonomiku boli identifikovanĂ©')
WHERE code = 'E1.IRO-1_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako bola analĂ˝za klimatickĂ˝ch scenĂˇrov pouĹľitĂˇ na informovanie identifikĂˇcie a posĂşdenia tranzitnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ v krĂˇtkodobom, strednodobom a dlhodobom horizonte')
WHERE code = 'E1.IRO-1_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sĂş pouĹľitĂ© klimatickĂ© scenĂˇre kompatibilnĂ© s kritickĂ˝mi klimatickĂ˝mi predpokladmi pouĹľitĂ˝mi vo finanÄŤnĂ˝ch vĂ˝kazoch')
WHERE code = 'E1.IRO-1_16';

-- E1-2: Policies
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich so zmenou klĂ­my [pozri ESRS 2 MDR-P]')
WHERE code = 'E1.MDR-P_01-06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OtĂˇzky udrĹľateÄľnosti rieĹˇenĂ© politikou pre zmenu klĂ­my')
WHERE code = 'E1-2_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ v prĂ­pade, Ĺľe podnik neprijal politiky')
WHERE code = 'E1.MDR-P_07-08';

-- E1-3: Actions and Resources
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje sĂşvisiace so zmierĹovanĂ­m a adaptĂˇciou na zmenu klĂ­my [pozri ESRS 2 MDR-A]')
WHERE code = 'E1.MDR-A_01-12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ dekarbonizaÄŤnej pĂˇky')
WHERE code = 'E1-3_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ adaptaÄŤnĂ©ho rieĹˇenia')
WHERE code = 'E1-3_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'DosiahnutĂ© znĂ­Ĺľenie emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-3_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OÄŤakĂˇvanĂ© znĂ­Ĺľenie emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-3_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie rozsahu, v akom zĂˇvisĂ­ schopnosĹĄ implementovaĹĄ akciu od dostupnosti a alokĂˇcie zdrojov')
WHERE code = 'E1-3_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzĹĄahu vĂ˝znamnĂ˝ch kapitĂˇlovĂ˝ch a prevĂˇdzkovĂ˝ch vĂ˝davkov potrebnĂ˝ch na implementĂˇciu akciĂ­ k relevantnĂ˝m poloĹľkĂˇm alebo poznĂˇmkam vo finanÄŤnĂ˝ch vĂ˝kazoch')
WHERE code = 'E1-3_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzĹĄahu vĂ˝znamnĂ˝ch kapitĂˇlovĂ˝ch a prevĂˇdzkovĂ˝ch vĂ˝davkov potrebnĂ˝ch na implementĂˇciu akciĂ­ ku kÄľĂşÄŤovĂ˝m ukazovateÄľom vĂ˝konnosti podÄľa delegovanĂ©ho nariadenia (EĂš) 2021/2178')
WHERE code = 'E1-3_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzĹĄahu vĂ˝znamnĂ˝ch kapitĂˇlovĂ˝ch a prevĂˇdzkovĂ˝ch vĂ˝davkov potrebnĂ˝ch na implementĂˇciu akciĂ­ k plĂˇnu kapitĂˇlovĂ˝ch vĂ˝davkov podÄľa delegovanĂ©ho nariadenia (EĂš) 2021/2178')
WHERE code = 'E1-3_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktorĂ© sa mĂˇ uviesĹĄ, ak podnik neprijal akcie')
WHERE code = 'E1.MDR-A_13-14';

-- E1-4: Targets
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektĂ­vnosti politĂ­k a akciĂ­ prostrednĂ­ctvom cieÄľov [pozri ESRS 2 MDR-T]')
WHERE code = 'E1.MDR-T_01-13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako boli stanovenĂ© ciele znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov a/alebo inĂ© ciele na riadenie materiĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s klĂ­mou')
WHERE code = 'E1-4_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'TabuÄľky: ViacerĂ© dimenzie (bĂˇzickĂ˝ rok a ciele; typy sklenĂ­kovĂ˝ch plynov, kategĂłrie Rozsah 3, dekarbonizaÄŤnĂ© pĂˇky, ĹˇpecifickĂ© pre subjekt menovatele pre intenzitnĂ© hodnoty)')
WHERE code = 'E1-4_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AbsolĂştna hodnota celkovĂ©ho znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-4_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlne znĂ­Ĺľenie celkovĂ˝ch emisiĂ­ sklenĂ­kovĂ˝ch plynov (k emisiĂˇm bĂˇzickĂ©ho roku)')
WHERE code = 'E1-4_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IntenzitnĂˇ hodnota celkovĂ©ho znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-4_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AbsolĂştna hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 1')
WHERE code = 'E1-4_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlne znĂ­Ĺľenie emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 1 (k emisiĂˇm bĂˇzickĂ©ho roku)')
WHERE code = 'E1-4_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IntenzitnĂˇ hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 1')
WHERE code = 'E1-4_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AbsolĂştna hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade lokality')
WHERE code = 'E1-4_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlne znĂ­Ĺľenie emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade lokality (k emisiĂˇm bĂˇzickĂ©ho roku)')
WHERE code = 'E1-4_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IntenzitnĂˇ hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade lokality')
WHERE code = 'E1-4_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AbsolĂştna hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade trhu')
WHERE code = 'E1-4_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlne znĂ­Ĺľenie emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade trhu (k emisiĂˇm bĂˇzickĂ©ho roku)')
WHERE code = 'E1-4_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IntenzitnĂˇ hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade trhu')
WHERE code = 'E1-4_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AbsolĂştna hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 3')
WHERE code = 'E1-4_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlne znĂ­Ĺľenie emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 3 (k emisiĂˇm bĂˇzickĂ©ho roku)')
WHERE code = 'E1-4_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'IntenzitnĂˇ hodnota znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 3')
WHERE code = 'E1-4_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako bola zabezpeÄŤenĂˇ konzistencia cieÄľov znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov s hranicami inventĂˇra sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-4_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie doterajĹˇieho pokroku pri plnenĂ­ cieÄľa pred aktuĂˇlnym bĂˇzickĂ˝m rokom')
WHERE code = 'E1-4_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako bolo zabezpeÄŤenĂ©, Ĺľe bĂˇzickĂˇ hodnota je reprezentatĂ­vna z hÄľadiska pokrytĂ˝ch ÄŤinnostĂ­ a vplyvov externĂ˝ch faktorov')
WHERE code = 'E1-4_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako novĂˇ bĂˇzickĂˇ hodnota ovplyvĹuje novĂ˝ cieÄľ, jeho dosiahnutie a prezentĂˇciu pokroku v ÄŤase')
WHERE code = 'E1-4_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CieÄľ znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov je zaloĹľenĂ˝ na vede a kompatibilnĂ˝ s obmedzenĂ­m globĂˇlneho otepÄľovania na jeden a pol stupĹa Celzia')
WHERE code = 'E1-4_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis oÄŤakĂˇvanĂ˝ch dekarbonizaÄŤnĂ˝ch pĂˇk a ich celkovĂ˝ch kvantitatĂ­vnych prĂ­spevkov k dosiahnutiu cieÄľa znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-4_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'RĂ´zne klimatickĂ© scenĂˇre boli zvĂˇĹľenĂ© na odhalenie relevantnĂ˝ch environmentĂˇlnych, spoloÄŤenskĂ˝ch, technologickĂ˝ch, trhovĂ˝ch a politickĂ˝ch vĂ˝voja a stanovenie dekarbonizaÄŤnĂ˝ch pĂˇk')
WHERE code = 'E1-4_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktorĂ© sa mĂˇ uviesĹĄ, ak podnik nestanovil Ĺľiadne merateÄľnĂ© ciele orientovanĂ© na vĂ˝sledky')
WHERE code = 'E1.MDR-T_14-19';

-- E1-5: Energy consumption and mix
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba energie sĂşvisiaca s vlastnĂ˝mi operĂˇciami')
WHERE code = 'E1-5_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba energie z fosĂ­lnych zdrojov')
WHERE code = 'E1-5_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba energie z jadrovĂ˝ch zdrojov')
WHERE code = 'E1-5_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel spotreby energie z jadrovĂ˝ch zdrojov na celkovej spotrebe energie')
WHERE code = 'E1-5_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba energie z obnoviteÄľnĂ˝ch zdrojov')
WHERE code = 'E1-5_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z obnoviteÄľnĂ˝ch zdrojov')
WHERE code = 'E1-5_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba zakĂşpenej alebo zĂ­skanej elektriny, tepla, pary a chladenia z obnoviteÄľnĂ˝ch zdrojov')
WHERE code = 'E1-5_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba samovytvorenej nepalivovej obnoviteÄľnej energie')
WHERE code = 'E1-5_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel obnoviteÄľnĂ˝ch zdrojov na celkovej spotrebe energie')
WHERE code = 'E1-5_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z uhlia a uhoÄľnĂ˝ch produktov')
WHERE code = 'E1-5_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z ropy a ropnĂ˝ch produktov')
WHERE code = 'E1-5_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva zo zemnĂ©ho plynu')
WHERE code = 'E1-5_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba paliva z inĂ˝ch fosĂ­lnych zdrojov')
WHERE code = 'E1-5_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Spotreba zakĂşpenej alebo zĂ­skanej elektriny, tepla, pary alebo chladenia z fosĂ­lnych zdrojov')
WHERE code = 'E1-5_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel fosĂ­lnych zdrojov na celkovej spotrebe energie')
WHERE code = 'E1-5_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'VĂ˝roba neobnoviteÄľnej energie')
WHERE code = 'E1-5_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'VĂ˝roba obnoviteÄľnej energie')
WHERE code = 'E1-5_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'EnergetickĂˇ intenzita z ÄŤinnostĂ­ v sektoroch s vysokĂ˝m klimatickĂ˝m dopadom (celkovĂˇ spotreba energie na ÄŤistĂ© vĂ˝nosy)')
WHERE code = 'E1-5_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba energie z ÄŤinnostĂ­ v sektoroch s vysokĂ˝m klimatickĂ˝m dopadom')
WHERE code = 'E1-5_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Sektory s vysokĂ˝m klimatickĂ˝m dopadom pouĹľitĂ© na urÄŤenie energetickej intenzity')
WHERE code = 'E1-5_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosĂşladenia s relevantnĂ˝mi poloĹľkami alebo poznĂˇmkami vo finanÄŤnĂ˝ch vĂ˝kazoch ÄŤistĂ˝ch vĂ˝nosov z ÄŤinnostĂ­ v sektoroch s vysokĂ˝m klimatickĂ˝m dopadom')
WHERE code = 'E1-5_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy z ÄŤinnostĂ­ v sektoroch s vysokĂ˝m klimatickĂ˝m dopadom')
WHERE code = 'E1-5_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy z ÄŤinnostĂ­ inĂ˝ch ako v sektoroch s vysokĂ˝m klimatickĂ˝m dopadom')
WHERE code = 'E1-5_23';

-- E1-6: Gross Scopes 1, 2, 3 and Total GHG emissions
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 1, 2, 3 a celkovĂ© emisie - emisie sklenĂ­kovĂ˝ch plynov podÄľa rozsahu [tabuÄľka]')
WHERE code = 'E1-6_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 1, 2, 3 a celkovĂ© emisie - finanÄŤnĂˇ a operaÄŤnĂˇ kontrola [tabuÄľka]')
WHERE code = 'E1-6_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Rozdelenie emisiĂ­ sklenĂ­kovĂ˝ch plynov - podÄľa krajiny, prevĂˇdzkovĂ˝ch segmentov, ekonomickej ÄŤinnosti, dcĂ©rskej spoloÄŤnosti, kategĂłrie sklenĂ­kovĂ˝ch plynov alebo typu zdroja')
WHERE code = 'E1-6_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 1, 2, 3 a celkovĂ© emisie - emisie Rozsah 3 (GHG Protocol) [tabuÄľka]')
WHERE code = 'E1-6_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 1, 2, 3 a celkovĂ© emisie - emisie Rozsah 3 (ISO 14064-1) [tabuÄľka]')
WHERE code = 'E1-6_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 1, 2, 3 a celkovĂ© emisie - celkovĂ© emisie sklenĂ­kovĂ˝ch plynov - hodnotovĂ˝ reĹĄazec [tabuÄľka]')
WHERE code = 'E1-6_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 1')
WHERE code = 'E1-6_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel emisiĂ­ sklenĂ­kovĂ˝ch plynov Rozsah 1 z regulovanĂ˝ch systĂ©mov obchodovania s emisiami')
WHERE code = 'E1-6_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade lokality')
WHERE code = 'E1-6_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 2 na zĂˇklade trhu')
WHERE code = 'E1-6_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'HrubĂ© emisie sklenĂ­kovĂ˝ch plynov Rozsah 3')
WHERE code = 'E1-6_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© emisie sklenĂ­kovĂ˝ch plynov na zĂˇklade lokality')
WHERE code = 'E1-6_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© emisie sklenĂ­kovĂ˝ch plynov na zĂˇklade trhu')
WHERE code = 'E1-6_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĂ˝znamnĂ˝ch zmien v definĂ­cii toho, ÄŤo predstavuje vykazujĂşci podnik a jeho hodnotovĂ˝ reĹĄazec, a vysvetlenie ich vplyvu na porovnateÄľnosĹĄ vykazovanĂ˝ch emisiĂ­ sklenĂ­kovĂ˝ch plynov rok po roku')
WHERE code = 'E1-6_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie metodolĂłgiĂ­, vĂ˝znamnĂ˝ch predpokladov a emisnĂ˝ch faktorov pouĹľitĂ˝ch na vĂ˝poÄŤet alebo meranie emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-6_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vplyvov vĂ˝znamnĂ˝ch udalostĂ­ a zmien okolnostĂ­ (relevantnĂ˝ch k jeho emisiĂˇm sklenĂ­kovĂ˝ch plynov), ktorĂ© nastanĂş medzi dĂˇtumami vykazovania subjektov v jeho hodnotovom reĹĄazci a dĂˇtumom finanÄŤnĂ˝ch vĂ˝kazov vĹˇeobecnĂ©ho ĂşÄŤelu podniku')
WHERE code = 'E1-6_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'BiogĂ©nne emisie CO2 zo spaÄľovania alebo biodegradĂˇcie biomasy nezahrnutĂ© v emisiĂˇch Rozsah 1')
WHERE code = 'E1-6_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zmluvnĂ˝ch nĂˇstrojov, emisie Rozsah 2')
WHERE code = 'E1-6_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zmluvnĂ˝ch nĂˇstrojov, emisie Rozsah 2')
WHERE code = 'E1-6_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel emisiĂ­ Rozsah 2 na zĂˇklade trhu spojenĂ˝ch so zakĂşpenou elektrinou spolu s nĂˇstrojmi')
WHERE code = 'E1-6_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zmluvnĂ˝ch nĂˇstrojov pouĹľitĂ˝ch na predaj a nĂˇkup energie spojenej s atribĂştmi o vĂ˝robe energie vo vzĹĄahu k emisiĂˇm Rozsah 2')
WHERE code = 'E1-6_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zmluvnĂ˝ch nĂˇstrojov pouĹľitĂ˝ch na predaj a nĂˇkup nespojenĂ˝ch energetickĂ˝ch atribĂştovĂ˝ch nĂˇrokov vo vzĹĄahu k emisiĂˇm Rozsah 2')
WHERE code = 'E1-6_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zmluvnĂ˝ch nĂˇstrojov pouĹľitĂ˝ch na predaj a nĂˇkup energie spojenej s atribĂştmi o vĂ˝robe energie alebo pre nespojenĂ© energetickĂ© atribĂştovĂ© nĂˇroky')
WHERE code = 'E1-6_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'BiogĂ©nne emisie CO2 zo spaÄľovania alebo biodegradĂˇcie biomasy nezahrnutĂ© v emisiĂˇch Rozsah 2')
WHERE code = 'E1-6_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel emisiĂ­ Rozsah 3 vypoÄŤĂ­tanĂ˝ch pomocou primĂˇrnych Ăşdajov')
WHERE code = 'E1-6_25';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dĂ´vodu, preÄŤo bola kategĂłria emisiĂ­ Rozsah 3 vylĂşÄŤenĂˇ')
WHERE code = 'E1-6_26';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zoznam kategĂłriĂ­ emisiĂ­ Rozsah 3 zahrnutĂ˝ch v inventĂˇri')
WHERE code = 'E1-6_27';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'BiogĂ©nne emisie CO2 zo spaÄľovania alebo biodegradĂˇcie biomasy, ktorĂ© sa vyskytujĂş v hodnotovom reĹĄazci a nie sĂş zahrnutĂ© v emisiĂˇch Rozsah 3')
WHERE code = 'E1-6_28';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zvĂˇĹľenĂ˝ch hranĂ­c vykazovania a metĂłd vĂ˝poÄŤtu na odhad emisiĂ­ Rozsah 3')
WHERE code = 'E1-6_29';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzita emisiĂ­ sklenĂ­kovĂ˝ch plynov, na zĂˇklade lokality (celkovĂ© emisie sklenĂ­kovĂ˝ch plynov na ÄŤistĂ© vĂ˝nosy)')
WHERE code = 'E1-6_30';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Intenzita emisiĂ­ sklenĂ­kovĂ˝ch plynov, na zĂˇklade trhu (celkovĂ© emisie sklenĂ­kovĂ˝ch plynov na ÄŤistĂ© vĂ˝nosy)')
WHERE code = 'E1-6_31';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosĂşladenia s finanÄŤnĂ˝mi vĂ˝kazmi ÄŤistĂ˝ch vĂ˝nosov pouĹľitĂ˝ch na vĂ˝poÄŤet intenzity emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-6_32';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy')
WHERE code = 'E1-6_33';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy pouĹľitĂ© na vĂ˝poÄŤet intenzity emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-6_34';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy inĂ© ako pouĹľitĂ© na vĂ˝poÄŤet intenzity emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-6_35';

-- E1-7: GHG removals and GHG mitigation projects
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odstrĂˇnenia a uskladnenia sklenĂ­kovĂ˝ch plynov vyplĂ˝vajĂşcich z projektov vyvinutĂ˝ch vo vlastnĂ˝ch operĂˇciĂˇch alebo prispievajĂşcich vo vĂ˝chodnom a zĂˇpadnom hodnotovom reĹĄazci')
WHERE code = 'E1-7_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov alebo odstrĂˇnenia z projektov zmierĹovania zmeny klĂ­my mimo hodnotovĂ©ho reĹĄazca financovanĂ˝ch alebo plĂˇnovanĂ˝ch financovaĹĄ prostrednĂ­ctvom nĂˇkupu uhlĂ­kovĂ˝ch kreditov')
WHERE code = 'E1-7_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OdstrĂˇnenia a uhlĂ­kovĂ© kredity sa pouĹľĂ­vajĂş')
WHERE code = 'E1-7_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚinnosĹĄ odstrĂˇnenia a uskladnenia sklenĂ­kovĂ˝ch plynov podÄľa rozsahu podniku (rozdelenie na vlastnĂ© operĂˇcie a hodnotovĂ˝ reĹĄazec) a podÄľa ÄŤinnosti odstrĂˇnenia a uskladnenia')
WHERE code = 'E1-7_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© odstrĂˇnenie a uskladnenie sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-7_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Emisie sklenĂ­kovĂ˝ch plynov spojenĂ© s ÄŤinnosĹĄou odstrĂˇnenia')
WHERE code = 'E1-7_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ObrĂˇtenia')
WHERE code = 'E1-7_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĂ˝poÄŤtovĂ˝ch predpokladov, metodolĂłgiĂ­ a rĂˇmcov aplikovanĂ˝ch (odstrĂˇnenie a uskladnenie sklenĂ­kovĂ˝ch plynov)')
WHERE code = 'E1-7_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚinnosĹĄ odstrĂˇnenia bola prevedenĂˇ na uhlĂ­kovĂ© kredity a predanĂˇ inĂ˝m stranĂˇm na dobrovoÄľnom trhu')
WHERE code = 'E1-7_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ suma uhlĂ­kovĂ˝ch kreditov mimo hodnotovĂ©ho reĹĄazca, ktorĂ© sĂş overenĂ© podÄľa uznanĂ˝ch Ĺˇtandardov kvality a zruĹˇenĂ©')
WHERE code = 'E1-7_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ suma uhlĂ­kovĂ˝ch kreditov mimo hodnotovĂ©ho reĹĄazca plĂˇnovanĂ˝ch na zruĹˇenie v budĂşcnosti')
WHERE code = 'E1-7_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu pouĹľitia a kritĂ©riĂ­ kvality pouĹľitĂ˝ch pre uhlĂ­kovĂ© kredity')
WHERE code = 'E1-7_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel projektov zniĹľovania')
WHERE code = 'E1-7_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel projektov odstrĂˇnenia')
WHERE code = 'E1-7_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ uhlĂ­kovĂ˝ch kreditov z projektov odstrĂˇnenia')
WHERE code = 'E1-7_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel pre uznanĂ˝ Ĺˇtandard kvality')
WHERE code = 'E1-7_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel vydanĂ˝ z projektov v EurĂłpskej Ăşnii')
WHERE code = 'E1-7_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel, ktorĂ˝ spÄşĹa podmienky zodpovedajĂşcej Ăşpravy')
WHERE code = 'E1-7_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'DĂˇtum, kedy sĂş plĂˇnovanĂ© zruĹˇenie uhlĂ­kovĂ˝ch kreditov mimo hodnotovĂ©ho reĹĄazca')
WHERE code = 'E1-7_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie rozsahu, metodolĂłgiĂ­ a rĂˇmcov aplikovanĂ˝ch a toho, ako sa plĂˇnuje neutralizovaĹĄ zostatkovĂ© emisie sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-7_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Boli vykonanĂ© verejnĂ© vyhlĂˇsenia o neutralite sklenĂ­kovĂ˝ch plynov zahĹ•ĹajĂşce pouĹľitie uhlĂ­kovĂ˝ch kreditov')
WHERE code = 'E1-7_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'VerejnĂ© vyhlĂˇsenia o neutralite sklenĂ­kovĂ˝ch plynov zahĹ•ĹajĂşce pouĹľitie uhlĂ­kovĂ˝ch kreditov sĂş sprevĂˇdzanĂ© cieÄľmi znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-7_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Tvrdenia o neutralite sklenĂ­kovĂ˝ch plynov a spoliehnanie sa na uhlĂ­kovĂ© kredity nebrĂˇnia ani nezniĹľujĂş dosiahnutie cieÄľov znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov alebo cieÄľa ÄŤistej nuly')
WHERE code = 'E1-7_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi a ako sĂş verejnĂ© vyhlĂˇsenia o neutralite sklenĂ­kovĂ˝ch plynov zahĹ•ĹajĂşce pouĹľitie uhlĂ­kovĂ˝ch kreditov sprevĂˇdzanĂ© cieÄľmi znĂ­Ĺľenia emisiĂ­ sklenĂ­kovĂ˝ch plynov a ako tvrdenia o neutralite a spoliehnanie sa na kredity nebrĂˇnia dosiahnutiu cieÄľov')
WHERE code = 'E1-7_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vierohodnosti a integrity pouĹľitĂ˝ch uhlĂ­kovĂ˝ch kreditov')
WHERE code = 'E1-7_25';

-- E1-8: Internal carbon pricing
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'SchĂ©ma oceĹovania uhlĂ­ka podÄľa typu')
WHERE code = 'E1-8_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Typ vnĂştornej schĂ©my oceĹovania uhlĂ­ka')
WHERE code = 'E1-8_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis ĹˇpecifickĂ©ho rozsahu aplikĂˇcie schĂ©my oceĹovania uhlĂ­ka')
WHERE code = 'E1-8_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Cena uhlĂ­ka aplikovanĂˇ na kaĹľdĂş metrickĂˇ tonu emisiĂ­ sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-8_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Opis kritickĂ˝ch predpokladov vykonanĂ˝ch na stanovenie aplikovanej ceny uhlĂ­ka')
WHERE code = 'E1-8_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel hrubĂ˝ch emisiĂ­ Rozsah 1 pokrytĂ˝ch vnĂştornou schĂ©mou oceĹovania uhlĂ­ka')
WHERE code = 'E1-8_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel hrubĂ˝ch emisiĂ­ Rozsah 2 pokrytĂ˝ch vnĂştornou schĂ©mou oceĹovania uhlĂ­ka')
WHERE code = 'E1-8_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel hrubĂ˝ch emisiĂ­ Rozsah 3 pokrytĂ˝ch vnĂştornou schĂ©mou oceĹovania uhlĂ­ka')
WHERE code = 'E1-8_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako je cena uhlĂ­ka pouĹľitĂˇ vo vnĂştornej schĂ©me oceĹovania uhlĂ­ka konzistentnĂˇ s cenou uhlĂ­ka pouĹľitou vo finanÄŤnĂ˝ch vĂ˝kazoch')
WHERE code = 'E1-8_09';

-- E1-9: Anticipated financial effects from material physical and transition risks and potential climate-related opportunities
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AktĂ­va v materiĂˇlnom fyzickom riziku pred zvĂˇĹľenĂ­m adaptaÄŤnĂ˝ch opatrenĂ­ na zmenu klĂ­my')
WHERE code = 'E1-9_01';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AktĂ­va v akĂştnom materiĂˇlnom fyzickom riziku pred zvĂˇĹľenĂ­m adaptaÄŤnĂ˝ch opatrenĂ­ na zmenu klĂ­my')
WHERE code = 'E1-9_02';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AktĂ­va v chronickom materiĂˇlnom fyzickom riziku pred zvĂˇĹľenĂ­m adaptaÄŤnĂ˝ch opatrenĂ­ na zmenu klĂ­my')
WHERE code = 'E1-9_03';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel aktĂ­v v materiĂˇlnom fyzickom riziku pred zvĂˇĹľenĂ­m adaptaÄŤnĂ˝ch opatrenĂ­ na zmenu klĂ­my')
WHERE code = 'E1-9_04';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie lokality vĂ˝znamnĂ˝ch aktĂ­v v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_05';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie lokality vĂ˝znamnĂ˝ch aktĂ­v v materiĂˇlnom fyzickom riziku (rozdelenĂ© podÄľa kĂłdov NUTS)')
WHERE code = 'E1-9_06';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel aktĂ­v v materiĂˇlnom fyzickom riziku rieĹˇenĂ˝ch adaptaÄŤnĂ˝mi opatreniami na zmenu klĂ­my')
WHERE code = 'E1-9_07';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy z obchodnĂ˝ch ÄŤinnostĂ­ v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_08';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch vĂ˝nosov z obchodnĂ˝ch ÄŤinnostĂ­ v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_09';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako boli posĂşdenĂ© oÄŤakĂˇvanĂ© finanÄŤnĂ© ĂşÄŤinky pre aktĂ­va a obchodnĂ© ÄŤinnosti v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_10';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako sa posĂşdenie aktĂ­v a obchodnĂ˝ch ÄŤinnostĂ­ povaĹľovanĂ˝ch za materiĂˇlne fyzickĂ© riziko spolieha alebo je sĂşÄŤasĹĄou procesu urÄŤenia materiĂˇlneho fyzickĂ©ho rizika a urÄŤenia klimatickĂ˝ch scenĂˇrov')
WHERE code = 'E1-9_11';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rizikovĂ˝ch faktorov pre ÄŤistĂ© vĂ˝nosy z obchodnĂ˝ch ÄŤinnostĂ­ v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_12';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu oÄŤakĂˇvanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkov z hÄľadiska erĂłzie marĹľĂ­ pre obchodnĂ© ÄŤinnosti v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_13';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'AktĂ­va v materiĂˇlnom tranzitnom riziku pred zvĂˇĹľenĂ­m klimatickĂ˝ch zmierĹujĂşcich opatrenĂ­')
WHERE code = 'E1-9_14';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel aktĂ­v v materiĂˇlnom tranzitnom riziku pred zvĂˇĹľenĂ­m klimatickĂ˝ch zmierĹujĂşcich opatrenĂ­')
WHERE code = 'E1-9_15';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel aktĂ­v v materiĂˇlnom tranzitnom riziku rieĹˇenĂ˝ch klimatickĂ˝mi zmierĹujĂşcimi opatreniami')
WHERE code = 'E1-9_16';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ ĂşÄŤtovnĂˇ hodnota nehnuteÄľnostĂ­ podÄľa tried energetickej efektĂ­vnosti')
WHERE code = 'E1-9_17';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako boli posĂşdenĂ© potenciĂˇlne ĂşÄŤinky na budĂşcu finanÄŤnĂş vĂ˝konnosĹĄ a pozĂ­ciu pre aktĂ­va a obchodnĂ© ÄŤinnosti v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_18';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako sa posĂşdenie aktĂ­v a obchodnĂ˝ch ÄŤinnostĂ­ povaĹľovanĂ˝ch za materiĂˇlne tranzitnĂ© riziko spolieha alebo je sĂşÄŤasĹĄou procesu urÄŤenia materiĂˇlnych tranzitnĂ˝ch rizĂ­k a urÄŤenia scenĂˇrov')
WHERE code = 'E1-9_19';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OdhadovanĂˇ suma potenciĂˇlne stratenĂ˝ch aktĂ­v')
WHERE code = 'E1-9_20';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel odhadovanĂ©ho podielu potenciĂˇlne stratenĂ˝ch aktĂ­v z celkovĂ˝ch aktĂ­v v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_21';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ ĂşÄŤtovnĂˇ hodnota nehnuteÄľnostĂ­, pre ktorĂ© je spotreba energie zaloĹľenĂˇ na internĂ˝ch odhadoch')
WHERE code = 'E1-9_22';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ZĂˇvĂ¤zky z materiĂˇlnych tranzitnĂ˝ch rizĂ­k, ktorĂ© moĹľno bude potrebnĂ© uznaĹĄ vo finanÄŤnĂ˝ch vĂ˝kazoch')
WHERE code = 'E1-9_23';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PoÄŤet povoleniek na emisie Rozsah 1 v rĂˇmci regulovanĂ˝ch systĂ©mov obchodovania s emisiami')
WHERE code = 'E1-9_24';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PoÄŤet uloĹľenĂ˝ch emisnĂ˝ch povoleniek (z predchĂˇdzajĂşcich povoleniek) na zaÄŤiatku vykazovacieho obdobia')
WHERE code = 'E1-9_25';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PotenciĂˇlne budĂşce zĂˇvĂ¤zky zaloĹľenĂ© na existujĂşcich zmluvnĂ˝ch dohodĂˇch spojenĂ© s uhlĂ­kovĂ˝mi kreditmi plĂˇnovanĂ˝mi na zruĹˇenie v blĂ­zkej budĂşcnosti')
WHERE code = 'E1-9_26';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'MonetizovanĂ© hrubĂ© emisie Rozsah 1 a 2')
WHERE code = 'E1-9_27';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'MonetizovanĂ© celkovĂ© emisie sklenĂ­kovĂ˝ch plynov')
WHERE code = 'E1-9_28';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy z obchodnĂ˝ch ÄŤinnostĂ­ v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_29';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy od zĂˇkaznĂ­kov pĂ´sobiacich v ÄŤinnostiach sĂşvisiacich s uhlĂ­m')
WHERE code = 'E1-9_30';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy od zĂˇkaznĂ­kov pĂ´sobiacich v ÄŤinnostiach sĂşvisiacich s ropou')
WHERE code = 'E1-9_31';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'ÄŚistĂ© vĂ˝nosy od zĂˇkaznĂ­kov pĂ´sobiacich v ÄŤinnostiach sĂşvisiacich s plynom')
WHERE code = 'E1-9_32';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch vĂ˝nosov od zĂˇkaznĂ­kov pĂ´sobiacich v ÄŤinnostiach sĂşvisiacich s uhlĂ­m')
WHERE code = 'E1-9_33';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch vĂ˝nosov od zĂˇkaznĂ­kov pĂ´sobiacich v ÄŤinnostiach sĂşvisiacich s ropou')
WHERE code = 'E1-9_34';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch vĂ˝nosov od zĂˇkaznĂ­kov pĂ´sobiacich v ÄŤinnostiach sĂşvisiacich s plynom')
WHERE code = 'E1-9_35';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch vĂ˝nosov z obchodnĂ˝ch ÄŤinnostĂ­ v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_36';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rizikovĂ˝ch faktorov pre ÄŤistĂ© vĂ˝nosy z obchodnĂ˝ch ÄŤinnostĂ­ v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_37';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie oÄŤakĂˇvanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkov z hÄľadiska erĂłzie marĹľĂ­ pre obchodnĂ© ÄŤinnosti v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_38';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosĂşladenia s finanÄŤnĂ˝mi vĂ˝kazmi vĂ˝znamnĂ˝ch sĂşm aktĂ­v a ÄŤistĂ˝ch vĂ˝nosov v materiĂˇlnom fyzickom riziku')
WHERE code = 'E1-9_39';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zosĂşladenia s finanÄŤnĂ˝mi vĂ˝kazmi vĂ˝znamnĂ˝ch sĂşm aktĂ­v, zĂˇvĂ¤zkov a ÄŤistĂ˝ch vĂ˝nosov v materiĂˇlnom tranzitnom riziku')
WHERE code = 'E1-9_40';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OÄŤakĂˇvanĂ© Ăşspory nĂˇkladov z opatrenĂ­ na zmierĹovanie zmeny klĂ­my')
WHERE code = 'E1-9_41';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OÄŤakĂˇvanĂ© Ăşspory nĂˇkladov z adaptaÄŤnĂ˝ch opatrenĂ­ na zmenu klĂ­my')
WHERE code = 'E1-9_42';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'PotenciĂˇlna veÄľkosĹĄ trhu nĂ­zkouhlĂ­kovĂ˝ch produktov a sluĹľieb alebo adaptaÄŤnĂ˝ch rieĹˇenĂ­, ku ktorĂ˝m mĂˇ podnik alebo mĂ´Ĺľe maĹĄ prĂ­stup')
WHERE code = 'E1-9_43';

UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'OÄŤakĂˇvanĂ© zmeny ÄŤistĂ˝ch vĂ˝nosov z nĂ­zkouhlĂ­kovĂ˝ch produktov a sluĹľieb alebo adaptaÄŤnĂ˝ch rieĹˇenĂ­, ku ktorĂ˝m mĂˇ podnik alebo mĂ´Ĺľe maĹĄ prĂ­stup')
WHERE code = 'E1-9_44';

-- Final message
SELECT 'All E1 translations completed successfully!' as status;
-- ============================================================================
-- ESRS E2-E5 SLOVAK TRANSLATIONS
-- Generated: February 6, 2026
-- Topics: E2 (Pollution), E3 (Water), E4 (Biodiversity), E5 (Circular Economy)
-- ============================================================================

-- ============================================================================
-- ESRS E2: ZNEÄŚISTENIE (POLLUTION)
-- ============================================================================

-- E2.IRO-1: Proces identifikĂˇcie dopadov, rizĂ­k a prĂ­leĹľitostĂ­
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o procese identifikĂˇcie skutoÄŤnĂ˝ch a potenciĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich so zneÄŤistenĂ­m') WHERE code = 'E2.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli vykonanĂ© konzultĂˇcie (zneÄŤistenie)') WHERE code = 'E2.IRO-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĂ˝sledkov posĂşdenia materiality (zneÄŤistenie)') WHERE code = 'E2.IRO-1_03';

-- E2-1: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich so zneÄŤistenĂ­m [pozri ESRS 2 MDR-P]') WHERE code = 'E2.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi zmiernenie negatĂ­vnych dopadov sĂşvisiacich so zneÄŤistenĂ­m ovzduĹˇia, vody a pĂ´dy') WHERE code = 'E2-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi nahrĂˇdzanie a minimalizĂˇciu pouĹľĂ­vania lĂˇtok vzbudzujĂşcich obavy a postupnĂ© vyraÄŹovanie lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy') WHERE code = 'E2-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi predchĂˇdzanie incidentom a nĂşdzovĂ˝m situĂˇciĂˇm, a ak k nim dĂ´jde, kontrolu a obmedzenie ich vplyvu na ÄľudĂ­ a ĹľivotnĂ© prostredie') WHERE code = 'E2-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ o vzĹĄahoch medzi implementovanĂ˝mi politikami a tĂ˝m, ako politiky prispievajĂş k AkÄŤnĂ©mu plĂˇnu EĂš smerom k nulovĂ©mu zneÄŤisteniu ovzduĹˇia, vody a pĂ´dy') WHERE code = 'E2-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal politiky') WHERE code = 'E2.MDR-P_07-08';

-- E2-2: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje tĂ˝kajĂşce sa zneÄŤistenia [pozri ESRS 2 MDR-A]') WHERE code = 'E2.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ĂšroveĹ v hierarchii zmierĹovania, do ktorej moĹľno priradiĹĄ akciu (zneÄŤistenie)') WHERE code = 'E2-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcia sĂşvisiaca so zneÄŤistenĂ­m sa vzĹĄahuje na angaĹľovanosĹĄ vo vyĹˇĹˇej/niĹľĹˇej ÄŤasti hodnotovĂ©ho reĹĄazca') WHERE code = 'E2-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ĂšroveĹ v hierarchii zmierĹovania, do ktorej moĹľno priradiĹĄ zdroje (zneÄŤistenie)') WHERE code = 'E2-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o akÄŤnĂ˝ch plĂˇnoch, ktorĂ© boli implementovanĂ© na Ăşrovni lokalĂ­t (zneÄŤistenie)') WHERE code = 'E2-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal akcie') WHERE code = 'E2.MDR-A_13-14';

-- E2-3: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektĂ­vnosti politĂ­k a akciĂ­ prostrednĂ­ctvom cieÄľov [pozri ESRS 2 MDR-T]') WHERE code = 'E2.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka prevencie a kontroly zneÄŤisĹĄujĂşcich lĂˇtok v ovzduĹˇĂ­ a prĂ­sluĹˇnĂ˝ch ĹˇpecifickĂ˝ch zaĹĄaĹľenĂ­') WHERE code = 'E2-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka prevencie a kontroly emisiĂ­ do vody a prĂ­sluĹˇnĂ˝ch ĹˇpecifickĂ˝ch zaĹĄaĹľenĂ­') WHERE code = 'E2-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka prevencie a kontroly zneÄŤistenia pĂ´dy a prĂ­sluĹˇnĂ˝ch ĹˇpecifickĂ˝ch zaĹĄaĹľenĂ­') WHERE code = 'E2-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka prevencie a kontroly lĂˇtok vzbudzujĂşcich obavy a lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy') WHERE code = 'E2-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pri stanovenĂ­ cieÄľa sĂşvisiaceho so zneÄŤistenĂ­m boli zohÄľadnenĂ© ekologickĂ© prahy a pridelenia ĹˇpecifickĂ© pre subjekt') WHERE code = 'E2-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovanĂ˝ch ekologickĂ˝ch prahov a metodolĂłgie pouĹľitej na identifikĂˇciu ekologickĂ˝ch prahov (zneÄŤistenie)') WHERE code = 'E2-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako boli urÄŤenĂ© ekologickĂ© prahy ĹˇpecifickĂ© pre subjekt (zneÄŤistenie)') WHERE code = 'E2-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako je pridelenĂˇ zodpovednosĹĄ za reĹˇpektovanie identifikovanĂ˝ch ekologickĂ˝ch prahov (zneÄŤistenie)') WHERE code = 'E2-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ sĂşvisiaci so zneÄŤistenĂ­m je povinnĂ˝ (vyĹľadovanĂ˝ legislatĂ­vou)/dobrovoÄľnĂ˝') WHERE code = 'E2-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ sĂşvisiaci so zneÄŤistenĂ­m rieĹˇi nedostatky tĂ˝kajĂşce sa kritĂ©riĂ­ podstatnĂ©ho prĂ­nosu pre prevenciu a kontrolu zneÄŤistenia') WHERE code = 'E2-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o cieÄľoch, ktorĂ© boli implementovanĂ© na Ăşrovni lokalĂ­t (zneÄŤistenie)') WHERE code = 'E2-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal ciele') WHERE code = 'E2.MDR-T_14-19';

-- E2-4: ZneÄŤistenie ovzduĹˇia, vody a pĂ´dy
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ZneÄŤistenie ovzduĹˇia, vody a pĂ´dy [viacerĂ© dimenzie: na Ăşrovni lokality alebo podÄľa typu zdroja, podÄľa sektora alebo geografickej oblasti]') WHERE code = 'E2-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Emisie do ovzduĹˇia podÄľa zneÄŤisĹĄujĂşcej lĂˇtky') WHERE code = 'E2-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Emisie do vody podÄľa zneÄŤisĹĄujĂşcej lĂˇtky [+ podÄľa sektorov/geografickej oblasti/typu zdroja/umiestnenia lokality]') WHERE code = 'E2-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Emisie do pĂ´dy podÄľa zneÄŤisĹĄujĂşcej lĂˇtky [+ podÄľa sektorov/geografickej oblasti/typu zdroja/umiestnenia lokality]') WHERE code = 'E2-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mikroplasty generovanĂ© a pouĹľĂ­vanĂ©') WHERE code = 'E2-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mikroplasty generovanĂ©') WHERE code = 'E2-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mikroplasty pouĹľĂ­vanĂ©') WHERE code = 'E2-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zmien v priebehu ÄŤasu (zneÄŤistenie ovzduĹˇia, vody a pĂ´dy)') WHERE code = 'E2-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodolĂłgiĂ­ merania (zneÄŤistenie ovzduĹˇia, vody a pĂ´dy)') WHERE code = 'E2-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesov zberu Ăşdajov pre ĂşÄŤtovnĂ­ctvo a vykazovanie sĂşvisiace so zneÄŤistenĂ­m') WHERE code = 'E2-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel celkovĂ˝ch emisiĂ­ zneÄŤisĹĄujĂşcich lĂˇtok do vody v oblastiach s vodnĂ˝m rizikom') WHERE code = 'E2-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel celkovĂ˝ch emisiĂ­ zneÄŤisĹĄujĂşcich lĂˇtok do vody v oblastiach s vysokĂ˝m vodnĂ˝m stresom') WHERE code = 'E2-4_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel celkovĂ˝ch emisiĂ­ zneÄŤisĹĄujĂşcich lĂˇtok do pĂ´dy v oblastiach s vodnĂ˝m rizikom') WHERE code = 'E2-4_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel celkovĂ˝ch emisiĂ­ zneÄŤisĹĄujĂşcich lĂˇtok do pĂ´dy v oblastiach s vysokĂ˝m vodnĂ˝m stresom') WHERE code = 'E2-4_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dĂ´vodov vĂ˝beru menej vhodnej metodolĂłgie na kvantifikĂˇciu emisiĂ­') WHERE code = 'E2-4_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu prevĂˇdzkovanĂ˝ch zariadenĂ­, ktorĂ© spadajĂş pod IED a ZĂˇvery EĂš o BAT') WHERE code = 'E2-4_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu akĂ˝chkoÄľvek incidentov nedodrĹľiavania predpisov alebo donucovacĂ­ch opatrenĂ­ potrebnĂ˝ch na zabezpeÄŤenie sĂşladu v prĂ­pade poruĹˇenĂ­ podmienok povolenia') WHERE code = 'E2-4_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie skutoÄŤnej vĂ˝konnosti a porovnanie environmentĂˇlnej vĂ˝konnosti s ĂşrovĹami emisiĂ­ spojenĂ˝mi s najlepĹˇĂ­mi dostupnĂ˝mi technikami (BAT-AEL), ako sĂş opĂ­sanĂ© v ZĂˇveroch EĂš o BAT') WHERE code = 'E2-4_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie skutoÄŤnej vĂ˝konnosti v porovnanĂ­ s ĂşrovĹami environmentĂˇlnej vĂ˝konnosti spojenĂ˝mi s najlepĹˇĂ­mi dostupnĂ˝mi technikami (BAT-AEPL) platnĂ˝mi pre sektor a zariadenie') WHERE code = 'E2-4_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu akĂ˝chkoÄľvek ÄŤasovĂ˝ch plĂˇnov sĂşladu alebo vĂ˝nimiek udelenĂ˝ch prĂ­sluĹˇnĂ˝mi orgĂˇnmi podÄľa ÄŤlĂˇnku 15(4) IED, ktorĂ© sĂşvisia s implementĂˇciou BAT-AEL') WHERE code = 'E2-4_20';

-- E2-5: LĂˇtky vzbudzujĂşce obavy a lĂˇtky vzbudzujĂşce veÄľmi vysokĂ© obavy
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© sa generujĂş alebo pouĹľĂ­vajĂş poÄŤas vĂ˝roby alebo sa obstarĂˇvajĂş, rozdelenie podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© sa generujĂş alebo pouĹľĂ­vajĂş poÄŤas vĂ˝roby alebo sa obstarĂˇvajĂş') WHERE code = 'E2-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako emisie, ako produkty alebo ako sĂşÄŤasĹĄ produktov alebo sluĹľieb') WHERE code = 'E2-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako emisie podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako produkty podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako sĂşÄŤasĹĄ produktov podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako sluĹľby podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy, ktorĂ© sa generujĂş alebo pouĹľĂ­vajĂş poÄŤas vĂ˝roby alebo sa obstarĂˇvajĂş podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako emisie, ako produkty alebo ako sĂşÄŤasĹĄ produktov alebo sluĹľieb podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako emisie podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako produkty podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako sĂşÄŤasĹĄ produktov podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'MnoĹľstvo lĂˇtok vzbudzujĂşcich veÄľmi vysokĂ© obavy, ktorĂ© opĂşĹˇĹĄajĂş zariadenia ako sluĹľby podÄľa hlavnĂ˝ch tried nebezpeÄŤenstva lĂˇtok vzbudzujĂşcich obavy') WHERE code = 'E2-5_13';

-- E2-6: PredpokladanĂ© finanÄŤnĂ© ĂşÄŤinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich so zneÄŤistenĂ­m') WHERE code = 'E2-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch prĂ­jmov dosiahnutĂ˝ch prostrednĂ­ctvom produktov a sluĹľieb, ktorĂ© sĂş alebo obsahujĂş lĂˇtky vzbudzujĂşce obavy') WHERE code = 'E2-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄŤistĂ˝ch prĂ­jmov dosiahnutĂ˝ch prostrednĂ­ctvom produktov a sluĹľieb, ktorĂ© sĂş alebo obsahujĂş lĂˇtky vzbudzujĂşce veÄľmi vysokĂ© obavy') WHERE code = 'E2-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PrevĂˇdzkovĂ© vĂ˝davky (OpEx) v sĂşvislosti s vĂ˝znamnĂ˝mi incidentmi a depozitmi (zneÄŤistenie)') WHERE code = 'E2-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'KapitĂˇlovĂ© vĂ˝davky (CapEx) v sĂşvislosti s vĂ˝znamnĂ˝mi incidentmi a depozitmi (zneÄŤistenie)') WHERE code = 'E2-6_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rezervy na nĂˇklady na ochranu ĹľivotnĂ©ho prostredia a nĂˇpravu (zneÄŤistenie)') WHERE code = 'E2-6_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich so zneÄŤistenĂ­m') WHERE code = 'E2-6_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvaĹľovanĂ˝ch ĂşÄŤinkov, sĂşvisiacich dopadov a ÄŤasovĂ˝ch horizontov, v ktorĂ˝ch sa pravdepodobne zhmotnia (zneÄŤistenie)') WHERE code = 'E2-6_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritickĂ˝ch predpokladov pouĹľitĂ˝ch na kvantifikĂˇciu predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkov, zdrojov a Ăşrovne neistoty predpokladov (zneÄŤistenie)') WHERE code = 'E2-6_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vĂ˝znamnĂ˝ch incidentov a depozitov, pri ktorĂ˝ch malo zneÄŤistenie negatĂ­vne dopady na ĹľivotnĂ© prostredie a (alebo) sa oÄŤakĂˇva, Ĺľe bude maĹĄ negatĂ­vne ĂşÄŤinky na finanÄŤnĂ© peĹaĹľnĂ© toky, finanÄŤnĂş pozĂ­ciu a finanÄŤnĂş vĂ˝konnosĹĄ') WHERE code = 'E2-6_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie posĂşdenia sĂşvisiacich produktov a sluĹľieb ohrozenĂ˝ch a vysvetlenie toho, ako je definovanĂ˝ ÄŤasovĂ˝ horizont, odhadnutĂ© finanÄŤnĂ© ÄŤiastky a akĂ© kritickĂ© predpoklady sĂş urobenĂ© (zneÄŤistenie)') WHERE code = 'E2-6_11';

-- ============================================================================
-- ESRS E3: VODNĂ‰ ZDROJE A MORSKĂ‰ ZDROJE (WATER AND MARINE RESOURCES)
-- ============================================================================

-- E3.IRO-1: Proces identifikĂˇcie dopadov, rizĂ­k a prĂ­leĹľitostĂ­
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli aktĂ­va a ÄŤinnosti preskĂşmanĂ© s cieÄľom identifikovaĹĄ skutoÄŤnĂ© a potenciĂˇlne dopady, rizikĂˇ a prĂ­leĹľitosti sĂşvisiace s vodnĂ˝mi a morskĂ˝mi zdrojmi vo vlastnĂ˝ch operĂˇciĂˇch a vo vyĹˇĹˇom a niĹľĹˇom hodnotovom reĹĄazci a pouĹľitĂ© metodolĂłgie, predpoklady a nĂˇstroje') WHERE code = 'E3.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako boli vykonanĂ© konzultĂˇcie (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3.IRO-1_02';

-- E3-1: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s vodnĂ˝mi a morskĂ˝mi zdrojmi [pozri ESRS 2 MDR-P]') WHERE code = 'E3.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi hospodĂˇrenie s vodou') WHERE code = 'E3-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi pouĹľĂ­vanie a zĂ­skavanie vody a morskĂ˝ch zdrojov vo vlastnĂ˝ch operĂˇciĂˇch') WHERE code = 'E3-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi Ăşpravu vody') WHERE code = 'E3-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi prevenciu a zniĹľovanie zneÄŤistenia vody') WHERE code = 'E3-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi nĂˇvrh produktov a sluĹľieb s ohÄľadom na rieĹˇenie problĂ©mov sĂşvisiacich s vodou a ochranu morskĂ˝ch zdrojov') WHERE code = 'E3-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi zĂˇvĂ¤zok znĂ­ĹľiĹĄ spotrebu vody v oblastiach s vodnĂ˝m rizikom') WHERE code = 'E3-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dĂ´vodov, preÄŤo neboli prijatĂ© politiky v oblastiach s vysokĂ˝m vodnĂ˝m stresom') WHERE code = 'E3-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho rĂˇmca, v ktorom budĂş prijatĂ© politiky v oblastiach s vysokĂ˝m vodnĂ˝m stresom') WHERE code = 'E3-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijatĂ© politiky alebo postupy tĂ˝kajĂşce sa udrĹľateÄľnĂ˝ch oceĂˇnov a morĂ­') WHERE code = 'E3-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politika prispieva k dobrej ekologickej a chemickej kvalite povrchovĂ˝ch vodnĂ˝ch Ăştvarov a dobrej chemickej kvalite a mnoĹľstvu podzemnĂ˝ch vĂ´d, aby sa ochrĂˇnilo ÄľudskĂ© zdravie, zĂˇsobovanie vodou, prĂ­rodnĂ© ekosystĂ©my a biodiverzita, dobrĂ˝ environmentĂˇlny stav morskĂ˝ch vĂ´d a ochrana zdrojovej zĂˇkladne, na ktorej zĂˇvisia ÄŤinnosti sĂşvisiace s morom') WHERE code = 'E3-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politika minimalizuje materiĂˇlne dopady a rizikĂˇ a implementuje zmierĹujĂşce opatrenia, ktorĂ© majĂş za cieÄľ udrĹľaĹĄ hodnotu a funkÄŤnosĹĄ prioritnĂ˝ch sluĹľieb a zvĂ˝ĹˇiĹĄ efektĂ­vnosĹĄ zdrojov vo vlastnĂ˝ch operĂˇciĂˇch') WHERE code = 'E3-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politika sa vyhĂ˝ba dopadom na dotknutĂ© komunity') WHERE code = 'E3-1_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal politiky') WHERE code = 'E3.MDR-P_07-08';

-- E3-2: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje tĂ˝kajĂşce sa vodnĂ˝ch a morskĂ˝ch zdrojov [pozri ESRS 2 MDR-A]') WHERE code = 'E3.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ĂšroveĹ v hierarchii zmierĹovania, do ktorej moĹľno priradiĹĄ akciu a zdroje (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o Ĺˇpecifickej kolektĂ­vnej akcii pre vodnĂ© a morskĂ© zdroje') WHERE code = 'E3-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie akciĂ­ a zdrojov vo vzĹĄahu k oblastiam s vodnĂ˝m rizikom') WHERE code = 'E3-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal akcie') WHERE code = 'E3.MDR-A_13-14';

-- E3-3: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektĂ­vnosti politĂ­k a akciĂ­ prostrednĂ­ctvom cieÄľov [pozri ESRS 2 MDR-T]') WHERE code = 'E3.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka riadenia materiĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s oblasĹĄami s vodnĂ˝m rizikom') WHERE code = 'E3-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka zodpovednĂ©ho riadenia dopadov, rizĂ­k a prĂ­leĹľitostĂ­ morskĂ˝ch zdrojov') WHERE code = 'E3-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa cieÄľ tĂ˝ka znĂ­Ĺľenia spotreby vody') WHERE code = 'E3-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pri stanovenĂ­ cieÄľa vodnĂ˝ch a morskĂ˝ch zdrojov bol zohÄľadnenĂ˝ (lokĂˇlny) ekologickĂ˝ prah a pridelenie ĹˇpecifickĂ© pre subjekt') WHERE code = 'E3-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovanĂ©ho ekologickĂ©ho prahu a metodolĂłgie pouĹľitej na identifikĂˇciu ekologickĂ©ho prahu (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako bol urÄŤenĂ˝ ekologickĂ˝ prah ĹˇpecifickĂ˝ pre subjekt (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako je pridelenĂˇ zodpovednosĹĄ za reĹˇpektovanie identifikovanĂ©ho ekologickĂ©ho prahu (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PrijatĂ˝ a prezentovanĂ˝ cieÄľ sĂşvisiaci s vodnĂ˝mi a morskĂ˝mi zdrojmi je povinnĂ˝ (na zĂˇklade legislatĂ­vy)') WHERE code = 'E3-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ sa tĂ˝ka znĂ­Ĺľenia odberu vody') WHERE code = 'E3-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ sa tĂ˝ka znĂ­Ĺľenia vypĂşĹˇĹĄania vody') WHERE code = 'E3-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal ciele') WHERE code = 'E3.MDR-T_14-19';

-- E3-4: Spotreba vody a recyklĂˇcia
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba vody') WHERE code = 'E3-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ spotreba vody v oblastiach s vodnĂ˝m rizikom, vrĂˇtane oblastĂ­ s vysokĂ˝m vodnĂ˝m stresom') WHERE code = 'E3-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo recyklovanej a opakovane pouĹľitej vody') WHERE code = 'E3-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo uskladnenej vody') WHERE code = 'E3-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zmeny v uskladnenĂ­ vody') WHERE code = 'E3-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ tĂ˝kajĂşcich sa spotreby vody') WHERE code = 'E3-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podiel merania zĂ­skanĂ˝ z priameho merania, zo vzorkovania a extrapolĂˇcie alebo z najlepĹˇĂ­ch odhadov') WHERE code = 'E3-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pomer intenzity vody') WHERE code = 'E3-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Spotreba vody - sektory/SEGMENTY [tabuÄľka]') WHERE code = 'E3-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'DodatoÄŤnĂ˝ pomer intenzity vody') WHERE code = 'E3-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ˝ odber vody') WHERE code = 'E3-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© vypĂşĹˇĹĄanie vody') WHERE code = 'E3-4_12';

-- E3-5: PredpokladanĂ© finanÄŤnĂ© ĂşÄŤinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich s vodnĂ˝mi a morskĂ˝mi zdrojmi') WHERE code = 'E3-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich s vodnĂ˝mi a morskĂ˝mi zdrojmi') WHERE code = 'E3-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvaĹľovanĂ˝ch ĂşÄŤinkov a sĂşvisiacich dopadov (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritickĂ˝ch predpokladov pouĹľitĂ˝ch v odhadoch finanÄŤnĂ˝ch ĂşÄŤinkov materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich s vodnĂ˝mi a morskĂ˝mi zdrojmi') WHERE code = 'E3-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis sĂşvisiacich produktov a sluĹľieb ohrozenĂ˝ch (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sĂş definovanĂ© ÄŤasovĂ© horizonty, odhadnutĂ© finanÄŤnĂ© ÄŤiastky a urobenĂ© kritickĂ© predpoklady (vodnĂ© a morskĂ© zdroje)') WHERE code = 'E3-5_06';

-- ============================================================================
-- ESRS E4: BIODIVERZITA A EKOSYSTĂ‰MY (BIODIVERSITY AND ECOSYSTEMS)
-- ============================================================================

-- E4.SBM-3: VĂ˝znamnĂ© lokality
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zoznam materiĂˇlnych lokalĂ­t vo vlastnĂ˝ch operĂˇciĂˇch') WHERE code = 'E4.SBM-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤinnostĂ­ negatĂ­vne ovplyvĹujĂşcich biodiverzitne citlivĂ© oblasti') WHERE code = 'E4.SBM-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zoznamu materiĂˇlnych lokalĂ­t vo vlastnĂ˝ch operĂˇciĂˇch na zĂˇklade vĂ˝sledkov identifikĂˇcie a posĂşdenia skutoÄŤnĂ˝ch a potenciĂˇlnych dopadov na biodiverzitu a ekosystĂ©my') WHERE code = 'E4.SBM-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie biodiverzitne citlivĂ˝ch oblastĂ­ ovplyvnenĂ˝ch') WHERE code = 'E4.SBM-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli identifikovanĂ© materiĂˇlne negatĂ­vne dopady tĂ˝kajĂşce sa degradĂˇcie pĂ´dy, dezertifikĂˇcie alebo zapeÄŤatenia pĂ´dy') WHERE code = 'E4.SBM-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VlastnĂ© operĂˇcie ovplyvĹujĂş ohrozenĂ© druhy') WHERE code = 'E4.SBM-3_06';

-- E4.IRO-1: Proces identifikĂˇcie dopadov, rizĂ­k a prĂ­leĹľitostĂ­
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli identifikovanĂ© a posĂşdenĂ© skutoÄŤnĂ© a potenciĂˇlne dopady na biodiverzitu a ekosystĂ©my na vlastnĂ˝ch lokalitĂˇch a v hodnotovom reĹĄazci') WHERE code = 'E4.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli identifikovanĂ© a posĂşdenĂ© zĂˇvislosti na biodiverzite a ekosystĂ©moch a ich sluĹľbĂˇch na vlastnĂ˝ch lokalitĂˇch a v hodnotovom reĹĄazci') WHERE code = 'E4.IRO-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli identifikovanĂ© a posĂşdenĂ© tranzitnĂ© a fyzickĂ© rizikĂˇ a prĂ­leĹľitosti sĂşvisiace s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4.IRO-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli zvaĹľovanĂ© systĂ©movĂ© rizikĂˇ (biodiverzita a ekosystĂ©my)') WHERE code = 'E4.IRO-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli vykonanĂ© konzultĂˇcie s dotknutĂ˝mi komunitami o posĂşdeniach udrĹľateÄľnosti zdieÄľanĂ˝ch biologickĂ˝ch zdrojov a ekosystĂ©mov') WHERE code = 'E4.IRO-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako konkrĂ©tne lokality, vĂ˝roba alebo zĂ­skavanie surovĂ­n s negatĂ­vnymi alebo potenciĂˇlne negatĂ­vnymi dopadmi na dotknutĂ© komunity') WHERE code = 'E4.IRO-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako boli komunity zapojenĂ© do posĂşdenia materiality') WHERE code = 'E4.IRO-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa moĹľno vyhnĂşĹĄ negatĂ­vnym dopadom na prioritnĂ© ekosystĂ©movĂ© sluĹľby relevantnĂ© pre dotknutĂ© komunity') WHERE code = 'E4.IRO-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plĂˇnov na minimalizĂˇciu nevyhnutnĂ˝ch negatĂ­vnych dopadov a implementĂˇciu zmierĹujĂşcich opatrenĂ­, ktorĂ© majĂş za cieÄľ udrĹľaĹĄ hodnotu a funkÄŤnosĹĄ prioritnĂ˝ch sluĹľieb') WHERE code = 'E4.IRO-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako bol obchodnĂ˝ model overenĂ˝ pomocou radu scenĂˇrov biodiverzity a ekosystĂ©mov alebo inĂ˝ch scenĂˇrov s modelovanĂ­m dĂ´sledkov sĂşvisiacich s biodiverzitou a ekosystĂ©mami s rĂ´znymi moĹľnĂ˝mi cestami') WHERE code = 'E4.IRO-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie dĂ´vodov, preÄŤo boli zvaĹľovanĂ© scenĂˇre zohÄľadnenĂ©') WHERE code = 'E4.IRO-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa zvaĹľovanĂ© scenĂˇre aktualizujĂş podÄľa vyvĂ­jajĂşcich sa podmienok a vznikajĂşcich trendov') WHERE code = 'E4.IRO-1_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ScenĂˇre sĂş informovanĂ© oÄŤakĂˇvaniami v autoritatĂ­vnych medzivlĂˇdnych nĂˇstrojoch a vedeckĂ˝m konsenzom') WHERE code = 'E4.IRO-1_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik mĂˇ lokality umiestnenĂ© v alebo v blĂ­zkosti biodiverzitne citlivĂ˝ch oblastĂ­') WHERE code = 'E4.IRO-1_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ÄŚinnosti sĂşvisiace s lokalitami umiestnenĂ© v alebo v blĂ­zkosti biodiverzitne citlivĂ˝ch oblastĂ­ negatĂ­vne ovplyvĹujĂş tieto oblasti vedenĂ­m k zhorĹˇovaniu prĂ­rodnĂ˝ch habitatov a habitatov druhov a k naruĹˇeniu druhov, pre ktorĂ© bola chrĂˇnenĂˇ oblasĹĄ urÄŤenĂˇ') WHERE code = 'E4.IRO-1_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Bolo dospenĂ© k zĂˇveru, Ĺľe je potrebnĂ© implementovaĹĄ zmierĹujĂşce opatrenia tĂ˝kajĂşce sa biodiverzity') WHERE code = 'E4.IRO-1_16';

-- E4-1: StratĂ©gia a odolnosĹĄ
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odolnosti sĂşÄŤasnĂ©ho obchodnĂ©ho modelu(-ov) a stratĂ©gie voÄŤi fyzickĂ˝m, tranzitnĂ˝m a systĂ©movĂ˝m rizikĂˇm a prĂ­leĹľitostiam sĂşvisiacim s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu analĂ˝zy odolnosti pozdÄşĹľ vlastnĂ˝ch operĂˇciĂ­ a sĂşvisiaceho vyĹˇĹˇieho a niĹľĹˇieho hodnotovĂ©ho reĹĄazca') WHERE code = 'E4-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kÄľĂşÄŤovĂ˝ch predpokladov urobenĂ˝ch (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ˝ch horizontov pouĹľitĂ˝ch pre analĂ˝zu (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĂ˝sledkov analĂ˝zy odolnosti (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zapojenia zainteresovanĂ˝ch strĂˇn (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie prechodnĂ©ho plĂˇnu na zlepĹˇenie a dosiahnutie zosĂşladenia jeho obchodnĂ©ho modelu a stratĂ©gie') WHERE code = 'E4-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sa stratĂ©gia a obchodnĂ˝ model upravia na zlepĹˇenie a nakoniec dosiahnutie zosĂşladenia s relevantnĂ˝mi miestnymi, nĂˇrodnĂ˝mi a globĂˇlnymi cieÄľmi verejnej politiky') WHERE code = 'E4-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zahrnutie informĂˇciĂ­ o vlastnĂ˝ch operĂˇciĂˇch a vysvetlenie toho, ako reaguje na materiĂˇlne dopady vo svojom sĂşvisiacom hodnotovom reĹĄazci') WHERE code = 'E4-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako stratĂ©gia interaguje s prechodnĂ˝m plĂˇnom') WHERE code = 'E4-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie prĂ­nosu k hnacĂ­m silĂˇm dopadu a moĹľnĂ˝ch zmierĹujĂşcich akciĂ­ podÄľa hierarchie zmierĹovania a hlavnej cestovej zĂˇvislosti a uzamknutĂ˝ch aktĂ­v a zdrojov, ktorĂ© sĂş spojenĂ© so zmenou biodiverzity a ekosystĂ©mov') WHERE code = 'E4-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie a kvantifikĂˇcia investĂ­ciĂ­ a financovania podporujĂşcich implementĂˇciu jeho prechodnĂ©ho plĂˇnu') WHERE code = 'E4-1_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie cieÄľov alebo plĂˇnov na zosĂşladenie ekonomickĂ˝ch aktivĂ­t (prĂ­jmy, CapEx)') WHERE code = 'E4-1_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'BiodiverzitnĂ© kompenzĂˇcie sĂş sĂşÄŤasĹĄou prechodnĂ©ho plĂˇnu') WHERE code = 'E4-1_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o tom, ako sa riadi proces implementĂˇcie a aktualizĂˇcie prechodnĂ©ho plĂˇnu') WHERE code = 'E4-1_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Uvedenie metrĂ­k a sĂşvisiacich nĂˇstrojov pouĹľitĂ˝ch na meranie pokroku, ktorĂ© sĂş integrovanĂ© do prĂ­stupu merania (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-1_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AdministratĂ­vne, riadiace a dozornĂ© orgĂˇny schvĂˇlili prechodnĂ˝ plĂˇn') WHERE code = 'E4-1_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Uvedenie sĂşÄŤasnĂ˝ch vĂ˝ziev a obmedzenĂ­ pri vypracovanĂ­ plĂˇnu vo vzĹĄahu k oblastiam vĂ˝znamnĂ©ho dopadu a opatrenĂ­, ktorĂ© spoloÄŤnosĹĄ prijĂ­ma na ich rieĹˇenie (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-1_18';

-- E4-2: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiĂˇlnych dopadov, rizĂ­k, zĂˇvislostĂ­ a prĂ­leĹľitostĂ­ sĂşvisiacich s biodiverzitou a ekosystĂ©mami [pozri ESRS 2 - MDR-P]') WHERE code = 'E4.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako sa politiky sĂşvisiace s biodiverzitou a ekosystĂ©mami tĂ˝kajĂş zĂˇleĹľitostĂ­ uvedenĂ˝ch v E4 AR4') WHERE code = 'E4-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi a ako sa politika sĂşvisiaca s biodiverzitou a ekosystĂ©mami tĂ˝ka materiĂˇlnych dopadov sĂşvisiacich s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi a ako sa politika sĂşvisiaca s biodiverzitou a ekosystĂ©mami tĂ˝ka materiĂˇlnych zĂˇvislostĂ­ a materiĂˇlnych fyzickĂ˝ch a tranzitnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­') WHERE code = 'E4-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi a ako politika sĂşvisiaca s biodiverzitou a ekosystĂ©mami podporuje vysledovateÄľnosĹĄ produktov, komponentov a surovĂ­n s vĂ˝znamnĂ˝mi skutoÄŤnĂ˝mi alebo potenciĂˇlnymi dopadmi na biodiverzitu a ekosystĂ©my pozdÄşĹľ hodnotovĂ©ho reĹĄazca') WHERE code = 'E4-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi a ako politika sĂşvisiaca s biodiverzitou a ekosystĂ©mami rieĹˇi vĂ˝robu, zĂ­skavanie alebo spotrebu z ekosystĂ©mov, ktorĂ© sa riadia tak, aby sa udrĹľali alebo zlepĹˇili podmienky pre biodiverzitu') WHERE code = 'E4-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi a ako politika sĂşvisiaca s biodiverzitou a ekosystĂ©mami rieĹˇi sociĂˇlne dĂ´sledky dopadov sĂşvisiacich s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa politika tĂ˝ka vĂ˝roby, zĂ­skavania alebo spotreby surovĂ­n') WHERE code = 'E4-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa politika tĂ˝ka politĂ­k obmedzujĂşcich obstarĂˇvanie od dodĂˇvateÄľov, ktorĂ­ nemĂ´Ĺľu preukĂˇzaĹĄ, Ĺľe neprispieva k vĂ˝znamnĂ©mu prestavovaniu chrĂˇnenĂ˝ch oblastĂ­ alebo kÄľĂşÄŤovĂ˝ch biodiverzitnĂ˝ch oblastĂ­') WHERE code = 'E4-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa politika tĂ˝ka uznĂˇvanĂ˝ch noriem alebo certifikĂˇciĂ­ tretĂ­ch strĂˇn dohÄľadovanĂ˝ch regulĂˇtormi') WHERE code = 'E4-2_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako politika rieĹˇi suroviny pochĂˇdzajĂşce z ekosystĂ©mov, ktorĂ© boli riadenĂ© tak, aby sa udrĹľali alebo zlepĹˇili podmienky pre biodiverzitu, ako to preukazuje pravidelnĂ© monitorovanie a podĂˇvanie sprĂˇv o stave biodiverzity a prĂ­rastkoch alebo stratĂˇch') WHERE code = 'E4-2_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako politika umoĹľĹuje a), b), c) a d)') WHERE code = 'E4-2_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma sprĂˇvania tretĂ­ch strĂˇn pouĹľitĂˇ v politike je objektĂ­vna a dosiahnuteÄľnĂˇ na zĂˇklade vedeckĂ©ho prĂ­stupu k identifikĂˇcii problĂ©mov a realistickĂˇ pri hodnotenĂ­ toho, ako moĹľno tieto problĂ©my rieĹˇiĹĄ za rĂ´znych praktickĂ˝ch okolnostĂ­') WHERE code = 'E4-2_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma sprĂˇvania tretĂ­ch strĂˇn pouĹľitĂˇ v politike je vyvinutĂˇ alebo udrĹľiavanĂˇ prostrednĂ­ctvom procesu prebiehajĂşcich konzultĂˇciĂ­ s relevantnĂ˝mi zainteresovanĂ˝mi stranami s vyvĂˇĹľenĂ˝m prĂ­spevkom od vĹˇetkĂ˝ch relevantnĂ˝ch skupĂ­n zainteresovanĂ˝ch strĂˇn bez toho, aby Ĺľiadna skupina mala neprimeranĂ© oprĂˇvnenia alebo prĂˇvo veta nad obsahom') WHERE code = 'E4-2_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma sprĂˇvania tretĂ­ch strĂˇn pouĹľitĂˇ v politike podporuje postupnĂ˝ prĂ­stup a neustĂˇle zlepĹˇovanie normy a jej aplikĂˇcie lepĹˇĂ­ch manaĹľĂ©rskych postupov a vyĹľaduje stanovenie zmysluplnĂ˝ch cieÄľov a konkrĂ©tnych mĂ­Äľnikov na oznaÄŤenie pokroku voÄŤi zĂˇsadĂˇm a kritĂ©riĂˇm v priebehu ÄŤasu') WHERE code = 'E4-2_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma sprĂˇvania tretĂ­ch strĂˇn pouĹľitĂˇ v politike je overiteÄľnĂˇ nezĂˇvislĂ˝mi certifikaÄŤnĂ˝mi alebo overovacĂ­mi orgĂˇnmi, ktorĂ© majĂş definovanĂ© a prĂ­sne hodnotiace postupy, ktorĂ© sa vyhĂ˝bajĂş konfliktom zĂˇujmov a sĂş v sĂşlade s usmerneniami ISO o akreditĂˇcii a overovacĂ­ch postupoch alebo ÄŤlĂˇnkom 5(2) nariadenia (ES) ÄŤ. 765/2008') WHERE code = 'E4-2_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Norma sprĂˇvania tretĂ­ch strĂˇn pouĹľitĂˇ v politike je v sĂşlade s ISEAL Code of Good Practice') WHERE code = 'E4-2_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Bola prijatĂˇ politika ochrany biodiverzity a ekosystĂ©mov pokrĂ˝vajĂşca prevĂˇdzkovĂ© lokality vlastnenĂ©, prenajĂ­manĂ©, riadenĂ© v alebo v blĂ­zkosti chrĂˇnenej oblasti alebo biodiverzitne citlivej oblasti mimo chrĂˇnenĂ˝ch oblastĂ­') WHERE code = 'E4-2_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijatĂ© postupy alebo politiky udrĹľateÄľnĂ©ho vyuĹľĂ­vania pĂ´dy alebo poÄľnohospodĂˇrstva') WHERE code = 'E4-2_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijatĂ© postupy alebo politiky udrĹľateÄľnĂ˝ch oceĂˇnov alebo morĂ­') WHERE code = 'E4-2_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Boli prijatĂ© politiky na rieĹˇenie odlesĹovania') WHERE code = 'E4-2_20';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal politiky') WHERE code = 'E4.MDR-P_07-08';

-- E4-3: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje tĂ˝kajĂşce sa biodiverzity a ekosystĂ©mov [pozri ESRS 2 - MDR-A]') WHERE code = 'E4.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako bola aplikovanĂˇ hierarchia zmierĹovania vzhÄľadom na akcie tĂ˝kajĂşce sa biodiverzity a ekosystĂ©mov') WHERE code = 'E4-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'BiodiverzitnĂ© kompenzĂˇcie boli pouĹľitĂ© v akÄŤnom plĂˇne') WHERE code = 'E4-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie cieÄľa biodiverzitnej kompenzĂˇcie a pouĹľitĂ˝ch kÄľĂşÄŤovĂ˝ch ukazovateÄľov vĂ˝konnosti') WHERE code = 'E4-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'FinanÄŤnĂ© ĂşÄŤinky (priame a nepriame nĂˇklady) biodiverzitnĂ˝ch kompenzĂˇciĂ­') WHERE code = 'E4-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzĹĄahu vĂ˝znamnĂ˝ch CapEx a OpEx potrebnĂ˝ch na implementĂˇciu prijatĂ˝ch alebo plĂˇnovanĂ˝ch opatrenĂ­ k relevantnĂ˝m riadkovĂ˝m poloĹľkĂˇm alebo poznĂˇmkam vo finanÄŤnĂ˝ch vĂ˝kazoch') WHERE code = 'E4-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzĹĄahu vĂ˝znamnĂ˝ch CapEx a OpEx potrebnĂ˝ch na implementĂˇciu prijatĂ˝ch alebo plĂˇnovanĂ˝ch opatrenĂ­ ku kÄľĂşÄŤovĂ˝m ukazovateÄľom vĂ˝konnosti poĹľadovanĂ˝m podÄľa delegovanĂ©ho nariadenia Komisie (EĂš) 2021/2178') WHERE code = 'E4-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie vzĹĄahu vĂ˝znamnĂ˝ch CapEx a OpEx potrebnĂ˝ch na implementĂˇciu prijatĂ˝ch alebo plĂˇnovanĂ˝ch opatrenĂ­ k plĂˇnu CapEx poĹľadovanĂ©mu podÄľa delegovanĂ©ho nariadenia Komisie (EĂš) 2021/2178') WHERE code = 'E4-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis biodiverzitnĂ˝ch kompenzĂˇciĂ­') WHERE code = 'E4-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ÄŤi a ako boli do akciĂ­ sĂşvisiacich s biodiverzitou a ekosystĂ©mami zaÄŤlenenĂ© miestne a domorodĂ© znalosti a rieĹˇenia zaloĹľenĂ© na prĂ­rode') WHERE code = 'E4-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kÄľĂşÄŤovĂ˝ch zainteresovanĂ˝ch strĂˇn zapojenĂ˝ch a ako sĂş zapojenĂ©, kÄľĂşÄŤovĂ˝ch zainteresovanĂ˝ch strĂˇn negatĂ­vne alebo pozitĂ­vne ovplyvnenĂ˝ch akciou a ako sĂş ovplyvnenĂ©') WHERE code = 'E4-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie potreby vhodnĂ˝ch konzultĂˇciĂ­ a potreby reĹˇpektovaĹĄ rozhodnutia dotknutĂ˝ch komunĂ­t') WHERE code = 'E4-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ÄŤi mĂ´Ĺľe kÄľĂşÄŤovĂˇ akcia vyvolaĹĄ vĂ˝znamnĂ© negatĂ­vne dopady na udrĹľateÄľnosĹĄ (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ÄŤi je kÄľĂşÄŤovĂˇ akcia urÄŤenĂˇ ako jednorazovĂˇ iniciatĂ­va alebo systematickĂˇ prax') WHERE code = 'E4-3_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'KÄľĂşÄŤovĂ˝ akÄŤnĂ˝ plĂˇn vykonĂˇva iba podnik (individuĂˇlna akcia) s vyuĹľitĂ­m vlastnĂ˝ch zdrojov (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-3_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'KÄľĂşÄŤovĂ˝ akÄŤnĂ˝ plĂˇn je sĂşÄŤasĹĄou ĹˇirĹˇieho akÄŤnĂ©ho plĂˇnu (kolektĂ­vna akcia), ktorĂ©ho ÄŤlenom je podnik (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-3_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'DodatoÄŤnĂ© informĂˇcie o projekte, jeho sponzoroch a ÄŹalĹˇĂ­ch ĂşÄŤastnĂ­koch (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-3_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal akcie') WHERE code = 'E4.MDR-A_13-14';

-- E4-4: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektĂ­vnosti politĂ­k a akciĂ­ prostrednĂ­ctvom cieÄľov [pozri ESRS 2 MDR-T]') WHERE code = 'E4.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pri stanovenĂ­ cieÄľa boli pouĹľitĂ© ekologickĂ˝ prah a pridelenie dopadov podniku (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovanĂ©ho ekologickĂ©ho prahu a metodolĂłgie pouĹľitej na identifikĂˇciu prahu (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako bol urÄŤenĂ˝ prah ĹˇpecifickĂ˝ pre subjekt (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako je pridelenĂˇ zodpovednosĹĄ za reĹˇpektovanie identifikovanĂ©ho ekologickĂ©ho prahu (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ je informovanĂ˝ relevantnĂ˝m aspektom StratĂ©gie biodiverzity EĂš pre rok 2030') WHERE code = 'E4-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa ciele tĂ˝kajĂş dopadov, zĂˇvislostĂ­, rizĂ­k a prĂ­leĹľitostĂ­ biodiverzity a ekosystĂ©mov identifikovanĂ˝ch vo vzĹĄahu k vlastnĂ˝m operĂˇciĂˇm a vyĹˇĹˇiemu a niĹľĹˇiemu hodnotovĂ©mu reĹĄazcu') WHERE code = 'E4-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie geografickĂ©ho rozsahu cieÄľov') WHERE code = 'E4-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'BiodiverzitnĂ© kompenzĂˇcie boli pouĹľitĂ© pri stanovenĂ­ cieÄľa') WHERE code = 'E4-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ĂšroveĹ v hierarchii zmierĹovania, do ktorej moĹľno priradiĹĄ cieÄľ (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ rieĹˇi nedostatky tĂ˝kajĂşce sa kritĂ©riĂ­ podstatnĂ©ho prĂ­nosu') WHERE code = 'E4-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal ciele') WHERE code = 'E4.MDR-T_14-19';

-- E4-5: Metriky dopadov
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet lokalĂ­t vlastnenĂ˝ch, prenajĂ­manĂ˝ch alebo riadenĂ˝ch v alebo v blĂ­zkosti chrĂˇnenĂ˝ch oblastĂ­ alebo kÄľĂşÄŤovĂ˝ch biodiverzitnĂ˝ch oblastĂ­, ktorĂ© podnik negatĂ­vne ovplyvĹuje') WHERE code = 'E4-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Plocha lokalĂ­t vlastnenĂ˝ch, prenajĂ­manĂ˝ch alebo riadenĂ˝ch v alebo v blĂ­zkosti chrĂˇnenĂ˝ch oblastĂ­ alebo kÄľĂşÄŤovĂ˝ch biodiverzitnĂ˝ch oblastĂ­, ktorĂ© podnik negatĂ­vne ovplyvĹuje') WHERE code = 'E4-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vyuĹľĂ­vania pĂ´dy na zĂˇklade posĂşdenia ĹľivotnĂ©ho cyklu') WHERE code = 'E4-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie metrĂ­k povaĹľovanĂ˝ch za relevantnĂ© (zmena vyuĹľĂ­vania pĂ´dy, zmena vyuĹľĂ­vania sladkĂ˝ch vĂ´d a (alebo) zmena vyuĹľĂ­vania mora)') WHERE code = 'E4-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie premeny pokryvu pĂ´dy v priebehu ÄŤasu') WHERE code = 'E4-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v priebehu ÄŤasu v riadenĂ­ ekosystĂ©mu') WHERE code = 'E4-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v priestorovej konfigurĂˇcii krajiny') WHERE code = 'E4-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v ĹˇtrukturĂˇlnej konektivite ekosystĂ©mu') WHERE code = 'E4-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkÄŤnej konektivity') WHERE code = 'E4-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© vyuĹľĂ­vanie plochy pĂ´dy') WHERE code = 'E4-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ zapeÄŤatenĂˇ plocha') WHERE code = 'E4-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PrĂ­rodne orientovanĂˇ plocha na mieste') WHERE code = 'E4-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PrĂ­rodne orientovanĂˇ plocha mimo miesta') WHERE code = 'E4-5_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa riadia cesty introdukcie a ĹˇĂ­renia invĂˇznych nepĂ´vodnĂ˝ch druhov a rizikĂˇ, ktorĂ© predstavujĂş invĂˇzne nepĂ´vodnĂ© druhy') WHERE code = 'E4-5_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet invĂˇznych nepĂ´vodnĂ˝ch druhov') WHERE code = 'E4-5_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Plocha pokrytĂˇ invĂˇznymy nepĂ´vodnĂ˝mi druhmi') WHERE code = 'E4-5_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie metrĂ­k povaĹľovanĂ˝ch za relevantnĂ© (stav druhov)') WHERE code = 'E4-5_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odseku v inom environmentĂˇlne sĂşvisiacom Ĺˇtandarde, na ktorĂ˝ sa metrika odvolĂˇva') WHERE code = 'E4-5_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie veÄľkosti populĂˇcie, rozsahu v rĂˇmci ĹˇpecifickĂ˝ch ekosystĂ©mov a rizika vyhynutia') WHERE code = 'E4-5_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmien v poÄŤte jedincov druhov v rĂˇmci Ĺˇpecifickej oblasti') WHERE code = 'E4-5_20';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o druhoch ohrozenĂ˝ch globĂˇlnym vyhynutĂ­m') WHERE code = 'E4-5_21';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie stavu ohrozenia druhov a toho, ako mĂ´Ĺľu ÄŤinnosti alebo tlaky ovplyvniĹĄ stav ohrozenia') WHERE code = 'E4-5_22';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zmeny v relevantnom habitate pre ohrozenĂ© druhy ako proxy pre dopad na riziko vyhynutia miestnej populĂˇcie') WHERE code = 'E4-5_23';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie pokrytia plochy ekosystĂ©mu') WHERE code = 'E4-5_24';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvality ekosystĂ©mov vo vzĹĄahu k vopred urÄŤenĂ©mu referenÄŤnĂ©mu stavu') WHERE code = 'E4-5_25';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie viacerĂ˝ch druhov v rĂˇmci ekosystĂ©mu') WHERE code = 'E4-5_26';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇtrukturĂˇlnych komponentov stavu ekosystĂ©mu') WHERE code = 'E4-5_27';

-- E4-6: PredpokladanĂ© finanÄŤnĂ© ĂşÄŤinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ sĂşvisiacich s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ sĂşvisiacich s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvaĹľovanĂ˝ch ĂşÄŤinkov, sĂşvisiacich dopadov a zĂˇvislostĂ­ (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritickĂ˝ch predpokladov pouĹľitĂ˝ch v odhadoch finanÄŤnĂ˝ch ĂşÄŤinkov materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ sĂşvisiacich s biodiverzitou a ekosystĂ©mami') WHERE code = 'E4-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis sĂşvisiacich produktov a sluĹľieb ohrozenĂ˝ch (biodiverzita a ekosystĂ©my) v krĂˇtkom, strednom a dlhom ÄŤasovom horizonte') WHERE code = 'E4-6_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sĂş odhadovanĂ© finanÄŤnĂ© ÄŤiastky a urobenĂ© kritickĂ© predpoklady (biodiverzita a ekosystĂ©my)') WHERE code = 'E4-6_06';

-- ============================================================================
-- ESRS E5: OBEHOVĂ‰ HOSPODĂRSTVO A ZDROJE (RESOURCE USE AND CIRCULAR ECONOMY)
-- ============================================================================

-- E5.IRO-1: Proces identifikĂˇcie dopadov, rizĂ­k a prĂ­leĹľitostĂ­
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi podnik preskĂşmal svoje aktĂ­va a ÄŤinnosti s cieÄľom identifikovaĹĄ skutoÄŤnĂ© a potenciĂˇlne dopady, rizikĂˇ a prĂ­leĹľitosti vo vlastnĂ˝ch operĂˇciĂˇch a vo vyĹˇĹˇom a niĹľĹˇom hodnotovom reĹĄazci, a ak Ăˇno, pouĹľitĂ© metodolĂłgie, predpoklady a nĂˇstroje') WHERE code = 'E5.IRO-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako podnik vykonal konzultĂˇcie (zdroje a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5.IRO-1_02';

-- E5-1: Politiky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiĂˇlnych dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s vyuĹľĂ­vanĂ­m zdrojov a obehovĂ˝m hospodĂˇrstvom [pozri ESRS 2 MDR-P]') WHERE code = 'E5.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi prechod od pouĹľĂ­vania panenskĂ˝ch zdrojov, vrĂˇtane relatĂ­vneho zvĂ˝Ĺˇenia pouĹľĂ­vania sekundĂˇrnych (recyklovanĂ˝ch) zdrojov') WHERE code = 'E5-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ÄŤi a ako politika rieĹˇi udrĹľateÄľnĂ© zĂ­skavanie a pouĹľĂ­vanie obnoviteÄľnĂ˝ch zdrojov') WHERE code = 'E5-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ÄŤi a ako politika rieĹˇi hierarchiu odpadov (prevencia, prĂ­prava na opĂ¤tovnĂ© pouĹľitie, recyklĂˇcia, inĂ© zhodnotenie, zneĹˇkodnenie)') WHERE code = 'E5-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ÄŤi a ako politika rieĹˇi uprednostĹovanie stratĂ©giĂ­ na predchĂˇdzanie alebo minimalizĂˇciu odpadov pred stratĂ©giami spracovania odpadov') WHERE code = 'E5-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal politiky') WHERE code = 'E5.MDR-P_07-08';

-- E5-2: Akcie a zdroje
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Akcie a zdroje tĂ˝kajĂşce sa vyuĹľĂ­vania zdrojov a obehovĂ©ho hospodĂˇrstva [pozri ESRS 2 MDR-A]') WHERE code = 'E5.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vyĹˇĹˇĂ­ch ĂşrovnĂ­ efektĂ­vnosti zdrojov pri pouĹľĂ­vanĂ­ technickĂ˝ch a biologickĂ˝ch materiĂˇlov a vody') WHERE code = 'E5-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vyĹˇĹˇĂ­ch mier pouĹľĂ­vania sekundĂˇrnych surovĂ­n') WHERE code = 'E5-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis aplikĂˇcie obehovĂ©ho dizajnu') WHERE code = 'E5-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis aplikĂˇcie obehovĂ˝ch obchodnĂ˝ch praktĂ­k') WHERE code = 'E5-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis akciĂ­ prijatĂ˝ch na prevenciu vzniku odpadu v hodnotovom reĹĄazci podniku smerom nahor a nadol') WHERE code = 'E5-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis optimalizĂˇcie odpadovĂ©ho hospodĂˇrstva') WHERE code = 'E5-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o kolektĂ­vnej akcii na rozvoj spoluprĂˇce alebo iniciatĂ­v zvyĹˇujĂşcich cirkularitu produktov a materiĂˇlov') WHERE code = 'E5-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­nosu k obehovĂ©mu hospodĂˇrstvu') WHERE code = 'E5-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ÄŹalĹˇĂ­ch zainteresovanĂ˝ch strĂˇn zapojenĂ˝ch do kolektĂ­vnej akcie (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-2_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis organizĂˇcie projektu (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-2_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal akcie') WHERE code = 'E5.MDR-A_13-14';

-- E5-3: Ciele
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Sledovanie efektĂ­vnosti politĂ­k a akciĂ­ prostrednĂ­ctvom cieÄľov [pozri ESRS 2 MDR-T]') WHERE code = 'E5.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka zdrojov (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka zvĂ˝Ĺˇenia obehovĂ©ho dizajnu') WHERE code = 'E5-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka zvĂ˝Ĺˇenia miery pouĹľĂ­vania obehovĂ˝ch materiĂˇlov') WHERE code = 'E5-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka minimalizĂˇcie primĂˇrnych surovĂ­n') WHERE code = 'E5-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka obrĂˇtenia vyÄŤerpania zĂˇsob obnoviteÄľnĂ˝ch zdrojov') WHERE code = 'E5-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CieÄľ sa tĂ˝ka odpadovĂ©ho hospodĂˇrstva') WHERE code = 'E5-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka odpadovĂ©ho hospodĂˇrstva') WHERE code = 'E5-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako sa cieÄľ tĂ˝ka inĂ˝ch zĂˇleĹľitostĂ­ sĂşvisiacich s vyuĹľĂ­vanĂ­m zdrojov alebo obehovĂ˝m hospodĂˇrstvom') WHERE code = 'E5-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ĂšroveĹ v hierarchii odpadov, na ktorĂş sa cieÄľ vzĹĄahuje') WHERE code = 'E5-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie identifikovanĂ©ho ekologickĂ©ho prahu a metodolĂłgie pouĹľitej na identifikĂˇciu ekologickĂ©ho prahu (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako bol urÄŤenĂ˝ ekologickĂ˝ prah ĹˇpecifickĂ˝ pre subjekt (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o tom, ako je pridelenĂˇ zodpovednosĹĄ za reĹˇpektovanie identifikovanĂ©ho ekologickĂ©ho prahu (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'StanovovanĂ© a prezentovanĂ© ciele sĂş povinnĂ© (vyĹľadovanĂ© legislatĂ­vou)') WHERE code = 'E5-3_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal ciele') WHERE code = 'E5.MDR-T_14-19';

-- E5-4: PrĂ­toky zdrojov
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie informĂˇciĂ­ o materiĂˇlnych prĂ­tokoch zdrojov') WHERE code = 'E5-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂˇ hmotnosĹĄ produktov a technickĂ˝ch a biologickĂ˝ch materiĂˇlov pouĹľitĂ˝ch poÄŤas vykazovanĂ©ho obdobia') WHERE code = 'E5-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel biologickĂ˝ch materiĂˇlov (a biopalĂ­v pouĹľĂ­vanĂ˝ch na neenergetickĂ© ĂşÄŤely)') WHERE code = 'E5-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AbsolĂştna hmotnosĹĄ sekundĂˇrnych opĂ¤tovne pouĹľitĂ˝ch alebo recyklovanĂ˝ch komponentov, sekundĂˇrnych medziproduktov a sekundĂˇrnych materiĂˇlov pouĹľitĂ˝ch na vĂ˝robu produktov a sluĹľieb podniku (vrĂˇtane obalov)') WHERE code = 'E5-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel sekundĂˇrnych opĂ¤tovne pouĹľitĂ˝ch alebo recyklovanĂ˝ch komponentov, sekundĂˇrnych medziproduktov a sekundĂˇrnych materiĂˇlov') WHERE code = 'E5-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodolĂłgiĂ­ pouĹľitĂ˝ch na vĂ˝poÄŤet Ăşdajov a kÄľĂşÄŤovĂ˝ch pouĹľitĂ˝ch predpokladov') WHERE code = 'E5-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis materiĂˇlov, ktorĂ© sĂş zĂ­skavanĂ© z vedÄľajĹˇĂ­ch produktov alebo odpadovĂ©ho prĂşdu') WHERE code = 'E5-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako sa vyhlo dvojitĂ©mu poÄŤĂ­taniu a vykonanĂ˝ch volieb') WHERE code = 'E5-4_08';

-- E5-5: Odtoky zdrojov
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis kÄľĂşÄŤovĂ˝ch produktov a materiĂˇlov, ktorĂ© vychĂˇdzajĂş z vĂ˝robnĂ©ho procesu podniku') WHERE code = 'E5-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie oÄŤakĂˇvanej Ĺľivotnosti produktov uvedenĂ˝ch na trh vo vzĹĄahu k priemeru v odvetvĂ­ pre kaĹľdĂş skupinu produktov') WHERE code = 'E5-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie opraviteÄľnosti produktov') WHERE code = 'E5-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Miera recyklovateÄľnĂ©ho obsahu v produktoch') WHERE code = 'E5-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Miera recyklovateÄľnĂ©ho obsahu v obaloch produktov') WHERE code = 'E5-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodolĂłgiĂ­ pouĹľitĂ˝ch na vĂ˝poÄŤet Ăşdajov (odtoky zdrojov)') WHERE code = 'E5-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ˝ odpad generovanĂ˝') WHERE code = 'E5-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Odpad odklonenĂ˝ od zneĹˇkodnenia, rozdelenie podÄľa nebezpeÄŤnĂ©ho a nebezpeÄŤnĂ©ho odpadu a typu spracovania') WHERE code = 'E5-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Odpad smerovanĂ˝ na zneĹˇkodnenie, rozdelenie podÄľa nebezpeÄŤnĂ©ho a nebezpeÄŤnĂ©ho odpadu a typu spracovania') WHERE code = 'E5-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'NerecyklovanĂ˝ odpad') WHERE code = 'E5-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel nerecyklovanĂ©ho odpadu') WHERE code = 'E5-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zloĹľenia odpadu') WHERE code = 'E5-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie prĂşdov odpadu relevantnĂ˝ch pre sektor alebo ÄŤinnosti podniku') WHERE code = 'E5-5_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie materiĂˇlov prĂ­tomnĂ˝ch v odpade') WHERE code = 'E5-5_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo nebezpeÄŤnĂ©ho odpadu') WHERE code = 'E5-5_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'CelkovĂ© mnoĹľstvo rĂˇdioaktĂ­vneho odpadu') WHERE code = 'E5-5_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodolĂłgiĂ­ pouĹľitĂ˝ch na vĂ˝poÄŤet Ăşdajov (generovanĂ˝ odpad)') WHERE code = 'E5-5_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie jeho zapojenia do odpadovĂ©ho hospodĂˇrstva produktov na konci Ĺľivotnosti') WHERE code = 'E5-5_18';

-- E5-6: PredpokladanĂ© finanÄŤnĂ© ĂşÄŤinky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvantitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich s vyuĹľĂ­vanĂ­m zdrojov a obehovĂ˝m hospodĂˇrstvom') WHERE code = 'E5-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kvalitatĂ­vnych informĂˇciĂ­ o predpokladanĂ˝ch finanÄŤnĂ˝ch ĂşÄŤinkoch materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich s vyuĹľĂ­vanĂ­m zdrojov a obehovĂ˝m hospodĂˇrstvom') WHERE code = 'E5-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zvaĹľovanĂ˝ch ĂşÄŤinkov a sĂşvisiacich dopadov (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kritickĂ˝ch predpokladov pouĹľitĂ˝ch v odhadoch finanÄŤnĂ˝ch ĂşÄŤinkov materiĂˇlnych rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov sĂşvisiacich s vyuĹľĂ­vanĂ­m zdrojov a obehovĂ˝m hospodĂˇrstvom') WHERE code = 'E5-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis sĂşvisiacich produktov a sluĹľieb ohrozenĂ˝ch (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-6_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie toho, ako sĂş definovanĂ© ÄŤasovĂ© horizonty, odhadnutĂ© finanÄŤnĂ© ÄŤiastky a urobenĂ© kritickĂ© predpoklady (vyuĹľĂ­vanie zdrojov a obehovĂ© hospodĂˇrstvo)') WHERE code = 'E5-6_06';

-- ============================================================================
-- END OF TRANSLATIONS
-- ============================================================================
-- ============================================================================
-- ESRS S1 (VlastnĂˇ pracovnĂˇ sila) - SlovenskĂ© preklady
-- ============================================================================
-- Ĺ tandard ESRS S1 sa zaoberĂˇ vlastnou pracovnou silou organizĂˇcie
-- ZahĹ•Ĺa tĂ©my: zamestnanci, pracovnĂ© podmienky, zdravie a bezpeÄŤnosĹĄ,
-- odmeĹovanie, diverzita, rovnosĹĄ prĂ­leĹľitostĂ­ a ÄľudskĂ© prĂˇva v prĂˇci
-- ============================================================================

-- S1.SBM-3: PodstatnĂ© dopady, rizikĂˇ a prĂ­leĹľitosti a ich interakcia s stratĂ©giou a obchodnĂ˝m modelom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci Äľudia vo vlastnej pracovnej sile, ktorĂ­ mĂ´Ĺľu byĹĄ podstatne ovplyvnenĂ­ podnikom, sĂş zahrnutĂ­ do rozsahu zverejnenia podÄľa ESRS 2') WHERE code = 'S1.SBM-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov zamestnancov a nezamestnancov vo vlastnej pracovnej sile, ktorĂ­ sĂş predmetom podstatnĂ˝ch dopadov') WHERE code = 'S1.SBM-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝skyt podstatnĂ˝ch negatĂ­vnych dopadov (vlastnĂˇ pracovnĂˇ sila)') WHERE code = 'S1.SBM-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ÄŤinnostĂ­, ktorĂ© vedĂş k pozitĂ­vnym dopadom a typy zamestnancov a nezamestnancov vo vlastnej pracovnej sile, ktorĂ­ sĂş alebo by mohli byĹĄ pozitĂ­vne ovplyvnenĂ­') WHERE code = 'S1.SBM-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis podstatnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na vlastnej pracovnej sile') WHERE code = 'S1.SBM-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis podstatnĂ˝ch dopadov na pracovnĂ­kov, ktorĂ© mĂ´Ĺľu vyplynĂşĹĄ z plĂˇnov prechodu na znĂ­Ĺľenie negatĂ­vnych dopadov na ĹľivotnĂ© prostredie a dosiahnutie ekologickejĹˇĂ­ch a klimaticky neutrĂˇlnych operĂˇciĂ­') WHERE code = 'S1.SBM-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o type operĂˇciĂ­ s vĂ˝znamnĂ˝m rizikom incidentov nĂştenej prĂˇce alebo povinnej prĂˇce') WHERE code = 'S1.SBM-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o krajinĂˇch alebo geografickĂ˝ch oblastiach s operĂˇciami povaĹľovanĂ˝mi za rizikovĂ© z hÄľadiska incidentov nĂştenej prĂˇce alebo povinnej prĂˇce') WHERE code = 'S1.SBM-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o type operĂˇciĂ­ s vĂ˝znamnĂ˝m rizikom incidentov detskej prĂˇce') WHERE code = 'S1.SBM-3_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o krajinĂˇch alebo geografickĂ˝ch oblastiach s operĂˇciami povaĹľovanĂ˝mi za rizikovĂ© z hÄľadiska incidentov detskej prĂˇce') WHERE code = 'S1.SBM-3_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako bolo rozvinutĂ© pochopenie ÄľudĂ­ vo vlastnej pracovnej sile s osobitnĂ˝mi charakteristikami, pracujĂşcich v osobitnĂ˝ch kontextoch alebo vykonĂˇvajĂşcich osobitnĂ© ÄŤinnosti, ktorĂ­ mĂ´Ĺľu byĹĄ vystavenĂ­ vĂ¤ÄŤĹˇiemu riziku poĹˇkodenia') WHERE code = 'S1.SBM-3_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ktorĂ© z podstatnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na ÄľuÄŹoch vo vlastnej pracovnej sile sa tĂ˝kajĂş konkrĂ©tnych skupĂ­n ÄľudĂ­') WHERE code = 'S1.SBM-3_12';

-- S1-1: Politiky sĂşvisiace s vlastnou pracovnou silou

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s vlastnou pracovnou silou [pozri ESRS 2 MDR-P]') WHERE code = 'S1.MDR-P_01-06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s vlastnou pracovnou silou, vrĂˇtane ĹˇpecifickĂ˝ch skupĂ­n v rĂˇmci pracovnej sily alebo celej vlastnej pracovnej sily') WHERE code = 'S1-1_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlenĂ­ vĂ˝znamnĂ˝ch zmien v politikĂˇch prijatĂ˝ch poÄŤas vykazovanĂ©ho roka') WHERE code = 'S1-1_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantnĂ˝ch zĂˇvĂ¤zkov v oblasti politiky ÄľudskĂ˝ch prĂˇv tĂ˝kajĂşcich sa vlastnej pracovnej sily') WHERE code = 'S1-1_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu k reĹˇpektovaniu ÄľudskĂ˝ch prĂˇv vrĂˇtane pracovnĂ˝ch prĂˇv ÄľudĂ­ vo vlastnej pracovnej sile') WHERE code = 'S1-1_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu k angaĹľovaniu ÄľudĂ­ vo vlastnej pracovnej sile') WHERE code = 'S1-1_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu k opatreniam na zabezpeÄŤenie a (alebo) umoĹľnenie nĂˇpravy dopadov na ÄľudskĂ© prĂˇva') WHERE code = 'S1-1_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako sĂş politiky zosĂşladenĂ© s relevantnĂ˝mi medzinĂˇrodne uznĂˇvanĂ˝mi nĂˇstrojmi') WHERE code = 'S1-1_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky vĂ˝slovne rieĹˇi obchodovanie s ÄľuÄŹmi, nĂştenĂş prĂˇcu alebo povinnĂş prĂˇcu a detskĂş prĂˇcu') WHERE code = 'S1-1_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existuje politika alebo systĂ©m riadenia prevencie pracovnĂ˝ch Ăşrazov') WHERE code = 'S1-1_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş ĹˇpecifickĂ© politiky zameranĂ© na odstrĂˇnenie diskriminĂˇcie') WHERE code = 'S1-1_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'DĂ´vody diskriminĂˇcie sĂş Ĺˇpecificky pokrytĂ© v politike') WHERE code = 'S1-1_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇpecifickĂ˝ch politickĂ˝ch zĂˇvĂ¤zkov sĂşvisiacich s inklĂşziou a (alebo) pozitĂ­vnymi opatreniami pre ÄľudĂ­ zo skupĂ­n s osobitnĂ˝m rizikom zraniteÄľnosti vo vlastnej pracovnej sile') WHERE code = 'S1-1_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako sĂş politiky implementovanĂ© prostrednĂ­ctvom ĹˇpecifickĂ˝ch postupov na zabezpeÄŤenie prevencie, zmierĹovania a konania v prĂ­pade zistenia diskriminĂˇcie, ako aj na podporu diverzity a inklĂşzie') WHERE code = 'S1-1_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ilustrĂˇcie typov komunikĂˇcie politĂ­k jednotlivcom, skupinĂˇm jednotlivcov alebo subjektom, pre ktorĂ© sĂş relevantnĂ©') WHERE code = 'S1-1_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş politiky a postupy, ktorĂ© robia kvalifikĂˇciu, zruÄŤnosti a skĂşsenosti zĂˇkladom pre nĂˇbor, umiestnenie, Ĺˇkolenie a postup') WHERE code = 'S1-1_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ZodpovednosĹĄ za rovnakĂ© zaobchĂˇdzanie a prĂ­leĹľitosti v zamestnanĂ­ bola pridelenĂˇ na Ăşrovni top manaĹľmentu, vydanĂ© jasnĂ© politiky a postupy v celej spoloÄŤnosti na riadenie rovnĂ˝ch pracovnĂ˝ch praktĂ­k a postup je spojenĂ˝ s poĹľadovanĂ˝m vĂ˝konom v tejto oblasti') WHERE code = 'S1-1_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Existuje Ĺˇkolenie zamestnancov o politikĂˇch a praktikĂˇch nediskriminĂˇcie') WHERE code = 'S1-1_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş Ăşpravy fyzickĂ©ho prostredia na zabezpeÄŤenie zdravia a bezpeÄŤnosti pre pracovnĂ­kov, zĂˇkaznĂ­kov a ostatnĂ˝ch nĂˇvĹˇtevnĂ­kov so zdravotnĂ˝m postihnutĂ­m') WHERE code = 'S1-1_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Bolo vyhodnotenĂ©, ÄŤi existuje riziko, Ĺľe pracovnĂ© poĹľiadavky boli definovanĂ© spĂ´sobom, ktorĂ˝ by systematicky znevĂ˝hodĹoval urÄŤitĂ© skupiny') WHERE code = 'S1-1_19';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vedenie aktuĂˇlnych zĂˇznamov o nĂˇbore, ĹˇkolenĂ­ a postupe, ktorĂ© poskytujĂş transparentnĂ˝ pohÄľad na prĂ­leĹľitosti pre zamÄ›stnancov a ich pokrok') WHERE code = 'S1-1_20';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş postupy pre sĹĄaĹľnosti na rieĹˇenie sĹĄaĹľnostĂ­, vybavovanie odvolanĂ­ a poskytovanie nĂˇpravy pre zamestnancov v prĂ­pade identifikĂˇcie diskriminĂˇcie, a je sa venovanĂˇ pozornosĹĄ formĂˇlnym ĹˇtruktĂşram a neformĂˇlnym kultĂşrnym otĂˇzkam, ktorĂ© mĂ´Ĺľu zabrĂˇniĹĄ zamestnancom vznĂˇĹˇaĹĄ obavy a sĹĄaĹľnosti') WHERE code = 'S1-1_21';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş programy na podporu prĂ­stupu k rozvoju zruÄŤnostĂ­') WHERE code = 'S1-1_22';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© majĂş byĹĄ uvedenĂ© v prĂ­pade, Ĺľe podnik neprijal politiky') WHERE code = 'S1.MDR-P_07-08';

-- S1-2: Procesy zapojenia pracovnĂ­kov a zĂˇstupcov pracovnĂ­kov pri rieĹˇenĂ­ dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako perspektĂ­vy vlastnej pracovnej sily informujĂş rozhodnutia alebo ÄŤinnosti zameranĂ© na riadenie skutoÄŤnĂ˝ch a potenciĂˇlnych dopadov') WHERE code = 'S1-2_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie prebieha s vlastnou pracovnou silou alebo ich zĂˇstupcami') WHERE code = 'S1-2_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇtĂˇdia, v ktorom dochĂˇdza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S1-2_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyĹˇĹˇej roly v rĂˇmci podniku, ktorĂˇ mĂˇ operaÄŤnĂş zodpovednosĹĄ za zabezpeÄŤenie toho, Ĺľe dochĂˇdza k zapojeniu a Ĺľe vĂ˝sledky informujĂş o prĂ­stupe podniku') WHERE code = 'S1-2_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie GlobĂˇlnej rĂˇmcovej dohody alebo inĂ˝ch dohĂ´d sĂşvisiacich s reĹˇpektovanĂ­m ÄľudskĂ˝ch prĂˇv pracovnĂ­kov') WHERE code = 'S1-2_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako je hodnotenĂˇ efektĂ­vnosĹĄ zapojenia vlastnej pracovnej sily') WHERE code = 'S1-2_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov podniknutĂ˝ch na zĂ­skanie nĂˇhÄľadu na perspektĂ­vy ÄľudĂ­ vo vlastnej pracovnej sile, ktorĂ­ mĂ´Ĺľu byĹĄ obzvlĂˇĹˇĹĄ zraniteÄľnĂ­ voÄŤi dopadom a (alebo) marginalizovanĂ­') WHERE code = 'S1-2_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces na zapojenie vlastnej pracovnej sily') WHERE code = 'S1-2_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho rĂˇmca pre prijatie vĹˇeobecnĂ©ho procesu na zapojenie vlastnej pracovnej sily v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces zapojenia') WHERE code = 'S1-2_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako podnik zapĂˇja osoby v riziku alebo osoby v zraniteÄľnĂ˝ch situĂˇciĂˇch') WHERE code = 'S1-2_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sa berĂş do Ăşvahy potenciĂˇlne bariĂ©ry pre zapojenie ÄľudĂ­ v pracovnej sile') WHERE code = 'S1-2_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sĂş Äľudia vo vlastnej pracovnej sile poskytovanĂ© informĂˇcie, ktorĂ© sĂş zrozumiteÄľnĂ© a prĂ­stupnĂ© prostrednĂ­ctvom vhodnĂ˝ch komunikaÄŤnĂ˝ch kanĂˇlov') WHERE code = 'S1-2_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie akĂ˝chkoÄľvek konfliktnĂ˝ch zĂˇujmov, ktorĂ© vznikli medzi rĂ´znymi pracovnĂ­kmi a ako boli tieto konfliktnĂ© zĂˇujmy vyrieĹˇenĂ©') WHERE code = 'S1-2_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako podnik usiluje reĹˇpektovaĹĄ ÄľudskĂ© prĂˇva vĹˇetkĂ˝ch zapojenĂ˝ch zainteresovanĂ˝ch strĂˇn') WHERE code = 'S1-2_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o efektĂ­vnosti procesov zapojenia vlastnej pracovnej sily z predchĂˇdzajĂşcich vykazovacĂ­ch obdobĂ­') WHERE code = 'S1-2_15';

-- S1-3: Procesy nĂˇpravy negatĂ­vnych dopadov a kanĂˇly pre vznesenie obav

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu a procesov na poskytovanie alebo prispievanie k nĂˇprave v prĂ­pade, Ĺľe podnik spĂ´sobil alebo prispel k podstatnĂ©mu negatĂ­vnemu dopadu na ÄľudĂ­ vo vlastnej pracovnej sile') WHERE code = 'S1-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇpecifickĂ˝ch kanĂˇlov, ktorĂ© mĂˇ vlastnĂˇ pracovnĂˇ sila k dispozĂ­cii na vznesenie obav alebo potrieb priamo voÄŤi podniku a ich rieĹˇenie') WHERE code = 'S1-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretĂ­ch strĂˇn sĂş prĂ­stupnĂ© pre vĹˇetkĂ˝ch vlastnĂ˝ch pracovnĂ­kov') WHERE code = 'S1-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako majĂş vlastnĂˇ pracovnĂˇ sila a ich zĂˇstupcovia pracovnĂ­kov prĂ­stup ku kanĂˇlom na Ăşrovni podniku, v ktorom sĂş zamestnanĂ­ alebo pre ktorĂ˝ majĂş zmluvu na prĂˇcu') WHERE code = 'S1-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş mechanizmy na vybavovanie sĹĄaĹľnostĂ­ alebo reklamĂˇciĂ­ sĂşvisiacich so zĂˇleĹľitosĹĄami zamestnancov') WHERE code = 'S1-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostrednĂ­ctvom ktorĂ˝ch podnik podporuje alebo vyĹľaduje dostupnosĹĄ kanĂˇlov') WHERE code = 'S1-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sĂş sledovanĂ© a monitorovanĂ© vznesenĂ© a rieĹˇenĂ© otĂˇzky a ako je zabezpeÄŤenĂˇ efektĂ­vnosĹĄ kanĂˇlov') WHERE code = 'S1-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako je hodnotenĂ©, Ĺľe vlastnĂˇ pracovnĂˇ sila je informovanĂˇ a dĂ´veruje ĹˇtruktĂşram alebo procesom ako spĂ´sobu vznĂˇĹˇania ich obav alebo potrieb a ich rieĹˇenia') WHERE code = 'S1-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş politiky tĂ˝kajĂşce sa ochrany pred odvetou pre jednotlivcov, ktorĂ­ pouĹľĂ­vajĂş kanĂˇly na vznesenie obav alebo potrieb') WHERE code = 'S1-3_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal kanĂˇl na vznesenie obav') WHERE code = 'S1-3_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho rĂˇmca pre zavedenie kanĂˇlu na vznesenie obav') WHERE code = 'S1-3_11';

-- S1-4: Akcie sĂşvisiace s podstatnĂ˝mi dopadmi na vlastnĂş pracovnĂş silu

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AkÄŤnĂ© plĂˇny a zdroje na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s vlastnou pracovnou silou [pozri ESRS 2 - MDR-A]') WHERE code = 'S1.MDR-A_01-12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prijatĂ˝ch, plĂˇnovanĂ˝ch alebo prebiehajĂşcich akciĂ­ na prevenciu alebo zmiernenie negatĂ­vnych dopadov na vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako bola prijatĂˇ akcia na poskytnutie alebo umoĹľnenie nĂˇpravy vo vzĹĄahu k skutoÄŤnĂ©mu podstatnĂ©mu dopadu') WHERE code = 'S1-4_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatoÄŤnĂ˝ch iniciatĂ­v alebo akciĂ­ s primĂˇrnym ĂşÄŤelom prinĂˇĹˇania pozitĂ­vnych dopadov pre vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako je sledovanĂˇ a hodnotenĂˇ efektĂ­vnosĹĄ akciĂ­ a iniciatĂ­v pri dosahovanĂ­ vĂ˝sledkov pre vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesu, prostrednĂ­ctvom ktorĂ©ho identifikuje, akĂˇ akcia je potrebnĂˇ a vhodnĂˇ ako odpoveÄŹ na konkrĂ©tny skutoÄŤnĂ˝ alebo potenciĂˇlny negatĂ­vny dopad na vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂˇ akcia je plĂˇnovanĂˇ alebo prebieha na zmiernenie podstatnĂ˝ch rizĂ­k vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na vlastnej pracovnej sile a ako je sledovanĂˇ efektĂ­vnosĹĄ') WHERE code = 'S1-4_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂˇ akcia je plĂˇnovanĂˇ alebo prebieha na vyuĹľitie podstatnĂ˝ch prĂ­leĹľitostĂ­ vo vzĹĄahu k vlastnej pracovnej sile') WHERE code = 'S1-4_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako je zabezpeÄŤenĂ©, Ĺľe vlastnĂ© praktiky nespĂ´sobujĂş ani neprispievajĂş k podstatnĂ˝m negatĂ­vnym dopadom na vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, Ĺľe zdroje sĂş alokovanĂ© na riadenie podstatnĂ˝ch dopadov') WHERE code = 'S1-4_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ˝ch a ĹˇpecifickĂ˝ch prĂ­stupov k rieĹˇeniu podstatnĂ˝ch negatĂ­vnych dopadov') WHERE code = 'S1-4_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie iniciatĂ­v zameranĂ˝ch na prispievanie k dodatoÄŤnĂ˝m podstatnĂ˝m pozitĂ­vnym dopadom') WHERE code = 'S1-4_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako ÄŹaleko podnik pokroÄŤil v ĂşsilĂ­ poÄŤas vykazovanĂ©ho obdobia') WHERE code = 'S1-4_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie cieÄľov pre pokraÄŤujĂşce zlepĹˇovanie') WHERE code = 'S1-4_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako podnik usiluje pouĹľiĹĄ vplyv s relevantnĂ˝mi obchodnĂ˝mi vzĹĄahmi na riadenie podstatnĂ˝ch negatĂ­vnych dopadov ovplyvĹujĂşcich vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako iniciatĂ­va a jej vlastnĂ© zapojenie usiluje rieĹˇiĹĄ prĂ­sluĹˇnĂ˝ podstatnĂ˝ dopad') WHERE code = 'S1-4_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako pracovnĂ­ci a zĂˇstupcovia pracovnĂ­kov zohrĂˇvajĂş Ăşlohu v rozhodnutiach tĂ˝kajĂşcich sa dizajnu a implementĂˇcie programov alebo procesov, ktorĂ˝ch primĂˇrnym cieÄľom je prinĂˇĹˇaĹĄ pozitĂ­vne dopady pre pracovnĂ­kov') WHERE code = 'S1-4_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zamĂ˝ĹˇÄľanĂ˝ch alebo dosiahnutĂ˝ch pozitĂ­vnych vĂ˝sledkoch programov alebo procesov pre vlastnĂş pracovnĂş silu') WHERE code = 'S1-4_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'IniciatĂ­vy alebo procesy, ktorĂ˝ch primĂˇrnym cieÄľom je prinĂˇĹˇaĹĄ pozitĂ­vne dopady pre vlastnĂş pracovnĂş silu, sĂş navrhnutĂ© aj na podporu dosiahnutia jednĂ©ho alebo viacerĂ˝ch CieÄľov udrĹľateÄľnĂ©ho rozvoja') WHERE code = 'S1-4_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o opatreniach prijatĂ˝ch na zmiernenie negatĂ­vnych dopadov na pracovnĂ­kov, ktorĂ© vyplĂ˝vajĂş z prechodu na ekologickejĹˇiu, klimaticky neutrĂˇlnu ekonomiku') WHERE code = 'S1-4_19';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis internĂ˝ch funkciĂ­, ktorĂ© sĂş zapojenĂ© do riadenia dopadov a typov akciĂ­ prijatĂ˝ch internĂ˝mi funkciami na rieĹˇenie negatĂ­vnych a podporu pozitĂ­vnych dopadov') WHERE code = 'S1-4_20';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© majĂş byĹĄ uvedenĂ©, ak podnik neprijal akcie') WHERE code = 'S1.MDR-A_13-14';

-- S1-5: Ciele sĂşvisiace s riadenĂ­m podstatnĂ˝ch negatĂ­vnych dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovenĂ© na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s vlastnou pracovnou silou [pozri ESRS 2 - MDR-T]') WHERE code = 'S1.MDR-T_01-13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako bola vlastnĂˇ pracovnĂˇ sila alebo zĂˇstupcovia pracovnej sily zapojenĂ­ priamo do stanovovania cieÄľov') WHERE code = 'S1-5_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako bola vlastnĂˇ pracovnĂˇ sila alebo zĂˇstupcovia pracovnej sily zapojenĂ­ priamo do sledovania vĂ˝konnosti voÄŤi cieÄľom') WHERE code = 'S1-5_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako bola vlastnĂˇ pracovnĂˇ sila alebo zĂˇstupcovia pracovnej sily zapojenĂ­ priamo do identifikĂˇcie lekciĂ­ alebo zlepĹˇenĂ­ v dĂ´sledku vĂ˝konnosti podniku') WHERE code = 'S1-5_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamĂ˝ĹˇÄľanĂ˝ch vĂ˝sledkov, ktorĂ© majĂş byĹĄ dosiahnutĂ© v Ĺľivotoch ÄľudĂ­ vo vlastnej pracovnej sile') WHERE code = 'S1-5_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o stabilite cieÄľa v priebehu ÄŤasu z hÄľadiska definĂ­ciĂ­ a metodĂ­k na umoĹľnenie porovnateÄľnosti') WHERE code = 'S1-5_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na Ĺˇtandardy alebo zĂˇvĂ¤zky, na ktorĂ˝ch sĂş ciele zaloĹľenĂ©') WHERE code = 'S1-5_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© majĂş byĹĄ uvedenĂ©, ak podnik neprijal ciele') WHERE code = 'S1.MDR-T_14-19';

-- S1-6: Charakteristiky zamestnancov podniku

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - poÄŤet zamestnancov podÄľa pohlavia [tabuÄľka]') WHERE code = 'S1-6_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zamestnancov (hlavy)') WHERE code = 'S1-6_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet zamestnancov (hlavy)') WHERE code = 'S1-6_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - poÄŤet zamestnancov v krajinĂˇch s 50 alebo viac zamestnancami predstavujĂşcimi aspoĹ 10% celkovĂ©ho poÄŤtu zamestnancov [tabuÄľka]') WHERE code = 'S1-6_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zamestnancov v krajinĂˇch s 50 alebo viac zamestnancami predstavujĂşcimi aspoĹ 10% celkovĂ©ho poÄŤtu zamestnancov') WHERE code = 'S1-6_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet zamestnancov v krajinĂˇch s 50 alebo viac zamestnancami predstavujĂşcimi aspoĹ 10% celkovĂ©ho poÄŤtu zamestnancov') WHERE code = 'S1-6_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - informĂˇcie o zamestnancoch podÄľa typu zmluvy a pohlavia [tabuÄľka]') WHERE code = 'S1-6_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Charakteristiky zamestnancov podniku - informĂˇcie o zamestnancoch podÄľa regiĂłnu [tabuÄľka]') WHERE code = 'S1-6_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zamestnancov (hlavy alebo ekvivalent na plnĂ˝ ĂşvĂ¤zok)') WHERE code = 'S1-6_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet zamestnancov (hlavy alebo ekvivalent na plnĂ˝ ĂşvĂ¤zok)') WHERE code = 'S1-6_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zamestnancov, ktorĂ­ opustili podnik') WHERE code = 'S1-6_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel fluktuĂˇcie zamestnancov') WHERE code = 'S1-6_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodĂ­k a predpokladov pouĹľitĂ˝ch na zostavenie Ăşdajov (zamestnanci)') WHERE code = 'S1-6_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤty zamestnancov sĂş uvedenĂ© v hlavĂˇch alebo ekvivalente na plnĂ˝ ĂşvĂ¤zok') WHERE code = 'S1-6_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤty zamestnancov sĂş uvedenĂ© na konci vykazovanĂ©ho obdobia/priemer/inĂˇ metodika') WHERE code = 'S1-6_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ potrebnĂ˝ch na pochopenie Ăşdajov (zamestnanci)') WHERE code = 'S1-6_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krĂ­ĹľovĂ©ho odkazu informĂˇciĂ­ uvedenĂ˝ch v odseku 50 (a) na najreprezentĂ­vnejĹˇie ÄŤĂ­slo v ĂşÄŤtovnej zĂˇvierke') WHERE code = 'S1-6_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ÄŽalĹˇie podrobnĂ© ÄŤlenenie podÄľa pohlavia a podÄľa regiĂłnu [tabuÄľka]') WHERE code = 'S1-6_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zamestnancov na plnĂ˝ ĂşvĂ¤zok podÄľa hlĂˇv alebo ekvivalentu na plnĂ˝ ĂşvĂ¤zok') WHERE code = 'S1-6_19';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zamestnancov na ÄŤiastoÄŤnĂ˝ ĂşvĂ¤zok podÄľa hlĂˇv alebo ekvivalentu na plnĂ˝ ĂşvĂ¤zok') WHERE code = 'S1-6_20';

-- S1-7: Charakteristiky nezamestnancov vo vlastnej pracovnej sile

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet nezamestnancov vo vlastnej pracovnej sile') WHERE code = 'S1-7_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet nezamestnancov vo vlastnej pracovnej sile - samostatne zĂˇrobkovo ÄŤinnĂ© osoby') WHERE code = 'S1-7_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet nezamestnancov vo vlastnej pracovnej sile - Äľudia poskytnutĂ­ podnikmi primĂˇrne zaoberajĂşcimi sa ÄŤinnosĹĄami zamestnĂˇvania') WHERE code = 'S1-7_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik nemĂˇ nezamestnancov vo vlastnej pracovnej sile') WHERE code = 'S1-7_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie najbeĹľnejĹˇĂ­ch typov nezamestnancov (naprĂ­klad samostatne zĂˇrobkovo ÄŤinnĂ© osoby, osoby poskytnutĂ© podnikmi primĂˇrne zaoberajĂşcimi sa ÄŤinnosĹĄami zamestnĂˇvania a inĂ© typy relevantnĂ© pre podnik), ich vzĹĄah k podniku a typ prĂˇce, ktorĂş vykonĂˇvajĂş') WHERE code = 'S1-7_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodĂ­k a predpokladov pouĹľitĂ˝ch na zostavenie Ăşdajov (nezamestnanci)') WHERE code = 'S1-7_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤty nezamestnancov sĂş uvedenĂ© v hlavĂˇch/ekvivalente na plnĂ˝ ĂşvĂ¤zok') WHERE code = 'S1-7_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤty nezamestnancov sĂş uvedenĂ© na konci vykazovanĂ©ho obdobia/priemer/inĂˇ metodika') WHERE code = 'S1-7_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ potrebnĂ˝ch na pochopenie Ăşdajov (nezamestnanĂ­ pracovnĂ­ci)') WHERE code = 'S1-7_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zĂˇkladu prĂ­pravy odhadovanĂ©ho poÄŤtu nezamestnancov') WHERE code = 'S1-7_10';

-- S1-8: Pokrytie kolektĂ­vnym vyjednĂˇvanĂ­m a sociĂˇlnym dialĂłgom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel celkovĂ˝ch zamestnancov pokrytĂ˝ch kolektĂ­vnymi zmluvami') WHERE code = 'S1-8_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel vlastnĂ˝ch zamestnancov pokrytĂ˝ch kolektĂ­vnymi zmluvami v rĂˇmci miery pokrytia podÄľa krajiny s vĂ˝znamnĂ˝m zamestnanĂ­m (v EHP)') WHERE code = 'S1-8_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel vlastnĂ˝ch zamestnancov pokrytĂ˝ch kolektĂ­vnymi zmluvami (mimo EHP) podÄľa regiĂłnu') WHERE code = 'S1-8_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PracovnĂ© podmienky a podmienky zamestnania pre zamestnancov, ktorĂ­ nie sĂş pokrytĂ­ kolektĂ­vnymi zmluvami, sĂş urÄŤenĂ© na zĂˇklade kolektĂ­vnych zmlĂşv, ktorĂ© pokrĂ˝vajĂş ostatnĂ˝ch zamestnancov, alebo na zĂˇklade kolektĂ­vnych zmlĂşv z inĂ˝ch podnikov') WHERE code = 'S1-8_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis rozsahu, v akom sĂş pracovnĂ© podmienky a podmienky zamestnania nezamestnancov vo vlastnej pracovnej sile urÄŤenĂ© alebo ovplyvnenĂ© kolektĂ­vnymi zmluvami') WHERE code = 'S1-8_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zamestnancov v krajine s vĂ˝znamnĂ˝m zamestnanĂ­m (v EHP) pokrytĂ˝ch zĂˇstupcami pracovnĂ­kov') WHERE code = 'S1-8_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie existencie akejkoÄľvek dohody so zamestnancami o zastĂşpenĂ­ EurĂłpskou radou zamestnancov (EWC), radou zamestnancov Societas Europaea (SE) alebo radou zamestnancov Societas Cooperativa Europaea (SCE)') WHERE code = 'S1-8_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VlastnĂˇ pracovnĂˇ sila v regiĂłne (mimo EHP) pokrytĂˇ kolektĂ­vnym vyjednĂˇvanĂ­m a dohodami o sociĂˇlnom dialĂłgu podÄľa miery pokrytia a podÄľa regiĂłnu') WHERE code = 'S1-8_08';

-- S1-9: Ukazovatele diverzity metrĂ­k

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie podÄľa pohlavia v poÄŤte zamestnancov (hlavy) na Ăşrovni top manaĹľmentu') WHERE code = 'S1-9_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie podÄľa pohlavia v percentĂˇch zamestnancov na Ăşrovni top manaĹľmentu') WHERE code = 'S1-9_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie zamestnancov (hlavy) mladĹˇĂ­ch ako 30 rokov') WHERE code = 'S1-9_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie zamestnancov (hlavy) medzi 30 a 50 rokmi') WHERE code = 'S1-9_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdelenie zamestnancov (hlavy) starĹˇĂ­ch ako 50 rokov') WHERE code = 'S1-9_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vlastnej definĂ­cie top manaĹľmentu') WHERE code = 'S1-9_06';

-- S1-10: PrimeranĂˇ mzda

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci sĂş platenĂ­ primeranĂş mzdu v sĂşlade s prĂ­sluĹˇnĂ˝mi referenÄŤnĂ˝mi hodnotami') WHERE code = 'S1-10_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Krajiny, kde zamestnanci zarĂˇbajĂş menej ako prĂ­sluĹˇnĂˇ primeranĂˇ mzdovĂˇ referenÄŤnĂˇ hodnota [tabuÄľka]') WHERE code = 'S1-10_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zamestnancov platenĂ˝ch menej ako prĂ­sluĹˇnĂˇ primeranĂˇ mzdovĂˇ referenÄŤnĂˇ hodnota') WHERE code = 'S1-10_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel nezamestnancov platenĂ˝ch menej ako primeranĂˇ mzda') WHERE code = 'S1-10_04';

-- S1-11: SociĂˇlna ochrana

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci vo vlastnej pracovnej sile sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku choroby') WHERE code = 'S1-11_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci vo vlastnej pracovnej sile sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku nezamestnanosti od zaÄŤiatku prĂˇce vlastnĂ©ho pracovnĂ­ka pre podnik') WHERE code = 'S1-11_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci vo vlastnej pracovnej sile sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku pracovnĂ©ho Ăşrazu a zĂ­skanĂ©ho zdravotnĂ©ho postihnutia') WHERE code = 'S1-11_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci vo vlastnej pracovnej sile sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku rodiÄŤovskej dovolenky') WHERE code = 'S1-11_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci vo vlastnej pracovnej sile sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku odchodu do dĂ´chodku') WHERE code = 'S1-11_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'SociĂˇlna ochrana zamestnancov podÄľa krajiny [tabuÄľka] podÄľa typov udalostĂ­ a typu zamestnancov [vrĂˇtane nezamestnancov]') WHERE code = 'S1-11_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorĂ­ nie sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku choroby') WHERE code = 'S1-11_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorĂ­ nie sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku nezamestnanosti od zaÄŤiatku prĂˇce vlastnĂ©ho pracovnĂ­ka pre podnik') WHERE code = 'S1-11_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorĂ­ nie sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku pracovnĂ©ho Ăşrazu a zĂ­skanĂ©ho zdravotnĂ©ho postihnutia') WHERE code = 'S1-11_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorĂ­ nie sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku materskej dovolenky') WHERE code = 'S1-11_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie typov zamestnancov, ktorĂ­ nie sĂş pokrytĂ­ sociĂˇlnou ochranou prostrednĂ­ctvom verejnĂ˝ch programov alebo prostrednĂ­ctvom poskytovanĂ˝ch vĂ˝hod voÄŤi strate prĂ­jmu v dĂ´sledku odchodu do dĂ´chodku') WHERE code = 'S1-11_11';

-- S1-12: Osoby so zdravotnĂ˝m postihnutĂ­m

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel osĂ´b so zdravotnĂ˝m postihnutĂ­m medzi zamestnancami, s vĂ˝hradou prĂˇvnych obmedzenĂ­ na zber Ăşdajov') WHERE code = 'S1-12_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zamestnancov so zdravotnĂ˝m postihnutĂ­m vo vlastnej pracovnej sile ÄŤlenenĂ˝ podÄľa pohlavia [tabuÄľka]') WHERE code = 'S1-12_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ potrebnĂ˝ch na pochopenie Ăşdajov a toho, ako boli Ăşdaje zostavenĂ© (osoby so zdravotnĂ˝m postihnutĂ­m)') WHERE code = 'S1-12_03';

-- S1-13: Metriky Ĺˇkolenia a rozvoja zruÄŤnostĂ­

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ukazovatele Ĺˇkolenia a rozvoja zruÄŤnostĂ­ podÄľa pohlavia [tabuÄľka]') WHERE code = 'S1-13_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zamestnancov, ktorĂ­ sa zĂşÄŤastnili pravidelnĂ˝ch hodnotenĂ­ vĂ˝konu a kariĂ©rneho rozvoja') WHERE code = 'S1-13_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet hodĂ­n Ĺˇkolenia podÄľa pohlavia [tabuÄľka]') WHERE code = 'S1-13_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet hodĂ­n Ĺˇkolenia na osobu pre zamestnancov') WHERE code = 'S1-13_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zamestnancov, ktorĂ­ sa zĂşÄŤastnili pravidelnĂ˝ch hodnotenĂ­ vĂ˝konu a kariĂ©rneho rozvoja podÄľa kategĂłrie zamestnancov [tabuÄľka]') WHERE code = 'S1-13_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet zamestnancov, ktorĂ­ sa zĂşÄŤastnili pravidelnĂ˝ch hodnotenĂ­ vĂ˝konu a kariĂ©rneho rozvoja podÄľa kategĂłrie zamestnancov') WHERE code = 'S1-13_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel nezamestnancov, ktorĂ­ sa zĂşÄŤastnili pravidelnĂ˝ch hodnotenĂ­ vĂ˝konu a kariĂ©rneho rozvoja') WHERE code = 'S1-13_07';

-- S1-14: Zdravie a bezpeÄŤnosĹĄ

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel ÄľudĂ­ vo vlastnej pracovnej sile, ktorĂ­ sĂş pokrytĂ­ systĂ©mom riadenia zdravia a bezpeÄŤnosti zaloĹľenĂ˝m na prĂˇvnych poĹľiadavkĂˇch a (alebo) uznĂˇvanĂ˝ch Ĺˇtandardoch alebo usmerneniach') WHERE code = 'S1-14_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet ĂşmrtĂ­ vo vlastnej pracovnej sile v dĹŻsledku pracovnĂ˝ch Ăşrazov a chorĂ´b sĂşvisiacich s prĂˇcou') WHERE code = 'S1-14_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet ĂşmrtĂ­ v dĂ´sledku pracovnĂ˝ch Ăşrazov a chorĂ´b sĂşvisiacich s prĂˇcou inĂ˝ch pracovnĂ­kov pracujĂşcich na pracoviskĂˇch podniku') WHERE code = 'S1-14_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zaznamenateÄľnĂ˝ch pracovnĂ˝ch Ăşrazov pre vlastnĂş pracovnĂş silu') WHERE code = 'S1-14_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Miera zaznamenateÄľnĂ˝ch pracovnĂ˝ch Ăşrazov pre vlastnĂş pracovnĂş silu') WHERE code = 'S1-14_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet prĂ­padov zaznamenateÄľnĂ˝ch chorĂ´b sĂşvisiacich s prĂˇcou u zamestnancov') WHERE code = 'S1-14_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet dnĂ­ stratenĂ˝ch v dĂ´sledku pracovnĂ˝ch Ăşrazov a ĂşmrtĂ­ z pracovnĂ˝ch Ăşrazov, chorĂ´b sĂşvisiacich s prĂˇcou a ĂşmrtĂ­ z chorĂ´b sĂşvisiacich so zdravĂ­m tĂ˝kajĂşcich sa zamestnancov') WHERE code = 'S1-14_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet prĂ­padov zaznamenateÄľnĂ˝ch chorĂ´b sĂşvisiacich s prĂˇcou u nezamestnancov') WHERE code = 'S1-14_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet dnĂ­ stratenĂ˝ch v dĂ´sledku pracovnĂ˝ch Ăşrazov a ĂşmrtĂ­ z pracovnĂ˝ch Ăşrazov, chorĂ´b sĂşvisiacich s prĂˇcou a ĂşmrtĂ­ z chorĂ´b sĂşvisiacich so zdravĂ­m tĂ˝kajĂşcich sa nezamestnancov') WHERE code = 'S1-14_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel vlastnej pracovnej sily, ktorĂˇ je pokrytĂˇ systĂ©mom riadenia zdravia a bezpeÄŤnosti zaloĹľenĂ˝m na prĂˇvnych poĹľiadavkĂˇch a (alebo) uznĂˇvanĂ˝ch Ĺˇtandardoch alebo usmerneniach a ktorĂ˝ bol interne auditovanĂ˝ a (alebo) auditovanĂ˝ alebo certifikovanĂ˝ externou stranou') WHERE code = 'S1-14_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis zĂˇkladnĂ˝ch Ĺˇtandardov pre internĂ˝ audit alebo externĂş certifikĂˇciu systĂ©mu riadenia zdravia a bezpeÄŤnosti') WHERE code = 'S1-14_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet prĂ­padov zaznamenateÄľnĂ˝ch chorĂ´b sĂşvisiacich s prĂˇcou zistenĂ˝ch medzi bĂ˝valou vlastnou pracovnou silou') WHERE code = 'S1-14_12';

-- S1-15: RovnovĂˇha medzi pracovnĂ˝m a sĂşkromnĂ˝m Ĺľivotom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel zamestnancov oprĂˇvnenĂ˝ch ÄŤerpaĹĄ dovolenku sĂşvisiacu s rodinou') WHERE code = 'S1-15_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel oprĂˇvnenĂ˝ch zamestnancov, ktorĂ­ ÄŤerpali dovolenku sĂşvisiacu s rodinou') WHERE code = 'S1-15_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PercentuĂˇlny podiel oprĂˇvnenĂ˝ch zamestnancov, ktorĂ­ ÄŤerpali dovolenku sĂşvisiacu s rodinou podÄľa pohlavia [tabuÄľka]') WHERE code = 'S1-15_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci zamestnanci majĂş nĂˇrok na dovolenku sĂşvisiacu s rodinou prostrednĂ­ctvom sociĂˇlnej politiky a (alebo) kolektĂ­vnych zmlĂşv') WHERE code = 'S1-15_04';

-- S1-16: OdmeĹovanie (mzdovĂ˝ rozdiel a pomer odmeĹovania)

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdiel v odmeĹovanĂ­ medzi pohlaviami') WHERE code = 'S1-16_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pomer roÄŤnĂ©ho celkovĂ©ho odmeĹovania') WHERE code = 'S1-16_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ potrebnĂ˝ch na pochopenie Ăşdajov, ako boli Ăşdaje zostavenĂ© a inĂ˝ch zmien v zĂˇkladnĂ˝ch Ăşdajoch, ktorĂ© je potrebnĂ© vziaĹĄ do Ăşvahy') WHERE code = 'S1-16_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdiel v odmeĹovanĂ­ medzi pohlaviami ÄŤlenenĂ˝ podÄľa kategĂłrie zamestnancov a/alebo krajiny/segmentu [tabuÄľka]') WHERE code = 'S1-16_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Rozdiel v odmeĹovanĂ­ medzi pohlaviami ÄŤlenenĂ˝ podÄľa kategĂłrie zamestnancov a riadneho zĂˇkladnĂ©ho platu a doplnkovĂ˝ch/variabilnĂ˝ch zloĹľiek') WHERE code = 'S1-16_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Pomer odmeĹovania upravenĂ˝ o rozdiely v kĂşpnej sile medzi krajinami') WHERE code = 'S1-16_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis metodiky pouĹľitej pre vĂ˝poÄŤet pomeru odmeĹovania upravenĂ©ho o rozdiely v kĂşpnej sile medzi krajinami') WHERE code = 'S1-16_07';

-- S1-17: Incidenty, sĹĄaĹľnosti a zĂˇvaĹľnĂ© dopady na ÄľudskĂ© prĂˇva

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet incidentov diskriminĂˇcie [tabuÄľka]') WHERE code = 'S1-17_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet incidentov diskriminĂˇcie') WHERE code = 'S1-17_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet sĹĄaĹľnostĂ­ podanĂ˝ch prostrednĂ­ctvom kanĂˇlov pre ÄľudĂ­ vo vlastnej pracovnej sile na vznesenie obav') WHERE code = 'S1-17_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet sĹĄaĹľnostĂ­ podanĂ˝ch nĂˇrodnĂ˝m kontaktnĂ˝m bodom pre OECD MnohonĂˇrodnĂ© podniky') WHERE code = 'S1-17_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝Ĺˇka pokĂşt, sankciĂ­ a nĂˇhrad Ĺˇkody v dĂ´sledku incidentov diskriminĂˇcie, vrĂˇtane obĹĄaĹľovania a podanĂ˝ch sĹĄaĹľnostĂ­') WHERE code = 'S1-17_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zosĂşladenĂ­ pokĂşt, sankciĂ­ a nĂˇhrad Ĺˇkody v dĂ´sledku poruĹˇenĂ­ tĂ˝kajĂşcich sa pracovnej diskriminĂˇcie a obĹĄaĹľovania s najrelevantnejĹˇou sumou uvedenou v ĂşÄŤtovnej zĂˇvierke') WHERE code = 'S1-17_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ potrebnĂ˝ch na pochopenie Ăşdajov a toho, ako boli Ăşdaje zostavenĂ© (sĹĄaĹľnosti, incidenty a sĹĄaĹľnosti sĂşvisiace so sociĂˇlnymi zĂˇleĹľitosĹĄami a ÄľudskĂ˝mi prĂˇvami v prĂˇci)') WHERE code = 'S1-17_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zĂˇvaĹľnĂ˝ch otĂˇzok a incidentov v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ˝ch s vlastnou pracovnou silou') WHERE code = 'S1-17_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zĂˇvaĹľnĂ˝ch otĂˇzok a incidentov v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ˝ch s vlastnou pracovnou silou, ktorĂ© sĂş prĂ­padmi nereĹˇpektovania UsmernenĂ­ OSN a UsmernenĂ­ OECD pre nadnĂˇrodnĂ© podniky') WHERE code = 'S1-17_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'NedoĹˇlo k Ĺľiadnym zĂˇvaĹľnĂ˝m otĂˇzkam a incidentom v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ˝m s vlastnou pracovnou silou') WHERE code = 'S1-17_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝Ĺˇka pokĂşt, sankciĂ­ a nĂˇhrad za zĂˇvaĹľnĂ© otĂˇzky a incidenty v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ© s vlastnou pracovnou silou') WHERE code = 'S1-17_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zosĂşladenĂ­ vĂ˝Ĺˇky pokĂşt, sankciĂ­ a nĂˇhrad za zĂˇvaĹľnĂ© otĂˇzky a incidenty v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ© s vlastnou pracovnou silou s najrelevantnejĹˇou sumou uvedenou v ĂşÄŤtovnej zĂˇvierke') WHERE code = 'S1-17_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie stavu incidentov a/alebo sĹĄaĹľnostĂ­ a prijatĂ˝ch opatrenĂ­') WHERE code = 'S1-17_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet zĂˇvaĹľnĂ˝ch prĂ­padov poruĹˇenia ÄľudskĂ˝ch prĂˇv, pri ktorĂ˝ch podnik hral Ăşlohu pri zabezpeÄŤenĂ­ nĂˇpravy pre postihnutĂ˝ch') WHERE code = 'S1-17_14';


-- ============================================================================
-- ESRS S2 (PracovnĂ­ci v hodnotovom reĹĄazci) - SlovenskĂ© preklady
-- ============================================================================
-- Ĺ tandard ESRS S2 sa zaoberĂˇ pracovnĂ­kmi v hodnotovom reĹĄazci organizĂˇcie
-- ZahĹ•Ĺa: dodĂˇvateÄľov, subdodĂˇvateÄľov, pracovnĂ© prĂˇva, nĂştenĂş prĂˇcu,
-- detskĂş prĂˇcu, bezpeÄŤnosĹĄ a zdravie pracovnĂ­kov mimo priamej pracovnej sily
-- ============================================================================

-- S2.SBM-3: PodstatnĂ© dopady, rizikĂˇ a prĂ­leĹľitosti a ich interakcia s stratĂ©giou a obchodnĂ˝m modelom

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci pracovnĂ­ci v hodnotovom reĹĄazci, ktorĂ­ mĂ´Ĺľu byĹĄ podstatne ovplyvnenĂ­ podnikom, sĂş zahrnutĂ­ do rozsahu zverejnenia podÄľa ESRS 2') WHERE code = 'S2.SBM-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov pracovnĂ­kov v hodnotovom reĹĄazci, ktorĂ­ sĂş predmetom podstatnĂ˝ch dopadov') WHERE code = 'S2.SBM-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ pracovnĂ­kov v hodnotovom reĹĄazci, ktorĂ­ sĂş predmetom podstatnĂ˝ch dopadov vlastnĂ˝mi operĂˇciami alebo prostrednĂ­ctvom hodnotovĂ©ho reĹĄazca') WHERE code = 'S2.SBM-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie geografickĂ˝ch oblastĂ­ alebo komodĂ­t, pri ktorĂ˝ch existuje vĂ˝znamnĂ© riziko detskej prĂˇce alebo nĂştenej alebo povinnej prĂˇce medzi pracovnĂ­kmi v hodnotovom reĹĄazci podniku') WHERE code = 'S2.SBM-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝skyt podstatnĂ˝ch negatĂ­vnych dopadov (pracovnĂ­ci v hodnotovom reĹĄazci)') WHERE code = 'S2.SBM-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ÄŤinnostĂ­, ktorĂ© vedĂş k pozitĂ­vnym dopadom a typy pracovnĂ­kov v hodnotovom reĹĄazci, ktorĂ­ sĂş alebo by mohli byĹĄ pozitĂ­vne ovplyvnenĂ­') WHERE code = 'S2.SBM-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis podstatnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na pracovnĂ­koch v hodnotovom reĹĄazci') WHERE code = 'S2.SBM-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako podnik vyvinul pochopenie toho, ako pracovnĂ­ci s osobitnĂ˝mi charakteristikami, tĂ­, ktorĂ­ pracujĂş v osobitnĂ˝ch kontextoch alebo vykonĂˇvajĂş osobitnĂ© ÄŤinnosti, mĂ´Ĺľu byĹĄ vystavenĂ­ vĂ¤ÄŤĹˇiemu riziku poĹˇkodenia') WHERE code = 'S2.SBM-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ktorĂ© z podstatnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na pracovnĂ­koch v hodnotovom reĹĄazci sĂş dopady na konkrĂ©tne skupiny') WHERE code = 'S2.SBM-3_09';

-- S2-1: Politiky sĂşvisiace s pracovnĂ­kmi v hodnotovom reĹĄazci

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s pracovnĂ­kmi v hodnotovom reĹĄazci [pozri ESRS 2 MDR-P]') WHERE code = 'S2.MDR-P_01-06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantnĂ˝ch zĂˇvĂ¤zkov v oblasti politiky ÄľudskĂ˝ch prĂˇv tĂ˝kajĂşcich sa pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-1_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu k reĹˇpektovaniu ÄľudskĂ˝ch prĂˇv tĂ˝kajĂşcich sa pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-1_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu k angaĹľovaniu pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-1_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu k opatreniam na zabezpeÄŤenie a (alebo) umoĹľnenie nĂˇpravy dopadov na ÄľudskĂ© prĂˇva') WHERE code = 'S2-1_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky vĂ˝slovne rieĹˇia obchodovanie s ÄľuÄŹmi, nĂştenĂş prĂˇcu alebo povinnĂş prĂˇcu a detskĂş prĂˇcu') WHERE code = 'S2-1_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik mĂˇ kĂłdex sprĂˇvania dodĂˇvateÄľov') WHERE code = 'S2-1_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ustanovenia v kĂłdexoch sprĂˇvania dodĂˇvateÄľov sĂş Ăşplne v sĂşlade s prĂ­sluĹˇnĂ˝mi Ĺˇtandardmi ILO') WHERE code = 'S2-1_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako sĂş politiky zosĂşladenĂ© s relevantnĂ˝mi medzinĂˇrodne uznĂˇvanĂ˝mi nĂˇstrojmi') WHERE code = 'S2-1_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu a nĂˇznaku povahy prĂ­padov nereĹˇpektovania UsmernenĂ­ OSN o podnikanĂ­ a ÄľudskĂ˝ch prĂˇvach, DeklarĂˇcie ILO o zĂˇkladnĂ˝ch princĂ­poch a prĂˇvach v prĂˇci alebo UsmernenĂ­ OECD pre nadnĂˇrodnĂ© podniky, ktorĂ© sa tĂ˝kajĂş pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-1_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlenĂ­ vĂ˝znamnĂ˝ch zmien v politikĂˇch prijatĂ˝ch poÄŤas vykazovanĂ©ho roka') WHERE code = 'S2-1_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ilustrĂˇcie typov komunikĂˇcie politĂ­k jednotlivcom, skupinĂˇm jednotlivcov alebo subjektom, pre ktorĂ© sĂş relevantnĂ©') WHERE code = 'S2-1_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© majĂş byĹĄ uvedenĂ© v prĂ­pade, Ĺľe podnik neprijal politiky') WHERE code = 'S2.MDR-P_07-08';

-- S2-2: Procesy zapojenia pracovnĂ­kov v hodnotovom reĹĄazci pri rieĹˇenĂ­ dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako perspektĂ­vy pracovnĂ­kov v hodnotovom reĹĄazci informujĂş rozhodnutia alebo ÄŤinnosti zameranĂ© na riadenie skutoÄŤnĂ˝ch a potenciĂˇlnych dopadov') WHERE code = 'S2-2_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie prebieha s pracovnĂ­kmi v hodnotovom reĹĄazci alebo ich legitĂ­mnymi zĂˇstupcami priamo alebo s dĂ´veryhodnĂ˝mi sprostredkovateÄľmi') WHERE code = 'S2-2_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇtĂˇdia, v ktorom dochĂˇdza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S2-2_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyĹˇĹˇej roly v rĂˇmci podniku, ktorĂˇ mĂˇ operaÄŤnĂş zodpovednosĹĄ za zabezpeÄŤenie toho, Ĺľe dochĂˇdza k zapojeniu a Ĺľe vĂ˝sledky informujĂş o prĂ­stupe podniku') WHERE code = 'S2-2_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie GlobĂˇlnej rĂˇmcovej dohody alebo inĂ˝ch dohĂ´d sĂşvisiacich s reĹˇpektovanĂ­m ÄľudskĂ˝ch prĂˇv pracovnĂ­kov') WHERE code = 'S2-2_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako je hodnotenĂˇ efektĂ­vnosĹĄ zapojenia pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-2_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov podniknutĂ˝ch na zĂ­skanie nĂˇhÄľadu na perspektĂ­vy pracovnĂ­kov v hodnotovom reĹĄazci, ktorĂ­ mĂ´Ĺľu byĹĄ obzvlĂˇĹˇĹĄ zraniteÄľnĂ­ voÄŤi dopadom a (alebo) marginalizovanĂ­') WHERE code = 'S2-2_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces na zapojenie pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-2_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho rĂˇmca pre prijatie vĹˇeobecnĂ©ho procesu na zapojenie pracovnĂ­kov v hodnotovom reĹĄazci v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces zapojenia') WHERE code = 'S2-2_09';

-- S2-3: Procesy nĂˇpravy negatĂ­vnych dopadov a kanĂˇly pre vznesenie obav

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu a procesov na poskytovanie alebo prispievanie k nĂˇprave v prĂ­pade, Ĺľe podnik identifikoval, Ĺľe je spojenĂ˝ s podstatnĂ˝m negatĂ­vnym dopadom na pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-3_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇpecifickĂ˝ch kanĂˇlov, ktorĂ© majĂş pracovnĂ­ci v hodnotovom reĹĄazci k dispozĂ­cii na vznesenie obav alebo potrieb priamo voÄŤi podniku a ich rieĹˇenie') WHERE code = 'S2-3_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostrednĂ­ctvom ktorĂ˝ch podnik podporuje alebo vyĹľaduje dostupnosĹĄ kanĂˇlov') WHERE code = 'S2-3_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako sĂş sledovanĂ© a monitorovanĂ© vznesenĂ© a rieĹˇenĂ© otĂˇzky a ako je zabezpeÄŤenĂˇ efektĂ­vnosĹĄ kanĂˇlov') WHERE code = 'S2-3_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako je hodnotenĂ©, Ĺľe pracovnĂ­ci v hodnotovom reĹĄazci sĂş informovanĂ­ a dĂ´verujĂş ĹˇtruktĂşram alebo procesom ako spĂ´sobu vznĂˇĹˇania ich obĂˇv alebo potrieb a ich rieĹˇenia') WHERE code = 'S2-3_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş politiky tĂ˝kajĂşce sa ochrany pred odvetou pre jednotlivcov, ktorĂ­ pouĹľĂ­vajĂş kanĂˇly na vznesenie obav alebo potrieb') WHERE code = 'S2-3_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal kanĂˇl na vznesenie obĂˇv') WHERE code = 'S2-3_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho rĂˇmca pre zavedenie kanĂˇlu na vznesenie obĂˇv') WHERE code = 'S2-3_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako majĂş pracovnĂ­ci v hodnotovom reĹĄazci prĂ­stup ku kanĂˇlom na Ăşrovni podniku, v ktorom sĂş zamestnanĂ­ alebo pre ktorĂ˝ majĂş zmluvu na prĂˇcu') WHERE code = 'S2-3_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretĂ­ch strĂˇn sĂş prĂ­stupnĂ© pre vĹˇetkĂ˝ch pracovnĂ­kov') WHERE code = 'S2-3_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'SĹĄaĹľnosti sĂş rieĹˇenĂ© dĂ´verne a s reĹˇpektovanĂ­m prĂˇv na sĂşkromie a ochranu Ăşdajov') WHERE code = 'S2-3_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'KanĂˇly na vznesenie obĂˇv alebo potrieb umoĹľĹujĂş pracovnĂ­kom v hodnotovom reĹĄazci ich pouĹľĂ­vaĹĄ anonymne') WHERE code = 'S2-3_12';

-- S2-4: Akcie sĂşvisiace s podstatnĂ˝mi dopadmi na pracovnĂ­kov v hodnotovom reĹĄazci

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AkÄŤnĂ© plĂˇny a zdroje na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s pracovnĂ­kmi v hodnotovom reĹĄazci [pozri ESRS 2 - MDR-A]') WHERE code = 'S2.MDR-A_01-12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis plĂˇnovanĂ˝ch alebo prebiehajĂşcich akciĂ­ na prevenciu, zmiernenie alebo nĂˇpravu podstatnĂ˝ch negatĂ­vnych dopadov na pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ÄŤi a ako akcia na poskytnutie alebo umoĹľnenie nĂˇpravy vo vzĹĄahu k skutoÄŤnĂ©mu podstatnĂ©mu dopadu') WHERE code = 'S2-4_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatoÄŤnĂ˝ch iniciatĂ­v alebo procesov s primĂˇrnym ĂşÄŤelom prinĂˇĹˇania pozitĂ­vnych dopadov pre pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako je sledovanĂˇ a hodnotenĂˇ efektĂ­vnosĹĄ akciĂ­ alebo iniciatĂ­v pri dosahovanĂ­ vĂ˝sledkov pre pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesov na identifikĂˇciu toho, akĂˇ akcia je potrebnĂˇ a vhodnĂˇ ako odpoveÄŹ na konkrĂ©tny skutoÄŤnĂ˝ alebo potenciĂˇlny podstatnĂ˝ negatĂ­vny dopad na pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k prijĂ­maniu akciĂ­ vo vzĹĄahu k ĹˇpecifickĂ˝m podstatnĂ˝m negatĂ­vnym dopadom na pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k zabezpeÄŤeniu toho, Ĺľe procesy na poskytnutie alebo umoĹľnenie nĂˇpravy v prĂ­pade podstatnĂ˝ch negatĂ­vnych dopadov na pracovnĂ­kov v hodnotovom reĹĄazci sĂş dostupnĂ© a efektĂ­vne v ich implementĂˇcii a vĂ˝sledkoch') WHERE code = 'S2-4_07';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂˇ akcia je plĂˇnovanĂˇ alebo prebieha na zmiernenie podstatnĂ˝ch rizĂ­k vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na pracovnĂ­koch v hodnotovom reĹĄazci a ako je sledovanĂˇ efektĂ­vnosĹĄ') WHERE code = 'S2-4_08';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂˇ akcia je plĂˇnovanĂˇ alebo prebieha na vyuĹľitie podstatnĂ˝ch prĂ­leĹľitostĂ­ vo vzĹĄahu k pracovnĂ­kom v hodnotovom reĹĄazci') WHERE code = 'S2-4_09';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako je zabezpeÄŤenĂ©, Ĺľe vlastnĂ© praktiky nespĂ´sobujĂş ani neprispievajĂş k podstatnĂ˝m negatĂ­vnym dopadom na pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_10';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zĂˇvaĹľnĂ˝ch otĂˇzok a incidentov v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ˝ch s upstream a downstream hodnotovĂ˝m reĹĄazcom') WHERE code = 'S2-4_11';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zdrojov alokovanĂ˝ch na riadenie podstatnĂ˝ch dopadov') WHERE code = 'S2-4_12';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako podnik usiluje pouĹľiĹĄ vplyv s relevantnĂ˝mi obchodnĂ˝mi vzĹĄahmi na riadenie podstatnĂ˝ch negatĂ­vnych dopadov ovplyvĹujĂşcich pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ako ĂşÄŤasĹĄ v odvetvovej alebo viacstrannej iniciatĂ­ve a vlastnĂ© zapojenie podniku usiluje rieĹˇiĹĄ podstatnĂ© dopady') WHERE code = 'S2-4_14';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako pracovnĂ­ci v hodnotovom reĹĄazci a legitĂ­mni zĂˇstupcovia alebo ich dĂ´veryhodnĂ­ sprostredkovatelia zohrĂˇvajĂş Ăşlohu v rozhodnutiach tĂ˝kajĂşcich sa dizajnu a implementĂˇcie programov alebo procesov') WHERE code = 'S2-4_15';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zamĂ˝ĹˇÄľanĂ˝ch alebo dosiahnutĂ˝ch pozitĂ­vnych vĂ˝sledkoch programov alebo procesov pre pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-4_16';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'IniciatĂ­vy alebo procesy, ktorĂ˝ch primĂˇrnym cieÄľom je prinĂˇĹˇaĹĄ pozitĂ­vne dopady pre pracovnĂ­kov v hodnotovom reĹĄazci, sĂş navrhnutĂ© aj na podporu dosiahnutia jednĂ©ho alebo viacerĂ˝ch CieÄľov udrĹľateÄľnĂ©ho rozvoja') WHERE code = 'S2-4_17';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis internĂ˝ch funkciĂ­, ktorĂ© sĂş zapojenĂ© do riadenia dopadov a typov akciĂ­ prijatĂ˝ch internĂ˝mi funkciami na rieĹˇenie negatĂ­vnych a podporu pozitĂ­vnych dopadov') WHERE code = 'S2-4_18';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© majĂş byĹĄ uvedenĂ©, ak podnik neprijal akcie') WHERE code = 'S2.MDR-A_13-14';

-- S2-5: Ciele sĂşvisiace s riadenĂ­m podstatnĂ˝ch negatĂ­vnych dopadov

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovenĂ© na riadenie podstatnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s pracovnĂ­kmi v hodnotovom reĹĄazci [pozri ESRS 2 - MDR-T]') WHERE code = 'S2.MDR-T_01-13';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako boli pracovnĂ­ci v hodnotovom reĹĄazci, ich legitĂ­mni zĂˇstupcovia alebo dĂ´veryhodnĂ­ sprostredkovatelia zapojenĂ­ priamo do stanovovania cieÄľov') WHERE code = 'S2-5_01';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako boli pracovnĂ­ci v hodnotovom reĹĄazci, ich legitĂ­mni zĂˇstupcovia alebo dĂ´veryhodnĂ­ sprostredkovatelia zapojenĂ­ priamo do sledovania vĂ˝konnosti voÄŤi cieÄľom') WHERE code = 'S2-5_02';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie toho, ÄŤi a ako boli pracovnĂ­ci v hodnotovom reĹĄazci, ich legitĂ­mni zĂˇstupcovia alebo dĂ´veryhodnĂ­ sprostredkovatelia zapojenĂ­ priamo do identifikĂˇcie lekciĂ­ alebo zlepĹˇenĂ­ v dĂ´sledku vĂ˝konnosti podniku') WHERE code = 'S2-5_03';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamĂ˝ĹˇÄľanĂ˝ch vĂ˝sledkov, ktorĂ© majĂş byĹĄ dosiahnutĂ© v Ĺľivotoch pracovnĂ­kov v hodnotovom reĹĄazci') WHERE code = 'S2-5_04';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o stabilite cieÄľa v priebehu ÄŤasu z hÄľadiska definĂ­ciĂ­ a metodĂ­k na umoĹľnenie porovnateÄľnosti') WHERE code = 'S2-5_05';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na Ĺˇtandardy alebo zĂˇvĂ¤zky, na ktorĂ˝ch je cieÄľ zaloĹľenĂ˝') WHERE code = 'S2-5_06';

UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© majĂş byĹĄ uvedenĂ©, ak podnik neprijal ciele') WHERE code = 'S2.MDR-T_14-19';
-- =====================================================
-- ESRS S3 (OvplyvnenĂ© komunity) - Slovak Translations
-- =====================================================

-- S3.SBM-3: Strategy and Business Model
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetky ovplyvnenĂ© komunity, ktorĂ© mĂ´Ĺľu byĹĄ vĂ˝znamne ovplyvnenĂ© podnikom, sĂş zahrnutĂ© v rozsahu zverejnenia podÄľa ESRS 2') WHERE code = 'S3.SBM-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov ovplyvnenĂ˝ch komunĂ­t podliehajĂşcich vĂ˝znamnĂ˝m dopadom') WHERE code = 'S3.SBM-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ komunĂ­t podliehajĂşcich vĂ˝znamnĂ˝m dopadom vlastnĂ˝mi ÄŤinnosĹĄami alebo prostrednĂ­ctvom hodnotovĂ©ho reĹĄazca') WHERE code = 'S3.SBM-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝skyt vĂ˝znamnĂ˝ch negatĂ­vnych dopadov (ovplyvnenĂ© komunity)') WHERE code = 'S3.SBM-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ÄŤinnostĂ­, ktorĂ© majĂş pozitĂ­vne dopady, a typy ovplyvnenĂ˝ch komunĂ­t, ktorĂ© sĂş alebo mĂ´Ĺľu byĹĄ pozitĂ­vne ovplyvnenĂ©') WHERE code = 'S3.SBM-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vĂ˝znamnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na ovplyvnenĂ˝ch komunitĂˇch') WHERE code = 'S3.SBM-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako podnik rozvinul pochopenie toho, ako mĂ´Ĺľu byĹĄ ovplyvnenĂ© komunity s osobitnĂ˝mi charakteristikami alebo ĹľijĂşce v osobitnĂ˝ch podmienkach vystavenĂ© vyĹˇĹˇiemu riziku poĹˇkodenia') WHERE code = 'S3.SBM-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktorĂ© zo vĂ˝znamnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na ovplyvnenĂ˝ch komunitĂˇch sĂş dopadmi na konkrĂ©tne skupiny') WHERE code = 'S3.SBM-3_08';

-- S3-1: Policies
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa ovplyvnenĂ˝ch komunĂ­t [pozri ESRS 2 MDR-P]') WHERE code = 'S3.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie akĂ˝chkoÄľvek osobitnĂ˝ch politickĂ˝ch ustanovenĂ­ na predchĂˇdzanie a rieĹˇenie dopadov na pĂ´vodnĂ© obyvateÄľstvo') WHERE code = 'S3-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantnĂ˝ch zĂˇvĂ¤zkov v oblasti politiky ÄľudskĂ˝ch prĂˇv tĂ˝kajĂşcich sa ovplyvnenĂ˝ch komunĂ­t') WHERE code = 'S3-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu vo vzĹĄahu k reĹˇpektovaniu ÄľudskĂ˝ch prĂˇv komunĂ­t a konkrĂ©tne pĂ´vodnĂ©ho obyvateÄľstva') WHERE code = 'S3-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu vo vzĹĄahu k zapojeniu ovplyvnenĂ˝ch komunĂ­t') WHERE code = 'S3-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu vo vzĹĄahu k opatreniam na zabezpeÄŤenie a (alebo) umoĹľnenie nĂˇpravy dopadov na ÄľudskĂ© prĂˇva') WHERE code = 'S3-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sĂş politiky zosĂşladenĂ© s prĂ­sluĹˇnĂ˝mi medzinĂˇrodne uznĂˇvanĂ˝mi nĂˇstrojmi') WHERE code = 'S3-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu a uvedenie povahy prĂ­padov nedodrĹľania UsmernenĂ­ OSN pre podnikanie a ÄľudskĂ© prĂˇva, DeklarĂˇcie MOP o zĂˇkladnĂ˝ch princĂ­poch a prĂˇvach pri prĂˇci alebo UsmernenĂ­ OECD pre nadnĂˇrodnĂ© podniky, ktorĂ© zahĹ•ĹajĂş ovplyvnenĂ© komunity') WHERE code = 'S3-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlenia vĂ˝znamnĂ˝ch zmien prijatĂ˝ch politĂ­k poÄŤas vykazovacieho roka') WHERE code = 'S3-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie o ilustrĂˇcii typov komunikĂˇcie svojich politĂ­k jednotlivcom, skupine jednotlivcov alebo subjektom, pre ktorĂ© sĂş relevantnĂ©') WHERE code = 'S3-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş vykazovaĹĄ v prĂ­pade, Ĺľe podnik neprijal politiky') WHERE code = 'S3.MDR-P_07-08';

-- S3-2: Engagement with affected communities
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako perspektĂ­vy ovplyvnenĂ˝ch komunĂ­t ovplyvĹujĂş rozhodnutia alebo ÄŤinnosti zameranĂ© na riadenie skutoÄŤnĂ˝ch a potenciĂˇlnych dopadov') WHERE code = 'S3-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie sa uskutoÄŤĹuje s ovplyvnenĂ˝mi komunitami alebo ich legitĂ­mnymi zĂˇstupcami priamo alebo s dĂ´veryhodnĂ˝mi zĂˇstupcami') WHERE code = 'S3-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇtĂˇdia, v ktorom dochĂˇdza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S3-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyĹˇĹˇej pozĂ­cie v rĂˇmci podniku, ktorĂˇ mĂˇ operatĂ­vnu zodpovednosĹĄ za zabezpeÄŤenie zapojenia a za to, Ĺľe vĂ˝sledky informujĂş o prĂ­stupe podniku') WHERE code = 'S3-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako podnik hodnotĂ­ ĂşÄŤinnosĹĄ svojho zapojenia ovplyvnenĂ˝ch komunĂ­t') WHERE code = 'S3-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov prijatĂ˝ch na zĂ­skanie prehÄľadu o perspektĂ­vach ovplyvnenĂ˝ch komunĂ­t, ktorĂ© mĂ´Ĺľu byĹĄ obzvlĂˇĹˇĹĄ zraniteÄľnĂ© voÄŤi dopadom a (alebo) marginalizovanĂ©') WHERE code = 'S3-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako podnik zohÄľadĹuje a zabezpeÄŤuje reĹˇpektovanie osobitnĂ˝ch prĂˇv pĂ´vodnĂ©ho obyvateÄľstva vo svojom prĂ­stupe k zapojeniu zainteresovanĂ˝ch strĂˇn') WHERE code = 'S3-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces na zapojenie ovplyvnenĂ˝ch komunĂ­t') WHERE code = 'S3-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho harmonogramu prijatia vĹˇeobecnĂ©ho procesu na zapojenie ovplyvnenĂ˝ch komunĂ­t v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces zapojenia') WHERE code = 'S3-2_09';

-- S3-3: Processes to remediate negative impacts and channels for affected communities to raise concerns
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu a procesov na poskytovanie alebo prispievanie k nĂˇprave, keÄŹ podnik identifikoval, Ĺľe je spojenĂ˝ so vĂ˝znamnĂ˝m negatĂ­vnym dopadom na ovplyvnenĂ© komunity') WHERE code = 'S3-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie konkrĂ©tnych kanĂˇlov, ktorĂ© majĂş ovplyvnenĂ© komunity k dispozĂ­cii na priame vznesenie obav alebo potrieb s podnikom a ich rieĹˇenie') WHERE code = 'S3-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostrednĂ­ctvom ktorĂ˝ch podnik podporuje alebo vyĹľaduje dostupnosĹĄ kanĂˇlov') WHERE code = 'S3-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako sĂş vznesenĂ© a rieĹˇenĂ© otĂˇzky sledovanĂ© a monitorovanĂ© a ako je zabezpeÄŤenĂˇ ĂşÄŤinnosĹĄ kanĂˇlov') WHERE code = 'S3-3_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa hodnotĂ­, Ĺľe ovplyvnenĂ© komunity si sĂş vedomĂ© ĹˇtruktĂşr alebo procesov a dĂ´verujĂş im ako spĂ´sobu, ako vyjadriĹĄ svoje obavy alebo potreby a nechaĹĄ ich rieĹˇiĹĄ') WHERE code = 'S3-3_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky tĂ˝kajĂşce sa ochrany pred odvetou pre jednotlivcov, ktorĂ­ pouĹľĂ­vajĂş kanĂˇly na vznesenie obav alebo potrieb, sĂş zavedenĂ©') WHERE code = 'S3-3_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces na zapojenie ovplyvnenĂ˝ch komunĂ­t') WHERE code = 'S3-3_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho harmonogramu zavedenia kanĂˇlov alebo procesov na vznesenie obav') WHERE code = 'S3-3_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako majĂş ovplyvnenĂ© komunity prĂ­stup ku kanĂˇlom na Ăşrovni podniku, ktorĂ˝m sĂş ovplyvnenĂ©') WHERE code = 'S3-3_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretĂ­ch strĂˇn sĂş prĂ­stupnĂ© vĹˇetkĂ˝m ovplyvnenĂ˝m komunitĂˇm') WHERE code = 'S3-3_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'SĹĄaĹľnosti sa rieĹˇia dĂ´verne a s reĹˇpektovanĂ­m prĂˇva na sĂşkromie a ochranu Ăşdajov') WHERE code = 'S3-3_20';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'OvplyvnenĂ© komunity majĂş moĹľnosĹĄ pouĹľĂ­vaĹĄ kanĂˇly na vznesenie obĂˇv alebo potrieb anonymne') WHERE code = 'S3-3_21';

-- S3-4: Actions
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AkÄŤnĂ© plĂˇny a zdroje na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa ovplyvnenĂ˝ch komunĂ­t [pozri ESRS 2 - MDR-A]') WHERE code = 'S3.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prijatĂ˝ch, plĂˇnovanĂ˝ch alebo prebiehajĂşcich opatrenĂ­ na predchĂˇdzanie, zmiernenie alebo nĂˇpravu vĂ˝znamnĂ˝ch negatĂ­vnych dopadov na ovplyvnenĂ© komunity') WHERE code = 'S3-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis, ÄŤi a ako podnik prijal opatrenia na poskytnutie alebo umoĹľnenie nĂˇpravy vo vzĹĄahu k skutoÄŤnĂ©mu vĂ˝znamnĂ©mu dopadu') WHERE code = 'S3-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatoÄŤnĂ˝ch iniciatĂ­v alebo procesov, ktorĂ˝ch primĂˇrnym ĂşÄŤelom je poskytovanie pozitĂ­vnych dopadov pre ovplyvnenĂ© komunity') WHERE code = 'S3-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako sa sleduje a hodnotĂ­ ĂşÄŤinnosĹĄ opatrenĂ­ alebo iniciatĂ­v pri dosahovanĂ­ vĂ˝sledkov pre ovplyvnenĂ© komunity') WHERE code = 'S3-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis procesov identifikĂˇcie toho, akĂ© opatrenie je potrebnĂ© a vhodnĂ© v reakcii na konkrĂ©tny skutoÄŤnĂ˝ alebo potenciĂˇlny vĂ˝znamnĂ˝ negatĂ­vny dopad na ovplyvnenĂ© komunity') WHERE code = 'S3-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k prijĂ­maniu opatrenĂ­ vo vzĹĄahu ku konkrĂ©tnym vĂ˝znamnĂ˝m negatĂ­vnym dopadom na ovplyvnenĂ© komunity') WHERE code = 'S3-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k zabezpeÄŤeniu, Ĺľe procesy na poskytovanie alebo umoĹľnenie nĂˇpravy v prĂ­pade vĂ˝znamnĂ˝ch negatĂ­vnych dopadov na ovplyvnenĂ© komunity sĂş dostupnĂ© a ĂşÄŤinnĂ© v ich implementĂˇcii a vĂ˝sledkoch') WHERE code = 'S3-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂ© opatrenie je plĂˇnovanĂ© alebo prebieha na zmiernenie vĂ˝znamnĂ˝ch rizĂ­k vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na ovplyvnenĂ˝ch komunitĂˇch a ako sa sleduje ĂşÄŤinnosĹĄ') WHERE code = 'S3-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂ© opatrenie je plĂˇnovanĂ© alebo prebieha na vyuĹľitie vĂ˝znamnĂ˝ch prĂ­leĹľitostĂ­ vo vzĹĄahu k ovplyvnenĂ˝m komunitĂˇm') WHERE code = 'S3-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa zabezpeÄŤuje, Ĺľe vlastnĂ© postupy nespĂ´sobujĂş ani neprispievajĂş k vĂ˝znamnĂ˝m negatĂ­vnym dopadom na ovplyvnenĂ© komunity') WHERE code = 'S3-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zĂˇvaĹľnĂ˝ch otĂˇzok a incidentov v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ˝ch s ovplyvnenĂ˝mi komunitami') WHERE code = 'S3-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zdrojov pridelenĂ˝ch na riadenie vĂ˝znamnĂ˝ch dopadov') WHERE code = 'S3-4_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa podnik snaĹľĂ­ vyuĹľiĹĄ vplyv s relevantnĂ˝mi obchodnĂ˝mi vzĹĄahmi na riadenie vĂ˝znamnĂ˝ch negatĂ­vnych dopadov ovplyvĹujĂşcich ovplyvnenĂ© komunity') WHERE code = 'S3-4_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako je ĂşÄŤasĹĄ v priemyselnej alebo viacstrannej iniciatĂ­ve a vlastnĂ© zapojenie podniku zameranĂ© na rieĹˇenie vĂ˝znamnĂ˝ch dopadov') WHERE code = 'S3-4_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako ovplyvnenĂ© komunity zohrĂˇvajĂş Ăşlohu v rozhodnutiach tĂ˝kajĂşcich sa nĂˇvrhu a implementĂˇcie programov alebo investĂ­ciĂ­') WHERE code = 'S3-4_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zamĂ˝ĹˇÄľanĂ˝ch alebo dosiahnutĂ˝ch pozitĂ­vnych vĂ˝sledkoch programov alebo investĂ­ciĂ­ pre ovplyvnenĂ© komunity') WHERE code = 'S3-4_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie pribliĹľnĂ©ho rozsahu ovplyvnenĂ˝ch komunĂ­t pokrytĂ˝ch opisovanĂ˝mi programami sociĂˇlnych investĂ­ciĂ­ alebo rozvoja a, kde je to moĹľnĂ©, odĂ´vodnenie, preÄŤo boli vybranĂ© konkrĂ©tne komunity') WHERE code = 'S3-4_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'IniciatĂ­vy alebo procesy, ktorĂ˝ch primĂˇrnym cieÄľom je poskytovanie pozitĂ­vnych dopadov pre ovplyvnenĂ© komunity, jsou navrhnutĂ© aj na podporu dosiahnutia jednĂ©ho alebo viacerĂ˝ch CieÄľov udrĹľateÄľnĂ©ho rozvoja') WHERE code = 'S3-4_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis internĂ˝ch funkciĂ­, ktorĂ© sa podieÄľajĂş na riadenĂ­ dopadov a typy opatrenĂ­ prijatĂ˝ch internĂ˝mi funkciami na rieĹˇenie negatĂ­vnych a podporu pozitĂ­vnych dopadov') WHERE code = 'S3-4_19';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş vykazovaĹĄ, ak podnik neprijal opatrenia') WHERE code = 'S3.MDR-A_13-14';

-- S3-5: Targets
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovenĂ© na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa ovplyvnenĂ˝ch komunĂ­t [pozri ESRS 2 - MDR-T]') WHERE code = 'S3.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako boli ovplyvnenĂ© komunity priamo zapojenĂ© do stanovovania cieÄľov') WHERE code = 'S3-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako boli ovplyvnenĂ© komunity priamo zapojenĂ© do sledovania vĂ˝konnosti voÄŤi cieÄľom') WHERE code = 'S3-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako boli ovplyvnenĂ© komunity priamo zapojenĂ© do identifikĂˇcie pouÄŤenĂ­ alebo zlepĹˇenĂ­ ako vĂ˝sledku vĂ˝konnosti podniku') WHERE code = 'S3-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamĂ˝ĹˇÄľanĂ˝ch vĂ˝sledkov, ktorĂ© sa majĂş dosiahnuĹĄ v Ĺľivotoch ovplyvnenĂ˝ch komunĂ­t') WHERE code = 'S3-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o stabilite cieÄľa v priebehu ÄŤasu z hÄľadiska definĂ­ciĂ­ a metodĂ­k na umoĹľnenie porovnateÄľnosti') WHERE code = 'S3-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na Ĺˇtandardy alebo zĂˇvĂ¤zky, na ktorĂ˝ch je cieÄľ zaloĹľenĂ˝') WHERE code = 'S3-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş vykazovaĹĄ, ak podnik neprijal ciele') WHERE code = 'S3.MDR-T_14-19';

-- =====================================================
-- ESRS S4 (Spotrebitelia a koncovĂ­ pouĹľĂ­vatelia) - Slovak Translations
-- =====================================================

-- S4.SBM-3: Strategy and Business Model
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĹˇetci spotrebitelia a koncovĂ­ pouĹľĂ­vatelia, ktorĂ­ mĂ´Ĺľu byĹĄ vĂ˝znamne ovplyvnenĂ­ podnikom, sĂş zahrnutĂ­ v rozsahu zverejnenia podÄľa ESRS 2') WHERE code = 'S4.SBM-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis typov spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov podliehajĂşcich vĂ˝znamnĂ˝m dopadom') WHERE code = 'S4.SBM-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov podliehajĂşcich vĂ˝znamnĂ˝m dopadom vlastnĂ˝mi ÄŤinnosĹĄami alebo prostrednĂ­ctvom hodnotovĂ©ho reĹĄazca') WHERE code = 'S4.SBM-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝skyt vĂ˝znamnĂ˝ch negatĂ­vnych dopadov (spotrebitelia a koncovĂ­ pouĹľĂ­vatelia)') WHERE code = 'S4.SBM-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ÄŤinnostĂ­, ktorĂ© majĂş pozitĂ­vne dopady, a typy spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov, ktorĂ­ sĂş alebo mĂ´Ĺľu byĹĄ pozitĂ­vne ovplyvnenĂ­') WHERE code = 'S4.SBM-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis vĂ˝znamnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na spotrebiteÄľoch a koncovĂ˝ch pouĹľĂ­vateÄľoch') WHERE code = 'S4.SBM-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako bolo rozvinutĂ© pochopenie toho, ako mĂ´Ĺľu byĹĄ spotrebitelia a koncovĂ­ pouĹľĂ­vatelia s osobitnĂ˝mi charakteristikami, pracujĂşci v osobitnĂ˝ch podmienkach alebo vykonĂˇvajĂşci osobitnĂ© ÄŤinnosti vystavenĂ­ vyĹˇĹˇiemu riziku poĹˇkodenia') WHERE code = 'S4.SBM-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ktorĂ© zo vĂ˝znamnĂ˝ch rizĂ­k a prĂ­leĹľitostĂ­ vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na spotrebiteÄľoch a koncovĂ˝ch pouĹľĂ­vateÄľoch sĂş dopadmi na konkrĂ©tne skupiny') WHERE code = 'S4.SBM-3_08';

-- S4-1: Policies
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov [pozri ESRS 2 MDR-P]') WHERE code = 'S4.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa ovplyvnenĂ˝ch spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov, vrĂˇtane ĹˇpecifickĂ˝ch skupĂ­n alebo vĹˇetkĂ˝ch spotrebiteÄľov / koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis relevantnĂ˝ch zĂˇvĂ¤zkov v oblasti politiky ÄľudskĂ˝ch prĂˇv tĂ˝kajĂşcich sa spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu vo vzĹĄahu k reĹˇpektovaniu ÄľudskĂ˝ch prĂˇv spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu vo vzĹĄahu k zapojeniu spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu vo vzĹĄahu k opatreniam na zabezpeÄŤenie a (alebo) umoĹľnenie nĂˇpravy dopadov na ÄľudskĂ© prĂˇva') WHERE code = 'S4-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis, ÄŤi a ako sĂş politiky zosĂşladenĂ© s prĂ­sluĹˇnĂ˝mi medzinĂˇrodne uznĂˇvanĂ˝mi nĂˇstrojmi') WHERE code = 'S4-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie rozsahu a uvedenie povahy prĂ­padov nedodrĹľania UsmernenĂ­ OSN pre podnikanie a ÄľudskĂ© prĂˇva, DeklarĂˇcie MOP o zĂˇkladnĂ˝ch princĂ­poch a prĂˇvach pri prĂˇci alebo UsmernenĂ­ OECD pre nadnĂˇrodnĂ© podniky, ktorĂ© zahĹ•ĹajĂş spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vysvetlenia vĂ˝znamnĂ˝ch zmien prijatĂ˝ch politĂ­k poÄŤas vykazovacieho roka') WHERE code = 'S4-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie o ilustrĂˇcii typov komunikĂˇcie svojich politĂ­k jednotlivcom, skupine jednotlivcov alebo subjektom, pre ktorĂ© sĂş relevantnĂ©') WHERE code = 'S4-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş vykazovaĹĄ v prĂ­pade, Ĺľe podnik neprijal politiky') WHERE code = 'S4.MDR-P_07-08';

-- S4-2: Engagement with consumers and end-users
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako perspektĂ­vy spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov ovplyvĹujĂş rozhodnutia alebo ÄŤinnosti zameranĂ© na riadenie skutoÄŤnĂ˝ch a potenciĂˇlnych dopadov') WHERE code = 'S4-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zapojenie sa uskutoÄŤĹuje so spotrebiteÄľmi a koncovĂ˝mi pouĹľĂ­vateÄľmi alebo ich legitĂ­mnymi zĂˇstupcami priamo alebo s dĂ´veryhodnĂ˝mi zĂˇstupcami') WHERE code = 'S4-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ĹˇtĂˇdia, v ktorom dochĂˇdza k zapojeniu, typu zapojenia a frekvencie zapojenia') WHERE code = 'S4-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkcie a najvyĹˇĹˇej pozĂ­cie v rĂˇmci podniku, ktorĂˇ mĂˇ operatĂ­vnu zodpovednosĹĄ za zabezpeÄŤenie zapojenia a za to, Ĺľe vĂ˝sledky informujĂş o prĂ­stupe podniku') WHERE code = 'S4-2_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako sa hodnotĂ­ ĂşÄŤinnosĹĄ zapojenia so spotrebiteÄľmi a koncovĂ˝mi pouĹľĂ­vateÄľmi') WHERE code = 'S4-2_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie krokov prijatĂ˝ch na zĂ­skanie prehÄľadu o perspektĂ­vach spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov / spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov, ktorĂ­ mĂ´Ĺľu byĹĄ obzvlĂˇĹˇĹĄ zraniteÄľnĂ­ voÄŤi dopadom a (alebo) marginalizovanĂ­') WHERE code = 'S4-2_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces na zapojenie spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-2_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho harmonogramu prijatia vĹˇeobecnĂ©ho procesu na zapojenie spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces zapojenia') WHERE code = 'S4-2_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Typ Ăşlohy alebo funkcie, ktorĂˇ sa zaoberĂˇ zapojenĂ­m') WHERE code = 'S4-2_09';

-- S4-3: Processes to remediate negative impacts and channels for consumers and end-users to raise concerns
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie vĹˇeobecnĂ©ho prĂ­stupu a procesov na poskytovanie alebo prispievanie k nĂˇprave, keÄŹ podnik identifikoval, Ĺľe je spojenĂ˝ so vĂ˝znamnĂ˝m negatĂ­vnym dopadom na spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie konkrĂ©tnych kanĂˇlov, ktorĂ© majĂş spotrebitelia a koncovĂ­ pouĹľĂ­vatelia k dispozĂ­cii na priame vznesenie obĂˇv alebo potrieb s podnikom a ich rieĹˇenie') WHERE code = 'S4-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie procesov, prostrednĂ­ctvom ktorĂ˝ch podnik podporuje alebo vyĹľaduje dostupnosĹĄ kanĂˇlov') WHERE code = 'S4-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako sĂş vznesenĂ© a rieĹˇenĂ© otĂˇzky sledovanĂ© a monitorovanĂ© a ako je zabezpeÄŤenĂˇ ĂşÄŤinnosĹĄ kanĂˇlov') WHERE code = 'S4-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa hodnotĂ­, Ĺľe spotrebitelia a koncovĂ­ pouĹľĂ­vatelia si sĂş vedomĂ­ ĹˇtruktĂşr alebo procesov a dĂ´verujĂş im ako spĂ´sobu, ako vyjadriĹĄ svoje obavy alebo potreby a nechaĹĄ ich rieĹˇiĹĄ') WHERE code = 'S4-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky tĂ˝kajĂşce sa ochrany pred odvetou pre jednotlivcov, ktorĂ­ pouĹľĂ­vajĂş kanĂˇly na vznesenie obĂˇv alebo potrieb, sĂş zavedenĂ©') WHERE code = 'S4-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyhlĂˇsenie v prĂ­pade, Ĺľe podnik neprijal vĹˇeobecnĂ˝ proces na zapojenie spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ÄŤasovĂ©ho harmonogramu zavedenia kanĂˇlov alebo procesov na vznesenie obĂˇv') WHERE code = 'S4-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako majĂş spotrebitelia a (alebo) koncovĂ­ pouĹľĂ­vatelia prĂ­stup ku kanĂˇlom na Ăşrovni podniku, ktorĂ˝m sĂş ovplyvnenĂ­') WHERE code = 'S4-3_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Mechanizmy tretĂ­ch strĂˇn sĂş prĂ­stupnĂ© vĹˇetkĂ˝m spotrebiteÄľom a (alebo) koncovĂ˝m pouĹľĂ­vateÄľom') WHERE code = 'S4-3_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'SĹĄaĹľnosti sa rieĹˇia dĂ´verne a s reĹˇpektovanĂ­m prĂˇva na sĂşkromie a ochranu Ăşdajov') WHERE code = 'S4-3_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Spotrebitelia a koncovĂ­ pouĹľĂ­vatelia majĂş moĹľnosĹĄ pouĹľĂ­vaĹĄ kanĂˇly na vznesenie obĂˇv alebo potrieb anonymne') WHERE code = 'S4-3_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet sĹĄaĹľnostĂ­ prijatĂ˝ch od spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov poÄŤas vykazovacieho obdobia') WHERE code = 'S4-3_13';

-- S4-4: Actions
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AkÄŤnĂ© plĂˇny a zdroje na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov [pozri ESRS 2 - MDR-A]') WHERE code = 'S4.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis plĂˇnovanĂ˝ch alebo prebiehajĂşcich opatrenĂ­ na predchĂˇdzanie, zmiernenie alebo nĂˇpravu vĂ˝znamnĂ˝ch negatĂ­vnych dopadov na spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis, ÄŤi a ako boli prijatĂ© opatrenia na poskytnutie alebo umoĹľnenie nĂˇpravy vo vzĹĄahu k skutoÄŤnĂ©mu vĂ˝znamnĂ©mu dopadu') WHERE code = 'S4-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis dodatoÄŤnĂ˝ch iniciatĂ­v alebo procesov, ktorĂ˝ch primĂˇrnym ĂşÄŤelom je poskytovanie pozitĂ­vnych dopadov pre spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, ako sa sleduje a hodnotĂ­ ĂşÄŤinnosĹĄ opatrenĂ­ alebo iniciatĂ­v pri dosahovanĂ­ vĂ˝sledkov pre spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k identifikĂˇcii toho, akĂ© opatrenie je potrebnĂ© a vhodnĂ© v reakcii na konkrĂ©tny skutoÄŤnĂ˝ alebo potenciĂˇlny vĂ˝znamnĂ˝ negatĂ­vny dopad na spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k prijĂ­maniu opatrenĂ­ vo vzĹĄahu ku konkrĂ©tnym vĂ˝znamnĂ˝m dopadom na spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupu k zabezpeÄŤeniu, Ĺľe procesy na poskytovanie alebo umoĹľnenie nĂˇpravy v prĂ­pade vĂ˝znamnĂ˝ch negatĂ­vnych dopadov na spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov sĂş dostupnĂ© a ĂşÄŤinnĂ© v ich implementĂˇcii a vĂ˝sledkoch') WHERE code = 'S4-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂ© opatrenie je plĂˇnovanĂ© alebo prebieha na zmiernenie vĂ˝znamnĂ˝ch rizĂ­k vyplĂ˝vajĂşcich z dopadov a zĂˇvislostĂ­ na spotrebiteÄľoch a koncovĂ˝ch pouĹľĂ­vateÄľoch a ako sa sleduje ĂşÄŤinnosĹĄ') WHERE code = 'S4-4_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis toho, akĂ© opatrenie je plĂˇnovanĂ© alebo prebieha na vyuĹľitie vĂ˝znamnĂ˝ch prĂ­leĹľitostĂ­ vo vzĹĄahu k spotrebiteÄľom a koncovĂ˝m pouĹľĂ­vateÄľom') WHERE code = 'S4-4_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa zabezpeÄŤuje, Ĺľe vlastnĂ© postupy nespĂ´sobujĂş ani neprispievajĂş k vĂ˝znamnĂ˝m negatĂ­vnym dopadom na spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zĂˇvaĹľnĂ˝ch otĂˇzok a incidentov v oblasti ÄľudskĂ˝ch prĂˇv spojenĂ˝ch so spotrebiteÄľmi a (alebo) koncovĂ˝mi pouĹľĂ­vateÄľmi') WHERE code = 'S4-4_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zdrojov pridelenĂ˝ch na riadenie vĂ˝znamnĂ˝ch dopadov') WHERE code = 'S4-4_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa podnik snaĹľĂ­ vyuĹľiĹĄ vplyv s relevantnĂ˝mi obchodnĂ˝mi vzĹĄahmi na riadenie vĂ˝znamnĂ˝ch negatĂ­vnych dopadov ovplyvĹujĂşcich spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako je ĂşÄŤasĹĄ v priemyselnej alebo viacstrannej iniciatĂ­ve a vlastnĂ© zapojenie podniku zameranĂ© na rieĹˇenie vĂ˝znamnĂ˝ch dopadov') WHERE code = 'S4-4_14';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ako spotrebitelia a koncovĂ­ pouĹľĂ­vatelia zohrĂˇvajĂş Ăşlohu v rozhodnutiach tĂ˝kajĂşcich sa nĂˇvrhu a implementĂˇcie programov alebo procesov') WHERE code = 'S4-4_15';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zamĂ˝ĹˇÄľanĂ˝ch alebo dosiahnutĂ˝ch pozitĂ­vnych vĂ˝sledkoch programov alebo procesov pre spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-4_16';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'IniciatĂ­vy alebo procesy, ktorĂ˝ch primĂˇrnym cieÄľom je poskytovanie pozitĂ­vnych dopadov pre spotrebiteÄľov a (alebo) koncovĂ˝ch pouĹľĂ­vateÄľov, sĂş navrhnutĂ© aj na podporu dosiahnutia jednĂ©ho alebo viacerĂ˝ch CieÄľov udrĹľateÄľnĂ©ho rozvoja') WHERE code = 'S4-4_17';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis internĂ˝ch funkciĂ­, ktorĂ© sa podieÄľajĂş na riadenĂ­ dopadov a typy opatrenĂ­ prijatĂ˝ch internĂ˝mi funkciami na rieĹˇenie negatĂ­vnych a podporu pozitĂ­vnych dopadov') WHERE code = 'S4-4_18';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş vykazovaĹĄ, ak podnik neprijal opatrenia') WHERE code = 'S4.MDR-A_13-14';

-- S4-5: Targets
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Ciele stanovenĂ© na riadenie vĂ˝znamnĂ˝ch dopadov, rizĂ­k a prĂ­leĹľitostĂ­ tĂ˝kajĂşcich sa spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov [pozri ESRS 2 - MDR-T]') WHERE code = 'S4.MDR-T_01-13';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako boli spotrebitelia a koncovĂ­ pouĹľĂ­vatelia priamo zapojenĂ­ do stanovovania cieÄľov') WHERE code = 'S4-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako boli spotrebitelia a koncovĂ­ pouĹľĂ­vatelia priamo zapojenĂ­ do sledovania vĂ˝konnosti voÄŤi cieÄľom') WHERE code = 'S4-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako boli spotrebitelia a koncovĂ­ pouĹľĂ­vatelia priamo zapojenĂ­ do identifikĂˇcie pouÄŤenĂ­ alebo zlepĹˇenĂ­ ako vĂ˝sledku vĂ˝konnosti podniku') WHERE code = 'S4-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie zamĂ˝ĹˇÄľanĂ˝ch vĂ˝sledkov, ktorĂ© sa majĂş dosiahnuĹĄ v Ĺľivotoch spotrebiteÄľov a koncovĂ˝ch pouĹľĂ­vateÄľov') WHERE code = 'S4-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o stabilite cieÄľa v priebehu ÄŤasu z hÄľadiska definĂ­ciĂ­ a metodĂ­k na umoĹľnenie porovnateÄľnosti') WHERE code = 'S4-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odkazov na Ĺˇtandardy alebo zĂˇvĂ¤zky, na ktorĂ˝ch je cieÄľ zaloĹľenĂ˝') WHERE code = 'S4-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş vykazovaĹĄ, ak podnik neprijal ciele') WHERE code = 'S4.MDR-T_14-19';
-- ============================================================================
-- ESRS G1: ObchodnĂ© sprĂˇvanie - SlovenskĂ© preklady
-- ============================================================================
-- DĂˇtum vytvorenia: 6. februĂˇr 2026
-- Ĺ tandard: ESRS G1 - Business Conduct (ObchodnĂ© sprĂˇvanie)
-- 
-- TematickĂ© oblasti:
-- - SprĂˇva a dohÄľad nad obchodnĂ˝m sprĂˇvanĂ­m
-- - FiremnĂˇ kultĂşra a etickĂ˝ kĂłdex
-- - Politiky proti korupcii a ĂşplatkĂˇrstvu
-- - Ochrana oznamovateÄľov (whistleblowers)
-- - VzĹĄahy s dodĂˇvateÄľmi a platobnĂˇ prax
-- - PolitickĂ˝ vplyv a lobbing
-- - Platby vlĂˇdam
-- - DodrĹľiavanie pravidiel hospodĂˇrskej sĂşĹĄaĹľe
-- ============================================================================

-- GOV-1: SprĂˇva a dohÄľad nad obchodnĂ˝m sprĂˇvanĂ­m
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie Ăşlohy sprĂˇvnych, riadiacich a dozornĂ˝ch orgĂˇnov vo vzĹĄahu k obchodnĂ©mu sprĂˇvaniu') WHERE code = 'G1.GOV-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie odbornĂ˝ch znalostĂ­ sprĂˇvnych, riadiacich a dozornĂ˝ch orgĂˇnov v oblasti obchodnĂ©ho sprĂˇvania') WHERE code = 'G1.GOV-1_02';

-- G1-1: FiremnĂˇ kultĂşra, etickĂ˝ kĂłdex a politiky obchodnĂ©ho sprĂˇvania
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Politiky na riadenie materiĂˇlnych vplyvov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s obchodnĂ˝m sprĂˇvanĂ­m a firemnou kultĂşrou [pozri ESRS 2 MDR-P]') WHERE code = 'G1.MDR-P_01-06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis spĂ´sobu, akĂ˝m podnik vytvĂˇra, rozvĂ­ja, podporuje a vyhodnocuje svoju firemnĂş kultĂşru') WHERE code = 'G1-1_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis mechanizmov na identifikĂˇciu, nahlasovanie a vyĹˇetrovanie obĂˇv tĂ˝kajĂşcich sa protiprĂˇvneho sprĂˇvania alebo sprĂˇvania v rozpore s kĂłdexom sprĂˇvania alebo podobnĂ˝mi internĂ˝mi pravidlami') WHERE code = 'G1-1_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'NeexistujĂş politiky proti korupcii alebo ĂşplatkĂˇrstvu v sĂşlade s Dohovorom OSN proti korupcii') WHERE code = 'G1-1_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ÄŚasovĂ˝ harmonogram implementĂˇcie politĂ­k proti korupcii alebo ĂşplatkĂˇrstvu v sĂşlade s Dohovorom OSN proti korupcii') WHERE code = 'G1-1_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie ochrannĂ˝ch opatrenĂ­ pri nahlasovanĂ­ nezrovnalostĂ­ vrĂˇtane ochrany oznamovateÄľov') WHERE code = 'G1-1_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'NeexistujĂş politiky ochrany oznamovateÄľov') WHERE code = 'G1-1_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ÄŚasovĂ˝ harmonogram implementĂˇcie politĂ­k ochrany oznamovateÄľov') WHERE code = 'G1-1_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik sa zavĂ¤zuje vyĹˇetrovaĹĄ incidenty tĂ˝kajĂşce sa obchodnĂ©ho sprĂˇvania rĂ˝chlo, nezĂˇvisle a objektĂ­vne') WHERE code = 'G1-1_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'ExistujĂş politiky tĂ˝kajĂşce sa ochrany zvierat') WHERE code = 'G1-1_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o politike ĹˇkolenĂ­ v rĂˇmci organizĂˇcie tĂ˝kajĂşcich sa obchodnĂ©ho sprĂˇvania') WHERE code = 'G1-1_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie funkciĂ­, ktorĂ© sĂş najviac ohrozenĂ© korupciou a ĂşplatkĂˇrstvom') WHERE code = 'G1-1_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Subjekt podlieha zĂˇkonnĂ˝m poĹľiadavkĂˇm tĂ˝kajĂşcim sa ochrany oznamovateÄľov') WHERE code = 'G1-1_12';

-- G1-2: VzĹĄahy s dodĂˇvateÄľmi a platobnĂˇ prax
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis politiky na predchĂˇdzanie oneskorenĂ˝m platbĂˇm, najmĂ¤ malĂ˝m a strednĂ˝m podnikom') WHERE code = 'G1-2_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis prĂ­stupov tĂ˝kajĂşcich sa vzĹĄahov s dodĂˇvateÄľmi s prihliadnutĂ­m na rizikĂˇ sĂşvisiace s dodĂˇvateÄľskĂ˝m reĹĄazcom a vplyvy na otĂˇzky udrĹľateÄľnosti') WHERE code = 'G1-2_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie, ÄŤi a ako sa zohÄľadĹujĂş sociĂˇlne a environmentĂˇlne kritĂ©riĂˇ pri vĂ˝bere zmluvnĂ˝ch partnerov na strane dodĂˇvok') WHERE code = 'G1-2_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ v prĂ­pade, Ĺľe podnik neprijal politiky') WHERE code = 'G1.MDR-P_07-08';

-- G1-3: Postupy proti korupcii a ĂşplatkĂˇrstvu
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o postupoch na predchĂˇdzanie, odhaÄľovanie a rieĹˇenie obvinenĂ­ alebo incidentov korupcie alebo ĂşplatkĂˇrstva') WHERE code = 'G1-3_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VyĹˇetrovatelia alebo vyĹˇetrovacĂ­ vĂ˝bor sĂş oddelenĂ­ od reĹĄazca riadenia zapojenĂ©ho do prevencie a odhaÄľovania korupcie alebo ĂşplatkĂˇrstva') WHERE code = 'G1-3_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o procese oznamovania vĂ˝sledkov sprĂˇvnym, riadiacim a dozornĂ˝m orgĂˇnom') WHERE code = 'G1-3_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plĂˇnov na prijatie postupov na predchĂˇdzanie, odhaÄľovanie a rieĹˇenie obvinenĂ­ alebo incidentov korupcie alebo ĂşplatkĂˇrstva v prĂ­pade neexistencie postupov') WHERE code = 'G1-3_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o tom, ako sa politiky komunikujĂş tĂ˝m, pre ktorĂ˝ch sĂş relevantnĂ© (prevencia a odhaÄľovanie korupcie alebo ĂşplatkĂˇrstva)') WHERE code = 'G1-3_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o povahe, rozsahu a hÄşbke Ĺˇkoliacich programov proti korupcii alebo ĂşplatkĂˇrstvu, ktorĂ© sĂş ponĂşkanĂ© alebo vyĹľadovanĂ©') WHERE code = 'G1-3_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percento rizikovĂ˝ch funkciĂ­ pokrytĂ˝ch Ĺˇkoliacimi programami') WHERE code = 'G1-3_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o ÄŤlenoch sprĂˇvnych, dozornĂ˝ch a riadiacich orgĂˇnov tĂ˝kajĂşce sa ĹˇkolenĂ­ proti korupcii alebo ĂşplatkĂˇrstvu') WHERE code = 'G1-3_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie analĂ˝zy Ĺˇkoliacich aktivĂ­t naprĂ­klad podÄľa regiĂłnu Ĺˇkolenia alebo kategĂłrie') WHERE code = 'G1-3_09';

-- G1-4: AkÄŤnĂ© plĂˇny, ciele a opatrenia proti korupcii
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'AkÄŤnĂ© plĂˇny a zdroje na riadenie materiĂˇlnych vplyvov, rizĂ­k a prĂ­leĹľitostĂ­ sĂşvisiacich s korupciou a ĂşplatkĂˇrstvom [pozri ESRS 2 - MDR-A]') WHERE code = 'G1.MDR-A_01-12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet odsĂşdenĂ­ za poruĹˇenie zĂˇkonov proti korupcii a ĂşplatkĂˇrstvu') WHERE code = 'G1-4_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝Ĺˇka pokĂşt za poruĹˇenie zĂˇkonov proti korupcii a ĂşplatkĂˇrstvu') WHERE code = 'G1-4_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Prevencia a odhaÄľovanie korupcie alebo ĂşplatkĂˇrstva - tabuÄľka ĹˇkolenĂ­ proti korupcii a ĂşplatkĂˇrstvu') WHERE code = 'G1-4_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet potvrdenĂ˝ch incidentov korupcie alebo ĂşplatkĂˇrstva') WHERE code = 'G1-4_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o povahe potvrdenĂ˝ch incidentov korupcie alebo ĂşplatkĂˇrstva') WHERE code = 'G1-4_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet potvrdenĂ˝ch incidentov, pri ktorĂ˝ch boli vlastnĂ­ zamestnanci prepustenĂ­ alebo disciplinĂˇrne potrestanĂ­ za incidenty sĂşvisiace s korupciou alebo ĂşplatkĂˇrstvom') WHERE code = 'G1-4_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet potvrdenĂ˝ch incidentov tĂ˝kajĂşcich sa zmlĂşv s obchodnĂ˝mi partnermi, ktorĂ© boli ukonÄŤenĂ© alebo neboli obnovenĂ© z dĹŻvodu poruĹˇenĂ­ sĂşvisiacich s korupciou alebo ĂşplatkĂˇrstvom') WHERE code = 'G1-4_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o detailoch verejnĂ˝ch prĂˇvnych prĂ­padov tĂ˝kajĂşcich sa korupcie alebo ĂşplatkĂˇrstva vznesenĂ˝ch proti podniku a vlastnĂ˝m zamestnancom a o vĂ˝sledkoch takĂ˝chto prĂ­padov') WHERE code = 'G1-4_08';

-- G1-5: PolitickĂ˝ vplyv, lobbing a finanÄŤnĂ© prĂ­spevky
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o zĂˇstupcovi/zĂˇstupcoch zodpovednĂ˝ch v sprĂˇvnych, riadiacich a dozornĂ˝ch orgĂˇnoch za dohÄľad nad aktivitami politickĂ©ho vplyvu a lobbingu') WHERE code = 'G1-5_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o finanÄŤnĂ˝ch alebo naturĂˇlnych politickĂ˝ch prĂ­spevkoch') WHERE code = 'G1-5_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoskytnutĂ© finanÄŤnĂ© politickĂ© prĂ­spevky') WHERE code = 'G1-5_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝Ĺˇka internĂ˝ch a externĂ˝ch vĂ˝davkov na lobbing') WHERE code = 'G1-5_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'VĂ˝Ĺˇka zaplatenĂˇ za ÄŤlenstvo v lobbingovĂ˝ch asociĂˇciĂˇch') WHERE code = 'G1-5_05';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoskytnutĂ© naturĂˇlne politickĂ© prĂ­spevky') WHERE code = 'G1-5_06';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie spĂ´sobu odhadu peĹaĹľnej hodnoty naturĂˇlnych prĂ­spevkov') WHERE code = 'G1-5_07';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoskytnutĂ© finanÄŤnĂ© a naturĂˇlne politickĂ© prĂ­spevky [tabuÄľka]') WHERE code = 'G1-5_08';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie hlavnĂ˝ch tĂ©m pokrytĂ˝ch lobbingovĂ˝mi aktivitami a hlavnĂ˝ch postojov podniku k tĂ˝mto tĂ©mam') WHERE code = 'G1-5_09';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Podnik je registrovanĂ˝ v Registri transparentnosti EĂš alebo v ekvivalentnom registri transparentnosti v ÄŤlenskom ĹˇtĂˇte') WHERE code = 'G1-5_10';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'InformĂˇcie o vymenovanĂ­ akĂ˝chkoÄľvek ÄŤlenov sprĂˇvnych, riadiacich a dozornĂ˝ch orgĂˇnov, ktorĂ­ zastĂˇvali porovnateÄľnĂş pozĂ­ciu vo verejnej sprĂˇve poÄŤas dvoch rokov pred takĂ˝mto vymenovanĂ­m') WHERE code = 'G1-5_11';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Subjekt je zo zĂˇkona povinnĂ˝ byĹĄ ÄŤlenom obchodnej komory alebo inej organizĂˇcie zastupujĂşcej jeho zĂˇujmy') WHERE code = 'G1-5_12';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenia, ktorĂ© sa majĂş uviesĹĄ, ak podnik neprijal opatrenia') WHERE code = 'G1.MDR-A_13-14';

-- G1-6: PlatobnĂˇ prax a vzĹĄahy s dodĂˇvateÄľmi
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PriemernĂ˝ poÄŤet dnĂ­ na zaplatenie faktĂşry odo dĹa, keÄŹ sa zaÄŤĂ­na poÄŤĂ­taĹĄ zmluvnĂˇ alebo zĂˇkonnĂˇ lehota splatnosti') WHERE code = 'G1-6_01';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Opis ĹˇtandardnĂ˝ch platobnĂ˝ch podmienok podniku v poÄŤte dnĂ­ podÄľa hlavnej kategĂłrie dodĂˇvateÄľov') WHERE code = 'G1-6_02';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Percento platieb v sĂşlade so ĹˇtandardnĂ˝mi platobnĂ˝mi podmienkami') WHERE code = 'G1-6_03';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'PoÄŤet prebiehajĂşcich sĂşdnych konanĂ­ tĂ˝kajĂşcich sa oneskorenĂ˝ch platieb') WHERE code = 'G1-6_04';
UPDATE disclosure_question SET translations = translations || jsonb_build_object('sk', 'Zverejnenie kontextovĂ˝ch informĂˇciĂ­ tĂ˝kajĂşcich sa platobnej praxe') WHERE code = 'G1-6_05';
