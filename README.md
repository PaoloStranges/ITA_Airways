# ITA Airways – Project Work Database

Repository realizzato per il Project Work del Corso di Laurea in *Informatica per le Aziende Digitali (L-31)* – Università Telematica Pegaso.

📌 Obiettivo: progettare un database relazionale a supporto della **gestione operativa della flotta aerea** di ITA Airways, con particolare attenzione al tracciamento in tempo reale, alla registrazione degli eventi tecnici e all’analisi dei consumi.

---

## 🎯 Obiettivi principali

- Memorizzazione delle posizioni GPS (latitudine, longitudine, altitudine, timestamp)
- Gestione di eventi operativi (guasti, ritardi, manutenzioni)
- Monitoraggio dei consumi carburante per singolo viaggio
- Supporto all’efficienza energetica e alla manutenzione predittiva
- Creazione di viste e query per il supporto decisionale operativo

---

## 📂 Contenuto del repository

- `ITA_Airways_DB_script.sql` – Script completo (DDL, DML, viste e query)
- `diagramma_ER_ITA_Airways.png` – Schema ER delle entità e relazioni
- `README.md` – Istruzioni e documentazione

---

## 🧰 Requisiti

Per testare il progetto è consigliato un ambiente PostgreSQL:

- PostgreSQL ≥ 15
- Compatibile con: pgAdmin, DBeaver, Azure Data Studio
- Per test rapidi: [https://dbfiddle.uk](https://dbfiddle.uk)

---

## 🛠️ Istruzioni per l'uso

1. Apri il file `ITA_Airways_DB_script.sql` in un ambiente SQL compatibile.
2. Esegui lo script per:
   - Creare lo schema relazionale
   - Popolare i dati con esempi realistici
   - Eseguire query e viste dimostrative

---

## ✈️ Funzionalità implementate

- Tracciamento real-time della posizione degli aerei
- Registro eventi operativi e storico manutenzioni
- Calcolo efficienza per tratta e modello
- Viste aggregate per stato della flotta
- Analisi ambientale basata sul consumo carburante

---

## ✅ Query SQL esemplificative

- Ultima posizione GPS registrata per un aereo
- Storico eventi tecnici di un velivolo
- Consumo medio per tipo di aeromobile
- Efficienza energetica per tratta
- Tratte a maggior impatto ambientale

È inclusa anche una vista `Vista_Posizione_Attuale` per monitoraggio live semplificato.

---

## 📊 Diagramma ER

Il modello concettuale include le entità:

- Aereo
- Tratta
- Viaggio
- PosizioneAereo
- EventoOperativo
- ConsumoCarburante

Realizzato con: [dbdiagram.io](https://dbdiagram.io)

<p align="center">
  <img src="diagramma_ER_ITA_Airways.png" alt="Diagramma ER" width="700"/>
</p>

---

## 📖 Fonti e strumenti

- [ITA Airways – Sito ufficiale](https://www.ita-airways.com)
- [PostgreSQL Docs](https://www.postgresql.org/docs)
- Elmasri & Navathe – *Fundamentals of Database Systems*
- [IATA – Digital Transformation in Air Transport](https://www.iata.org)
- [dbfiddle.uk](https://dbfiddle.uk)
- [dbdiagram.io](https://dbdiagram.io)

---

## 👨‍💻 Autore

- **Nome**: Paolo Stranges  
- **Matricola**: 0312201143  
- **Università**: Università Telematica Pegaso  
- **Corso di laurea**: Informatica per le Aziende Digitali (L-31)
