# ITA Airways – Project Work Database

Questo repository contiene il dump del database realizzato per il project work del Corso di Laurea in Informatica per le Aziende Digitali (L-31), incentrato sulla progettazione dello schema di persistenza dei dati per ITA Airways.

## 🎯 Obiettivo del progetto

Progettare un sistema di gestione dati a supporto del processo di **vendita dei biglietti aerei**, comprendente:
- Tratte e voli
- Aeroporti
- Clienti e prenotazioni
- Gestione di scali e cambi
- Esecuzione di query SQL rappresentative di operazioni reali

## 📂 Contenuto

- `ITA_Airways_DB_dump.sql`: file SQL contenente la struttura del database, dati di esempio e query di test.
- `README.md`: istruzioni per l'importazione e l'utilizzo del database.

## 🧰 Requisiti

- SQLite 3 oppure un ambiente che supporti SQL standard (MySQL/PostgreSQL possono necessitare adattamenti minimi).
- [DB Browser for SQLite](https://sqlitebrowser.org/) (opzionale, utile per importazione e gestione visuale).

## 🛠️ Istruzioni per l'uso

1. Scarica il file **`ITA_Airways_DB_dump.sql`** da questo repository.
2. Apri il file con il tuo editor o tool SQL preferito, ad esempio:
   - **DB Browser for SQLite**
   - **SQLiteStudio**
   - **DBeaver**
   - o direttamente da terminale con `sqlite3`.
3. Esegui l’intero script per:
   - creare le tabelle;
   - inserire i dati;
   - eseguire le **5 query SQL** richieste nel project work.

## ✅ Query SQL di esempio

Il progetto include query per:
- Ricerca voli disponibili tra città in una data
- Storico prenotazioni di un cliente
- Verifica validità di un biglietto
- Elenco passeggeri su un volo
- Tratte più prenotate in un intervallo temporale

## 📘 Autore

- Nome: *Paolo Stranges*
- Matricola: *0312201143*
- Università: *Universita Telematica Pegaso*
- Corso: *Informatica per le Aziende Digitali (L-31)*

---
