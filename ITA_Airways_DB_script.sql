-- =====================================================
-- DATABASE ITA AIRWAYS - PROJECT WORK
-- =====================================================

-- Drop tabelle esistenti
DROP TABLE IF EXISTS Prenotazione CASCADE;
DROP TABLE IF EXISTS Biglietto CASCADE;
DROP TABLE IF EXISTS Passeggero CASCADE;
DROP TABLE IF EXISTS Scalo CASCADE;
DROP TABLE IF EXISTS Viaggio CASCADE;
DROP TABLE IF EXISTS Tratta CASCADE;
DROP TABLE IF EXISTS Aereo CASCADE;
DROP TABLE IF EXISTS Aeroporto CASCADE;

-- Creazione tabelle
CREATE TABLE Aeroporto (
    codice VARCHAR(3) PRIMARY KEY,
    citta VARCHAR(50) NOT NULL,
    nazione VARCHAR(50) NOT NULL,
    nome_completo VARCHAR(100) NOT NULL
);

CREATE TABLE Aereo (
    id_aereo SERIAL PRIMARY KEY,
    compagnia VARCHAR(50) NOT NULL,
    modello VARCHAR(50) NOT NULL,
    capacita INTEGER NOT NULL,
    consumo_medio_litri_km DECIMAL(5,3) NOT NULL
);

CREATE TABLE Tratta (
    id_tratta SERIAL PRIMARY KEY,
    aeroporto_partenza VARCHAR(3) NOT NULL,
    aeroporto_arrivo VARCHAR(3) NOT NULL,
    distanza_km INTEGER NOT NULL,
    FOREIGN KEY (aeroporto_partenza) REFERENCES Aeroporto(codice),
    FOREIGN KEY (aeroporto_arrivo) REFERENCES Aeroporto(codice)
);

CREATE TABLE Viaggio (
    id_viaggio SERIAL PRIMARY KEY,
    id_aereo INTEGER NOT NULL,
    data_partenza TIMESTAMP NOT NULL,
    FOREIGN KEY (id_aereo) REFERENCES Aereo(id_aereo)
);

CREATE TABLE Scalo (
    id_scalo SERIAL PRIMARY KEY,
    id_viaggio INTEGER NOT NULL,
    id_tratta INTEGER NOT NULL,
    ordine_scalo INTEGER NOT NULL,
    FOREIGN KEY (id_viaggio) REFERENCES Viaggio(id_viaggio),
    FOREIGN KEY (id_tratta) REFERENCES Tratta(id_tratta)
);

CREATE TABLE Passeggero (
    id_passeggero SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    data_nascita DATE
);

CREATE TABLE Prenotazione (
    id_prenotazione SERIAL PRIMARY KEY,
    id_passeggero INTEGER NOT NULL,
    data_prenotazione TIMESTAMP NOT NULL,
    metodo_pagamento VARCHAR(20) CHECK (metodo_pagamento IN ('carta_credito', 'bonifico', 'paypal', 'contanti')) NOT NULL,
    stato VARCHAR(15) CHECK (stato IN ('confermata', 'cancellata', 'in_attesa')) NOT NULL,
    FOREIGN KEY (id_passeggero) REFERENCES Passeggero(id_passeggero)
);

CREATE TABLE Biglietto (
    id_biglietto SERIAL PRIMARY KEY,
    id_passeggero INTEGER NOT NULL,
    id_viaggio INTEGER NOT NULL,
    id_prenotazione INTEGER NOT NULL,
    aeroporto_partenza VARCHAR(3) NOT NULL,
    aeroporto_arrivo VARCHAR(3) NOT NULL,
    classe VARCHAR(10) CHECK (classe IN ('economy', 'business', 'first')) NOT NULL,
    prezzo DECIMAL(8,2) NOT NULL,
    stato VARCHAR(15) CHECK (stato IN ('valido', 'cancellato', 'utilizzato')) NOT NULL,
    data_emissione TIMESTAMP NOT NULL,
    FOREIGN KEY (id_passeggero) REFERENCES Passeggero(id_passeggero),
    FOREIGN KEY (id_viaggio) REFERENCES Viaggio(id_viaggio),
    FOREIGN KEY (id_prenotazione) REFERENCES Prenotazione(id_prenotazione),
    FOREIGN KEY (aeroporto_partenza) REFERENCES Aeroporto(codice),
    FOREIGN KEY (aeroporto_arrivo) REFERENCES Aeroporto(codice)
);

