# Le mie pastiglie

App web per gestire gli orari delle pastiglie: dosi del giorno divise per fascia oraria, spunta "Presa", settimana a colpo d'occhio, scorte che scalano da sole.

Tutto sta in `index.html`, senza dipendenze. I dati restano salvati nel browser del dispositivo (localStorage).

Non sostituisce le indicazioni del medico o del farmacista.

## Dati e accesso (Supabase)

- Registrazione e accesso con email e password (conferma dell'email una sola volta; recupero password via email).
- I dati stanno su Supabase (regione UE). Le regole di Row Level Security in [`supabase/schema.sql`](supabase/schema.sql) fanno sì che ogni utente legga e modifichi solo le proprie righe.
- Nel codice c'è solo la chiave pubblica (`publishable`), che da sola non dà accesso ai dati. La chiave `secret` / `service_role` non va mai messa qui.

## Installazione su iPhone

Apri il sito in **Safari**, tocca **Condividi** e poi **Aggiungi alla schermata Home**. L'app si apre a schermo intero e funziona anche offline: le modifiche fatte senza connessione restano sul telefono e vengono inviate al database appena torna la rete.
