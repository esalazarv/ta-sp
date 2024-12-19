create type workspace_status as enum (
  'active',
  'suspended',
  'archived',
  'banned'
);

create table "public"."workspaces" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid not null,
    "owner_id" uuid,
    "name" varchar(100) default 'Default Workspace',
    "description" text,
    "logo" jsonb,
    "status" workspace_status not null default 'active',
    "preferred_time_zone" varchar(50) default 'America/Mexico_City',
    "preferred_language" varchar(10) default 'es',
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);


alter table "public"."workspaces" enable row level security;

CREATE UNIQUE INDEX workspaces_pkey ON public.workspaces USING btree (id);

alter table "public"."workspaces" add constraint "workspaces_pkey" PRIMARY KEY using index "workspaces_pkey";

alter table "public"."workspaces" add constraint "workspaces_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."workspaces" validate constraint "workspaces_organization_id_fkey";

alter table "public"."workspaces" add constraint "workspaces_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."workspaces" validate constraint "workspaces_owner_id_fkey";


alter table "public"."users" add column "default_workspace_id" uuid;

alter table "public"."users" add constraint "users_default_workspace_id_fkey" FOREIGN KEY (default_workspace_id) REFERENCES workspaces(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."users" validate constraint "users_default_workspace_id_fkey";


grant delete on table "public"."workspaces" to "anon";

grant insert on table "public"."workspaces" to "anon";

grant references on table "public"."workspaces" to "anon";

grant select on table "public"."workspaces" to "anon";

grant trigger on table "public"."workspaces" to "anon";

grant truncate on table "public"."workspaces" to "anon";

grant update on table "public"."workspaces" to "anon";

grant delete on table "public"."workspaces" to "authenticated";

grant insert on table "public"."workspaces" to "authenticated";

grant references on table "public"."workspaces" to "authenticated";

grant select on table "public"."workspaces" to "authenticated";

grant trigger on table "public"."workspaces" to "authenticated";

grant truncate on table "public"."workspaces" to "authenticated";

grant update on table "public"."workspaces" to "authenticated";

grant delete on table "public"."workspaces" to "service_role";

grant insert on table "public"."workspaces" to "service_role";

grant references on table "public"."workspaces" to "service_role";

grant select on table "public"."workspaces" to "service_role";

grant trigger on table "public"."workspaces" to "service_role";

grant truncate on table "public"."workspaces" to "service_role";

grant update on table "public"."workspaces" to "service_role";


create policy "create:workspaces"
on "public"."workspaces"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:workspaces"
on "public"."workspaces"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:workspaces"
on "public"."workspaces"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:workspaces"
on "public"."workspaces"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.workspaces FOR EACH ROW EXECUTE FUNCTION set_updated_at();

