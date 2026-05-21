import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { User, Baby, Plus, Edit2, Trash2 } from 'lucide-react';
import api from '../api/axios';

// Avatares disponibles
const AVATARES = [
  { id: 'avatar1', emoji: '😀', nombre: 'Feliz' },
  { id: 'avatar2', emoji: '😎', nombre: 'Cool' },
  { id: 'avatar3', emoji: '🤓', nombre: 'Nerd' },
  { id: 'avatar4', emoji: '😇', nombre: 'Ángel' },
  { id: 'avatar5', emoji: '🤠', nombre: 'Vaquero' },
  { id: 'avatar6', emoji: '🥳', nombre: 'Fiesta' },
  { id: 'avatar7', emoji: '🤖', nombre: 'Robot' },
  { id: 'avatar8', emoji: '👽', nombre: 'Alien' },
  { id: 'avatar9', emoji: '🦸', nombre: 'Héroe' },
  { id: 'avatar10', emoji: '🧙', nombre: 'Mago' },
  { id: 'avatar11', emoji: '🐶', nombre: 'Perro' },
  { id: 'avatar12', emoji: '🐱', nombre: 'Gato' },
  { id: 'avatar13', emoji: '🦁', nombre: 'León' },
  { id: 'avatar14', emoji: '🐼', nombre: 'Panda' },
  { id: 'avatar15', emoji: '🦊', nombre: 'Zorro' },
  { id: 'avatar16', emoji: '🐸', nombre: 'Rana' },
];

