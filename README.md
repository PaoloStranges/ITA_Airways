# ITA Airways – Project Work Database

Repository realizzato per il Project Work del Corso di Laurea in *Informatica per le Aziende Digitali (L-31)* – Università Telematica Pegaso.

📌 **Obiettivo**: progettare un database relazionale a supporto della **gestione della vendita dei biglietti** per ITA Airways, includendo prenotazioni, emissione dei titoli di viaggio e gestione dei voli con scalo.

---

## 🎯 Obiettivi principali

- Modellazione di biglietti aerei, tratte, viaggi e scali  
- Gestione di prenotazioni e stato dei biglietti  
- Rappresentazione di voli con scalo tramite tabella intermedia  
- Implementazione di query SQL per scenari operativi concreti  
- Calcolo delle emissioni stimate di CO₂ su base tratta  

---

## 📂 Contenuto del repository

- `DIAGRAMMA_ER.sql` – File SQL compatibile con dbdiagram.io: consente la visualizzazione del modello ER  
- `diagramma_ER_ITA_Airways.png` – Immagine del diagramma ER (modello concettuale)  
- `ITA_Airways_DB_script.sql` – Script SQL completo: creazione tabelle, vincoli, dati realistici, query  
- `README.md` – Istruzioni per l’uso del progetto  

---

## 🧰 Requisiti

Per eseguire il progetto è necessario un ambiente PostgreSQL compatibile:

- PostgreSQL ≥ 15  
- Tool consigliati: pgAdmin, DBeaver, Azure Data Studio, psql  
- Testabile anche su:  
  - https://dbfiddle.uk  
  - https://extendsclass.com/postgresql-online.html

---

## 🛠️ Istruzioni per l'uso

1. Apri il file `ITA_Airways_DB_script.sql` in un ambiente PostgreSQL  
2. Esegui lo script per:  
   - Creare le tabelle relazionali  
   - Inserire i dati di esempio  
   - Lanciare le query dimostrative  
3. Analizza i risultati ed esplora le funzionalità simulate  

---

## ✈️ Funzionalità implementate

- Gestione delle prenotazioni e biglietti  
- Associazione tra viaggi, tratte e scali intermedi  
- Query aggregate su voli e prenotazioni  
- Stima emissioni CO₂ per tratta  
- Interrogazioni SQL ottimizzate per l’analisi operativa  

---

## ✅ Query SQL dimostrative

Nel file `.sql` sono incluse le seguenti **6 query**, tutte testate e documentate:

1. **Ultima posizione GPS per un aereo**  
   Recupera l’ultima posizione registrata di un aereo.

2. **Storico eventi operativi di un aereo**  
   Elenca tutti gli eventi tecnici associati a un aereo (ritardi, guasti, manutenzioni).

3. **Consumo medio di carburante per modello di aereo**  
   Calcola il consumo medio in litri per ogni modello di aeromobile.

4. **Viaggi programmati su una determinata tratta (es. FCO → JFK)**  
   Mostra tutti i voli schedulati tra due aeroporti specifici.

5. **Tratte con maggiore consumo totale in un intervallo temporale**  
   Restituisce le tratte con il maggiore impatto in termini di carburante utilizzato.

6. **Stima delle emissioni di CO₂ per tratta**  
   Moltiplica i litri consumati per 3.16 (kg CO₂/litro), secondo le linee guida IPCC.

---

## 📊 Diagramma ER

Il modello concettuale include sette entità principali:

- `Passeggero`  
- `Biglietto`  
- `Prenotazione`  
- `Viaggio`  
- `Tratta`  
- `Scalo`  
- `Aereo`  

Realizzato con [dbdiagram.io](https://dbdiagram.io).

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

