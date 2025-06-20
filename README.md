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

- `ITA_Airways_DB_dump.sql.gz`  
  → Dump completo del database (schema e dati di esempio), compatibile con **SQLite**.

## 🧰 Requisiti

- SQLite 3 oppure un ambiente che supporti SQL standard (MySQL/PostgreSQL possono necessitare adattamenti minimi).
- [DB Browser for SQLite](https://sqlitebrowser.org/) (opzionale, utile per importazione e gestione visuale).

## 🛠️ Istruzioni per l'uso

1. Scarica e decomprimi il file `ITA_Airways_DB_dump.sql.gz`.
2. Apri il file `.sql` con il tuo editor SQL preferito o importalo tramite un'interfaccia grafica (es. DB Browser for SQLite).
3. Esegui le query di test (già incluse nel file `.sql`) per verificare la struttura e i dati.

## ✅ Query SQL di esempio

Il progetto include query per:
- Ricerca voli disponibili tra città in una data
- Storico prenotazioni di un cliente
- Verifica validità di un biglietto
- Elenco passeggeri su un volo
- Tratte più prenotate in un intervallo temporale

## 📘 Autore

- Nome: *[Paolo Stranges]*
- Matricola: *[0312201143]*
- Università: *Universita Telematica Pegaso*
- Corso: *Informatica per le Aziende Digitali (L-31)*

---
