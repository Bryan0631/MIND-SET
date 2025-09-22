-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-09-2025 a las 20:10:00
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `mindset2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitaciones`
--

CREATE TABLE `capacitaciones` (
  `id` int(11) NOT NULL,
  `tema` varchar(255) NOT NULL,
  `fecha` date NOT NULL,
  `encargado` varchar(255) NOT NULL,
  `estado` enum('programada','expirada','cancelada') NOT NULL DEFAULT 'programada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `capacitaciones`
--

INSERT INTO `capacitaciones` (`id`, `tema`, `fecha`, `encargado`, `estado`) VALUES
(1, 'postura', '2025-09-25', 'vanti', 'cancelada'),
(2, 'pausas activas', '2025-09-23', 'sura', 'programada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitacion_asistentes`
--

CREATE TABLE `capacitacion_asistentes` (
  `id` int(11) NOT NULL,
  `capacitacion_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `capacitacion_asistentes`
--

INSERT INTO `capacitacion_asistentes` (`id`, `capacitacion_id`, `usuario_id`) VALUES
(31, 1, 7),
(32, 1, 4),
(33, 2, 4),
(34, 2, 6),
(35, 2, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` int(11) NOT NULL,
  `tipo` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id`, `tipo`) VALUES
(1, 'Admin'),
(2, 'Programador\r\n'),
(3, 'Empleado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

CREATE TABLE `tareas` (
  `id_tarea` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `estado` enum('Asignada','Realizada','Pendiente') DEFAULT 'Pendiente',
  `porcentaje` int(11) DEFAULT 0 CHECK (`porcentaje` between 0 and 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tareas`
--

INSERT INTO `tareas` (`id_tarea`, `nombre`, `descripcion`, `estado`, `porcentaje`) VALUES
(1, 'limpiar baños ', '5', 'Asignada', 0),
(2, 'vas', 'hola pollo', 'Asignada', 0),
(3, 'vas', '2', 'Pendiente', 0),
(4, 'vas', '5', 'Pendiente', 0),
(5, 'vas', '5', 'Pendiente', 0),
(6, 'cosa1', '5', 'Pendiente', 0),
(7, 'arreglar un vidrio ', '5', 'Pendiente', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas_usuarios`
--

CREATE TABLE `tareas_usuarios` (
  `id_tarea` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tareas_usuarios`
--

INSERT INTO `tareas_usuarios` (`id_tarea`, `id_usuario`) VALUES
(1, 4),
(1, 5),
(1, 6),
(2, 6),
(3, 6),
(4, 6),
(5, 6),
(6, 6),
(7, 6),
(7, 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `rol` int(11) NOT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `contraseña` varchar(200) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` enum('Activo','Suspendido') DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `rol`, `correo`, `contraseña`, `fecha_registro`, `estado`) VALUES
(4, 'juan camilo garzon ', 1, 'david23.felipe45@gmail.com', '$2b$10$HZf5p3XBMWJM9HSyfapyuO0khQE2fB0.3FzqbY2y0SsXhVSYkcZJ2', '2025-09-21 17:41:38', 'Activo'),
(5, 'luis', 2, 'davidfelipesilvarodri337@gmail.com', '$2b$10$Iu2yPookAayvPtoNL.Xpue9af.UM3pS38c8bb.bWnMBAWI5E9XTTu', '2025-09-21 18:06:32', 'Activo'),
(6, 'luis', 3, 'pipe45.deivid23@gmail.com', '$2b$10$FLXbCTGzxe8lzqymGbZ4WOEro30ZZyzodHnyTwG6IXxHmXrx0Iyre', '2025-09-21 18:50:16', 'Activo'),
(7, 'David', 3, 'sd730000@gmail.com', '$2b$10$djSK0ukbjJXJT2RJ7H8DV.Ta4i7OeS7YhxQTaE43gJ/ppLysht6mS', '2025-09-22 16:17:04', 'Activo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `capacitacion_asistentes`
--
ALTER TABLE `capacitacion_asistentes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_capacitacion` (`capacitacion_id`),
  ADD KEY `fr_usuario` (`usuario_id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD PRIMARY KEY (`id_tarea`),
  ADD KEY `categoria_fk` (`descripcion`);

--
-- Indices de la tabla `tareas_usuarios`
--
ALTER TABLE `tareas_usuarios`
  ADD PRIMARY KEY (`id_tarea`,`id_usuario`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `fk_usuario_rol` (`rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `capacitaciones`
--
ALTER TABLE `capacitaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `capacitacion_asistentes`
--
ALTER TABLE `capacitacion_asistentes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `tareas`
--
ALTER TABLE `tareas`
  MODIFY `id_tarea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `capacitacion_asistentes`
--
ALTER TABLE `capacitacion_asistentes`
  ADD CONSTRAINT `fk_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fr_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `tareas_usuarios`
--
ALTER TABLE `tareas_usuarios`
  ADD CONSTRAINT `tareas_usuarios_ibfk_1` FOREIGN KEY (`id_tarea`) REFERENCES `tareas` (`id_tarea`) ON DELETE CASCADE,
  ADD CONSTRAINT `tareas_usuarios_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`rol`) REFERENCES `rol` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
