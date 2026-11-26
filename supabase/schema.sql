-- Le mie pastiglie: schema del database Supabase.
-- Incollalo in Supabase -> SQL Editor -> New query, poi premi "Run".
-- Ogni utente vede e modifica SOLO le proprie righe (Row Level Security).

-- Farmaci di ciascun utente
create table if not exists public.farmaci (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  nome        text not null check (char_length(nome) between 1 and 120),
  dose        text not null default '' check (char_length(dose) <= 120),
  cibo        text not null default '' check (cibo in ('', 'pieno', 'vuoto', 'acqua', 'sciogliere')),
  orari       text[] not null check (cardinality(orari) between 1 and 12),
  giorni      smallint[] not null check (cardinality(giorni) between 1 and 7),
  forma       text not null default 'round' check (forma in ('round', 'oval', 'capsule', 'half')),
  colore      text not null default '#f4f4f1' check (colore ~ '^#[0-9a-f]{6}$'),
  scorte      numeric check (scorte is null or scorte >= 0),
  per_dose    numeric not null default 1 check (per_dose > 0),
  inizio      date,
  fine        date,
  note        text not null default '' check (char_length(note) <= 500),
  creato      timestamptz not null default now(),
  aggiornato  timestamptz not null default now()
);
create index if not exists farmaci_user_idx on public.farmaci (user_id);

-- Dosi segnate come prese
create table if not exists public.assunzioni (
  id          bigint generated always as identity primary key,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  farmaco_id  uuid not null references public.farmaci (id) on delete cascade,
  giorno      date not null,
  orario      text not null check (orario ~ '^\d\d:\d\d$'),
  presa_alle  text not null check (presa_alle ~ '^\d\d:\d\d$'),
  creato      timestamptz not null default now(),
  unique (farmaco_id, giorno, orario)
);
create index if not exists assunzioni_user_giorno_idx on public.assunzioni (user_id, giorno);

-- Sicurezza: attiva RLS e togli ogni accesso a chi non ha fatto login
alter table public.farmaci    enable row level security;
alter table public.assunzioni enable row level security;
revoke all on public.farmaci, public.assunzioni from anon;
grant select, insert, update, delete on public.farmaci, public.assunzioni to authenticated;

drop policy if exists "farmaci: solo i propri" on public.farmaci;
create policy "farmaci: solo i propri" on public.farmaci
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "assunzioni: solo le proprie" on public.assunzioni;
create policy "assunzioni: solo le proprie" on public.assunzioni
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.farmaci f
                where f.id = farmaco_id and f.user_id = (select auth.uid()))
  );
