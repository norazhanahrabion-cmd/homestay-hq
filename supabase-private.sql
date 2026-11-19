-- Kunci akses: hanya emel dalam allowed_emails boleh LIHAT data, dan hanya emel itu boleh daftar akaun.
-- Jalankan di Supabase > SQL Editor jika belum dipasang.

drop policy if exists "bookings_read" on public.bookings;
drop policy if exists "settings_read" on public.settings;
drop policy if exists "expenses_read" on public.expenses;
create policy "bookings_read" on public.bookings for select to authenticated using (public.is_allowed());
create policy "settings_read" on public.settings for select to authenticated using (public.is_allowed());
create policy "expenses_read" on public.expenses for select to authenticated using (public.is_allowed());

create or replace function public.restrict_signup()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (select 1 from public.allowed_emails where lower(email) = lower(new.email)) then
    raise exception 'Emel ini tidak dibenarkan mendaftar';
  end if;
  return new;
end;
$$;
revoke execute on function public.restrict_signup() from public, anon, authenticated;
drop trigger if exists restrict_signup on auth.users;
create trigger restrict_signup before insert on auth.users for each row execute function public.restrict_signup();
