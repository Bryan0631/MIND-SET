CREATE DATABASE IF NOT EXISTS mindset;
USE mindset;
-------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE,
    contraseña VARCHAR(255) NOT NULL,
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE categorias_ejercicios (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);

CREATE TABLE ejercicios (
    id_ejercicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion_aprox_min INT,
    dificultad ENUM('Baja', 'Media', 'Alta'),
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias_ejercicios(id_categoria)
);

CREATE TABLE rutinas (
    id_rutina INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rutina VARCHAR(100) NOT NULL,
    objetivo TEXT,
    duracion_semanas INT
);

CREATE TABLE rutina_ejercicio (
    id_rutina INT,
    id_ejercicio INT,
    dia_semana ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'),
    repeticiones INT,
    series INT,
    PRIMARY KEY (id_rutina, id_ejercicio, dia_semana),
    FOREIGN KEY (id_rutina) REFERENCES rutinas(id_rutina)
);

CREATE TABLE usuario_rutina (
    id_usuario INT,
    id_rutina INT,
    fecha_inicio DATE,
    PRIMARY KEY (id_usuario, id_rutina),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_rutina) REFERENCES rutinas(id_rutina)
);

CREATE TABLE progreso (
    id_progreso INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    fecha DATE,
    peso_kg DECIMAL(5,2),
    observaciones TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE perfil_usuario (
    id_usuario INT PRIMARY KEY,
    id_genero INT,
    fecha_nacimiento DATE,
    altura_cm DECIMAL(5,2),
    peso_inicial_kg DECIMAL(5,2),
    condiciones_medicas TEXT,
    nivel_actividad ENUM('basico', 'intermedio', 'avanzado'),
    objetivo_personal TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_genero) REFERENCES generos(id_genero)
);

CREATE TABLE generos (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre_genero VARCHAR(50) NOT NULL
);
-----------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO usuarios (nombre, correo, contraseña, fecha_registro) VALUES
('Juan Pérez', 'juanperez@example.com', '1234hashedpass', '2025-06-01'),
('María Gómez', 'mariagomez@example.com', '5678hashedpass', '2025-06-05'),
('Carlos Ramírez', 'carlosr@example.com', 'abcdhashedpass', '2025-06-10');

INSERT INTO categorias_ejercicios (nombre_categoria) VALUES
('Cardio'),
('Fuerza'),
('Flexibilidad'),
('Equilibrio');

INSERT INTO ejercicios (nombre, descripcion, duracion_aprox_min, dificultad, id_categoria) VALUES
('Correr', 'Correr al aire libre o en cinta', 30, 'Media', 1),
('Saltos de tijera', 'Ejercicio cardiovascular de bajo impacto', 10, 'Baja', 1),
('Flexiones', 'Flexiones de pecho tradicionales', 15, 'Media', 2),
('Sentadillas', 'Sentadillas con el peso corporal', 20, 'Media', 2),
('Estiramiento de espalda', 'Estiramiento suave para la zona lumbar', 5, 'Baja', 3),
('Postura del árbol', 'Ejercicio de equilibrio básico', 5, 'Baja', 4);

INSERT INTO rutinas (nombre_rutina, objetivo, duracion_semanas) VALUES
('Rutina Principiante', 'Mejorar la resistencia general', 4),
('Rutina Fuerza Intermedia', 'Incrementar fuerza y tono muscular', 6);

INSERT INTO rutina_ejercicio (id_rutina, id_ejercicio, dia_semana, repeticiones, series) VALUES
(1, 1, 'Lunes', 0, 1),
(1, 2, 'Miércoles', 0, 1),
(1, 5, 'Viernes', 0, 1),
(2, 3, 'Martes', 12, 3),
(2, 4, 'Jueves', 15, 3),
(2, 6, 'Sábado', 0, 2);

INSERT INTO usuario_rutina (id_usuario, id_rutina, fecha_inicio) VALUES
(1, 1, '2025-06-02'),
(2, 2, '2025-06-06'),
(3, 1, '2025-06-11');

