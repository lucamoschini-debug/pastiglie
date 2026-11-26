# Le mie pastiglie

App web per gestire gli orari delle pastiglie: dosi del giorno divise per fascia oraria, spunta "Presa", settimana a colpo d'occhio, scorte che scalano da sole.

Tutto sta in `index.html`, senza dipendenze. I dati restano salvati nel browser del dispositivo (localStorage).

Non sostituisce le indicazioni del medico o del farmacista.

## Dati e accesso (Supabase)

- Login via email con link magico, senza password.
- I dati stanno su Supabase (regione UE). Le regole di Row Level Security in [`supabase/schema.sql`](supabase/schema.sql) fanno sì che ogni utente legga e modifichi solo le proprie righe.
- Nel codice c'è solo la chiave pubblica (`publishable`), che da sola non dà accesso ai dati. La chiave `secret` / `service_role` non va mai messa qui.
