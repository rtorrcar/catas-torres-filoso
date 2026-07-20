-- =========================================================
-- Torres Filoso · Tabla de ventas de catas
-- Ejecutar en el SQL Editor de tu proyecto Supabase
-- =========================================================

create table if not exists public.ventas_catas (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  fecha date not null default current_date,
  nombre text,
  productos jsonb,
  num_catas integer default 0,
  estado_cata text,
  descuento_aplicado text,
  envio boolean default false,
  subtotal numeric(10,2),
  total numeric(10,2),
  forma_pago text,
  email text,
  notas text,
  direccion text,
  items jsonb,
  precio_cata numeric(10,2),
  subtotal_catas numeric(10,2),
  extra_valor numeric(10,2),
  extra_tipo text
);

-- Si ya habias creado la tabla con una version anterior de este script,
-- estas líneas añaden las columnas nuevas sin romper nada (seguras de repetir):
alter table public.ventas_catas add column if not exists direccion text;
alter table public.ventas_catas add column if not exists items jsonb;
alter table public.ventas_catas add column if not exists precio_cata numeric(10,2);
alter table public.ventas_catas add column if not exists subtotal_catas numeric(10,2);
alter table public.ventas_catas add column if not exists extra_valor numeric(10,2);
alter table public.ventas_catas add column if not exists extra_tipo text;
-- items: desglose de cada vino/producto individual del pedido (para el detalle y "para preparar").
-- precio_cata / subtotal_catas: guardan el precio por cata y el importe de catas de ese pedido.
-- extra_valor / extra_tipo: guardan el valor y tipo (%/€) del descuento extra aplicado, si lo hubo.

-- Índice para listar rápido por fecha (historial)
create index if not exists idx_ventas_catas_fecha on public.ventas_catas (fecha desc, id desc);

-- Activar Row Level Security
alter table public.ventas_catas enable row level security;

-- La app usa la anon key desde el móvil, sin login de usuario.
-- Estas políticas permiten leer, insertar, borrar y actualizar
-- únicamente a través de la anon key (nunca acceso público sin key).
drop policy if exists "anon puede leer ventas_catas" on public.ventas_catas;
create policy "anon puede leer ventas_catas"
  on public.ventas_catas for select
  to anon
  using (true);

drop policy if exists "anon puede insertar ventas_catas" on public.ventas_catas;
create policy "anon puede insertar ventas_catas"
  on public.ventas_catas for insert
  to anon
  with check (true);

drop policy if exists "anon puede borrar ventas_catas" on public.ventas_catas;
create policy "anon puede borrar ventas_catas"
  on public.ventas_catas for delete
  to anon
  using (true);

drop policy if exists "anon puede actualizar ventas_catas" on public.ventas_catas;
create policy "anon puede actualizar ventas_catas"
  on public.ventas_catas for update
  to anon
  using (true)
  with check (true);

-- =========================================================
-- Nota de seguridad: estas políticas dan acceso completo a
-- quien tenga la URL + anon key del proyecto (visibles en el
-- código de la app). Es aceptable para un uso interno familiar
-- con datos de ventas, pero si en el futuro quieres restringir
-- más, se puede añadir autenticación con Supabase Auth.
-- =========================================================
