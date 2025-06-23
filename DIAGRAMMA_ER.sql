CREATE TABLE "Cliente" (
  "IDCliente" SERIAL PRIMARY KEY,
  "Nome" "VARCHAR(50)" NOT NULL,
  "Cognome" "VARCHAR(50)" NOT NULL,
  "Email" "VARCHAR(100)" UNIQUE NOT NULL,
  "Telefono" "VARCHAR(20)",
  "DataNascita" "DATE",
  "IscrizioneVolare" "BOOLEAN" DEFAULT false
);

CREATE TABLE "Aeroporto" (
  "IDAeroporto" SERIAL PRIMARY KEY,
  "Nome" "VARCHAR(100)",
  "CodiceIATA" "CHAR (3)" UNIQUE,
  "CodiceICAO" "CHAR (4)" UNIQUE,
  "Città" "VARCHAR(100)",
  "Nazione" "VARCHAR(100)"
);

CREATE TABLE "Aeromobile" (
  "IDAeromobile" SERIAL PRIMARY KEY,
  "Modello" "VARCHAR(50)",
  "AnnoImmatricolazione" "INT",
  "Capienza" "INT",
  "Consumo" "DECIMAL(6,2)",
  "AutonomiaKM" "INT"
);

CREATE TABLE "Dipendente" (
  "IDDipendente" SERIAL PRIMARY KEY,
  "Nome" "VARCHAR(50)",
  "Cognome" "VARCHAR(50)",
  "Ruolo" "VARCHAR(50)",
  "Certificazioni" "TEXT",
  "OreDiVolo" "INT"
);

CREATE TABLE "Volo" (
  "IDVolo" SERIAL PRIMARY KEY,
  "DataPartenza" "DATE",
  "OraPartenza" "TIME",
  "DataArrivo" "DATE",
  "OraArrivo" "TIME",
  "Stato" "VARCHAR(30)",
  "IDAeroportoPartenza" "INT",
  "IDAeroportoArrivo" "INT",
  "IDAeromobile" "INT",
  "PostiDisponibili" "INT",
  "DurataStimata" "INTERVAL"
);

CREATE TABLE "Prenotazione" (
  "IDPrenotazione" SERIAL PRIMARY KEY,
  "DataPrenotazione" "TIMESTAMP" DEFAULT (CURRENT_TIMESTAMP),
  "Stato" "VARCHAR(30)",
  "MetodoPagamento" "VARCHAR(50)",
  "IDCliente" "INT",
  "CodiceSconto" "VARCHAR(20)"
);

CREATE TABLE "Prenotazione_Volo" (
  "IDPrenotazione" "INT",
  "IDVolo" "INT",
  "PostoAssegnato" "VARCHAR(5)",
  PRIMARY KEY ("IDPrenotazione", "IDVolo")
);

CREATE TABLE "Equipaggio" (
  "IDVolo" "INT",
  "IDDipendente" "INT",
  "RuoloInVolo" "VARCHAR(50)",
  PRIMARY KEY ("IDVolo", "IDDipendente")
);

ALTER TABLE "Volo" ADD FOREIGN KEY ("IDAeroportoPartenza") REFERENCES "Aeroporto" ("IDAeroporto");

ALTER TABLE "Volo" ADD FOREIGN KEY ("IDAeroportoArrivo") REFERENCES "Aeroporto" ("IDAeroporto");

ALTER TABLE "Volo" ADD FOREIGN KEY ("IDAeromobile") REFERENCES "Aeromobile" ("IDAeromobile");

ALTER TABLE "Prenotazione" ADD FOREIGN KEY ("IDCliente") REFERENCES "Cliente" ("IDCliente");

ALTER TABLE "Prenotazione_Volo" ADD FOREIGN KEY ("IDPrenotazione") REFERENCES "Prenotazione" ("IDPrenotazione") ON DELETE CASCADE;

ALTER TABLE "Prenotazione_Volo" ADD FOREIGN KEY ("IDVolo") REFERENCES "Volo" ("IDVolo") ON DELETE CASCADE;

ALTER TABLE "Equipaggio" ADD FOREIGN KEY ("IDVolo") REFERENCES "Volo" ("IDVolo") ON DELETE CASCADE;

ALTER TABLE "Equipaggio" ADD FOREIGN KEY ("IDDipendente") REFERENCES "Dipendente" ("IDDipendente") ON DELETE CASCADE;
