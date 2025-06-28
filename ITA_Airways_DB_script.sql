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

-- INSERIMENTO DATI

INSERT INTO Aereo (modello, capacita, consumo_medio) VALUES
('Airbus A350', 300, 2.50),
('Airbus A320neo', 180, 2.00);

INSERT INTO Tratta (aeroporto_partenza, aeroporto_arrivo, distanza, durata_stimata) VALUES
('FCO', 'JFK', 6800, 540),
('MXP', 'LIN', 50, 20);

INSERT INTO Viaggio (id_aereo, id_tratta, data_partenza, ora_partenza) VALUES
(1, 1, '2025-06-23', '10:30'),
(2, 2, '2025-06-24', '08:00'),
(1, 1, '2025-07-01', '09:00'),
(1, 1, '2025-07-05', '13:30'),
(2, 2, '2025-06-30', '07:00');

INSERT INTO PosizioneAereo (id_aereo, latitudine, longitudine, altitudine, timestamp) VALUES
(1, 41.800000, 12.250000, 10000, '2025-06-23 11:00:00'),
(1, 43.000000, -5.000000, 11000, '2025-06-23 12:00:00'),
(2, 45.630000, 8.720000, 3000, '2025-06-24 08:15:00'),
(1, 44.100000, -10.100000, 11200, CURRENT_TIMESTAMP);

INSERT INTO EventoOperativo (id_aereo, id_viaggio, tipo_evento, descrizione, data_ora) VALUES
(1, 1, 'Ritardo', 'Partenza posticipata di 30 minuti', '2025-06-23 10:00:00'),
(1, 1, 'Turbolenza', 'Turbolenza moderata in volo', '2025-06-23 12:30:00'),
(1, NULL, 'Manutenzione Programmata', 'Check completo motore - Hangar 2', '2025-06-29 08:00:00');

INSERT INTO ConsumoCarburante (id_viaggio, litri_consumati, durata_effettiva) VALUES
(1, 17000.50, 560),
(2, 500.25, 25),
(3, 17250.25, 545),
(4, 16980.75, 530);


### All'interno di `ITA_Airways_DB_script.sql`, puoi aggiungere le query alla fine del file:

```sql
-- Query dimostrative

-- 1. Ultima posizione GPS per aereo
SELECT * FROM PosizioneAereo
WHERE id_aereo = 1
ORDER BY timestamp DESC
LIMIT 1;

-- 2. Storico eventi tecnici per aereo
SELECT * FROM EventoOperativo
WHERE id_aereo = 1
ORDER BY data_ora DESC;

-- 3. Consumo medio per modello di aereo
SELECT Aereo.modello, AVG(ConsumoCarburante.litri_consumati) AS consumo_medio
FROM Aereo
JOIN Viaggio ON Aereo.id_aereo = Viaggio.id_aereo
JOIN ConsumoCarburante ON Viaggio.id_viaggio = ConsumoCarburante.id_viaggio
GROUP BY Aereo.modello;

-- 4. Viaggi programmati tra due aeroporti (es. FCO → JFK)
SELECT * FROM Viaggio
JOIN Tratta ON Viaggio.id_tratta = Tratta.id_tratta
WHERE Tratta.aeroporto_partenza = 'FCO' AND Tratta.aeroporto_arrivo = 'JFK'
ORDER BY Viaggio.data_partenza;

-- 5. Tratte con maggiore consumo totale in un intervallo di tempo
SELECT Tratta.aeroporto_partenza, Tratta.aeroporto_arrivo, SUM(ConsumoCarburante.litri_consumati) AS consumo_totale
FROM Tratta
JOIN Viaggio ON Tratta.id_tratta = Viaggio.id_tratta
JOIN ConsumoCarburante ON Viaggio.id_viaggio = ConsumoCarburante.id_viaggio
WHERE Viaggio.data_partenza BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY Tratta.aeroporto_partenza, Tratta.aeroporto_arrivo
ORDER BY consumo_totale DESC;
