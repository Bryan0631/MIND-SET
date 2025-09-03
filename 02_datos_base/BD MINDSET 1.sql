CREATE DATABASE mindset;
use mindset;

CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    rol ENUM('Admin','Supervisor','Empleado') NOT NULL,
    correo VARCHAR(150) UNIQUE,
    contraseña VARCHAR(200) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Riesgos (
    id_riesgo INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Ergonómico','Biomecánico','Psicosocial','Otro') NOT NULL,
    descripcion TEXT,
    area_afectada ENUM('Bodega','Cajas','Alimentos','General') NOT NULL,
    fecha_identificacion DATE,
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE IF NOT EXISTS Evaluaciones (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    id_riesgo INT,
    criticidad ENUM('Bajo','Medio','Alto') NOT NULL,
    plan_accion TEXT,
    fecha_evaluacion DATE,
    FOREIGN KEY (id_riesgo) REFERENCES Riesgos(id_riesgo)
);

CREATE TABLE IF NOT EXISTS Capacitaciones (
    id_capacitacion INT AUTO_INCREMENT PRIMARY KEY,
    tema ENUM('Ergonómica','Psicosocial','Pausas Activas','Manipulación de Alimentos','Otro') NOT NULL,
    fecha DATE,
    id_responsable INT,
    FOREIGN KEY (id_responsable) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE IF NOT EXISTS Checklist (
    id_checklist INT AUTO_INCREMENT PRIMARY KEY,
    area ENUM('Extintores','Pisos','Señalización','EPP','Otro') NOT NULL,
    estado ENUM('Correcto','Incorrecto','Pendiente') NOT NULL,
    observaciones TEXT,
    fecha DATE,
    id_supervisor INT,
    FOREIGN KEY (id_supervisor) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE IF NOT EXISTS Alertas (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('Extintores','Capacitación','Examen Médico','Autocuidado','Otro') NOT NULL,
    descripcion TEXT,
    fecha DATE,
    estado ENUM('Pendiente','Atendida') DEFAULT 'Pendiente',
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE IF NOT EXISTS  Encuestas (
    id_encuesta INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    descripcion TEXT,
    fecha DATE,
    tipo ENUM('Likert','Bienestar','Otro') NOT NULL
);

CREATE TABLE IF NOT EXISTS Preguntas (
    id_pregunta INT AUTO_INCREMENT PRIMARY KEY,
    id_encuesta INT,
    texto_pregunta TEXT NOT NULL,
    FOREIGN KEY (id_encuesta) REFERENCES Encuestas(id_encuesta)
);

CREATE TABLE IF NOT EXISTS Respuestas (
    id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
    id_pregunta INT,
    id_usuario INT,
    valor ENUM('1','2','3','4','5') NOT NULL, -- escala Likert
    fecha DATE,
    FOREIGN KEY (id_pregunta) REFERENCES Preguntas(id_pregunta),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);



-------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Usuarios (id_usuario, nombre, rol, correo, contraseña) VALUES
(1, 'Laura Martínez', 'Admin', 'laura@smarket.com', '1234'),
(2, 'Carlos Pérez', 'Supervisor', 'carlos@smarket.com', '1234'),
(3, 'Ana Torres', 'Empleado', 'ana@smarket.com', '1234'),
(4, 'Luis Gómez', 'Empleado', 'luis@smarket.com', '1234');

INSERT INTO Riesgos (tipo, descripcion, area_afectada, fecha_identificacion, id_usuario) VALUES
('Ergonómico', 'Posturas inadecuadas al levantar cajas', 'Bodega', '2025-08-10', 2),
('Biomecánico', 'Movimientos repetitivos en caja registradora', 'Cajas', '2025-08-15', 2),
('Psicosocial', 'Estrés por sobrecarga laboral en horas pico', 'General', '2025-08-20', 2);

INSERT INTO Evaluaciones (id_riesgo, criticidad, plan_accion, fecha_evaluacion) VALUES
(1, 'Alto', 'Capacitación en manipulación de cargas y uso de fajas', '2025-08-12'),
(2, 'Medio', 'Rotación de personal en cajas cada 2 horas', '2025-08-16'),
(3, 'Alto', 'Implementar pausas activas cada 3 horas', '2025-08-21');

INSERT INTO Capacitaciones (tema, fecha, id_responsable) VALUES
('Ergonómica', '2025-09-05', 2),
('Psicosocial', '2025-09-10', 2),
('Pausas Activas', '2025-09-12', 2);

INSERT INTO Checklist (area, estado, observaciones, fecha, id_supervisor) VALUES
('Extintores', 'Correcto', 'Todos los extintores en buen estado', '2025-09-01', 2),
('Pisos', 'Incorrecto', 'Área de bodega con líquido derramado', '2025-09-01', 2),
('Señalización', 'Pendiente', 'Falta señal en salida de emergencia', '2025-09-01', 2);

INSERT INTO Alertas (tipo, descripcion, fecha, estado, id_usuario) VALUES
('Extintores', 'Revisión de extintores programada', '2025-09-15', 'Pendiente', 2),
('Capacitación', 'Capacitación en pausas activas', '2025-09-12', 'Pendiente', 3),
('Examen Médico', 'Examen ocupacional anual', '2025-09-20', 'Pendiente', 4);

INSERT INTO Encuestas (titulo, descripcion, fecha, tipo) VALUES
('Bienestar Laboral', 'Encuesta para medir percepción del bienestar en el trabajo', '2025-09-01', 'Likert');

INSERT INTO Preguntas (id_encuesta, texto_pregunta) VALUES
(1, 'Las pausas activas ayudan a reducir mi fatiga laboral'),
(1, 'El supermercado promueve condiciones seguras de trabajo'),
(1, 'Siento que se atienden mis sugerencias sobre seguridad y salud');

INSERT INTO Respuestas (id_pregunta, id_usuario, valor, fecha) VALUES
(1, 3, '4', '2025-09-02'),
(1, 4, '5', '2025-09-02'),
(2, 3, '3', '2025-09-02'),
(2, 4, '4', '2025-09-02'),
(3, 3, '2', '2025-09-02'),
(3, 4, '3', '2025-09-02');

