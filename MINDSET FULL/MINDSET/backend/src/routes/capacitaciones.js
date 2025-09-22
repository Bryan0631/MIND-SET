const express = require("express");
const pool = require("../config/db");

const router = express.Router();

// 📌 Obtener todas las capacitaciones con asistentes
router.get("/", async (req, res) => {
  try {
    // 1️⃣ Actualizamos en BD todas las capacitaciones vencidas
    await pool.query(
      "UPDATE capacitaciones SET estado='expirada' WHERE estado='programada' AND fecha < CURDATE()"
    );

    // 2️⃣ Consultamos capacitaciones con usuarios asignados
    const [rows] = await pool.query(`
      SELECT c.id, c.tema, c.fecha, c.encargado, c.estado,
             u.id_usuario, u.nombre, u.rol
      FROM capacitaciones c
      LEFT JOIN capacitacion_asistentes ca ON c.id = ca.capacitacion_id
      LEFT JOIN usuarios u ON ca.usuario_id = u.id_usuario
      ORDER BY c.id DESC
    `);

    const capacitacionesMap = {};
    rows.forEach((row) => {
      if (!capacitacionesMap[row.id]) {
        capacitacionesMap[row.id] = {
          id: row.id,
          tema: row.tema,
          fecha: row.fecha,
          encargado: row.encargado,
          estado: row.estado,
          usuarios: [],
        };
      }
      if (row.id_usuario) {
        capacitacionesMap[row.id].usuarios.push({
          id_usuario: row.id_usuario,
          nombre: row.nombre,
          rol: row.rol,
        });
      }
    });

    res.json(Object.values(capacitacionesMap));
  } catch (err) {
    console.error("❌ Error al obtener capacitaciones:", err);
    res.status(500).json({ error: err.message });
  }
});

// 📌 Crear nueva capacitación
router.post("/", async (req, res) => {
  try {
    const { tema, fecha, encargado, usuarios } = req.body;

    const [result] = await pool.query(
      "INSERT INTO capacitaciones (tema, fecha, encargado, estado) VALUES (?, ?, ?, 'programada')",
      [tema, fecha, encargado]
    );
    const idCapacitacion = result.insertId;

    if (usuarios && usuarios.length > 0) {
      for (let usuarioId of usuarios) {
        await pool.query(
          "INSERT INTO capacitacion_asistentes (capacitacion_id, usuario_id) VALUES (?, ?)",
          [idCapacitacion, usuarioId]
        );
      }
    }

    res.json({ id: idCapacitacion, message: "✅ Capacitación creada (programada)" });
  } catch (err) {
    console.error("❌ Error al crear capacitación:", err);
    res.status(500).json({ error: err.message });
  }
});

// 📌 Editar capacitación
router.put("/:id", async (req, res) => {
  try {
    const { tema, fecha, encargado, estado, usuarios } = req.body;
    const { id } = req.params;

    await pool.query(
      "UPDATE capacitaciones SET tema=?, fecha=?, encargado=?, estado=? WHERE id=?",
      [tema, fecha, encargado, estado, id]
    );

    await pool.query("DELETE FROM capacitacion_asistentes WHERE capacitacion_id=?", [id]);
    if (usuarios && usuarios.length > 0) {
      for (let usuarioId of usuarios) {
        await pool.query(
          "INSERT INTO capacitacion_asistentes (capacitacion_id, usuario_id) VALUES (?, ?)",
          [id, usuarioId]
        );
      }
    }

    res.json({ message: "✅ Capacitación actualizada" });
  } catch (err) {
    console.error("❌ Error al editar capacitación:", err);
    res.status(500).json({ error: err.message });
  }
});

// 📌 Cambiar estado (solo cancelada o programada, expirada se actualiza sola en GET)
router.put("/:id/estado", async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    if (!["cancelada", "programada"].includes(estado)) {
      return res.status(400).json({ error: "Estado inválido" });
    }

    await pool.query("UPDATE capacitaciones SET estado=? WHERE id=?", [estado, id]);

    res.json({ message: `✅ Estado actualizado a ${estado}` });
  } catch (err) {
    console.error("❌ Error al actualizar estado:", err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
