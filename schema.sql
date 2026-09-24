-- Nexora : catalogue géré par un seul propriétaire
-- À exécuter dans Supabase > SQL Editor.

create extension if not exists pgcrypto;

do $$
begin
  create type public.listing_category as enum ('estate', 'vehicle', 'dog');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.listing_status as enum ('available', 'reserved', 'sold', 'draft');
exception
  when duplicate_object then null;
end $$;

create table if not exists public.listings (
  id uuid primary key default gen_random_uuid(),
  category public.listing_category not null,
  title text not null,
  price text not null,
  city text not null,
  description text not null,
  images text[] not null default '{}',
  video_url text,
  status public.listing_status not null default 'available',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists listings_status_created_idx on public.listings(status, created_at desc);

alter table public.listings enable row level security;

-- Les visiteurs voient uniquement les offres disponibles.
drop policy if exists "Public can view available listings" on public.listings;
create policy "Public can view available listings"
on public.listings for select
to anon, authenticated
using (status = 'available');

-- Le compte administrateur connecté peut gérer les offres.
drop policy if exists "Authenticated can view all listings" on public.listings;
create policy "Authenticated can view all listings"
on public.listings for select
to authenticated
using (true);

drop policy if exists "Authenticated can create listings" on public.listings;
create policy "Authenticated can create listings"
on public.listings for insert
to authenticated
with check (true);

drop policy if exists "Authenticated can update listings" on public.listings;
create policy "Authenticated can update listings"
on public.listings for update
to authenticated
using (true)
with check (true);

drop policy if exists "Authenticated can delete listings" on public.listings;
create policy "Authenticated can delete listings"
on public.listings for delete
to authenticated
using (true);

-- Bucket public pour que les visiteurs puissent afficher les photos et vidéos.
insert into storage.buckets (id, name, public)
values ('listing-media', 'listing-media', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view listing media" on storage.objects;
create policy "Public can view listing media"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'listing-media');

drop policy if exists "Authenticated can upload listing media" on storage.objects;
create policy "Authenticated can upload listing media"
on storage.objects for insert
to authenticated
with check (bucket_id = 'listing-media');

drop policy if exists "Authenticated can update listing media" on storage.objects;
create policy "Authenticated can update listing media"
on storage.objects for update
to authenticated
using (bucket_id = 'listing-media')
with check (bucket_id = 'listing-media');

drop policy if exists "Authenticated can delete listing media" on storage.objects;
create policy "Authenticated can delete listing media"
on storage.objects for delete
to authenticated
using (bucket_id = 'listing-media');
