Table "Aereo" {
  "id_aereo" INT [pk]
  "modello" VARCHAR(50)
  "capacita" INT
  "consumo_medio" DECIMAL(5,2)
}

Table "Tratta" {
  "id_tratta" INT [pk]
  "aeroporto_partenza" VARCHAR(10)
  "aeroporto_arrivo" VARCHAR(10)
  "distanza" INT
  "durata_stimata" INT
}

Table "Viaggio" {
  "id_viaggio" INT [pk]
  "id_aereo" INT
  "id_tratta" INT
  "data_partenza" DATE
  "ora_partenza" TIME
}

Table "PosizioneAereo" {
  "id_posizione" INT [pk]
  "id_aereo" INT
  "latitudine" DECIMAL(9,6)
  "longitudine" DECIMAL(9,6)
  "altitudine" INT
  "timestamp" TIMESTAMP
}

Table "EventoOperativo" {
  "id_evento" INT [pk]
  "id_aereo" INT
  "id_viaggio" INT
  "tipo_evento" VARCHAR(50)
  "descrizione" TEXT
  "data_ora" TIMESTAMP
}

Table "ConsumoCarburante" {
  "id_consumo" INT [pk]
  "id_viaggio" INT
  "litri_consumati" DECIMAL(6,2)
  "durata_effettiva" INT
}

Ref: "Aereo"."id_aereo" < "Viaggio"."id_aereo"
Ref: "Tratta"."id_tratta" < "Viaggio"."id_tratta"
Ref: "Aereo"."id_aereo" < "PosizioneAereo"."id_aereo"
Ref: "Aereo"."id_aereo" < "EventoOperativo"."id_aereo"
Ref: "Viaggio"."id_viaggio" < "EventoOperativo"."id_viaggio"
Ref: "Viaggio"."id_viaggio" < "ConsumoCarburante"."id_viaggio"
