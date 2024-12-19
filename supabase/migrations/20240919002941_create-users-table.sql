create table "public"."users" (
    "id" uuid not null default gen_random_uuid(),
    "auth_id" uuid not null,
    "email" varchar(250) not null,
    "avatar" jsonb,
    "given_name" varchar(150),
    "second_given_name" varchar(150),
    "paternal_family_name" varchar(300),
    "maternal_family_name" varchar(200),
    "phone_country" varchar(5),
    "phone_dial_code" varchar(5),
    "phone_number" varchar(25),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);


alter table "public"."users" enable row level security;

CREATE UNIQUE INDEX users_auth_id_key ON public.users USING btree (auth_id);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."users" add constraint "users_auth_id_fkey" FOREIGN KEY (auth_id) REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_auth_id_fkey";

alter table "public"."users" add constraint "users_auth_id_key" UNIQUE using index "users_auth_id_key";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";


create policy "create:users"
on "public"."users"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:users"
on "public"."users"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:users"
on "public"."users"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:users"
on "public"."users"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION set_updated_at();

