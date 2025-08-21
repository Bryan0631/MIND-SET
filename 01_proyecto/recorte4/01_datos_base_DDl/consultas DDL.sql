-- Cambiar nombre de la tabla "usuarios" a "clientes"
RENAME TABLE usuarios TO clientes;

-- Eliminar columna "condiciones_medicas" de perfil_usuario
ALTER TABLE perfil_usuario
DROP COLUMN condiciones_medicas;

-- Agregar columna "telefono" a la tabla usuarios
ALTER TABLE usuarios
ADD telefono VARCHAR(15);

-- Cambiar el nombre de la columna "objetivo" en rutinas por "meta"
ALTER TABLE rutinas
CHANGE objetivo meta TEXT;

-- Modificar el tipo de dato en la columna "altura_cm"
ALTER TABLE perfil_usuario
MODIFY altura_cm DECIMAL(6,2);

-- Agregar columna "telefono" y "direccion" a usuarios
ALTER TABLE usuarios
ADD telefono VARCHAR(20),
ADD direccion VARCHAR(150);

-- Hacer que "correo" en usuarios NO pueda ser NULL
ALTER TABLE usuarios
MODIFY correo VARCHAR(100) NOT NULL UNIQUE;
