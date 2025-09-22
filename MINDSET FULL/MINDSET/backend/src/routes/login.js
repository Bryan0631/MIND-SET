const express = require("express");
const bcrypt = require("bcrypt");
const pool = require("../config/db");

const router = express.Router();

router.post("/", async (req, res) => {
  const { usuario, clave } = req.body;

  try {
    const [rows] = await pool.query(
      "SELECT * FROM usuarios WHERE correo = ? OR nombre = ?",
      [usuario, usuario]
    );

    if (rows.length === 0) {
      return res.status(401).json({ mensaje: "Usuario no encontrado ❌" });
    }

    const user = rows[0];

    // 🚨 Validar estado
    if (user.estado === "Suspendido") {
      return res.status(403).json({ mensaje: "Usuario suspendido, acceso denegado ❌" });
    }

    // ✅ Validar contraseña
    const validPassword = await bcrypt.compare(clave, user.contraseña);
    if (!validPassword) {
      return res.status(401).json({ mensaje: "Contraseña incorrecta ❌" });
    }

    res.json({
      mensaje: "Login exitoso ✅",
      usuario: {
        id_usuario: user.id_usuario,
        nombre: user.nombre,
        rol: user.rol,
        correo: user.correo,
        estado: user.estado, // incluyo estado en la respuesta
      },
    });
  } catch (error) {
    console.error("❌ Error en login:", error);
    res.status(500).json({ mensaje: "Error en el servidor" });
  }
});

module.exports = router;