export default function PerfilesPage() {
  const { user, selectPerfil } = useAuth();
  const navigate = useNavigate();
  const [perfiles, setPerfiles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({ nombre: '', tipo: 'ADULTO', avatar: 'avatar1' });
  const [error, setError] = useState('');
  const [maxPerfiles, setMaxPerfiles] = useState(5);

  useEffect(() => {
    if (!user) {
      navigate('/login');
      return;
    }
    loadPerfiles();
  }, [user, navigate]);

  async function loadPerfiles() {
    try {
      const { data } = await api.get(`/auth/perfiles/${user.ID_USUARIO}`);
      setPerfiles(data);
      
      // Obtener el límite de perfiles según el plan
      const planRes = await api.get(`/usuarios/${user.ID_USUARIO}`);
      setMaxPerfiles(planRes.data.MAX_PERFILES || 5);
    } catch (err) {
      console.error('Error cargando perfiles:', err);
    } finally {
      setLoading(false);
    }
  }

  async function handleCreatePerfil(e) {
    e.preventDefault();
    setError('');
    
    if (perfiles.length >= maxPerfiles) {
      return setError(`Has alcanzado el límite de ${maxPerfiles} perfiles para tu plan.`);
    }
    
    try {
      await api.post('/auth/perfiles', {
        id_usuario: user.ID_USUARIO,
        nombre: form.nombre,
        tipo: form.tipo,
        avatar: form.avatar
      });
      setForm({ nombre: '', tipo: 'ADULTO', avatar: 'avatar1' });
      setShowForm(false);
      loadPerfiles();
    } catch (err) {
      setError(err.response?.data?.error || 'Error al crear perfil.');
    }
  }

  async function handleDeletePerfil(id) {
    if (!confirm('¿Estás seguro de eliminar este perfil?')) return;
    try {
      await api.delete(`/auth/perfiles/${id}`);
      loadPerfiles();
    } catch (err) {
      alert('Error al eliminar perfil.');
    }
  }

  function handleSelectPerfil(p) {
    selectPerfil(p);
    navigate('/');
  }

  function getAvatarEmoji(avatarId) {
    const avatar = AVATARES.find(a => a.id === avatarId);
    return avatar ? avatar.emoji : '😀';
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-950 flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  // Si no hay perfiles, mostrar formulario automáticamente
  if (perfiles.length === 0 && !showForm) {
    setShowForm(true);
  }

  return (
    <div className="min-h-screen bg-gray-950 flex flex-col items-center justify-center p-4">
      <div className="max-w-4xl w-full">
        <h1 className="text-3xl font-bold text-white mb-2 text-center">
          {perfiles.length === 0 ? 'Crea tu primer perfil' : '¿Quién está viendo?'}
        </h1>
        <p className="text-gray-400 text-center mb-8">
          {perfiles.length === 0 
            ? 'Necesitas al menos un perfil para empezar a disfrutar QuindioFlix'
            : `Tienes ${perfiles.length} de ${maxPerfiles} perfiles disponibles`}
        </p>

        {/* Lista de perfiles */}
        <div className="flex flex-wrap gap-6 justify-center mb-8">
          {perfiles.map(p => (
            <div key={p.ID_PERFIL} className="relative group">
              <button
                onClick={() => handleSelectPerfil(p)}
                className="flex flex-col items-center gap-3"
              >
                <div className="w-32 h-32 rounded-lg bg-gradient-to-br from-gray-700 to-gray-800 
                                flex items-center justify-center text-6xl
                                group-hover:ring-4 group-hover:ring-brand transition-all
                                group-hover:scale-105">
                  {getAvatarEmoji(p.AVATAR)}
                </div>
                <span className="text-gray-300 group-hover:text-white font-medium">{p.NOMBRE}</span>
                {p.TIPO === 'INFANTIL' && (
                  <span className="text-xs bg-blue-700 px-2 py-0.5 rounded">Infantil</span>
                )}
              </button>
              
              {/* Botón de eliminar */}
              <button
                onClick={() => handleDeletePerfil(p.ID_PERFIL)}
                className="absolute top-0 right-0 bg-red-600 hover:bg-red-700 p-2 rounded-full
                           opacity-0 group-hover:opacity-100 transition-opacity"
                title="Eliminar perfil"
              >
                <Trash2 size={16} />
              </button>
            </div>
          ))}

          {/* Botón para agregar perfil */}
          {perfiles.length < maxPerfiles && !showForm && (
            <button
              onClick={() => setShowForm(true)}
              className="flex flex-col items-center gap-3 group"
            >
              <div className="w-32 h-32 rounded-lg border-2 border-dashed border-gray-600
                              flex items-center justify-center
                              group-hover:border-brand group-hover:bg-gray-800 transition-all">
                <Plus size={48} className="text-gray-500 group-hover:text-brand" strokeWidth={1.5} />
              </div>
              <span className="text-gray-400 group-hover:text-white font-medium">Agregar perfil</span>
            </button>
          )}
        </div>

        {/* Formulario para crear perfil */}
        {showForm && (
          <div className="bg-gray-800 rounded-xl p-6 max-w-2xl mx-auto">
            <h2 className="text-xl font-semibold text-white mb-4">Nuevo Perfil</h2>
            <form onSubmit={handleCreatePerfil} className="space-y-4">
              <div>
                <label className="block text-sm text-gray-400 mb-1">Nombre del perfil</label>
                <input
                  type="text"
                  value={form.nombre}
                  onChange={e => setForm(f => ({ ...f, nombre: e.target.value }))}
                  required
                  maxLength={50}
                  placeholder="Ej: Juan, María, Niños..."
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white
                             focus:outline-none focus:border-brand"
                />
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-2">Selecciona un avatar</label>
                <div className="grid grid-cols-8 gap-2 max-h-48 overflow-y-auto bg-gray-700 border border-gray-600 rounded-lg p-3">
                  {AVATARES.map(avatar => (
                    <button
                      key={avatar.id}
                      type="button"
                      onClick={() => setForm(f => ({ ...f, avatar: avatar.id }))}
                      className={`w-12 h-12 rounded-lg flex items-center justify-center text-2xl transition
                        ${form.avatar === avatar.id
                          ? 'bg-brand ring-2 ring-brand scale-110'
                          : 'bg-gray-600 hover:bg-gray-500'}`}
                      title={avatar.nombre}
                    >
                      {avatar.emoji}
                    </button>
                  ))}
                </div>
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-2">Tipo de perfil</label>
                <div className="grid grid-cols-2 gap-3">
                  <button
                    type="button"
                    onClick={() => setForm(f => ({ ...f, tipo: 'ADULTO' }))}
                    className={`p-4 rounded-lg border text-center transition
                      ${form.tipo === 'ADULTO'
                        ? 'border-brand bg-brand/10 text-white'
                        : 'border-gray-600 text-gray-400 hover:border-gray-500'}`}
                  >
                    <User size={32} className="mx-auto mb-2" />
                    <div className="font-medium">Adulto</div>
                    <div className="text-xs text-gray-500">Todo el contenido</div>
                  </button>
                  <button
                    type="button"
                    onClick={() => setForm(f => ({ ...f, tipo: 'INFANTIL' }))}
                    className={`p-4 rounded-lg border text-center transition
                      ${form.tipo === 'INFANTIL'
                        ? 'border-brand bg-brand/10 text-white'
                        : 'border-gray-600 text-gray-400 hover:border-gray-500'}`}
                  >
                    <Baby size={32} className="mx-auto mb-2" />
                    <div className="font-medium">Infantil</div>
                    <div className="text-xs text-gray-500">Solo TP, +7, +13</div>
                  </button>
                </div>
              </div>

              {error && <p className="text-red-400 text-sm">{error}</p>}

              <div className="flex gap-3">
                {perfiles.length > 0 && (
                  <button
                    type="button"
                    onClick={() => {
                      setShowForm(false);
                      setError('');
                      setForm({ nombre: '', tipo: 'ADULTO', avatar: 'avatar1' });
                    }}
                    className="flex-1 bg-gray-700 hover:bg-gray-600 text-white font-semibold py-2.5 rounded-lg transition"
                  >
                    Cancelar
                  </button>
                )}
                <button
                  type="submit"
                  className="flex-1 bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition"
                >
                  Crear Perfil
                </button>
              </div>
            </form>
          </div>
        )}

        {/* Mensaje si no hay perfiles y no está mostrando el formulario */}
        {perfiles.length === 0 && !showForm && (
          <div className="text-center">
            <p className="text-gray-400 mb-4">No tienes perfiles aún</p>
            <button
              onClick={() => setShowForm(true)}
              className="bg-brand hover:bg-brand-dark text-white px-6 py-2.5 rounded-lg transition"
            >
              Crear mi primer perfil
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
