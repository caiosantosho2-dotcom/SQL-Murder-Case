/*
PROJETO: SQL Murder Mystery - Log Completo de Análise
DATA: 2018-01-15 (Data do Crime Investigado)
OBJETIVO: Documentar a jornada completa:
    SEÇÃO A: Root Cause Analysis (Investigação para identificar Jeremy Bowers).
    SEÇÃO B: Business Intelligence Reports (Geração de insights acionáveis).
*/

-- ====================================================================
-- SEÇÃO A: ROOT CAUSE ANALYSIS (INVESTIGAÇÃO DO CRIME)
-- Ação: Ligar 6 tabelas para isolar o único suspeito que atende a todas as 4 pistas.
-- ====================================================================

-- PASSO 1: LOCALIZANDO O CRIME E AS PISTAS INICIAIS
-- Filtrar o crime pelo dia 20180115 na SQL City.
SELECT description
FROM crime_scene_report
WHERE date = 20180115 AND city = 'SQL City' AND type = 'murder';
-- PISTA CHAVE: 2 testemunhas. 1) Última casa na "Northwestern Dr". 2) Chamada Annabel, mora na "Franklin Ave".


-- PASSO 2: ENCONTRANDO AS TESTEMUNHAS E OBTENDO AS PISTAS DETALHADAS
-- A) Testemunha 1 (Morty Schapiro) - Usando ORDER BY DESC LIMIT 1 para 'última casa'.
SELECT id, name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;
-- Resultado: Morty Schapiro (ID: 14887)

-- B) Testemunha 2 (Annabel Miller) - Usando LIKE 'Annabel%' para nome parcial.
SELECT id, name
FROM person
WHERE address_street_name = 'Franklin Ave' AND name LIKE 'Annabel%';
-- Resultado: Annabel Miller (ID: 16371)

-- C) Extração das Pistas Textuais (Transcrições)
SELECT transcript
FROM interview
WHERE person_id IN (14887, 16371);
/* PISTAS OBTIDAS (FILTROS)
   1. Status: 'gold'
   2. Associação: ID LIKE '48Z%'
   3. Placa: LIKE '%H42W%'
   4. Álibi Quebrado: Check-in na academia em 20180109
*/

-- PASSO 3: QUERY FINAL - ISOLANDO O ASSASSINO (O JOIN Principal)
-- Ligar todas as tabelas (person, get_fit_now_member, drivers_license, get_fit_now_check_in)
-- e aplicar os 4 filtros simultaneamente.
SELECT T1.id, T1.name
FROM person AS T1
JOIN get_fit_now_member AS T2 ON T1.id = T2.person_id
JOIN drivers_license AS T3 ON T1.license_id = T3.id
JOIN get_fit_now_check_in AS T4 ON T2.id = T4.membership_id
WHERE T2.membership_status = 'gold'
  AND T2.id LIKE '48Z%'              
  AND T3.plate_number LIKE '%H42W%'
  AND T4.check_in_date = 20180109;
-- Resultado Final: Jeremy Bowers (ID: 67318)


-- ====================================================================
-- SEÇÃO B: BUSINESS INTELLIGENCE REPORTS (ANÁLISES DE VALOR)
-- Propósito: Gerar 4 insights acionáveis (KPI, Otimização, Risco, Scoring).
-- ====================================================================

-- RELATÓRIO BI 1: OTIMIZAÇÃO DE RECURSOS (PICO DE DEMANDA)
-- Insight: Identificar horários de pico segmentados por tipo de membro para alocação de staff/segurança.
SELECT
    T2.membership_status,
    -- Extrai a hora (os 2 primeiros dígitos) do campo de hora
    CAST(SUBSTR(T1.check_in_time, 1, 2) AS INT) AS check_in_hour,
    COUNT(T1.membership_id) AS total_checkins
FROM get_fit_now_check_in AS T1
JOIN get_fit_now_member AS T2
  ON T1.membership_id = T2.id
GROUP BY 1, 2
ORDER BY total_checkins DESC;

-- RELATÓRIO BI 2: ANÁLISE DE RISCO GEOGRÁFICO (CONTAGEM DE INCIDÊNCIA)
-- Insight: Provar que a Franklin Ave é uma área de risco, usando o total de entrevistas como proxy de incidência criminal.
SELECT
    T2.address_street_name,
    COUNT(T1.person_id) AS total_interviews_count
FROM interview AS T1
JOIN person AS T2
  ON T1.person_id = T2.id
GROUP BY 1
ORDER BY total_interviews_count DESC;
-- Resultado: Confirma que Franklin Ave (27 entrevistas) tem alta atividade policial.

-- RELATÓRIO BI 3: PLACAR DE SUSPEITA (MODELAGEM PREDITIVA/LEAD SCORING)
-- Insight: Criar um ranking ponderado de risco (Score 0 a 100) usando a função CASE WHEN.
SELECT
    T1.name,
    T1.id AS person_id,
    -- Cálcula o Placar de Suspeita (Lead Scoring)
    (
        CASE WHEN T3.plate_number LIKE '%H42W%' THEN 50 ELSE 0 END + -- Maior Peso: Placa
        CASE WHEN T2.membership_status = 'gold' THEN 20 ELSE 0 END +
        CASE WHEN T2.id LIKE '48Z%' THEN 15 ELSE 0 END +
        CASE WHEN T4.check_in_date = 20180109 THEN 15 ELSE 0 END +
        CASE WHEN T1.address_street_name = 'Franklin Ave' THEN 10 ELSE 0 END -- Peso Adicional pelo Risco Geográfico
    ) AS suspect_score
FROM person AS T1
JOIN get_fit_now_member AS T2 ON T1.id = T2.person_id
LEFT JOIN drivers_license AS T3 ON T1.license_id = T3.id
LEFT JOIN get_fit_now_check_in AS T4 ON T2.id = T4.membership_id
GROUP BY T1.name, T1.id, T3.plate_number, T2.id, T1.address_street_name, T4.check_in_date
ORDER BY suspect_score DESC
LIMIT 10;
-- Resultado: Jeremy Bowers (ID: 67318) obtém a pontuação máxima de 100.

-- RELATÓRIO BI 4: KPI DE CONFIRMAÇÃO DO CRIMINOSO
-- Confirmação final da Causa Raiz. Usada no script Python para o relatório final.
SELECT T1.name, T2.plate_number, T4.check_in_time
FROM person AS T1
JOIN drivers_license AS T2 ON T1.license_id = T2.id
JOIN get_fit_now_member AS T3 ON T1.id = T3.person_id
JOIN get_fit_now_check_in AS T4 ON T3.id = T4.membership_id
WHERE T1.id = 67318 AND T4.check_in_date = 20180109;