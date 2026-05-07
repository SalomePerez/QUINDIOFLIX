import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Navbar            from './components/Navbar';
import LoginPage         from './pages/LoginPage';
import RegisterPage      from './pages/RegisterPage';
import HomePage          from './pages/HomePage';
import ContenidoDetailPage from './pages/ContenidoDetailPage';
import DashboardPage     from './pages/DashboardPage';
import AdminContenidoPage from './pages/AdminContenidoPage';

function PrivateRoute({ children }) {
  const { user } = useAuth();
  return user ? children : <Navigate to="/login" replace />;
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Navbar />
        <Routes>
          <Route path="/login"    element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route path="/" element={<PrivateRoute><HomePage /></PrivateRoute>} />
          <Route path="/contenido/:id" element={<PrivateRoute><ContenidoDetailPage /></PrivateRoute>} />
          <Route path="/dashboard"     element={<PrivateRoute><DashboardPage /></PrivateRoute>} />
          <Route path="/admin/contenido" element={<PrivateRoute><AdminContenidoPage /></PrivateRoute>} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

