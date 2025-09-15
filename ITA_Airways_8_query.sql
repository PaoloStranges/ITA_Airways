-- =====================================================
-- QUERY SQL - PROJECT WORK ITA AIRWAYS
-- Studente: Paolo Stranges
-- Matricola: 0312201143
-- =====================================================

-- =====================================================
-- Query 1: Ricerca biglietti disponibili per viaggio
-- =====================================================
-- Obiettivo: Visualizzare i viaggi futuri con posti disponibili
-- Utilizzo: Supporto alle prenotazioni e gestione capacità
SELECT 
    v.id_viaggio,
    v.data_partenza,
    a.compagnia,
    a.modello,
    a.capacita,
    COUNT(b.id_biglietto) AS biglietti_emessi,
    (a.capacita - COUNT(b.id_biglietto)) AS posti_disponibili,
    ROUND((COUNT(b.id_biglietto)::DECIMAL / a.capacita) * 100, 2) AS occupazione_percentuale
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
WHERE v.data_partenza >= '2025-07-01'
GROUP BY v.id_viaggio, v.data_partenza, a.compagnia, a.modello, a.capacita
ORDER BY v.data_partenza;

-- =====================================================
-- Query 2: Storico prenotazioni di un cliente
-- =====================================================
-- Obiettivo: Recuperare tutte le prenotazioni di un passeggero
-- Utilizzo: Servizio clienti e gestione CRM
-- Nota: Sfrutta i nuovi attributi aeroporto_partenza/arrivo per accesso diretto
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

-- =====================================================
-- Query 3: Verifica validità biglietto
-- =====================================================
-- Obiettivo: Controllare lo stato e la validità di un biglietto
-- Utilizzo: Check-in e controllo accessi
SELECT 
    b.id_biglietto,
    p.nome || ' ' || p.cognome AS passeggero,
    p.email,
    b.stato,
    b.aeroporto_partenza || ' → ' || b.aeroporto_arrivo AS tratta,
    ap1.citta AS citta_partenza,
    ap2.citta AS citta_arrivo,
    v.data_partenza,
    a.compagnia,
    CASE 
        WHEN b.stato = 'valido' AND v.data_partenza > NOW() THEN 'Valido'
        WHEN b.stato = 'valido' AND v.data_partenza <= NOW() THEN 'Scaduto'
        WHEN b.stato = 'cancellato' THEN 'Cancellato'
        ELSE 'Non valido'
    END AS esito,
    CASE 
        WHEN v.data_partenza > NOW() THEN 
            EXTRACT(DAYS FROM (v.data_partenza - NOW()))::TEXT || ' giorni al volo'
        ELSE 'Volo già partito'
    END AS tempo_rimanente
FROM Biglietto b
JOIN Passeggero p ON b.id_passeggero = p.id_passeggero
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
JOIN Aereo a ON v.id_aereo = a.id_aereo
JOIN Aeroporto ap1 ON b.aeroporto_partenza = ap1.codice
JOIN Aeroporto ap2 ON b.aeroporto_arrivo = ap2.codice
WHERE b.id_biglietto = 1;  -- Parametro: ID del biglietto

-- =====================================================
-- Query 4: Percorso completo del viaggio con scali
-- =====================================================
-- Obiettivo: Visualizzare il percorso dettagliato con eventuali scali
-- Utilizzo: Informazioni per passeggeri e pianificazione voli
SELECT 
    v.id_viaggio,
    v.data_partenza,
    a.compagnia,
    a.modello,
    COUNT(s.id_scalo) AS numero_tratte,
    MIN(ap1.citta) AS citta_partenza,
    MAX(ap2.citta) AS citta_arrivo,
    SUM(t.distanza_km) AS distanza_totale_km,
    STRING_AGG(
        ap1.citta || ' → ' || ap2.citta,
        ' | ' ORDER BY s.ordine_scalo
    ) AS percorso_dettagliato
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
LEFT JOIN Scalo s ON v.id_viaggio = s.id_viaggio
LEFT JOIN Tratta t ON s.id_tratta = t.id_tratta
LEFT JOIN Aeroporto ap1 ON t.aeroporto_partenza = ap1.codice
LEFT JOIN Aeroporto ap2 ON t.aeroporto_arrivo = ap2.codice
GROUP BY v.id_viaggio, v.data_partenza, a.compagnia, a.modello
ORDER BY v.data_partenza;

-- =====================================================
-- Query 5: Passeggeri VIP per spesa totale
-- =====================================================
-- Obiettivo: Identificare i clienti più importanti per valore
-- Utilizzo: Marketing mirato e programmi fedeltà
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
JOIN Prenotazione pr ON b.id_prenotazione = pr.id_prenotazione  -- CORRETTO: FK da Biglietto a Prenotazione
WHERE b.stato = 'valido'
GROUP BY p.id_passeggero, p.nome, p.cognome, p.email
HAVING COUNT(b.id_biglietto) >= 1
ORDER BY totale_speso DESC, viaggi_ultimo_anno DESC
LIMIT 100;

