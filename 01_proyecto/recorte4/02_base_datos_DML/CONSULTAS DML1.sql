-- CONSULTAS DML --

-- Ver todos los riesgos identificados en el supermercado --
SELECT r.id_riesgo, r.tipo, r.descripcion, r.area_afectada, u.nombre AS reportado_por, r.fecha_identificacion
FROM Riesgos r
JOIN Usuarios u ON r.id_usuario = u.id_usuario;

-- Consultar las evaluaciones de riesgos con nivel Alto --
SELECT e.id_evaluacion, r.tipo, r.descripcion, e.criticidad, e.plan_accion
FROM Evaluaciones e
JOIN Riesgos r ON e.id_riesgo = r.id_riesgo
WHERE e.criticidad = 'Alto';

-- Ver capacitaciones programadas en septiembre 2025 --
SELECT c.tema, c.fecha, u.nombre AS responsable
FROM Capacitaciones c
JOIN Usuarios u ON c.id_responsable = u.id_usuario
WHERE MONTH(c.fecha) = 9 AND YEAR(c.fecha) = 2025;

-- Buscar checklist con estado "Incorrecto" -- 
SELECT area, observaciones, fecha
FROM Checklist
WHERE estado = 'Incorrecto';

-- Actualizar estado de una alerta a "Atendida" -- 
UPDATE Alertas
SET estado = 'Atendida'
WHERE id_alerta = 2;

-- Eliminar respuestas de encuestas de un usuario dado --
DELETE FROM Respuestas
WHERE id_usuario = 3;

-- Promedio de respuestas del test de Likert por pregunta -- 
SELECT p.texto_pregunta, AVG(r.valor) AS promedio_respuestas
FROM Respuestas r
JOIN Preguntas p ON r.id_pregunta = p.id_pregunta
GROUP BY p.texto_pregunta;

-- Listar empleados que han respondido encuestas --
SELECT DISTINCT u.nombre, u.rol, u.correo
FROM Usuarios u
JOIN Respuestas r ON u.id_usuario = r.id_usuario;

-- Insertar un nuevo riesgo reportado --
INSERT INTO Riesgos (tipo, descripcion, area_afectada, fecha_identificacion, id_usuario) VALUES
('Químico', 'Exposición a productos de limpieza sin guantes', 'Aseo', '2025-09-02', 4);

-- Mostrar alertas pendientes ordenadas por fecha --
SELECT tipo, descripcion, fecha, estado
FROM Alertas
WHERE estado = 'Pendiente'
ORDER BY fecha ASC;