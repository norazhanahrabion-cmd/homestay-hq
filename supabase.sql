-- Homestay HQ: skema Supabase (sudah dipasang pada projek "homestay-hq")
-- Lihat = sesiapa (tanpa log masuk). Tambah/edit/padam = emel dalam allowed_emails selepas log masuk.

create table if not exists public.allowed_emails (email text primary key);
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  data jsonb not null,
  updated_at timestamptz not null default now()
);
create table if not exists public.settings (id int primary key, data jsonb not null);

create or replace function public.is_allowed() returns boolean
language sql security definer stable set search_path = public as $$
  select exists (select 1 from public.allowed_emails where lower(email) = lower(auth.jwt() ->> 'email'));
$$;

alter table public.allowed_emails enable row level security;
alter table public.bookings enable row level security;
alter table public.settings enable row level security;

create policy "bookings_read" on public.bookings for select to anon, authenticated using (true);
create policy "settings_read" on public.settings for select to anon, authenticated using (true);
create policy "bookings_insert" on public.bookings for insert to authenticated with check (public.is_allowed());
create policy "bookings_update" on public.bookings for update to authenticated using (public.is_allowed()) with check (public.is_allowed());
create policy "bookings_delete" on public.bookings for delete to authenticated using (public.is_allowed());
create policy "settings_insert" on public.settings for insert to authenticated with check (public.is_allowed());
create policy "settings_update" on public.settings for update to authenticated using (public.is_allowed()) with check (public.is_allowed());

alter publication supabase_realtime add table public.bookings;
alter publication supabase_realtime add table public.settings;

revoke execute on function public.is_allowed() from public, anon;
grant execute on function public.is_allowed() to authenticated;

-- Tambah emel anda & partner:
-- insert into public.allowed_emails (email) values ('saya@gmail.com'), ('partner@gmail.com');
