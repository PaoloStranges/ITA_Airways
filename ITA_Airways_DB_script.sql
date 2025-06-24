-- ============================
--  CREAZIONE TABELLE
-- ============================

CREATE TABLE Aereo (
    id_aereo SERIAL PRIMARY KEY,
    modello VARCHAR(50),
    capacita INTEGER,
    consumo_medio DECIMAL(8,2)
);

CREATE TABLE Tratta (
    id_tratta SERIAL PRIMARY KEY,
    aeroporto_partenza VARCHAR(10),
    aeroporto_arrivo VARCHAR(10),
    distanza INTEGER,
    durata_stimata INTEGER
);

CREATE TABLE Viaggio (
    id_viaggio SERIAL PRIMARY KEY,
    id_aereo INTEGER REFERENCES Aereo(id_aereo),
    id_tratta INTEGER REFERENCES Tratta(id_tratta),
    data_partenza DATE,
    ora_partenza TIME
);

CREATE TABLE PosizioneAereo (
    id_posizione SERIAL PRIMARY KEY,
    id_aereo INTEGER REFERENCES Aereo(id_aereo),
    latitudine DECIMAL(9,6),
    longitudine DECIMAL(9,6),
    altitudine INTEGER,
    timestamp TIMESTAMP
);

CREATE TABLE EventoOperativo (
    id_evento SERIAL PRIMARY KEY,
    id_aereo INTEGER REFERENCES Aereo(id_aereo),
    id_viaggio INTEGER REFERENCES Viaggio(id_viaggio),
    tipo_evento VARCHAR(50),
    descrizione TEXT,
    data_ora TIMESTAMP
);

CREATE TABLE ConsumoCarburante (
    id_consumo SERIAL PRIMARY KEY,
    id_viaggio INTEGER REFERENCES Viaggio(id_viaggio),
    litri_consumati DECIMAL(8,2),
    durata_effettiva INTEGER
);

-- ============================
--  INSERIMENTO DATI ESEMPI
-- ============================

-- Aerei
INSERT INTO Aereo (modello, capacita, consumo_medio) VALUES
('Airbus A350', 300, 2.50),
('Airbus A320neo', 180, 2.00);

-- Tratte
INSERT INTO Tratta (aeroporto_partenza, aeroporto_arrivo, distanza, durata_stimata) VALUES
('FCO', 'JFK', 6800, 540),
('MXP', 'LIN', 50, 20);

-- Viaggi pianificati e futuri
INSERT INTO Viaggio (id_aereo, id_tratta, data_partenza, ora_partenza) VALUES
(1, 1, '2025-06-23', '10:30'),
(2, 2, '2025-06-24', '08:00'),
(1, 1, '2025-07-01', '09:00'),
(1, 1, '2025-07-05', '13:30'),
(2, 2, '2025-06-30', '07:00');

-- Posizione aerei (storico + "realtime")
INSERT INTO PosizioneAereo (id_aereo, latitudine, longitudine, altitudine, timestamp) VALUES
(1, 41.800000, 12.250000, 10000, '2025-06-23 11:00:00'),
(1, 43.000000, -5.000000, 11000, '2025-06-23 12:00:00'),
(2, 45.630000, 8.720000, 3000, '2025-06-24 08:15:00'),
(1, 44.100000, -10.100000, 11200, CURRENT_TIMESTAMP); -- simulazione GPS live

-- Eventi operativi
INSERT INTO EventoOperativo (id_aereo, id_viaggio, tipo_evento, descrizione, data_ora) VALUES
(1, 1, 'Ritardo', 'Partenza posticipata di 30 minuti', '2025-06-23 10:00:00'),
(1, 1, 'Turbolenza', 'Turboenza moderata in volo', '2025-06-23 12:30:00'),
(1, NULL, 'Manutenzione Programmata', 'Check completo motore - Hangar 2', '2025-06-29 08:00:00');

-- Consumi reali
INSERT INTO ConsumoCarburante (id_viaggio, litri_consumati, durata_effettiva) VALUES
(1, 17000.50, 560),
(2, 500.25, 25),
(3, 17250.25, 545),
(4, 16980.75, 530);

-- ============================
--  VISTA: POSIZIONE ATTUALE AEREI
-- ============================

CREATE VIEW Vista_Posizione_Attuale AS
SELECT DISTINCT ON (id_aereo)
    id_aereo, latitudine, longitudine, altitudine, timestamp
FROM PosizioneAereo
ORDER BY id_aereo, timestamp DESC;

-- ============================
--  QUERY DI UTILITÀ OPERATIVA
-- ============================

-- 1. Ultima posizione per ogni aereo
SELECT * FROM Vista_Posizione_Attuale;

-- 2. Storico eventi per aereo
SELECT tipo_evento, descrizione, data_ora
FROM EventoOperativo
WHERE id_aereo = 1
ORDER BY data_ora DESC;

-- 3. Consumo medio per modello
SELECT a.modello, AVG(c.litri_consumati) AS consumo_medio
FROM ConsumoCarburante c
JOIN Viaggio v ON c.id_viaggio = v.id_viaggio
JOIN Aereo a ON v.id_aereo = a.id_aereo
GROUP BY a.modello;

-- 4. Viaggi tra FCO e JFK
SELECT v.id_viaggio, v.data_partenza, v.ora_partenza, a.modello
FROM Viaggio v
JOIN Tratta t ON v.id_tratta = t.id_tratta
JOIN Aereo a ON v.id_aereo = a.id_aereo
WHERE t.aeroporto_partenza = 'FCO' AND t.aeroporto_arrivo = 'JFK';

-- 5. Tratte con maggiore consumo totale
SELECT t.id_tratta, t.aeroporto_partenza, t.aeroporto_arrivo, SUM(c.litri_consumati) AS totale_consumo
FROM ConsumoCarburante c
JOIN Viaggio v ON c.id_viaggio = v.id_viaggio
JOIN Tratta t ON v.id_tratta = t.id_tratta
GROUP BY t.id_tratta, t.aeroporto_partenza, t.aeroporto_arrivo
ORDER BY totale_consumo DESC;

-- 6. Efficienza media (litri/km) per tratta
SELECT
    t.aeroporto_partenza,
    t.aeroporto_arrivo,
    COUNT(*) AS numero_viaggi,
    ROUND(AVG(c.litri_consumati / t.distanza), 2) AS litri_per_km_medi
FROM ConsumoCarburante c
JOIN Viaggio v ON c.id_viaggio = v.id_viaggio
JOIN Tratta t ON v.id_tratta = t.id_tratta
GROUP BY t.aeroporto_partenza, t.aeroporto_arrivo
ORDER BY litri_per_km_medi;
