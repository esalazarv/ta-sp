alter type "public"."order_payment_status" rename to "order_payment_status__old_version_to_be_dropped";

create type "public"."order_payment_status" as enum ('pending', 'paid', 'failed');

create table "public"."order_items" (
    "id" uuid not null default gen_random_uuid(),
    "order_id" uuid,
    "product_id" uuid,
    "sku" varchar(50) not null,
    "name" varchar(250) not null,
    "quantity" numeric(10, 2),
    "unit" varchar(30),
    "options" jsonb,
    "notes" text,
    "ia_completions" text,
    "embedding" vector(1536),
    "unit_price" numeric(10, 2),
    "total_price" numeric(10, 2),
    "discount_amount" numeric(10, 2),
    "tax_amount" numeric(10, 2),
    "total_amount" numeric(10, 2),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);

alter table "public"."order_items" enable row level security;

alter table "public"."orders" alter column payment_status type "public"."order_payment_status" using payment_status::text::"public"."order_payment_status";

drop type "public"."order_payment_status__old_version_to_be_dropped";

CREATE UNIQUE INDEX order_items_pkey ON public.order_items USING btree (id);

alter table "public"."order_items" add constraint "order_items_pkey" PRIMARY KEY using index "order_items_pkey";

alter table "public"."order_items" add constraint "order_items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."order_items" validate constraint "order_items_order_id_fkey";

alter table "public"."order_items" add constraint "order_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."order_items" validate constraint "order_items_product_id_fkey";

grant delete on table "public"."order_items" to "anon";

grant insert on table "public"."order_items" to "anon";

grant references on table "public"."order_items" to "anon";

grant select on table "public"."order_items" to "anon";

grant trigger on table "public"."order_items" to "anon";

grant truncate on table "public"."order_items" to "anon";

grant update on table "public"."order_items" to "anon";

grant delete on table "public"."order_items" to "authenticated";

grant insert on table "public"."order_items" to "authenticated";

grant references on table "public"."order_items" to "authenticated";

grant select on table "public"."order_items" to "authenticated";

grant trigger on table "public"."order_items" to "authenticated";

grant truncate on table "public"."order_items" to "authenticated";

grant update on table "public"."order_items" to "authenticated";

grant delete on table "public"."order_items" to "service_role";

grant insert on table "public"."order_items" to "service_role";

grant references on table "public"."order_items" to "service_role";

grant select on table "public"."order_items" to "service_role";

grant trigger on table "public"."order_items" to "service_role";

grant truncate on table "public"."order_items" to "service_role";

grant update on table "public"."order_items" to "service_role";



create policy "create:order_items"
on "public"."order_items"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:order_items"
on "public"."order_items"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:order_items"
on "public"."order_items"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:order_items"
on "public"."order_items"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION set_updated_at();
