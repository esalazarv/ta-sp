create table "public"."categories" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid not null,
    "workspace_id" uuid,
    "parent_id" uuid,
    "name" text,
    "description" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);

alter table "public"."categories" enable row level security;

CREATE UNIQUE INDEX categories_pkey ON public.categories USING btree (id);

alter table "public"."categories" add constraint "categories_pkey" PRIMARY KEY using index "categories_pkey";

alter table "public"."categories" add constraint "categories_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."categories" validate constraint "categories_organization_id_fkey";

alter table "public"."categories" add constraint "categories_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."categories" validate constraint "categories_parent_id_fkey";

alter table "public"."categories" add constraint "categories_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."categories" validate constraint "categories_workspace_id_fkey";

grant delete on table "public"."categories" to "anon";

grant insert on table "public"."categories" to "anon";

grant references on table "public"."categories" to "anon";

grant select on table "public"."categories" to "anon";

grant trigger on table "public"."categories" to "anon";

grant truncate on table "public"."categories" to "anon";

grant update on table "public"."categories" to "anon";

grant delete on table "public"."categories" to "authenticated";

grant insert on table "public"."categories" to "authenticated";

grant references on table "public"."categories" to "authenticated";

grant select on table "public"."categories" to "authenticated";

grant trigger on table "public"."categories" to "authenticated";

grant truncate on table "public"."categories" to "authenticated";

grant update on table "public"."categories" to "authenticated";

grant delete on table "public"."categories" to "service_role";

grant insert on table "public"."categories" to "service_role";

grant references on table "public"."categories" to "service_role";

grant select on table "public"."categories" to "service_role";

grant trigger on table "public"."categories" to "service_role";

grant truncate on table "public"."categories" to "service_role";

grant update on table "public"."categories" to "service_role";


create policy "create:categories"
on "public"."categories"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:categories"
on "public"."categories"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:categories"
on "public"."categories"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:categories"
on "public"."categories"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION set_updated_at();

