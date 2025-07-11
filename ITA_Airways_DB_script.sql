-- =====================================================
-- DATABASE ITA AIRWAYS - PROJECT WORK
-- =====================================================

-- Creazione delle tabelle
-- Tabella Aeroporto
CREATE TABLE Aeroporto (
    codice VARCHAR(3) PRIMARY KEY,
    citta VARCHAR(50) NOT NULL,
    nazione VARCHAR(50) NOT NULL,
    nome_completo VARCHAR(100) NOT NULL
);

-- Tabella Aereo
CREATE TABLE Aereo (
    id_aereo SERIAL PRIMARY KEY,
    compagnia VARCHAR(50) NOT NULL,
    modello VARCHAR(50) NOT NULL,
    capacita INTEGER NOT NULL,
    consumo_medio_litri_km DECIMAL(5,3) NOT NULL
);

-- Tabella Tratta
CREATE TABLE Tratta (
    id_tratta SERIAL PRIMARY KEY,
    aeroporto_partenza VARCHAR(3) NOT NULL,
    aeroporto_arrivo VARCHAR(3) NOT NULL,
    distanza_km INTEGER NOT NULL,
    FOREIGN KEY (aeroporto_partenza) REFERENCES Aeroporto(codice),
    FOREIGN KEY (aeroporto_arrivo) REFERENCES Aeroporto(codice)
);

-- Tabella Viaggio
CREATE TABLE Viaggio (
    id_viaggio SERIAL PRIMARY KEY,
    id_aereo INTEGER NOT NULL,
    data_partenza TIMESTAMP NOT NULL,
    FOREIGN KEY (id_aereo) REFERENCES Aereo(id_aereo)
);

-- Tabella Scalo
CREATE TABLE Scalo (
    id_scalo SERIAL PRIMARY KEY,
    id_viaggio INTEGER NOT NULL,
    id_tratta INTEGER NOT NULL,
    ordine_scalo INTEGER NOT NULL,
    FOREIGN KEY (id_viaggio) REFERENCES Viaggio(id_viaggio),
    FOREIGN KEY (id_tratta) REFERENCES Tratta(id_tratta)
);

-- Tabella Passeggero
CREATE TABLE Passeggero (
    id_passeggero SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    data_nascita DATE
);

-- Tabella Biglietto
CREATE TABLE Biglietto (
    id_biglietto SERIAL PRIMARY KEY,
    id_passeggero INTEGER NOT NULL,
    id_viaggio INTEGER NOT NULL,
    classe VARCHAR(10) CHECK (classe IN ('economy', 'business', 'first')) NOT NULL,
    prezzo DECIMAL(8,2) NOT NULL,
    stato VARCHAR(15) CHECK (stato IN ('valido', 'cancellato', 'utilizzato')) NOT NULL,
    data_emissione TIMESTAMP NOT NULL,
    FOREIGN KEY (id_passeggero) REFERENCES Passeggero(id_passeggero),
    FOREIGN KEY (id_viaggio) REFERENCES Viaggio(id_viaggio)
);

-- Tabella Prenotazione
CREATE TABLE Prenotazione (
    id_prenotazione SERIAL PRIMARY KEY,
    id_biglietto INTEGER NOT NULL,
    data_prenotazione TIMESTAMP NOT NULL,
    metodo_pagamento VARCHAR(20) CHECK (metodo_pagamento IN ('carta_credito', 'bonifico', 'paypal', 'contanti')) NOT NULL,
    stato VARCHAR(15) CHECK (stato IN ('confermata', 'cancellata', 'in_attesa')) NOT NULL,
    FOREIGN KEY (id_biglietto) REFERENCES Biglietto(id_biglietto)
);

-- =====================================================
-- INSERIMENTO DATI DI TEST
-- =====================================================

-- Inserimento Aeroporti
INSERT INTO Aeroporto (codice, citta, nazione, nome_completo) VALUES
('FCO', 'Roma', 'Italia', 'Aeroporto Leonardo da Vinci'),
('MXP', 'Milano', 'Italia', 'Aeroporto di Milano Malpensa'),
('NAP', 'Napoli', 'Italia', 'Aeroporto di Napoli Capodichino'),
('CDG', 'Parigi', 'Francia', 'Aeroporto Charles de Gaulle');

-- Inserimento Aerei
INSERT INTO Aereo (compagnia, modello, capacita, consumo_medio_litri_km) VALUES
('ITA Airways', 'Airbus A220-100', 149, 2.8),
('ITA Airways', 'Airbus A320', 174, 3.1),
('ITA Airways', 'Airbus A330-200', 257, 4.2),
('ITA Airways', 'Boeing 777-200ER', 293, 4.5);