-- Dati di test
INSERT INTO Aeroporto VALUES
('FCO','Roma','Italia','Leonardo da Vinci'),
('MXP','Milano','Italia','Malpensa'),
('NAP','Napoli','Italia','Capodichino'),
('CDG','Parigi','Francia','Charles de Gaulle'),
('LHR','Londra','Regno Unito','Heathrow'),
('BCN','Barcellona','Spagna','El Prat'),
('FRA','Francoforte','Germania','Francoforte'),
('VCE','Venezia','Italia','Marco Polo');

INSERT INTO Aereo (compagnia,modello,capacita,consumo_medio_litri_km) VALUES
('ITA Airways','Airbus A220-100',149,2.8),
('ITA Airways','Airbus A320',174,3.1),
('ITA Airways','Airbus A330-200',257,4.2),
('ITA Airways','Boeing 777-200ER',293,4.5);

INSERT INTO Tratta (aeroporto_partenza,aeroporto_arrivo,distanza_km) VALUES
('FCO','MXP',477),('MXP','FCO',477),('FCO','NAP',225),('FCO','CDG',1105),
('MXP','LHR',950),('MXP','VCE',250),('VCE','FRA',750),('FRA','BCN',1100),
('NAP','FCO',225);

INSERT INTO Viaggio (id_aereo,data_partenza) VALUES
(1,'2025-07-15 08:30:00'),(2,'2025-07-16 14:20:00'),
(3,'2025-07-17 09:15:00'),(4,'2025-07-18 22:10:00'),
(2,'2025-07-20 10:00:00'),(3,'2025-07-21 08:30:00'),
(1,'2025-07-22 16:45:00');

INSERT INTO Scalo (id_viaggio,id_tratta,ordine_scalo) VALUES
(1,1,1),(2,2,1),(3,3,1),(4,4,1),
(5,1,1),(5,5,2),
(6,6,1),(6,7,2),(6,8,3),
(7,9,1),(7,4,2);

INSERT INTO Passeggero (nome,cognome,email,telefono,data_nascita) VALUES
('Marco','Rossi','marco.rossi@email.com','+39 333 1234567','1985-03-15'),
('Giulia','Bianchi','giulia.bianchi@email.com','+39 349 2345678','1990-07-22'),
('Alessandro','Verdi','alessandro.verdi@email.com','+39 347 3456789','1978-11-08'),
('Francesca','Neri','francesca.neri@email.com','+39 338 4567890','1992-05-12'),
('Sofia','Romano','sofia.romano@email.com','+39 335 5678901','1988-12-03'),
('Matteo','Ferrari','matteo.ferrari@email.com','+39 346 6789012','1995-08-17'),
('Elena','Conte','elena.conte@email.com','+39 333 7890123','1982-04-25');

INSERT INTO Prenotazione (id_passeggero,data_prenotazione,metodo_pagamento,stato) VALUES
(1,'2025-06-15 10:30:00','carta_credito','confermata'),
(2,'2025-06-16 14:20:00','bonifico','confermata'),
(1,'2025-06-17 09:15:00','paypal','confermata'),
(4,'2025-06-18 16:30:00','bonifico','confermata'),
(5,'2025-07-01 09:00:00','carta_credito','confermata'),
(6,'2025-07-02 14:30:00','paypal','confermata'),
(7,'2025-07-03 11:15:00','bonifico','confermata');

INSERT INTO Biglietto (id_passeggero,id_viaggio,id_prenotazione,aeroporto_partenza,aeroporto_arrivo,classe,prezzo,stato,data_emissione) VALUES
(1,1,1,'FCO','MXP','economy',150.00,'valido','2025-06-15 10:30:00'),
(2,1,2,'FCO','MXP','business',450.00,'valido','2025-06-16 14:20:00'),
(1,2,3,'MXP','FCO','economy',280.00,'valido','2025-06-17 09:15:00'),
(3,2,3,'MXP','FCO','economy',280.00,'valido','2025-06-17 09:15:00'),
(4,2,3,'MXP','FCO','economy',280.00,'valido','2025-06-17 09:15:00'),
(4,3,4,'FCO','NAP','first',800.00,'valido','2025-06-18 16:30:00'),
(5,5,5,'FCO','LHR','business',680.00,'valido','2025-07-01 09:00:00'),
(6,6,6,'MXP','BCN','economy',420.00,'valido','2025-07-02 14:30:00'),
(7,7,7,'NAP','CDG','first',950.00,'valido','2025-07-03 11:15:00');

-- Indici
CREATE INDEX idx_viaggio_data ON Viaggio(data_partenza);
CREATE INDEX idx_biglietto_stato ON Biglietto(stato);
CREATE INDEX idx_biglietto_aeroporti ON Biglietto(aeroporto_partenza,aeroporto_arrivo);
