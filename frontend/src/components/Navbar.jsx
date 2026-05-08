import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { User, LogOut, Home, LayoutDashboard, Shield } from 'lucide-react';

export default function Navbar() {
  const { user, perfil, logout } = useAuth();
  const navigate = useNavigate();

  function handleLogout() {
    logout();
    navigate('/login');
  }

  return (
    <nav className="bg-gray-900 border-b border-gray-800 px-6 py-3 flex items-center justify-between sticky top-0 z-50">
      <Link to="/" className="text-2xl font-bold text-brand tracking-tight">
        QUINDIOFLIX
      </Link>

      {user && (
        <div className="flex items-center gap-6 text-sm">
          <Link to="/" className="text-gray-300 hover:text-white transition flex items-center gap-2">
            <Home size={16} />
            Inicio
          </Link>
          <Link to="/dashboard" className="text-gray-300 hover:text-white transition flex items-center gap-2">
            <LayoutDashboard size={16} />
            Dashboard
          </Link>
          {user.ES_MODERADOR === 'S' && (
            <Link to="/admin/contenido" className="text-yellow-400 hover:text-yellow-300 transition flex items-center gap-2">
              <Shield size={16} />
              Admin
            </Link>
          )}
        </div>
      )}

      <div className="flex items-center gap-4">
        {user ? (
          <>
            <span className="text-gray-400 text-sm flex items-center gap-2">
              <User size={16} className="text-gray-500" />
              {perfil ? perfil.NOMBRE : user.NOMBRE}
              <span className="ml-1 text-xs bg-gray-700 px-2 py-0.5 rounded">{user.PLAN}</span>
            </span>
            <button
              onClick={handleLogout}
              className="text-sm text-gray-400 hover:text-white transition flex items-center gap-1.5"
            >
              <LogOut size={16} />
              Salir
            </button>
          </>
        ) : (
          <>
            <Link to="/login" className="text-sm text-gray-300 hover:text-white">Iniciar sesión</Link>
            <Link to="/register" className="text-sm bg-brand hover:bg-brand-dark text-white px-4 py-1.5 rounded transition">
              Registrarse
            </Link>
          </>
        )}
      </div>
    </nav>
  );
}

