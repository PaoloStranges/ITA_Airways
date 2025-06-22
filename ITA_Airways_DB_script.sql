
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

-- INSERIMENTO DATI INIZIALI

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

-- SIMULAZIONI DI INPUT UTENTE

-- 👤 Simulazione: Nuovo cliente che si registra
INSERT INTO Cliente (Nome, Cognome, Email, Telefono, DataNascita)
VALUES ('Giulia', 'Verdi', 'giulia.verdi@email.it', '3409876543', '1992-12-12');

-- 🧾 Simulazione: Cliente Giulia effettua una prenotazione per il volo 1
INSERT INTO Prenotazione (IDCliente, DataPrenotazione, MetodoPagamento, ImportoTotale)
VALUES (3, '2025-06-22', 'Bonifico', 160.00);

-- ✈️ Simulazione: Assegnazione posto a Giulia sul volo 1
INSERT INTO Prenotazione_Volo (IDPrenotazione, IDVolo, PostoAssegnato)
VALUES (3, 1, '14B');

-- 🔍 Simulazione: Ricerca di tutti i voli con partenza da Roma il 15 luglio
SELECT V.IDVolo, V.DataOraPartenza, V.DataOraArrivo
FROM Volo V
JOIN Aeroporto A ON V.IDAeroportoPartenza = A.IDAeroporto
WHERE A.Città = 'Roma' AND DATE(V.DataOraPartenza) = '2025-07-15';

-- 🔍 Simulazione: Elenco passeggeri del volo 1
SELECT C.Nome, C.Cognome
FROM Cliente C
JOIN Prenotazione P ON C.IDCliente = P.IDCliente
JOIN Prenotazione_Volo PV ON P.IDPrenotazione = PV.IDPrenotazione
WHERE PV.IDVolo = 1;

-- 🔍 Simulazione: Prenotazioni effettuate dopo il 21 giugno
SELECT * FROM Prenotazione WHERE DataPrenotazione > '2025-06-21';