-- =====================================================
-- Query 6: Controllo situazioni di overbooking
-- =====================================================
-- Obiettivo: Identificare voli con più biglietti venduti della capacità
-- Utilizzo: Prevenzione problemi operativi e gestione rischi
SELECT 
    v.id_viaggio,
    v.data_partenza,
    COALESCE(
        MIN(b.aeroporto_partenza) || ' → ' || MIN(b.aeroporto_arrivo),
        'N/A'
    ) AS rotta,
    a.compagnia,
    a.modello,
    a.capacita,
    COUNT(b.id_biglietto) AS biglietti_venduti,
    (COUNT(b.id_biglietto) - a.capacita) AS overbooking_count,
    ROUND((COUNT(b.id_biglietto)::DECIMAL / a.capacita) * 100, 2) AS percentuale_vendita,
    CASE 
        WHEN COUNT(b.id_biglietto) > a.capacita THEN 'OVERBOOKING'
        WHEN COUNT(b.id_biglietto) > (a.capacita * 0.95) THEN 'RISCHIO ALTO'
        WHEN COUNT(b.id_biglietto) > (a.capacita * 0.85) THEN 'ATTENZIONE'
        ELSE 'OK'
    END AS stato_allerta
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
WHERE v.data_partenza >= '2025-07-01'
GROUP BY v.id_viaggio, v.data_partenza, a.compagnia, a.modello, a.capacita
ORDER BY percentuale_vendita DESC;

-- =====================================================
-- Query 7: Trend prenotazioni e ricavi mensili
-- =====================================================
-- Obiettivo: Analizzare l'andamento del business nel tempo
-- Utilizzo: Supporto decisionale e pianificazione strategica
SELECT 
    DATE_TRUNC('month', pr.data_prenotazione) AS mese,
    COUNT(DISTINCT pr.id_prenotazione) AS prenotazioni,
    COUNT(DISTINCT b.id_passeggero) AS passeggeri_unici,
    SUM(b.prezzo) AS ricavi_totali,
    ROUND(AVG(b.prezzo), 2) AS prezzo_medio,
    COUNT(CASE WHEN pr.stato = 'confermata' THEN 1 END) AS prenotazioni_confermate,
    COUNT(CASE WHEN pr.stato = 'cancellata' THEN 1 END) AS prenotazioni_cancellate
FROM Prenotazione pr
JOIN Biglietto b ON pr.id_prenotazione = b.id_prenotazione
GROUP BY DATE_TRUNC('month', pr.data_prenotazione)
ORDER BY mese DESC;

-- =====================================================
-- Query 8: Statistiche generali del sistema
-- =====================================================
-- Obiettivo: Dashboard riassuntiva con metriche chiave e KPI
-- Utilizzo: Monitoraggio performance e supporto decisionale
SELECT 
    'Passeggeri Totali' AS metrica,
    COUNT(DISTINCT p.id_passeggero)::TEXT AS valore
FROM Passeggero p

UNION ALL

SELECT 
    'Viaggi Attivi' AS metrica,
    COUNT(DISTINCT v.id_viaggio)::TEXT AS valore
FROM Viaggio v
WHERE v.data_partenza >= '2025-07-01'  -- Sostituito CURRENT_DATE per test

UNION ALL

SELECT 
    'Biglietti Venduti (Ultimo Anno)' AS metrica,
    COUNT(DISTINCT b.id_biglietto)::TEXT AS valore
FROM Biglietto b
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
WHERE v.data_partenza >= '2024-07-01'  -- Data fissa per simulare ultimo anno
    AND b.stato = 'valido'

UNION ALL

SELECT 
    'Ricavi Totali (Ultimo Anno)' AS metrica,
    COALESCE(SUM(b.prezzo), 0)::MONEY::TEXT AS valore
FROM Biglietto b
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
WHERE v.data_partenza >= '2024-07-01'  -- Data fissa per simulare ultimo anno
    AND b.stato = 'valido'

UNION ALL

SELECT 
    'Tasso Occupazione Medio' AS metrica,
    ROUND(AVG(occupazione.percentuale), 2)::TEXT || '%' AS valore
FROM (
    SELECT 
        (COUNT(b.id_biglietto)::DECIMAL / a.capacita) * 100 AS percentuale
    FROM Viaggio v
    JOIN Aereo a ON v.id_aereo = a.id_aereo
    LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
    WHERE v.data_partenza >= '2025-04-01'  -- Ultimi 3 mesi simulati
    GROUP BY v.id_viaggio, a.capacita
) occupazione;
