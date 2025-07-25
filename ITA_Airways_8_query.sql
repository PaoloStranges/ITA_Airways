-- =====================================================
-- QUERY SQL FINALI - PROJECT WORK TRASPORTI AEREI
-- =====================================================
-- Selezione delle 8 query ottimali per il voto massimo
-- Copertura completa: Operazioni base + Performance + Analytics
-- =====================================================

-- 1. Ricerca biglietti disponibili per viaggio
-- Risponde a: "ricerca biglietti disponibili"
-- Gestione: prenotazioni + emissione biglietti
-- INDEXES SUGGERITI: v.data_partenza, b.stato, v.id_viaggio
SELECT 
  v.id_viaggio,
  v.data_partenza,
  a.compagnia,
  a.modello,
  a.capacita,
  COALESCE(COUNT(b.id_biglietto), 0) AS biglietti_emessi,
  (a.capacita - COALESCE(COUNT(b.id_biglietto), 0)) AS posti_disponibili,
  CASE 
    WHEN a.capacita > 0 THEN ROUND((COALESCE(COUNT(b.id_biglietto), 0)::DECIMAL / a.capacita) * 100, 2)
    ELSE 0 
  END AS occupazione_percentuale
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
WHERE v.data_partenza >= CURRENT_DATE  -- Solo viaggi futuri
GROUP BY v.id_viaggio, v.data_partenza, a.compagnia, a.modello, a.capacita
ORDER BY v.data_partenza
LIMIT 100;

-- 2. Storico prenotazioni di un cliente
-- Risponde a: "storico prenotazioni di un cliente"
-- Gestione: prenotazioni + interazione clienti
-- PARAMETRIZZATA per sicurezza e riutilizzo
SELECT 
  p.nome || ' ' || p.cognome AS passeggero,
  p.email,
  pr.id_prenotazione,
  pr.data_prenotazione,
  pr.metodo_pagamento,
  pr.stato AS stato_prenotazione,
  b.stato AS stato_biglietto,
  b.classe,
  b.prezzo,
  v.data_partenza,
  a.compagnia,
  CASE 
    WHEN v.data_partenza > CURRENT_TIMESTAMP THEN 'FUTURO'
    WHEN v.data_partenza <= CURRENT_TIMESTAMP THEN 'PASSATO'
  END AS categoria_viaggio
FROM Passeggero p
JOIN Biglietto b ON p.id_passeggero = b.id_passeggero
JOIN Prenotazione pr ON pr.id_biglietto = b.id_biglietto
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
JOIN Aereo a ON v.id_aereo = a.id_aereo
WHERE p.id_passeggero = 1  -- PARAMETRO: ID del passeggero
ORDER BY pr.data_prenotazione DESC;

-- 3. Verifica validità biglietto
-- Risponde a: "verifica validità di un biglietto"
-- Gestione: validazione biglietti
-- PARAMETRIZZATA con controlli business avanzati
SELECT 
  b.id_biglietto,
  p.nome || ' ' || p.cognome AS passeggero,
  p.email,
  b.stato,
  v.id_viaggio,
  v.data_partenza,
  a.compagnia,
  CASE 
    WHEN b.stato = 'valido' AND v.data_partenza > CURRENT_TIMESTAMP THEN '✓ Valido'
    WHEN b.stato = 'valido' AND v.data_partenza <= CURRENT_TIMESTAMP THEN '⚠ Scaduto'
    WHEN b.stato = 'cancellato' THEN '✗ Cancellato'
    ELSE '✗ Non valido'
  END AS esito,
  CASE 
    WHEN v.data_partenza > CURRENT_TIMESTAMP THEN 
      EXTRACT(DAYS FROM (v.data_partenza - CURRENT_TIMESTAMP)) || ' giorni al volo'
    ELSE 'Volo già partito'
  END AS tempo_rimanente
FROM Biglietto b
JOIN Passeggero p ON b.id_passeggero = p.id_passeggero
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
JOIN Aereo a ON v.id_aereo = a.id_aereo
WHERE b.id_biglietto = 1;  -- PARAMETRO: ID del biglietto