-- Inserimento Tratte
INSERT INTO Tratta (aeroporto_partenza, aeroporto_arrivo, distanza_km) VALUES
('FCO', 'MXP', 477),
('MXP', 'FCO', 477),
('FCO', 'NAP', 225),
('FCO', 'CDG', 1105);

-- Inserimento Viaggi
INSERT INTO Viaggio (id_aereo, data_partenza) VALUES
(1, '2025-07-15 08:30:00'),
(2, '2025-07-16 14:20:00'),
(3, '2025-07-17 09:15:00'),
(4, '2025-07-18 22:10:00');

-- Inserimento Scali
INSERT INTO Scalo (id_viaggio, id_tratta, ordine_scalo) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1);

-- Inserimento Passeggeri
INSERT INTO Passeggero (nome, cognome, email, telefono, data_nascita) VALUES
('Marco', 'Rossi', 'marco.rossi@email.com', '+39 333 1234567', '1985-03-15'),
('Giulia', 'Bianchi', 'giulia.bianchi@email.com', '+39 349 2345678', '1990-07-22'),
('Alessandro', 'Verdi', 'alessandro.verdi@email.com', '+39 347 3456789', '1978-11-08'),
('Francesca', 'Neri', 'francesca.neri@email.com', '+39 338 4567890', '1992-05-12');

-- Inserimento Biglietti
INSERT INTO Biglietto (id_passeggero, id_viaggio, classe, prezzo, stato, data_emissione) VALUES
(1, 1, 'economy', 150.00, 'valido', '2025-06-15 10:30:00'),
(2, 1, 'business', 450.00, 'valido', '2025-06-16 14:20:00'),
(3, 2, 'economy', 280.00, 'valido', '2025-06-17 09:15:00'),
(4, 3, 'first', 800.00, 'valido', '2025-06-18 16:30:00');

-- Inserimento Prenotazioni
INSERT INTO Prenotazione (id_biglietto, data_prenotazione, metodo_pagamento, stato) VALUES
(1, '2025-06-15 10:30:00', 'carta_credito', 'confermata'),
(2, '2025-06-16 14:20:00', 'bonifico', 'confermata'),
(3, '2025-06-17 09:15:00', 'paypal', 'confermata'),
(4, '2025-06-18 16:30:00', 'bonifico', 'confermata');

-- =====================================================
-- INDICI PER OTTIMIZZAZIONE
-- =====================================================

CREATE INDEX idx_viaggio_data_partenza ON Viaggio(data_partenza);
CREATE INDEX idx_biglietto_stato ON Biglietto(stato);
CREATE INDEX idx_biglietto_viaggio ON Biglietto(id_viaggio);
CREATE INDEX idx_prenotazione_data ON Prenotazione(data_prenotazione);

-- =====================================================
-- VIEWS UTILI PER ANALISI
-- =====================================================

-- View per biglietti attivi
CREATE VIEW v_biglietti_attivi AS
SELECT 
    b.id_biglietto,
    CONCAT(p.nome, ' ', p.cognome) AS passeggero,
    b.classe,
    b.prezzo,
    v.data_partenza,
    a.compagnia,
    a.modello
FROM Biglietto b
JOIN Passeggero p ON b.id_passeggero = p.id_passeggero
JOIN Viaggio v ON b.id_viaggio = v.id_viaggio
JOIN Aereo a ON v.id_aereo = a.id_aereo
WHERE b.stato = 'valido' AND v.data_partenza >= CURRENT_DATE;

-- View per occupazione voli
CREATE VIEW v_occupazione_voli AS
SELECT 
    v.id_viaggio,
    v.data_partenza,
    a.compagnia,
    a.modello,
    a.capacita,
    COUNT(b.id_biglietto) AS biglietti_venduti,
    (a.capacita - COUNT(b.id_biglietto)) AS posti_disponibili,
    ROUND((COUNT(b.id_biglietto)::DECIMAL / a.capacita) * 100, 2) AS occupazione_percentuale
FROM Viaggio v
JOIN Aereo a ON v.id_aereo = a.id_aereo
LEFT JOIN Biglietto b ON v.id_viaggio = b.id_viaggio AND b.stato = 'valido'
GROUP BY v.id_viaggio, v.data_partenza, a.compagnia, a.modello, a.capacita;

-- =====================================================
-- QUERY DI VERIFICA
-- =====================================================

-- Verifica integrità dati
SELECT 'Passeggeri totali' AS descrizione, COUNT(*) AS conteggio FROM Passeggero
UNION ALL
SELECT 'Aeroporti totali', COUNT(*) FROM Aeroporto
UNION ALL
SELECT 'Aerei totali', COUNT(*) FROM Aereo
UNION ALL
SELECT 'Viaggi totali', COUNT(*) FROM Viaggio
UNION ALL
SELECT 'Biglietti totali', COUNT(*) FROM Biglietto
UNION ALL
SELECT 'Prenotazioni totali', COUNT(*) FROM Prenotazione;
