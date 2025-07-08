-- ===================================================
-- Query 1: Biglietti disponibili su una tratta e data
-- Obiettivo: Recuperare i biglietti validi e prenotabili 
-- per un volo diretto da FCO a JFK in data 2025-07-15
-- ===================================================
SELECT b.id_biglietto, p.nome, p.cognome
FROM Biglietto b
JOIN Passeggero p ON b.id_passeggero = p.id_passeggero
JOIN Prenotazione pr ON pr.id_biglietto = b.id_biglietto
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
WHERE v.data_partenza = '2025-07-15'
  AND b.stato = 'valido'
  AND pr.stato = 'confermata';

-- ===================================================
-- Query 2: Storico delle prenotazioni di un passeggero
-- Obiettivo: Visualizzare la cronologia delle prenotazioni 
-- effettuate da un passeggero specifico (Luca Rossi)
-- ===================================================
SELECT pr.id_prenotazione, pr.data_prenotazione, pr.stato, b.id_biglietto
FROM Passeggero p
JOIN Biglietto b ON p.id_passeggero = b.id_passeggero
JOIN Prenotazione pr ON pr.id_biglietto = b.id_biglietto
WHERE p.nome = 'Luca' AND p.cognome = 'Rossi'
ORDER BY pr.data_prenotazione DESC;

-- ===================================================
-- Query 3: Verifica validità di un biglietto
-- Obiettivo: Controllare lo stato (valido/usato/annullato)
-- del biglietto con ID specifico (es. 1)
-- ===================================================
SELECT id_biglietto, stato
FROM Biglietto
WHERE id_biglietto = 1;

-- ===================================================
-- Query 4: Voli con scalo tra FCO e JFK
-- Obiettivo: Identificare viaggi che includono 
-- almeno due tratte: FCO → scalo e scalo → JFK
-- ===================================================
SELECT DISTINCT v.id_viaggio
FROM Viaggio v
JOIN Scalo s1 ON v.id_viaggio = s1.id_viaggio
JOIN Tratta t1 ON s1.id_tratta = t1.id_tratta
JOIN Scalo s2 ON v.id_viaggio = s2.id_viaggio
JOIN Tratta t2 ON s2.id_tratta = t2.id_tratta
WHERE t1.aeroporto_partenza = 'FCO'
  AND t2.aeroporto_arrivo = 'JFK'
  AND s1.ordine_scalo < s2.ordine_scalo;

-- ===================================================
-- Query 5: Numero di biglietti emessi per tratta FCO → JFK
-- Obiettivo: Calcolare quanti biglietti sono stati emessi
-- per viaggi che includono la tratta FCO → JFK
-- ===================================================
SELECT COUNT(DISTINCT b.id_biglietto) AS biglietti_emessi
FROM Biglietto b
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
JOIN Scalo s ON v.id_viaggio = s.id_viaggio
JOIN Tratta t ON s.id_tratta = t.id_tratta
WHERE t.aeroporto_partenza = 'FCO' AND t.aeroporto_arrivo = 'JFK';

-- ===================================================
-- Query 6: Prenotazioni attive in una certa data
-- Obiettivo: Trovare prenotazioni confermate per voli 
-- in partenza il 15 luglio 2025
-- ===================================================
SELECT pr.id_prenotazione, p.nome, p.cognome, v.data_partenza
FROM Prenotazione pr
JOIN Biglietto b ON pr.id_biglietto = b.id_biglietto
JOIN Passeggero p ON b.id_passeggero = p.id_passeggero
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
WHERE pr.stato = 'confermata'
  AND v.data_partenza = '2025-07-15';