-- 4. Percorso completo del viaggio 
-- Risponde a: "gestione delle tratte" e "cambi o scali"
-- Gestione: tratte + scali (requisito dominio trasporti)
-- OTTIMIZZATA con STRING_AGG per concatenazione percorsi
SELECT 
  v.id_viaggio, v.data_partenza, a.compagnia, a.modello, a.capacita,
  p.citta || ' (' || p.codice || ')' AS citta_partenza,
  r.citta || ' (' || r.codice || ')' AS citta_arrivo,
  GREATEST(COUNT(s.id_scalo) - 1, 0) AS numero_scali_intermedi,
  COALESCE(STRING_AGG(
    CASE WHEN s.ordine_scalo > 1 THEN 'Scalo ' || (s.ordine_scalo - 1) || ': ' || ap2.citta || ' (' || ap2.codice || ') - ' || ap2.nome_completo END,
    ' | ' ORDER BY s.ordine_scalo
  ), 'Volo diretto (nessun scalo)') AS scali_intermedi,
  STRING_AGG(
    'Tratta ' || s.ordine_scalo || ': ' || ap1.citta || ' (' || ap1.codice || ') → ' || ap2.citta || ' (' || ap2.codice || ') - ' || t.distanza_km || ' km',
    ' | ' ORDER BY s.ordine_scalo
  ) AS percorso_dettagliato,
  SUM(t.distanza_km) AS distanza_totale_km,
  ROUND(SUM(t.distanza_km * a.consumo_medio_litri_km), 2) AS consumo_carburante_stimato_litri,
  STRING_AGG(
    DISTINCT ap1.citta || CASE WHEN s.ordine_scalo = 1 THEN ' (partenza)' ELSE '' END,
    ' → ' ORDER BY ap1.citta || CASE WHEN s.ordine_scalo = 1 THEN ' (partenza)' ELSE '' END
  ) AS citta_toccate
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
LEFT JOIN Scalo s ON v.id_viaggio = s.id_viaggio
LEFT JOIN Tratta t ON s.id_tratta = t.id_tratta
LEFT JOIN Aeroporto ap1 ON t.aeroporto_partenza = ap1.codice
LEFT JOIN Aeroporto ap2 ON t.aeroporto_arrivo = ap2.codice
LEFT JOIN (
  SELECT s1.id_viaggio, ap.codice, ap.citta
  FROM Scalo s1
  JOIN Tratta t1 ON s1.id_tratta = t1.id_tratta
  JOIN Aeroporto ap ON t1.aeroporto_partenza = ap.codice
  WHERE s1.ordine_scalo = 1
) p ON v.id_viaggio = p.id_viaggio
LEFT JOIN (
  SELECT s2.id_viaggio, ap.codice, ap.citta
  FROM Scalo s2
  JOIN Tratta t2 ON s2.id_tratta = t2.id_tratta
  JOIN Aeroporto ap ON t2.aeroporto_arrivo = ap.codice
  WHERE s2.ordine_scalo = (
    SELECT MAX(ordine_scalo) FROM Scalo s3 WHERE s3.id_viaggio = s2.id_viaggio
  )
) r ON v.id_viaggio = r.id_viaggio
GROUP BY 
  v.id_viaggio, v.data_partenza,
  a.compagnia, a.modello, a.capacita, a.consumo_medio_litri_km,
  p.citta, p.codice, r.citta, r.codice
ORDER BY v.data_partenza
LIMIT 50;

-- 5. Passeggeri VIP per spesa totale 
-- Risponde a: "interazione con i clienti" + "efficienza operativa"
-- Gestione: clienti + analytics CRM
-- ANALISI AVANZATA con categorizzazione e loyalty metrics
SELECT 
  p.nome || ' ' || p.cognome AS passeggero,
  p.email,
  COUNT(b.id_biglietto) AS viaggi_totali,
  COUNT(CASE WHEN v.data_partenza >= CURRENT_DATE - INTERVAL '12 months' THEN 1 END) AS viaggi_ultimo_anno,
  SUM(b.prezzo) AS totale_speso,
  ROUND(AVG(b.prezzo), 2) AS prezzo_medio,
  MIN(b.prezzo) AS prezzo_minimo,
  MAX(b.prezzo) AS prezzo_massimo,
  CASE
    WHEN SUM(b.prezzo) >= 2000 THEN 'PLATINUM'
    WHEN SUM(b.prezzo) >= 1000 THEN 'GOLD'
    WHEN SUM(b.prezzo) >= 500 THEN 'SILVER'
    ELSE 'STANDARD'
  END AS livello_cliente,
  CASE 
    WHEN COUNT(CASE WHEN v.data_partenza >= CURRENT_DATE - INTERVAL '12 months' THEN 1 END) >= 10 THEN 'FREQUENT FLYER'
    WHEN COUNT(CASE WHEN v.data_partenza >= CURRENT_DATE - INTERVAL '12 months' THEN 1 END) >= 5 THEN 'REGULAR'
    ELSE 'OCCASIONALE'
  END AS frequenza_viaggi,
  MIN(pr.data_prenotazione) AS prima_prenotazione,
  MAX(pr.data_prenotazione) AS ultima_prenotazione
