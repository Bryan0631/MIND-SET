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