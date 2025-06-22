
-- CREAZIONE TABELLE

CREATE TABLE Cliente (
    IDCliente SERIAL PRIMARY KEY,
    Nome VARCHAR(50),
    Cognome VARCHAR(50),
    Email VARCHAR(100),
    Telefono VARCHAR(20),
    DataNascita DATE
);

CREATE TABLE Aeroporto (
    IDAeroporto SERIAL PRIMARY KEY,
    Nome VARCHAR(100),
    Città VARCHAR(50),
    Nazione VARCHAR(50)
);

CREATE TABLE Aeromobile (
    IDAeromobile SERIAL PRIMARY KEY,
    Modello VARCHAR(50),
    Capacità INT,
    AnnoImmatricolazione INT
);

CREATE TABLE Volo (
    IDVolo SERIAL PRIMARY KEY,
    DataOraPartenza TIMESTAMP,
    DataOraArrivo TIMESTAMP,
    IDAeroportoPartenza INT REFERENCES Aeroporto(IDAeroporto),
    IDAeroportoArrivo INT REFERENCES Aeroporto(IDAeroporto),
    IDAeromobile INT REFERENCES Aeromobile(IDAeromobile)
);

CREATE TABLE Prenotazione (
    IDPrenotazione SERIAL PRIMARY KEY,
    IDCliente INT REFERENCES Cliente(IDCliente),
    DataPrenotazione DATE,
    MetodoPagamento VARCHAR(50),
    ImportoTotale DECIMAL(10,2)
);

CREATE TABLE Prenotazione_Volo (
    IDPrenotazione INT REFERENCES Prenotazione(IDPrenotazione),
    IDVolo INT REFERENCES Volo(IDVolo),
    PostoAssegnato VARCHAR(10),
    PRIMARY KEY (IDPrenotazione, IDVolo)
);

-- INSERIMENTO DATI DI ESEMPIO

INSERT INTO Cliente (Nome, Cognome, Email, Telefono, DataNascita) VALUES
('Mario', 'Rossi', 'mario.rossi@email.it', '3401234567', '1980-05-20'),
('Luca', 'Bianchi', 'luca.bianchi@email.it', '3477654321', '1995-10-10');

INSERT INTO Aeroporto (Nome, Città, Nazione) VALUES
('Leonardo da Vinci', 'Roma', 'Italia'),
('Linate', 'Milano', 'Italia');

INSERT INTO Aeromobile (Modello, Capacità, AnnoImmatricolazione) VALUES
('Airbus A320neo', 180, 2022),
('Airbus A350', 300, 2023);

INSERT INTO Volo (DataOraPartenza, DataOraArrivo, IDAeroportoPartenza, IDAeroportoArrivo, IDAeromobile) VALUES
('2025-07-15 08:00:00', '2025-07-15 09:10:00', 1, 2, 1),
('2025-07-16 15:00:00', '2025-07-16 18:00:00', 2, 1, 2);

INSERT INTO Prenotazione (IDCliente, DataPrenotazione, MetodoPagamento, ImportoTotale) VALUES
(1, '2025-06-20', 'Carta di credito', 150.00),
(2, '2025-06-21', 'PayPal', 180.00);

INSERT INTO Prenotazione_Volo (IDPrenotazione, IDVolo, PostoAssegnato) VALUES
(1, 1, '12A'),
(2, 2, '15C');

-- QUERY ESEMPLIFICATIVE

-- 1. Voli disponibili tra due città in data specifica
SELECT V.IDVolo, V.DataOraPartenza, V.DataOraArrivo, A1.Città AS Partenza, A2.Città AS Arrivo
FROM Volo V
JOIN Aeroporto A1 ON V.IDAeroportoPartenza = A1.IDAeroporto
JOIN Aeroporto A2 ON V.IDAeroportoArrivo = A2.IDAeroporto
WHERE A1.Città = 'Roma' AND A2.Città = 'Milano'
  AND DATE(V.DataOraPartenza) = '2025-07-15';

-- 2. Storico prenotazioni cliente
SELECT P.IDPrenotazione, P.DataPrenotazione, V.IDVolo, V.DataOraPartenza, V.DataOraArrivo
FROM Prenotazione P
JOIN Prenotazione_Volo PV ON P.IDPrenotazione = PV.IDPrenotazione
JOIN Volo V ON PV.IDVolo = V.IDVolo
WHERE P.IDCliente = 1;

-- 3. Verifica validità biglietto
SELECT CASE
           WHEN V.DataOraPartenza > NOW() THEN 'Valido'
           ELSE 'Scaduto'
       END AS StatoBiglietto
FROM Prenotazione_Volo PV
JOIN Volo V ON PV.IDVolo = V.IDVolo
WHERE PV.IDPrenotazione = 1;

-- 4. Elenco passeggeri di un volo
SELECT C.Nome, C.Cognome
FROM Cliente C
JOIN Prenotazione P ON C.IDCliente = P.IDCliente
JOIN Prenotazione_Volo PV ON P.IDPrenotazione = PV.IDPrenotazione
WHERE PV.IDVolo = 1;

-- 5. Tratte più richieste in un intervallo
SELECT A1.Città AS Partenza, A2.Città AS Arrivo, COUNT(*) AS NumeroPrenotazioni
FROM Volo V
JOIN Aeroporto A1 ON V.IDAeroportoPartenza = A1.IDAeroporto
JOIN Aeroporto A2 ON V.IDAeroportoArrivo = A2.IDAeroporto
JOIN Prenotazione_Volo PV ON V.IDVolo = PV.IDVolo
JOIN Prenotazione P ON PV.IDPrenotazione = P.IDPrenotazione
WHERE P.DataPrenotazione BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY A1.Città, A2.Città
ORDER BY NumeroPrenotazioni DESC;
