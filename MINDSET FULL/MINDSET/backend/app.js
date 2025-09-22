const express = require('express')
const cors = require("cors")
require('dotenv').config()
const login = require('./src/routes/login')
const registroroutes = require('./src/routes/register')
const capacitaciones = require('./src/routes/capacitaciones')
const usuarios = require('./src/routes/user')
const tarea = require('./src/routes/tareas')
const app = express();

app.use(express.json());

app.use(cors({
  origin: "http://localhost:5000",
  methods: ["GET", "POST", "PUT", "DELETE"],
  credentials: true
}));


app.use('/login', login)
app.use('/reguistro', registroroutes)
app.use('/usuarios', usuarios)
app.use('/capacitaciones', capacitaciones)
app.use('/tareas', tarea)

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor escuchando en el puerto ${PORT}`);
});