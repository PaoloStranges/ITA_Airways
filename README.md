
# ITA Airways – Project Work Database

Repository realizzato per il Project Work del Corso di Laurea in *Informatica per le Aziende Digitali (L-31)* – Università Telematica Pegaso.

📌 **Obiettivo**: progettare un database relazionale a supporto della **gestione della vendita dei biglietti** per ITA Airways, includendo prenotazioni, emissione dei titoli di viaggio, gestione dei voli con scalo e verifica della validità dei biglietti.

---

## 🎯 Obiettivi principali

- Modellazione delle entità principali (Passeggero, Biglietto, Prenotazione, Viaggio, Tratta, Scalo, Aereo)  
- Gestione completa di prenotazioni e biglietti  
- Rappresentazione dei voli con scalo tramite tabella intermedia  
- Interrogazioni SQL utili per gestione operativa e analisi  

---

## 📂 Contenuto del repository

- `DIAGRAMMA_ER.sql` – File SQL per dbdiagram.io  
- `diagramma_ER_ITA_Airways.png` – Immagine del diagramma ER  
- `ITA_Airways_DB_script.sql` – Script SQL completo con struttura, dati e query  
- `README.md` – Guida tecnica al progetto

---

## 🧰 Requisiti

- PostgreSQL ≥ 15  
- Tool consigliati: pgAdmin, DBeaver, Azure Data Studio  
- Ambienti alternativi online:  
  - https://dbfiddle.uk  
  - https://extendsclass.com/postgresql-online.html

---

## 🛠️ Istruzioni per l'uso

1. Importa lo script `ITA_Airways_DB_script.sql` in PostgreSQL  
2. Esegui lo script per creare schema, vincoli e dati  
3. Lancia le query SQL dimostrative per testare il sistema

---

## ✈️ Funzionalità implementate

- Gestione completa di **prenotazioni e biglietti**, con tracciamento dello stato (emesso, confermato, annullato, utilizzato)  
- Rappresentazione di **voli con scalo**, grazie a una tabella intermedia che mantiene l’ordine degli scali  
- **Verifica della validità di un biglietto** in base a viaggio, data e stato  
- Ricerca delle **prenotazioni attive** per data o tratta  
- Analisi delle **tratte più richieste** sulla base del numero di biglietti emessi  

---

## ✅ Query SQL dimostrative

1. **Biglietti disponibili su una tratta e data**  
   Recupera i biglietti ancora validi e prenotabili su una determinata tratta in una data specifica.

2. **Storico delle prenotazioni di un passeggero**  
   Elenca tutte le prenotazioni effettuate da un determinato passeggero, con stato e cronologia.

3. **Verifica validità di un biglietto**  
   Controlla se un biglietto è ancora valido, già utilizzato o annullato.

4. **Voli con scalo tra due aeroporti**  
   Restituisce i viaggi che collegano due aeroporti anche attraverso uno o più scali, in ordine sequenziale.

5. **Numero di biglietti emessi per una tratta**  
   Calcola il totale dei biglietti venduti su una specifica tratta, utile per analisi della domanda.

6. **Prenotazioni attive in una certa data**  
   Mostra tutte le prenotazioni confermate per voli in partenza in una data specifica.

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

Realizzato con [dbdiagram.io](https://dbdiagram.io)

<p align="center">
  <img src="DIAGRAMMA__ER_ITA_Airways.png" alt="Diagramma ER" width="700"/>
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
