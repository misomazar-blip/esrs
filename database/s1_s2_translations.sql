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
