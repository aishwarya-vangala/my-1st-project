create extension if not exists pgcrypto;
create table if not exists public.events (
 id uuid primary key default gen_random_uuid(), title varchar(120) not null,
 description text not null, category varchar(40) not null check(category in ('Technical','Cultural','Sports','Workshop','Other')),
 venue varchar(180) not null, event_date timestamptz not null,
 capacity integer not null check(capacity between 1 and 10000),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.registrations (
 id uuid primary key default gen_random_uuid(), event_id uuid not null references public.events(id) on delete cascade,
 student_name varchar(100) not null, email varchar(180) not null, roll_number varchar(40) not null,
 created_at timestamptz not null default now(),
 constraint registrations_unique_roll_per_event unique(event_id,roll_number),
 constraint registrations_unique_email_per_event unique(event_id,email)
);
create index if not exists events_event_date_idx on public.events(event_date);
create index if not exists events_category_idx on public.events(category);
create index if not exists registrations_event_id_idx on public.registrations(event_id);
create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end; $$;
drop trigger if exists events_set_updated_at on public.events;
create trigger events_set_updated_at before update on public.events for each row execute function public.set_updated_at();
alter table public.events enable row level security;
alter table public.registrations enable row level security;
-- This MVP accesses PostgreSQL through the Express server using a private service-role key.
-- Keep that key secret. Service-role access bypasses RLS, so backend authorization is essential.
insert into public.events(title,description,category,venue,event_date,capacity)
select * from (values
 ('Campus CodeSprint','Team up, solve practical coding challenges, and present a creative solution.','Technical','Computer Science Lab',now()+interval '14 days',120),
 ('Rhythm & Roots','An evening of music, dance, performances, and campus talent.','Cultural','College Auditorium',now()+interval '21 days',300),
 ('Build Your First App','A beginner-friendly hands-on workshop on planning and building a small web application.','Workshop','Innovation Hub',now()+interval '28 days',80)
) as seed(title,description,category,venue,event_date,capacity)
where not exists(select 1 from public.events);
