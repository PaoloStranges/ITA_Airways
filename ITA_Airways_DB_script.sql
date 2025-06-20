
-- ============================================
-- DROP TABELLE (se esistono)
-- ============================================
DROP TABLE IF EXISTS Prenotazione_Volo;
DROP TABLE IF EXISTS Prenotazione;
DROP TABLE IF EXISTS Volo;
DROP TABLE IF EXISTS Aeroporto;
DROP TABLE IF EXISTS Cliente;

-- ============================================
-- CREAZIONE TABELLE
-- ============================================
-- Tabella degli aeroporti con ID e città
CREATE TABLE Aeroporto (
    IDAeroporto INTEGER PRIMARY KEY,
    Città TEXT
);

-- Tabella dei voli con riferimenti agli aeroporti di partenza e arrivo
CREATE TABLE Volo (
    IDVolo INTEGER PRIMARY KEY,
    IDAeroportoPartenza INTEGER,
    IDAeroportoArrivo INTEGER,
    DataOraPartenza TEXT,
    DataOraArrivo TEXT
);

-- Tabella dei clienti/passeggeri
CREATE TABLE Cliente (
    IDCliente INTEGER PRIMARY KEY,
    Nome TEXT,
    Cognome TEXT
);

-- Tabella delle prenotazioni effettuate dai clienti
CREATE TABLE Prenotazione (
    IDPrenotazione INTEGER PRIMARY KEY,
    IDCliente INTEGER,
    DataPrenotazione TEXT
);

-- Tabella ponte per la relazione molti-a-molti tra prenotazioni e voli
CREATE TABLE Prenotazione_Volo (
    IDPrenotazione INTEGER,
    IDVolo INTEGER,
    PRIMARY KEY (IDPrenotazione, IDVolo)
);

-- ============================================
-- INSERIMENTO DATI DI ESEMPIO
-- ============================================
INSERT INTO Aeroporto VALUES
(1, 'Roma'),
(2, 'Milano'),
(3, 'Napoli'),
(4, 'Torino'),
(5, 'Venezia');

INSERT INTO Volo VALUES
(100, 1, 2, '2025-07-15 08:00:00', '2025-07-15 10:00:00'),
(101, 2, 1, '2025-07-15 15:00:00', '2025-07-15 17:00:00'),
(102, 1, 3, '2025-07-16 09:00:00', '2025-07-16 10:30:00'),
(103, 3, 2, '2025-07-20 12:00:00', '2025-07-20 13:30:00'),
(104, 4, 5, '2025-07-18 07:00:00', '2025-07-18 08:15:00'),
(105, 1, 2, '2025-06-25 09:00:00', '2025-06-25 11:00:00');

INSERT INTO Cliente VALUES
(101, 'Mario', 'Rossi'),
(102, 'Anna', 'Bianchi'),
(103, 'Luca', 'Verdi'),
(104, 'Sara', 'Neri');

INSERT INTO Prenotazione VALUES
(200, 101, '2025-06-10'),
(201, 102, '2025-06-20'),
(202, 103, '2025-06-15'),
(203, 104, '2025-06-28');

INSERT INTO Prenotazione_Volo VALUES
(200, 100),
(201, 101),
(202, 102),
(203, 105),
(200, 103);

-- ============================================
-- QUERY SQL ESEMPLIFICATIVE
-- ============================================

-- 1. Ricerca voli disponibili Roma → Milano il 15 luglio 2025
SELECT V.IDVolo, V.DataOraPartenza, V.DataOraArrivo, A1.Città AS Partenza, A2.Città AS Arrivo
FROM Volo V
JOIN Aeroporto A1 ON V.IDAeroportoPartenza = A1.IDAeroporto
JOIN Aeroporto A2 ON V.IDAeroportoArrivo = A2.IDAeroporto
WHERE A1.Città = 'Roma'
  AND A2.Città = 'Milano'
  AND date(V.DataOraPartenza) = '2025-07-15';

-- 2. Storico prenotazioni per cliente ID 101
SELECT P.IDPrenotazione, P.DataPrenotazione, V.IDVolo, V.DataOraPartenza, V.DataOraArrivo
FROM Prenotazione P
JOIN Prenotazione_Volo PV ON P.IDPrenotazione = PV.IDPrenotazione
JOIN Volo V ON PV.IDVolo = V.IDVolo
WHERE P.IDCliente = 101;

-- 3. Verifica validità biglietto (prenotazione 200)
SELECT CASE
    WHEN V.DataOraPartenza > datetime('now') THEN 'Valido'
    ELSE 'Scaduto'
END AS StatoBiglietto
FROM Prenotazione_Volo PV
JOIN Volo V ON PV.IDVolo = V.IDVolo
WHERE PV.IDPrenotazione = 200;

-- 4. Elenco passeggeri prenotati su volo ID 100
SELECT C.Nome, C.Cognome
FROM Cliente C
JOIN Prenotazione P ON C.IDCliente = P.IDCliente
JOIN Prenotazione_Volo PV ON P.IDPrenotazione = PV.IDPrenotazione
WHERE PV.IDVolo = 100;

-- 5. Tratte con maggior numero di prenotazioni nel giugno 2025
SELECT A1.Città AS Partenza, A2.Città AS Arrivo, COUNT(*) AS NumeroPrenotazioni
FROM Volo V
JOIN Aeroporto A1 ON V.IDAeroportoPartenza = A1.IDAeroporto
JOIN Aeroporto A2 ON V.IDAeroportoArrivo = A2.IDAeroporto
JOIN Prenotazione_Volo PV ON V.IDVolo = PV.IDVolo
JOIN Prenotazione P ON PV.IDPrenotazione = P.IDPrenotazione
WHERE P.DataPrenotazione BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY A1.Città, A2.Città
ORDER BY NumeroPrenotazioni DESC;
