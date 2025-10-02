
import React from "react";
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import ProtectedRoute from './ProtectedRoute';
import { AuthProvider } from "./AuthContext";
import Capacitaciones from './html/capacitaciones';
import Tareas from "./html/tareas";
import Test from "./html/test_de_likert";
import Login from "./html/login";
import Register from "./html/register";
import Admin from "./html/admin";
import Empleado from "./html/Empleado";
import Programador from "./html/Programador";
import Usuario from "./html/usuarios";
import Resultados from "./html/Resultados";
import TestEmpleado from "./html/empleado_test";
import CapaEmpleado from "./html/capaciacon_em";
import TareEmpleado from "./html/em_tareas";

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/admin" element={
            <ProtectedRoute><Admin /></ProtectedRoute>
          } />
          <Route path="/empleado" element={
            <ProtectedRoute><Empleado /></ProtectedRoute>
          } />
          <Route path="/programador" element={
            <ProtectedRoute><Programador /></ProtectedRoute>
          } />
        <Route path="/Capacitaciones" element={<Capacitaciones/>} />
        <Route path="/Tareas" element={<Tareas/>} />
        <Route path="/Test" element={<Test/>} />
        <Route path="/Usuarios" element={<Usuario/>} />
        <Route path="/Resultados" element={<Resultados/>} />
        <Route path="/empleado/test" element={<TestEmpleado/>} />
        <Route path="/empleado/capacitaciones" element={
          <ProtectedRoute><CapaEmpleado/></ProtectedRoute>
        } />
        <Route path="/empleado/tareas" element={
          <ProtectedRoute><TareEmpleado/></ProtectedRoute>
        } />
      </Routes>
    </BrowserRouter>
    </AuthProvider>  
  )
}

export default App;