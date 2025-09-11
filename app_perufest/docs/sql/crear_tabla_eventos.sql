-- -- Crear tabla eventos
CREATE TABLE IF NOT EXISTS eventos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha_inicio TIMESTAMPTZ NOT NULL,
    fecha_fin TIMESTAMPTZ NOT NULL,
    lugar VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    imagen_url VARCHAR(500),
    fecha_creacion TIMESTAMPTZ DEFAULT NOW(),
    creado_por UUID NOT NULL,
    
    -- Constraints
    CONSTRAINT eventos_nombre_min_length CHECK (LENGTH(TRIM(nombre)) >= 3),
    CONSTRAINT eventos_lugar_min_length CHECK (LENGTH(TRIM(lugar)) >= 1),
    CONSTRAINT eventos_descripcion_min_length CHECK (LENGTH(TRIM(descripcion)) >= 10),
    CONSTRAINT eventos_fecha_inicio_futura CHECK (fecha_inicio >= CURRENT_DATE - INTERVAL '1 day'),
    CONSTRAINT eventos_fecha_fin_posterior CHECK (fecha_fin > fecha_inicio)
); la tabla de eventos en Supabase
-- Ejecutar este script en el editor SQL de Supabase

-- Crear tabla eventos
CREATE TABLE IF NOT EXISTS eventos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha TIMESTAMPTZ NOT NULL,
    lugar VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    imagen_url VARCHAR(500),
    fecha_creacion TIMESTAMPTZ DEFAULT NOW(),
    creado_por VARCHAR(255) NOT NULL,
    
    -- Constraints
    CONSTRAINT eventos_nombre_min_length CHECK (LENGTH(TRIM(nombre)) >= 3),
    CONSTRAINT eventos_lugar_min_length CHECK (LENGTH(TRIM(lugar)) >= 1),
    CONSTRAINT eventos_descripcion_min_length CHECK (LENGTH(TRIM(descripcion)) >= 10),
    CONSTRAINT eventos_fecha_futura CHECK (fecha >= CURRENT_DATE - INTERVAL '1 day')
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_eventos_fecha_inicio ON eventos(fecha_inicio);
CREATE INDEX IF NOT EXISTS idx_eventos_fecha_fin ON eventos(fecha_fin);
CREATE INDEX IF NOT EXISTS idx_eventos_nombre ON eventos(nombre);
CREATE INDEX IF NOT EXISTS idx_eventos_creado_por ON eventos(creado_por);

-- Habilitar RLS (Row Level Security)
ALTER TABLE eventos ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura a todos los usuarios autenticados
CREATE POLICY "Usuarios pueden leer eventos" ON eventos
    FOR SELECT
    USING (auth.role() = 'authenticated');

-- Política para permitir que los administradores creen eventos
CREATE POLICY "Administradores pueden crear eventos" ON eventos
    FOR INSERT
    WITH CHECK (
        auth.role() = 'authenticated' AND
        EXISTS (
            SELECT 1 FROM usuarios 
            WHERE usuarios.id = auth.uid()::text 
            AND usuarios.rol = 'administrador'
        )
    );

-- Política para permitir que los administradores actualicen eventos
CREATE POLICY "Administradores pueden actualizar eventos" ON eventos
    FOR UPDATE
    USING (
        auth.role() = 'authenticated' AND
        EXISTS (
            SELECT 1 FROM usuarios 
            WHERE usuarios.id = auth.uid()::text 
            AND usuarios.rol = 'administrador'
        )
    );

-- Política para permitir que los administradores eliminen eventos
CREATE POLICY "Administradores pueden eliminar eventos" ON eventos
    FOR DELETE
    USING (
        auth.role() = 'authenticated' AND
        EXISTS (
            SELECT 1 FROM usuarios 
            WHERE usuarios.id = auth.uid()::text 
            AND usuarios.rol = 'administrador'
        )
    );

-- Comentarios para documentar la tabla
COMMENT ON TABLE eventos IS 'Tabla que almacena los eventos del PeruFest';
COMMENT ON COLUMN eventos.id IS 'Identificador único del evento';
COMMENT ON COLUMN eventos.nombre IS 'Nombre del evento';
COMMENT ON COLUMN eventos.fecha IS 'Fecha y hora del evento';
COMMENT ON COLUMN eventos.lugar IS 'Lugar donde se realizará el evento';
COMMENT ON COLUMN eventos.descripcion IS 'Descripción detallada del evento';
COMMENT ON COLUMN eventos.imagen_url IS 'URL de la imagen del evento (opcional)';
COMMENT ON COLUMN eventos.fecha_creacion IS 'Fecha de creación del registro';
COMMENT ON COLUMN eventos.creado_por IS 'ID del usuario que creó el evento';
