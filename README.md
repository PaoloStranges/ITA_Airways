# ITA Airways – Project Work Database

Repository realizzato per il Project Work del Corso di Laurea in *Informatica per le Aziende Digitali (L-31)* – Università Telematica Pegaso.

📌 **Obiettivo**: progettare un database relazionale a supporto della **gestione della vendita dei biglietti** per ITA Airways, includendo prenotazioni, emissione dei titoli di viaggio, gestione dei voli con scalo e verifica della validità dei biglietti.

---

## 🎯 Obiettivi principali

- Modellazione delle entità principali: Passeggero, Biglietto, Prenotazione, Viaggio, Tratta, Scalo, Aereo  
- Gestione completa del ciclo di vita di una prenotazione e del biglietto  
- Supporto a voli con scalo tramite tabella intermedia `Scalo`  
- Query SQL operative per gestione, controllo e analisi  

---

## 📂 Contenuto del repository

- `DIAGRAMMA_ER.sql` – File SQL per la generazione del diagramma su dbdiagram.io  
- `diagramma_ER_ITA_Airways.png` – Diagramma ER in formato immagine  
- `ITA_Airways_DB_script.sql` – Script completo per la creazione del database (DDL + DML)  
- `ITA_Airways_6_query.sql` – File con le 6 query SQL descritte nel progetto  
- `README.md` – Guida tecnica e descrizione del progetto

---

## 🧰 Requisiti

- PostgreSQL ≥ 15  
- Tool consigliati: pgAdmin, DBeaver, Azure Data Studio  
- Ambienti online alternativi per test:  
  - https://dbfiddle.uk  
  - https://extendsclass.com/postgresql-online.html

---

## 🛠️ Istruzioni per l'uso

1. Importa lo script `ITA_Airways_DB_script.sql` in PostgreSQL  
2. Esegui il file per creare tabelle, relazioni e dati di esempio  
3. Esegui le query contenute in `ITA_Airways_6_query.sql` per testare il sistema  
4. Consulta il diagramma ER per comprendere la struttura

---

## ✈️ Funzionalità implementate

- Gestione completa di **prenotazioni e biglietti**, con stati aggiornabili  
- Rappresentazione dei **voli con scalo** in ordine sequenziale  
- **Verifica della validità** di un biglietto in tempo reale  
- Recupero delle **prenotazioni attive per data**  
- Analisi delle **tratte più richieste** e dei volumi di vendita  

---

## ✅ Query SQL dimostrative

Le seguenti query sono incluse nel file `query_dimostrative.sql`:

1. **Biglietti disponibili su una tratta e data**  
   Recupera i biglietti validi per voli in una data specifica (es. FCO → JFK, 15/07/2025).

2. **Storico delle prenotazioni di un passeggero**  
   Mostra le prenotazioni effettuate da un passeggero con stato e cronologia.

3. **Verifica validità di un biglietto**  
   Controlla se un biglietto è valido, usato o annullato.

4. **Voli con scalo tra due aeroporti**  
   Identifica viaggi che collegano due aeroporti tramite almeno uno scalo.

5. **Numero di biglietti emessi per una tratta**  
   Conta quanti biglietti sono stati venduti su una tratta specifica (diretti e con scalo).

6. **Prenotazioni attive in una certa data**  
   Elenca tutte le prenotazioni confermate per voli in partenza in una determinata data.

---

## 📊 Diagramma ER

Entità principali modellate:

- `Passeggero`  
- `Biglietto`  
- `Prenotazione`  
- `Viaggio`  
- `Tratta`  
- `Scalo`  
- `Aereo`  

Diagramma realizzato con [dbdiagram.io](https://dbdiagram.io)

<p align="center">
  <img src="diagramma_ER_ITA_Airways.png" alt="Diagramma ER" width="700"/>
</p>

---

## 📖 Fonti e strumenti

- [ITA Airways – Sito ufficiale](https://www.ita-airways.com)  
- [PostgreSQL – Documentazione](https://www.postgresql.org/docs)  
- Elmasri & Navathe – *Fundamentals of Database Systems*  
- [IATA – Digital Transformation in Air Transport](https://www.iata.org)  
- [dbdiagram.io](https://dbdiagram.io)  
- [dbfiddle.uk](https://dbfiddle.uk)  
- [extendsclass.com](https://extendsclass.com/postgresql-online.html)

---

## 👨‍💻 Autore

- **Nome**: Paolo Stranges  
- **Matricola**: 0312201143  
- **Università**: Università Telematica Pegaso  
- **Corso di laurea**: Informatica per le Aziende Digitali (L-31)
