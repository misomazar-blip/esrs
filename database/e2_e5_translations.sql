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
