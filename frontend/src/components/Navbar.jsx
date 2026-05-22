import { useState, useRef, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { User, LogOut, Home, LayoutDashboard, Shield, Users, Gift, Flag, Heart, CreditCard, ChevronDown } from 'lucide-react';

export default function Navbar() {
  const { user, perfil, logout } = useAuth();
  const navigate = useNavigate();
  const [showUserMenu, setShowUserMenu] = useState(false);
  const menuRef = useRef(null);

  // Cerrar menú al hacer clic fuera
  useEffect(() => {
    function handleClickOutside(event) {
      if (menuRef.current && !menuRef.current.contains(event.target)) {
        setShowUserMenu(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

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
          <Link to="/referidos" className="text-gray-300 hover:text-white transition flex items-center gap-2">
            <Gift size={16} />
            Referidos
          </Link>
          <Link to="/pagos" className="text-gray-300 hover:text-white transition flex items-center gap-2">
            <CreditCard size={16} />
            Pagos
          </Link>
          {user.ES_MODERADOR === 'S' && (
            <>
              <Link to="/dashboard" className="text-gray-300 hover:text-white transition flex items-center gap-2">
                <LayoutDashboard size={16} />
                Dashboard
              </Link>
              <Link to="/moderacion" className="text-orange-400 hover:text-orange-300 transition flex items-center gap-2">
                <Flag size={16} />
                Moderación
              </Link>
              <Link to="/admin/contenido" className="text-yellow-400 hover:text-yellow-300 transition flex items-center gap-2">
                <Shield size={16} />
                Admin
              </Link>
            </>
          )}
        </div>
      )}

      <div className="flex items-center gap-4">
        {user ? (
          <div className="relative" ref={menuRef}>
            <button
              onClick={() => setShowUserMenu(!showUserMenu)}
              className="text-gray-400 hover:text-white text-sm flex items-center gap-2 transition"
            >
              <User size={16} className="text-gray-500" />
              {perfil ? perfil.NOMBRE : user.NOMBRE}
              <span className="ml-1 text-xs bg-gray-700 px-2 py-0.5 rounded">{user.PLAN}</span>
              <ChevronDown size={14} className={`transition-transform ${showUserMenu ? 'rotate-180' : ''}`} />
            </button>

            {/* Menú desplegable */}
            {showUserMenu && (
              <div className="absolute right-0 mt-2 w-56 bg-gray-800 border border-gray-700 rounded-lg shadow-xl overflow-hidden z-50">
                <div className="px-4 py-3 border-b border-gray-700">
                  <p className="text-sm font-medium text-white">{user.NOMBRE} {user.APELLIDO}</p>
                  <p className="text-xs text-gray-400">{user.EMAIL}</p>
                </div>
                <div className="py-1">
                  <Link
                    to="/perfiles"
                    onClick={() => setShowUserMenu(false)}
                    className="flex items-center gap-3 px-4 py-2 text-sm text-gray-300 hover:bg-gray-700 hover:text-white transition"
                  >
                    <User size={16} />
                    Cambiar Perfil
                  </Link>
                  <Link
                    to="/favoritos"
                    onClick={() => setShowUserMenu(false)}
                    className="flex items-center gap-3 px-4 py-2 text-sm text-gray-300 hover:bg-gray-700 hover:text-white transition"
                  >
                    <Heart size={16} />
                    Mis Favoritos
                  </Link>
                  {user.ES_MODERADOR === 'S' && (
                    <Link
                      to="/dashboard"
                      onClick={() => setShowUserMenu(false)}
                      className="flex items-center gap-3 px-4 py-2 text-sm text-gray-300 hover:bg-gray-700 hover:text-white transition"
                    >
                      <LayoutDashboard size={16} />
                      Mi Dashboard
                    </Link>
                  )}
                </div>
                <div className="border-t border-gray-700 py-1">
                  <button
                    onClick={() => {
                      setShowUserMenu(false);
                      handleLogout();
                    }}
                    className="w-full flex items-center gap-3 px-4 py-2 text-sm text-red-400 hover:bg-gray-700 transition"
                  >
                    <LogOut size={16} />
                    Cerrar Sesión
                  </button>
                </div>
              </div>
            )}
          </div>
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

