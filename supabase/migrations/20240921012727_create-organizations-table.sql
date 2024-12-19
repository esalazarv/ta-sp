create type organization_type as enum (
  'personal',
  'team',
  'business'
);

create type organization_status as enum (
  'active',
  'suspended',
  'banned'
);


create table "public"."organizations" (
    "id" uuid not null default gen_random_uuid(),
    "owner_id" uuid,
    "type" organization_type not null default 'personal',
    "status" organization_status not null default 'active',
    "logo" jsonb,
    "name" varchar(200) not null default 'Unnamed Organization',
    "website" text,
    "contact_email" varchar(250),
    "contact_name" varchar(200),
    "contact_phone_country" varchar(5),
    "contact_phone_dial_code" varchar(5),
    "contact_phone_number" varchar(25),
    "preferred_time_zone" varchar(50) default 'America/Mexico_City',
    "preferred_language" varchar(10) default 'es',
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);


alter table "public"."organizations" enable row level security;

CREATE UNIQUE INDEX organization_pkey ON public.organizations USING btree (id);

alter table "public"."organizations" add constraint "organization_pkey" PRIMARY KEY using index "organization_pkey";

alter table "public"."organizations" add constraint "organizations_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."organizations" validate constraint "organizations_owner_id_fkey";


alter table "public"."users" add column "organization_id" uuid;

alter table "public"."users" add constraint "users_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_organization_id_fkey";


grant delete on table "public"."organizations" to "anon";

grant insert on table "public"."organizations" to "anon";

grant references on table "public"."organizations" to "anon";

grant select on table "public"."organizations" to "anon";

grant trigger on table "public"."organizations" to "anon";

grant truncate on table "public"."organizations" to "anon";

grant update on table "public"."organizations" to "anon";

grant delete on table "public"."organizations" to "authenticated";

grant insert on table "public"."organizations" to "authenticated";

grant references on table "public"."organizations" to "authenticated";

grant select on table "public"."organizations" to "authenticated";

grant trigger on table "public"."organizations" to "authenticated";

grant truncate on table "public"."organizations" to "authenticated";

grant update on table "public"."organizations" to "authenticated";

grant delete on table "public"."organizations" to "service_role";

grant insert on table "public"."organizations" to "service_role";

grant references on table "public"."organizations" to "service_role";

grant select on table "public"."organizations" to "service_role";

grant trigger on table "public"."organizations" to "service_role";

grant truncate on table "public"."organizations" to "service_role";

grant update on table "public"."organizations" to "service_role";

create policy "create:organizations"
on "public"."organizations"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:organizations"
on "public"."organizations"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:organizations"
on "public"."organizations"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:organizations"
on "public"."organizations"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.organizations FOR EACH ROW EXECUTE FUNCTION set_updated_at();