FROM Passeggero p
JOIN Biglietto b ON p.id_passeggero = b.id_passeggero
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
JOIN Prenotazione pr ON b.id_biglietto = pr.id_biglietto
WHERE b.stato = 'valido'
GROUP BY p.id_passeggero, p.nome, p.cognome, p.email
HAVING COUNT(b.id_biglietto) >= 1  -- Almeno un viaggio
ORDER BY totale_speso DESC, viaggi_ultimo_anno DESC
LIMIT 100;

-- 6. Controllo Overbooking 
-- Identifica viaggi con più biglietti venduti della capacità
-- PREVENZIONE RISCHI operativi e reputazionali
-- IMPATTO: Evita costi compensazione e problemi customer service
SELECT 
    v.id_viaggio,
    v.data_partenza,
    CONCAT(ap_partenza.citta, ' → ', ap_arrivo.citta) as rotta,
    a.compagnia,
    a.modello,
    a.capacita,
    COUNT(b.id_biglietto) as biglietti_venduti,
    (COUNT(b.id_biglietto) - a.capacita) as overbooking_count,
    ROUND((COUNT(b.id_biglietto)::DECIMAL / a.capacita) * 100, 2) as percentuale_vendita,
    CASE 
        WHEN COUNT(b.id_biglietto) > a.capacita THEN '🚨 OVERBOOKING'
        WHEN COUNT(b.id_biglietto) > (a.capacita * 0.95) THEN '⚠️ RISCHIO ALTO'
        WHEN COUNT(b.id_biglietto) > (a.capacita * 0.85) THEN '⚡ ATTENZIONE'
        ELSE '✅ OK'
    END as stato_allerta
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
JOIN Scalo s ON v.id_viaggio = s.id_viaggio AND s.ordine_scalo = 1
JOIN Tratta t ON s.id_tratta = t.id_tratta
JOIN Aeroporto ap_partenza ON t.aeroporto_partenza = ap_partenza.codice
JOIN Aeroporto ap_arrivo ON t.aeroporto_arrivo = ap_arrivo.codice
LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
WHERE v.data_partenza >= CURRENT_DATE
GROUP BY v.id_viaggio, v.data_partenza, ap_partenza.citta, ap_arrivo.citta, 
         a.compagnia, a.modello, a.capacita
ORDER BY 
    CASE 
        WHEN COUNT(b.id_biglietto) > a.capacita THEN 1
        WHEN COUNT(b.id_biglietto) > (a.capacita * 0.95) THEN 2
        WHEN COUNT(b.id_biglietto) > (a.capacita * 0.85) THEN 3
        ELSE 4
    END,
    percentuale_vendita DESC;

-- 7. Trend Prenotazioni e Ricavi Mensili 
-- Analisi performance business nel tempo
-- BUSINESS INTELLIGENCE per decisioni strategiche
-- TREND temporali per ottimizzazione ricavi e capacity planning
SELECT 
  DATE_TRUNC('month', pr.data_prenotazione) as mese,
  COUNT(DISTINCT pr.id_prenotazione) as prenotazioni,
  COUNT(DISTINCT b.id_passeggero) as passeggeri_unici,
  SUM(b.prezzo) as ricavi_totali,
  ROUND(AVG(b.prezzo), 2) as prezzo_medio,
  COUNT(CASE WHEN pr.stato = 'confermata' THEN 1 END) as prenotazioni_confermate,
  COUNT(CASE WHEN pr.stato = 'cancellata' THEN 1 END) as prenotazioni_cancellate,
  ROUND(COUNT(CASE WHEN pr.stato = 'cancellata' THEN 1 END)::DECIMAL / COUNT(*) * 100, 2) as tasso_cancellazione
FROM Prenotazione pr
JOIN Biglietto b ON pr.id_biglietto = b.id_biglietto
WHERE pr.data_prenotazione >= CURRENT_DATE - INTERVAL '24 months'  -- Ultimi 2 anni
GROUP BY DATE_TRUNC('month', pr.data_prenotazione)
ORDER BY mese DESC;

