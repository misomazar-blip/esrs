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
