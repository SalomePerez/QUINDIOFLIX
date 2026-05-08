import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { User, Baby } from 'lucide-react';
import api from '../api/axios';

export default function LoginPage() {
  const { login, selectPerfil } = useAuth();
  const navigate = useNavigate();
  const [email,    setEmail]    = useState('');
  const [error,    setError]    = useState('');
  const [loading,  setLoading]  = useState(false);
  const [perfiles, setPerfiles] = useState(null);
  const [userId,   setUserId]   = useState(null);

  async function handleLogin(e) {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const user = await login(email);
      setUserId(user.ID_USUARIO);
      // Cargar perfiles
      const { data } = await api.get(`/auth/perfiles/${user.ID_USUARIO}`);
      if (data.length === 1) {
        selectPerfil(data[0]);
        navigate('/');
      } else {
        setPerfiles(data);
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Error al iniciar sesión.');
    } finally {
      setLoading(false);
    }
  }

  function handleSelectPerfil(p) {
    selectPerfil(p);
    navigate('/');
  }

  if (perfiles) {
    return (
      <div className="min-h-screen bg-gray-950 flex flex-col items-center justify-center p-4">
        <h2 className="text-2xl font-bold mb-8 text-white">¿Quién está viendo?</h2>
        <div className="flex flex-wrap gap-6 justify-center">
          {perfiles.map(p => (
            <button
              key={p.ID_PERFIL}
              onClick={() => handleSelectPerfil(p)}
              className="flex flex-col items-center gap-3 group"
            >
              <div className="w-24 h-24 rounded-lg bg-gradient-to-br from-gray-700 to-gray-800 
                              flex items-center justify-center
                              group-hover:ring-4 group-hover:ring-brand transition-all
                              group-hover:scale-105">
                {p.TIPO === 'INFANTIL' ? (
                  <Baby size={40} className="text-blue-400" strokeWidth={1.5} />
                ) : (
                  <User size={40} className="text-gray-300" strokeWidth={1.5} />
                )}
              </div>
              <span className="text-gray-300 group-hover:text-white text-sm font-medium">{p.NOMBRE}</span>
              {p.TIPO === 'INFANTIL' && (
                <span className="text-xs bg-blue-700 px-2 py-0.5 rounded">Infantil</span>
              )}
            </button>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center p-4">
      <div className="w-full max-w-md bg-gray-900 rounded-2xl p-8 shadow-2xl">
        <h1 className="text-3xl font-bold text-brand mb-2 text-center">QUINDIOFLIX</h1>
        <h2 className="text-xl font-semibold text-white mb-6 text-center">Iniciar sesión</h2>

        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-sm text-gray-400 mb-1">Email</label>
            <input
              type="email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
              placeholder="tu@email.com"
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-4 py-2.5
                         text-white placeholder-gray-500 focus:outline-none focus:border-brand"
            />
          </div>

          {error && <p className="text-red-400 text-sm">{error}</p>}

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg
                       transition disabled:opacity-50"
          >
            {loading ? 'Entrando...' : 'Entrar'}
          </button>
        </form>

        <p className="text-center text-gray-500 text-sm mt-6">
          ¿No tienes cuenta?{' '}
          <Link to="/register" className="text-brand hover:underline">Regístrate</Link>
        </p>
      </div>
    </div>
  );
}

