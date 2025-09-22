const express = require("express");
const router = express.Router();
const pool = require("../config/db");

// Obtener todas las tareas con sus usuarios
router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT t.id_tarea, t.nombre, t.descripcion, t.estado, t.porcentaje
      FROM tareas t
    `);

    for (let tarea of rows) {
      const [usuarios] = await pool.query(
        `SELECT u.id_usuario, u.nombre 
         FROM tareas_usuarios tu 
         JOIN usuarios u ON tu.id_usuario = u.id_usuario 
         WHERE tu.id_tarea=?`,
        [tarea.id_tarea]
      );
      tarea.usuarios = usuarios;
    }

    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener tareas" });
  }
});

// Crear nueva tarea con usuarios asignados
router.post("/", async (req, res) => {
  try {
    const { nombre, descripcion, usuarios } = req.body;

    const [result] = await pool.query(
      "INSERT INTO tareas (nombre, descripcion, estado, porcentaje) VALUES (?, ?, 'Asignada', 0)",
      [nombre, descripcion]
    );

    const id_tarea = result.insertId;

    if (usuarios && usuarios.length > 0) {
      for (let id_usuario of usuarios) {
        await pool.query(
          "INSERT INTO tareas_usuarios (id_tarea, id_usuario) VALUES (?, ?)",
          [id_tarea, id_usuario]
        );
      }
    }

    res.json({ message: "✅ Tarea creada correctamente", id_tarea });
  } catch (err) {
    console.error("❌ Error al crear tarea:", err);
    res.status(500).json({ error: err.message });
  }
});

// Editar tarea y reasignar usuarios
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, descripcion, estado, usuarios } = req.body;

    await pool.query(
      "UPDATE tareas SET nombre=?, descripcion=?, estado=? WHERE id_tarea=?",
      [nombre, descripcion, estado, id]
    );

    await pool.query("DELETE FROM tareas_usuarios WHERE id_tarea=?", [id]);

    if (usuarios && usuarios.length > 0) {
      for (const u of usuarios) {
        await pool.query(
          "INSERT INTO tareas_usuarios (id_tarea, id_usuario) VALUES (?, ?)",
          [id, u]
        );
      }
    }

    res.json({ message: "Tarea actualizada" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al actualizar tarea" });
  }
});

// Marcar progreso de tarea por un usuario
router.post("/:id/completar", async (req, res) => {
  try {
    const { id } = req.params;
    const { id_usuario } = req.body;

    const [usuarios] = await pool.query(
      "SELECT COUNT(*) AS total FROM tareas_usuarios WHERE id_tarea=?",
      [id]
    );
    const totalUsuarios = usuarios[0].total;

    const [tareaRows] = await pool.query(
      "SELECT porcentaje FROM tareas WHERE id_tarea=?",
      [id]
    );
    const porcentajeActual = tareaRows[0].porcentaje;

    const incremento = Math.floor(100 / totalUsuarios);
    let nuevoPorcentaje = porcentajeActual + incremento;
    if (nuevoPorcentaje > 100) nuevoPorcentaje = 100;

    let nuevoEstado = "Asignada";
    if (nuevoPorcentaje === 100) nuevoEstado = "Realizada";

    await pool.query(
      "UPDATE tareas SET porcentaje=?, estado=? WHERE id_tarea=?",
      [nuevoPorcentaje, nuevoEstado, id]
    );

    res.json({ message: "Progreso actualizado", porcentaje: nuevoPorcentaje, estado: nuevoEstado });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al completar tarea" });
  }
});

// Cambiar a pendiente
router.put("/:id/pendiente", async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query("UPDATE tareas SET estado='Pendiente' WHERE id_tarea=?", [id]);
    res.json({ message: "Tarea marcada como pendiente" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al marcar pendiente" });
  }
});

module.exports = router;
