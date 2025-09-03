-- CONSULTAS DDL --
 
 -- Agregar una columna a la tabla Usuarios --
 ALTER TABLE Usuarios
ADD fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Modificar el tipo de dato de la columna telefono --
ALTER TABLE Usuarios
MODIFY telefono VARCHAR(20);

-- Renombrar la tabla Alertas a Notificaciones --
RENAME TABLE Alertas TO Notificaciones;

-- Eliminar la columna observaciones de la tabla Checklist --
ALTER TABLE Checklist
DROP COLUMN observaciones;

-- Crear una vista que muestre los riesgos críticos --
CREATE VIEW Vista_Riesgos_Criticos AS
SELECT r.id_riesgo, r.tipo, r.descripcion, e.criticidad
FROM Riesgos r
JOIN Evaluaciones e ON r.id_riesgo = e.id_riesgo
WHERE e.criticidad = 'Alto';

-- Eliminar una vista --
DROP VIEW IF EXISTS Vista_Riesgos_Criticos;

-- Vaciar los registros de la tabla Respuestas (sin borrar la tabla) -- 
TRUNCATE TABLE Respuestas;

-- Cambiar el nombre de la columna rol en Usuarios a tipo_usuario --
ALTER TABLE Usuarios
CHANGE rol tipo_usuario ENUM('Administrador','Empleado','Experto') NOT NULL;

-- Eliminar una tabla por completo --
DROP TABLE IF EXISTS Evaluaciones;

-- Agregar una restricción UNIQUE para que no se repitan correos en la tabla Usuarios --
ALTER TABLE Usuarios
ADD CONSTRAINT uq_correo UNIQUE (correo);