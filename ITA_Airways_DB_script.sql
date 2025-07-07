
-- CREAZIONE TABELLE

CREATE TABLE Passeggero (
    id_passeggero SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50)
);

CREATE TABLE Aereo (
    id_aereo SERIAL PRIMARY KEY,
    modello VARCHAR(50),
    capacita INTEGER
);

CREATE TABLE Tratta (
    id_tratta SERIAL PRIMARY KEY,
    aeroporto_partenza VARCHAR(10),
    aeroporto_arrivo VARCHAR(10),
    distanza_km INTEGER
);

CREATE TABLE Viaggio (
    id_viaggio SERIAL PRIMARY KEY,
    id_aereo INT REFERENCES Aereo(id_aereo),
    data_partenza DATE
);

CREATE TABLE Scalo (
    id_scalo SERIAL PRIMARY KEY,
    id_viaggio INT REFERENCES Viaggio(id_viaggio),
    id_tratta INT REFERENCES Tratta(id_tratta),
    ordine_scalo INT
);

CREATE TABLE Biglietto (
    id_biglietto SERIAL PRIMARY KEY,
    id_passeggero INT REFERENCES Passeggero(id_passeggero),
    id_viaggio INT REFERENCES Viaggio(id_viaggio),
    stato VARCHAR(20) CHECK (stato IN ('valido', 'annullato', 'usato'))
);

CREATE TABLE Prenotazione (
    id_prenotazione SERIAL PRIMARY KEY,
    id_biglietto INT REFERENCES Biglietto(id_biglietto),
    data_prenotazione DATE,
    stato VARCHAR(20) CHECK (stato IN ('confermata', 'in_attesa', 'annullata'))
);

-- INSERIMENTO DATI DI ESEMPIO

INSERT INTO Passeggero (nome, cognome) VALUES 
('Luca', 'Rossi'),
('Maria', 'Bianchi');

INSERT INTO Aereo (modello, capacita) VALUES 
('Airbus A320', 180),
('Boeing 777', 300);

INSERT INTO Tratta (aeroporto_partenza, aeroporto_arrivo, distanza_km) VALUES
('FCO', 'LHR', 1440),
('LHR', 'JFK', 5567),
('FCO', 'JFK', 7000);

INSERT INTO Viaggio (id_aereo, data_partenza) VALUES 
(1, '2025-07-15'),
(2, '2025-07-15');

INSERT INTO Scalo (id_viaggio, id_tratta, ordine_scalo) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1);

INSERT INTO Biglietto (id_passeggero, id_viaggio, stato) VALUES
(1, 1, 'valido'),
(2, 2, 'valido');

INSERT INTO Prenotazione (id_biglietto, data_prenotazione, stato) VALUES
(1, '2025-07-01', 'confermata'),
(2, '2025-07-01', 'confermata');
