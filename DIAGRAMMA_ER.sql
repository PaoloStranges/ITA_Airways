Table Passeggero {
  id_passeggero INT [pk]
  nome VARCHAR(50)
  cognome VARCHAR(50)
}

Table Aereo {
  id_aereo INT [pk]
  modello VARCHAR(50)
  capacita INT
}

Table Tratta {
  id_tratta INT [pk]
  aeroporto_partenza VARCHAR(10)
  aeroporto_arrivo VARCHAR(10)
  distanza_km INT
}

Table Viaggio {
  id_viaggio INT [pk]
  id_aereo INT [ref: > Aereo.id_aereo]
  data_partenza DATE
}

Table Scalo {
  id_scalo INT [pk]
  id_viaggio INT [ref: > Viaggio.id_viaggio]
  id_tratta INT [ref: > Tratta.id_tratta]
  ordine_scalo INT
}

Table Biglietto {
  id_biglietto INT [pk]
  id_passeggero INT [ref: > Passeggero.id_passeggero]
  id_viaggio INT [ref: > Viaggio.id_viaggio]
  stato VARCHAR(20)
}

Table Prenotazione {
  id_prenotazione INT [pk]
  id_biglietto INT [ref: > Biglietto.id_biglietto]
  data_prenotazione DATE
  stato VARCHAR(20)
}
