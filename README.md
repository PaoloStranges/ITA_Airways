# ITA Airways – Project Work Database

Repository realizzato per il Project Work del Corso di Laurea in *Informatica per le Aziende Digitali (L-31)* – Università Telematica Pegaso.

📌 Obiettivo: progettare un database relazionale a supporto della **gestione operativa della flotta aerea** di ITA Airways, con particolare attenzione al tracciamento in tempo reale, alla registrazione degli eventi tecnici e all’analisi dei consumi.

---

## 🎯 Obiettivi principali

- Memorizzazione delle posizioni GPS (latitudine, longitudine, altitudine, timestamp)
- Gestione di eventi operativi (ritardi, turbolenze, manutenzioni)
- Monitoraggio dei consumi di carburante per singolo viaggio
- Supporto a sostenibilità e manutenzione predittiva
- Creazione di query e viste per analisi operative e ambientali

---

## 📂 Contenuto del repository

- `ITA_Airways_DB_script.sql` – Script SQL completo: struttura tabelle (DDL), dati realistici (DML), viste e query.
- `diagramma_ER_ITA_Airways.png` – Diagramma ER delle entità e relazioni.
- `README.md` – Istruzioni all’uso e guida tecnica.

---

## 🧰 Requisiti

Per eseguire il progetto è necessario un ambiente PostgreSQL compatibile:

- PostgreSQL ≥ 15
- Tool consigliati: pgAdmin, DBeaver, Azure Data Studio, psql
- Testabile anche su: [https://dbfiddle.uk](https://dbfiddle.uk), [https://extendsclass.com/postgresql-online.html](https://extendsclass.com/postgresql-online.html)

---

## 🛠️ Istruzioni per l'uso

1. Apri il file `ITA_Airways_DB_script.sql` in un ambiente PostgreSQL.
2. Esegui lo script per:
   - Creare tutte le tabelle relazionali
   - Inserire dati di esempio realistici
   - Eseguire viste e query dimostrative
3. Verifica i risultati eseguendo le query una alla volta. Tutte le query sono state testate e producono output coerenti con lo scenario.

---

## ✈️ Funzionalità implementate

- Tracciamento in tempo reale delle posizioni aeree
- Registro storico degli eventi operativi
- Analisi dei consumi e dell’efficienza per tipo di aereo e tratta
- Query aggregate su impatti ambientali e operativi
- Vista SQL (`Vista_Posizione_Attuale`) per aggiornamento live della flotta

---

## ✅ Query SQL dimostrative

Nel file `.sql` sono incluse le seguenti query, tutte testate e documentate:

1. **Ultima posizione GPS per aereo**
2. **Storico eventi tecnici per aereo**
3. **Consumo medio per modello di aereo**
4. **Viaggi programmati tra due aeroporti (es. FCO → JFK)**
5. **Tratte con maggiore consumo totale in un intervallo di tempo**

Tutti i risultati sono stati verificati su ambienti PostgreSQL online, e gli screenshot sono disponibili nell’elaborato PDF.

---

## 📊 Diagramma ER

Il modello concettuale include sei entità principali:

- `Aereo`
- `Tratta`
- `Viaggio`
- `PosizioneAereo`
- `EventoOperativo`
- `ConsumoCarburante`

Realizzato con [dbdiagram.io](https://dbdiagram.io).

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
