create extension if not exists "vector" with schema "extensions";

create table "public"."products" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid not null,
    "workspace_id" uuid,
    "parent_id" uuid,
    "category_id" uuid,
    "sku" varchar(40) not null,
    "name" varchar(250) not null,
    "description" text,
    "unit" varchar(30),
    "tags" text[] default '{}'::text[],
    "images" jsonb,
    "price" numeric(10, 2) not null,
    "currency" varchar(5) not null default 'MXN'::varchar,
    "is_variant" boolean default false,
    "is_active" boolean default true,
    "embedding" vector(1536),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);


alter table "public"."products" enable row level security;

CREATE UNIQUE INDEX products_pkey ON public.products USING btree (id);

CREATE UNIQUE INDEX products_sku_key ON public.products USING btree (sku);

alter table "public"."products" add constraint "products_pkey" PRIMARY KEY using index "products_pkey";

alter table "public"."products" add constraint "products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."products" validate constraint "products_category_id_fkey";

alter table "public"."products" add constraint "products_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."products" validate constraint "products_organization_id_fkey";

alter table "public"."products" add constraint "products_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."products" validate constraint "products_parent_id_fkey";

alter table "public"."products" add constraint "products_sku_key" UNIQUE using index "products_sku_key";

alter table "public"."products" add constraint "products_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."products" validate constraint "products_workspace_id_fkey";

grant delete on table "public"."products" to "anon";

grant insert on table "public"."products" to "anon";

grant references on table "public"."products" to "anon";

grant select on table "public"."products" to "anon";

grant trigger on table "public"."products" to "anon";

grant truncate on table "public"."products" to "anon";

grant update on table "public"."products" to "anon";

grant delete on table "public"."products" to "authenticated";

grant insert on table "public"."products" to "authenticated";

grant references on table "public"."products" to "authenticated";

grant select on table "public"."products" to "authenticated";

grant trigger on table "public"."products" to "authenticated";

grant truncate on table "public"."products" to "authenticated";

grant update on table "public"."products" to "authenticated";

grant delete on table "public"."products" to "service_role";

grant insert on table "public"."products" to "service_role";

grant references on table "public"."products" to "service_role";

grant select on table "public"."products" to "service_role";

grant trigger on table "public"."products" to "service_role";

grant truncate on table "public"."products" to "service_role";

grant update on table "public"."products" to "service_role";


create policy "create:products"
on "public"."products"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:products"
on "public"."products"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:products"
on "public"."products"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:products"
on "public"."products"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION set_updated_at();
