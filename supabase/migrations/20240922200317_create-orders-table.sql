create type order_status as enum (
  'draft',
  'pending',
  'processing',
  'shipped',
  'delivered',
  'cancelled'
);

create type order_payment_status as enum (
  'pending',
  'paid',
  'partially_paid',
  'refunded',
  'partially_refunded',
  'payment_failed'
);

create type order_source as enum (
  'web',
  'mobile',
  'api'
);

create type order_type as enum (
  'online',
  'in_store',
  'subscription'
);

create type order_refund_status as enum (
  'requested',
  'approved',
  'rejected',
  'refunded',
  'failed'
);


create type payment_method as enum (
  'cash',
  'credit_card',
  'debit_card',
  'transfer',
  'paypal',
  'spei',
  'oxxo',
  'stripe',
  'mercado_pago'
);

create type shipping_type as enum (
  'standard',
  'express',
  'next_day',
  'same_day'
);

create table "public"."orders" (
    "id" uuid not null default gen_random_uuid(),
    "organization_id" uuid,
    "workspace_id" uuid,
    "owner_id" uuid,
    "customer_id" uuid,
    "number" varchar(50) not null,
    "status" order_status not null default 'draft'::order_status,
    "source" order_source,
    "type" order_type,
    "notes" text,
    "ia_completions" text,
    "embedding" vector(1536),
    "gross_amount" numeric(10, 2),
    "discount_amount" numeric(10, 2),
    "tax_amount" numeric(10, 2),
    "total_amount" numeric(10, 2),
    "currency" varchar(5) default 'MXN'::varchar,
    "shipping_type" shipping_type,
    "shipping_method" varchar(50),
    "shipping_cost" numeric(10, 2),
    "shipping_address" text,
    "estimated_delivery_date" timestamp with time zone,
    "tracking_number" varchar(50),
    "payment_method" payment_method,
    "payment_status" order_payment_status,
    "billing_address" text,
    "refund_status" order_refund_status,
    "refund_amount" numeric(10, 2),
    "refund_date" timestamp with time zone,
    "promotion_code" varchar(50),
    "loyalty_points_used" integer,
    "order_date" timestamp with time zone default now(),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
);


alter table "public"."orders" enable row level security;

CREATE UNIQUE INDEX orders_number_key ON public.orders USING btree (number);

CREATE UNIQUE INDEX orders_pkey ON public.orders USING btree (id);

alter table "public"."orders" add constraint "orders_pkey" PRIMARY KEY using index "orders_pkey";

alter table "public"."orders" add constraint "orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."orders" validate constraint "orders_customer_id_fkey";

alter table "public"."orders" add constraint "orders_number_key" UNIQUE using index "orders_number_key";

alter table "public"."orders" add constraint "orders_organization_id_fkey" FOREIGN KEY (organization_id) REFERENCES organizations(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."orders" validate constraint "orders_organization_id_fkey";

alter table "public"."orders" add constraint "orders_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."orders" validate constraint "orders_owner_id_fkey";

alter table "public"."orders" add constraint "orders_workspace_id_fkey" FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."orders" validate constraint "orders_workspace_id_fkey";

grant delete on table "public"."orders" to "anon";

grant insert on table "public"."orders" to "anon";

grant references on table "public"."orders" to "anon";

grant select on table "public"."orders" to "anon";

grant trigger on table "public"."orders" to "anon";

grant truncate on table "public"."orders" to "anon";

grant update on table "public"."orders" to "anon";

grant delete on table "public"."orders" to "authenticated";

grant insert on table "public"."orders" to "authenticated";

grant references on table "public"."orders" to "authenticated";

grant select on table "public"."orders" to "authenticated";

grant trigger on table "public"."orders" to "authenticated";

grant truncate on table "public"."orders" to "authenticated";

grant update on table "public"."orders" to "authenticated";

grant delete on table "public"."orders" to "service_role";

grant insert on table "public"."orders" to "service_role";

grant references on table "public"."orders" to "service_role";

grant select on table "public"."orders" to "service_role";

grant trigger on table "public"."orders" to "service_role";

grant truncate on table "public"."orders" to "service_role";

grant update on table "public"."orders" to "service_role";


create policy "create:orders"
on "public"."orders"
as permissive
for insert
to anon, authenticated, service_role
with check (true);


create policy "delete:orders"
on "public"."orders"
as permissive
for delete
to anon, authenticated, service_role
using (true);


create policy "read:orders"
on "public"."orders"
as permissive
for select
to anon, authenticated, service_role
using (true);


create policy "update:orders"
on "public"."orders"
as permissive
for update
to anon, authenticated, service_role
using (true)
with check (true);

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION set_updated_at();


