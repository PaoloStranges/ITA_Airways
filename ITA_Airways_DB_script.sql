-- ===============================================
-- DATABASE - ITA AIRWAYS
-- Supporto alle query dimostrative (1–8)
-- ===============================================

-- === TABELLE NECESSARIE ===

-- Aeroporti
CREATE TABLE Aeroporto (
    codice VARCHAR(3) PRIMARY KEY,
    citta VARCHAR(50) NOT NULL,
    nazione VARCHAR(50) NOT NULL,
    nome_completo VARCHAR(100) NOT NULL
);

-- Aerei
CREATE TABLE Aereo (
    id_aereo SERIAL PRIMARY KEY,
    compagnia VARCHAR(50) NOT NULL,
    modello VARCHAR(50) NOT NULL,
    capacita INTEGER NOT NULL
);

-- Tratte
CREATE TABLE Tratta (
    id_tratta SERIAL PRIMARY KEY,
    aeroporto_partenza VARCHAR(3) NOT NULL,
    aeroporto_arrivo VARCHAR(3) NOT NULL,
    distanza_km INTEGER NOT NULL,
    FOREIGN KEY (aeroporto_partenza) REFERENCES Aeroporto(codice),
    FOREIGN KEY (aeroporto_arrivo) REFERENCES Aeroporto(codice)
);

-- Viaggi
CREATE TABLE Viaggio (
    id_viaggio SERIAL PRIMARY KEY,
    id_aereo INTEGER NOT NULL,
    data_partenza TIMESTAMP NOT NULL,
    FOREIGN KEY (id_aereo) REFERENCES Aereo(id_aereo)
);

-- Scali
CREATE TABLE Scalo (
    id_scalo SERIAL PRIMARY KEY,
    id_viaggio INTEGER NOT NULL,
    id_tratta INTEGER NOT NULL,
    ordine_scalo INTEGER NOT NULL,
    FOREIGN KEY (id_viaggio) REFERENCES Viaggio(id_viaggio),
    FOREIGN KEY (id_tratta) REFERENCES Tratta(id_tratta)
);

-- Passeggeri
CREATE TABLE Passeggero (
    id_passeggero SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

-- Biglietti
CREATE TABLE Biglietto (
    id_biglietto SERIAL PRIMARY KEY,
    id_passeggero INTEGER NOT NULL,
    id_viaggio INTEGER NOT NULL,
    classe VARCHAR(10),
    prezzo DECIMAL(8,2),
    stato VARCHAR(15),
    data_emissione TIMESTAMP,
    FOREIGN KEY (id_passeggero) REFERENCES Passeggero(id_passeggero),
    FOREIGN KEY (id_viaggio) REFERENCES Viaggio(id_viaggio)
);

-- Prenotazioni
CREATE TABLE Prenotazione (
    id_prenotazione SERIAL PRIMARY KEY,
    id_biglietto INTEGER NOT NULL,
    data_prenotazione TIMESTAMP,
    metodo_pagamento VARCHAR(20),
    stato VARCHAR(15),
    FOREIGN KEY (id_biglietto) REFERENCES Biglietto(id_biglietto)
);

-- === INSERIMENTI RIDOTTI ===

INSERT INTO Aeroporto VALUES 
('FCO', 'Roma', 'Italia', 'Leonardo da Vinci'),
('MXP', 'Milano', 'Italia', 'Malpensa');

INSERT INTO Aereo (compagnia, modello, capacita) VALUES 
('ITA Airways', 'A320', 5);

INSERT INTO Tratta (aeroporto_partenza, aeroporto_arrivo, distanza_km) VALUES 
('FCO', 'MXP', 477);

INSERT INTO Viaggio (id_aereo, data_partenza) VALUES 
(1, '2025-07-20 10:00:00');

INSERT INTO Scalo (id_viaggio, id_tratta, ordine_scalo) VALUES 
(1, 1, 1);

INSERT INTO Passeggero (nome, cognome, email) VALUES 
('Marco', 'Rossi', 'marco@email.com'),
('Luigi', 'Verdi', 'luigi@email.com'),
('Giulia', 'Bianchi', 'giulia@email.com'),
('Elena', 'Neri', 'elena@email.com'),
('Mario', 'Test', 'mario@email.com'),
('Luca', 'Demo', 'luca@email.com');

INSERT INTO Biglietto (id_passeggero, id_viaggio, classe, prezzo, stato, data_emissione) VALUES 
(1, 1, 'economy', 120.00, 'valido', '2025-07-01'),
(2, 1, 'economy', 120.00, 'valido', '2025-07-01'),
(3, 1, 'business', 350.00, 'valido', '2025-07-01'),
(4, 1, 'economy', 120.00, 'valido', '2025-07-01'),
(5, 1, 'first', 800.00, 'valido', '2025-07-01'),
(6, 1, 'economy', 120.00, 'valido', '2025-07-01');

INSERT INTO Prenotazione (id_biglietto, data_prenotazione, metodo_pagamento, stato) VALUES 
(1, '2025-07-01', 'carta_credito', 'confermata'),
(2, '2025-07-01', 'paypal', 'confermata'),
(3, '2025-07-01', 'bonifico', 'confermata'),
(4, '2025-07-01', 'carta_credito', 'confermata'),
(5, '2025-07-01', 'paypal', 'confermata'),
(6, '2025-07-01', 'bonifico', 'confermata');