INSERT INTO progreso (id_usuario, fecha, peso_kg, grasa_corporal, observaciones) VALUES
(1, '2025-06-03', 70.50, 18.5, 'Se siente bien, sin fatiga.'),
(1, '2025-06-10', 69.80, 18.0, 'Mejor resistencia.'),
(2, '2025-06-07', 60.00, 22.0, 'Dolor leve en piernas.'),
(3, '2025-06-12', 80.00, 25.0, 'Primera sesión completada.');

INSERT INTO perfil_usuario (id_usuario, id_genero, fecha_nacimiento, altura_cm, peso_inicial_kg, condiciones_medicas, nivel_actividad, objetivo_personal)
VALUES
(1, 1, '1995-04-15', 175.00, 70.50, 'Ninguna', 'Moderado', 'Ganar masa muscular'),
(2, 2, '1990-08-22', 162.00, 60.00, 'Asma leve', 'Ligero', 'Mejorar resistencia'),
(3, 1, '1985-12-05', 180.00, 80.00, 'Lesión de rodilla', 'Sedentario', 'Perder grasa corporal');

INSERT INTO generos (nombre_genero) VALUES
('Masculino'), ('Femenino'), ('No binario'), ('Prefiero no decir');


------------------------------------------------------------------------------------------------------------------------------------------------------------
#progreso de un usuario en especifico 
SELECT p.fecha, p.peso_kg, p.grasa_corporal, p.observaciones
FROM progreso p
JOIN usuarios u ON p.id_usuario = u.id_usuario
WHERE u.nombre = 'Juan Pérez'
ORDER BY p.fecha;

#listar ejercicios y su categoria 
SELECT e.nombre, e.dificultad, c.nombre_categoria
FROM ejercicios e
JOIN categorias_ejercicios c ON e.id_categoria = c.id_categoria;

#todos los usuarios y sus rutinas 
SELECT u.nombre, r.nombre_rutina, ur.fecha_inicio
FROM usuarios u
LEFT JOIN usuario_rutina ur ON u.id_usuario = ur.id_usuario
LEFT JOIN rutinas r ON ur.id_rutina = r.id_rutina;

#lista de rutinas con su duracion y objetivo 
SELECT nombre_rutina, duracion_semanas, objetivo
FROM rutinas
ORDER BY duracion_semanas DESC;

#promedio de grasa corporal por usuario 
SELECT u.nombre, ROUND(AVG(p.grasa_corporal), 2) AS grasa_promedio
FROM usuarios u
JOIN progreso p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario;

#Usuarios que tienen progreso registrado
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN progreso p ON u.id_usuario = p.id_usuario;

#último registro de progreso de cada usuario
SELECT p1.*
FROM progreso p1
JOIN (
    SELECT id_usuario, MAX(fecha) AS ultima_fecha
    FROM progreso
    GROUP BY id_usuario
) p2 ON p1.id_usuario = p2.id_usuario AND p1.fecha = p2.ultima_fecha;

#Usuarios y la cantidad de rutinas que tienen asignadas
SELECT u.nombre, COUNT(ur.id_rutina) AS total_rutinas
FROM usuarios u
LEFT JOIN usuario_rutina ur ON u.id_usuario = ur.id_usuario
GROUP BY u.id_usuario;

#Usuarios que comenzaron una rutina en un rango de fechas
SELECT u.nombre, r.nombre_rutina, ur.fecha_inicio
FROM usuario_rutina ur
JOIN usuarios u ON ur.id_usuario = u.id_usuario
JOIN rutinas r ON ur.id_rutina = r.id_rutina
WHERE ur.fecha_inicio BETWEEN '2025-06-01' AND '2025-06-15';

#Usuarios que tienen más de una rutina activa
SELECT u.nombre, COUNT(ur.id_rutina) AS cantidad_rutinas
FROM usuarios u
JOIN usuario_rutina ur ON u.id_usuario = ur.id_usuario
GROUP BY u.id_usuario
HAVING cantidad_rutinas > 1;




