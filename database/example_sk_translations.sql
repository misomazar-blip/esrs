-- Example Slovak translations for E1 (Climate Change) questions
-- Run this AFTER add_question_translations.sql

-- E1-1_01: Transition plan disclosure
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie plánu prechodu na zmierňovanie zmeny klímy')
WHERE code = 'E1-1_01';

-- E1-1_02: Paris Agreement compatibility
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie, ako sú ciele zlučiteľné s obmedzením globálneho otepľovania na jeden a pol stupňa Celzia v súlade s Parížskou dohodou')
WHERE code = 'E1-1_02';

-- E1-1_03: Decarbonisation levers
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie páky dekarbonizácie a kľúčové opatrenia')
WHERE code = 'E1-1_03';

-- E1-1_04: OpEx/CapEx requirements
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Zverejnenie významných prevádzkových výdavkov (OpEx) a/alebo kapitálových výdavkov (CapEx) potrebných na implementáciu akčného plánu')
WHERE code = 'E1-1_04';

-- E1-1_05: OpEx allocation
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Finančné zdroje pridelené na akčný plán (OpEx)')
WHERE code = 'E1-1_05';

-- E1-1_06: CapEx allocation
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Finančné zdroje pridelené na akčný plán (CapEx)')
WHERE code = 'E1-1_06';

-- E1-1_07: Locked-in emissions
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie potenciálnych uzamknutých emisií skleníkových plynov z kľúčových aktív a produktov a toho, ako môžu ohroziť dosiahnutie cieľov zníženia emisií')
WHERE code = 'E1-1_07';

-- E1-1_08: Taxonomy alignment
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Vysvetlenie akýchkoľvek cieľov alebo plánov na zosúladenie ekonomických činností s kritériami stanovenými v nariadení Komisie v přenesené pravomoci 2021/2139')
WHERE code = 'E1-1_08';

-- E1-1_09: Coal-related CapEx
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Významné kapitálové výdavky pre ekonomické činnosti súvisiace s uhlím')
WHERE code = 'E1-1_09';

-- E1-1_10: Oil-related CapEx
UPDATE disclosure_question 
SET translations = translations || jsonb_build_object('sk', 'Významné kapitálové výdavky pre ekonomické činnosti súvisiace s ropou')
WHERE code = 'E1-1_10';

-- Verify translations were added
SELECT code, question_text, translations 
FROM disclosure_question 
WHERE code LIKE 'E1-1_%'
ORDER BY code;