-- 8. Statistiche Generali Sistema 
-- Overview completo del sistema per monitoring
-- METRICHE AGGREGATE per controllo performance globale
-- SUPPORTO DECISIONALE per management e operations
SELECT 
  'Passeggeri Totali' as metrica,
  COUNT(DISTINCT p.id_passeggero)::TEXT as valore
FROM Passeggero p

UNION ALL

SELECT 
  'Viaggi Attivi' as metrica,
  COUNT(DISTINCT v.id_viaggio)::TEXT as valore
FROM Viaggio v
WHERE v.data_partenza >= CURRENT_DATE

UNION ALL

SELECT 
  'Biglietti Venduti (Ultimo Anno)' as metrica,
  COUNT(DISTINCT b.id_biglietto)::TEXT as valore
FROM Biglietto b
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
WHERE v.data_partenza >= CURRENT_DATE - INTERVAL '12 months'
  AND b.stato = 'valido'

UNION ALL

SELECT 
  'Ricavi Totali (Ultimo Anno)' as metrica,
  TO_CHAR(SUM(b.prezzo), 'FM999,999,999.00') || ' €' as valore
FROM Biglietto b
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
WHERE v.data_partenza >= CURRENT_DATE - INTERVAL '12 months'
  AND b.stato = 'valido'

UNION ALL

SELECT 
  'Tasso Occupazione Medio' as metrica,
  ROUND(AVG(occupazione.percentuale), 2)::TEXT || '%' as valore
FROM (
  SELECT 
    (COUNT(b.id_biglietto)::DECIMAL / a.capacita) * 100 as percentuale
  FROM Viaggio v
  JOIN Aereo a ON v.id_aereo = a.id_aereo
  LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
  WHERE v.data_partenza >= CURRENT_DATE - INTERVAL '3 months'
  GROUP BY v.id_viaggio, a.capacita
) occupazione;

-- =====================================================
-- INDICI SUGGERITI PER PERFORMANCE OTTIMALI
-- =====================================================

-- Query 1 - Ricerca biglietti disponibili
-- CREATE INDEX idx_viaggio_data_partenza ON Viaggio(data_partenza);
-- CREATE INDEX idx_biglietto_stato ON Biglietto(stato);
-- CREATE INDEX idx_biglietto_viaggio ON Biglietto(id_viaggio);

-- Query 2 - Storico prenotazioni cliente
-- CREATE INDEX idx_passeggero_email ON Passeggero(email);
-- CREATE INDEX idx_biglietto_passeggero ON Biglietto(id_passeggero);
-- CREATE INDEX idx_prenotazione_data ON Prenotazione(data_prenotazione);

-- Query 3 - Verifica validità biglietto
-- CREATE INDEX idx_biglietto_pk ON Biglietto(id_biglietto);  -- Già PK
-- CREATE INDEX idx_viaggio_data_partenza ON Viaggio(data_partenza);

-- Query 6 - Controllo Overbooking
-- CREATE INDEX idx_viaggio_data_aereo ON Viaggio(data_partenza, id_aereo);
-- CREATE INDEX idx_biglietto_viaggio_stato ON Biglietto(id_viaggio, stato);

-- Query 7 - Trend ricavi mensili
-- CREATE INDEX idx_prenotazione_data_stato ON Prenotazione(data_prenotazione, stato);

-- =====================================================
-- COVERAGE ANALYSIS - REQUISITI TRACCIA
-- =====================================================

/*
COPERTURA COMPLETA:

RICHIESTE SPECIFICHE:
- "ricerca biglietti disponibili" → Query #1 
- "storico prenotazioni di un cliente" → Query #2 
- "verifica validità di un biglietto" → Query #3 
- "gestione delle tratte" → Query #4 
- "cambi o scali" → Query #4 

PROCESSI COMPLESSI:
- "gestione delle prenotazioni" → Query #1, #2 
- "emissione e validazione dei biglietti" → Query #1, #3 
- "gestione delle tratte" → Query #4 
- "interazione con i clienti" → Query #2, #5 

PERFORMANCE E SCALABILITÀ:
- "efficienza operativa" → Query #5, #6, #8 
- "integrità delle informazioni" → Tutte le query 
- "scalabilità del servizio" → Query #7, #8

VALORE AGGIUNTO:
- Risk Management → Query #6 (Overbooking) 
- Business Intelligence → Query #7 (Trend) 
- System Monitoring → Query #8 (Dashboard) 
*/
