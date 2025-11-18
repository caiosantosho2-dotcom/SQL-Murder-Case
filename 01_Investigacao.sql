/*
/*
PROJETO: SQL Murder Mystery - Log de Investigação (Fase 1: Root Cause Analysis)
OBJETIVO: Documentar o passo a passo lógico para isolar o único suspeito que atende a todas as 4 pistas.
*/

-- ====================================================================
-- PASSO 1: LOCALIZANDO O CRIME E AS PISTAS INICIAIS
-- Ação: Filtrar o crime pelo dia 20180115 na SQL City.
-- --------------------------------------------------------------------
SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND city = 'SQL City' AND type = 'murder';

-- PISTA CHAVE: 2 testemunhas. 1) Última casa na "Northwestern Dr". 2) Chamada Annabel, mora na "Franklin Ave".

-- ====================================================================
-- PASSO 2: ENCONTRANDO AS TESTEMUNHAS E OBTENDO AS PISTAS DETALHADAS
-- Raciocínio: Usar ORDER BY DESC LIMIT 1 para a última casa e LIKE 'Annabel%' para a segunda.
-- --------------------------------------------------------------------
-- A) Testemunha 1 (Morty Schapiro)
SELECT id, name, license_id, address_number
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

-- B) Testemunha 2 (Annabel Miller)
SELECT id, name
FROM person
WHERE address_street_name = 'Franklin Ave' AND name LIKE 'Annabel%';

-- C) Extração das Pistas Textuais (Busca na tabela interview)
SELECT transcript
FROM interview
WHERE person_id IN (14887, 16371);
/* PISTAS OBTIDAS (FILTROS)
   1. Status: 'gold'
   2. Associação: ID LIKE '48Z%'
   3. Placa: LIKE '%H42W%'
   4. Álibi Quebrado: Check-in na academia em 20180109
*/

-- ====================================================================
-- PASSO 3: QUERY FINAL - ISOLANDO O ASSASSINO (O JOIN Principal)
-- Ligar todas as tabelas e aplicar os 4 filtros simultaneamente.
-- --------------------------------------------------------------------
SELECT T1.id, T1.name
FROM person AS T1
JOIN get_fit_now_member AS T2 ON T1.id = T2.person_id
JOIN drivers_license AS T3 ON T1.license_id = T3.id
JOIN get_fit_now_check_in AS T4 ON T2.id = T4.membership_id
WHERE T2.membership_status = 'gold'
  AND T2.id LIKE '48Z%'              
  AND T3.plate_number LIKE '%H42W%'
  AND T4.check_in_date = 20180109;

-- SOLUÇÃO FINAL: Jeremy Bowers (ID: 67318)