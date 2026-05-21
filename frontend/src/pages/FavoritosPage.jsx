import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { Heart, Film, Tv, FileVideo, Music, Mic, Trash2 } from 'lucide-react';
import api from '../api/axios';

const iconMap = {
  PELICULA: Film,
  SERIE: Tv,
  DOCUMENTAL: FileVideo,
  MUSICA: Music,
  PODCAST: Mic
};

export default function FavoritosPage() {
  const { user, perfil } = useAuth();
  const navigate = useNavigate();
  const [favoritos, setFavoritos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [deleteMsg, setDeleteMsg] = useState('');

  useEffect(() => {
    if (!perfil) {
      navigate('/perfiles');
      return;
    }
    loadFavoritos();
  }, [perfil, navigate]);

  async function loadFavoritos() {
    if (!user || !perfil) return;
    try {
      const { data } = await api.get(`/usuarios/${user.ID_USUARIO}/favoritos/${perfil.ID_PERFIL}`);
      setFavoritos(data);
    } catch (err) {
      console.error('Error cargando favoritos:', err);
    } finally {
      setLoading(false);
    }
  }

  async function handleEliminar(idContenido) {
    if (!perfil) return;
    try {
      await api.delete(`/contenido/${idContenido}/favorito`, {
        data: { id_perfil: perfil.ID_PERFIL }
      });
      setDeleteMsg('Eliminado de favoritos');
      setTimeout(() => setDeleteMsg(''), 2000);
      // Recargar lista
      loadFavoritos();
    } catch (err) {
      setDeleteMsg(err.response?.data?.error || 'Error al eliminar');
      setTimeout(() => setDeleteMsg(''), 3000);
    }
  }

  function handleVerDetalle(idContenido) {
    navigate(`/contenido/${idContenido}`);
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-950 flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
      <div className="max-w-6xl mx-auto">
        <div className="flex items-center gap-3 mb-8">
          <Heart size={32} className="text-brand" />
          <div>
            <h1 className="text-3xl font-bold">Mis Favoritos</h1>
            <p className="text-gray-400 text-sm">
              Perfil: <span className="text-white font-medium">{perfil?.NOMBRE}</span>
            </p>
          </div>
        </div>

        {deleteMsg && (
          <div className={`mb-4 px-4 py-2 rounded-lg ${
            deleteMsg.includes('Error') ? 'bg-red-600/20 text-red-400' : 'bg-green-600/20 text-green-400'
          }`}>
            {deleteMsg}
          </div>
        )}

        {favoritos.length === 0 ? (
          <div className="text-center py-20">
            <Heart size={64} className="mx-auto mb-4 text-gray-700" />
            <p className="text-gray-400 text-lg mb-2">No tienes favoritos aún</p>
            <p className="text-gray-500 text-sm">
              Explora el catálogo y agrega contenido a tu lista de favoritos
            </p>
            <button
              onClick={() => navigate('/')}
              className="mt-6 bg-brand hover:bg-brand-dark px-6 py-2 rounded-lg transition"
            >
              Explorar Catálogo
            </button>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {favoritos.map((fav) => {
              const Icon = iconMap[fav.TIPO] || Film;
              return (
                <div
                  key={fav.ID_CONTENIDO}
                  className="bg-gray-800 rounded-xl overflow-hidden hover:ring-2 hover:ring-brand transition group"
                >
                  <div className="relative">
                    <div className="aspect-video bg-gradient-to-br from-gray-700 to-gray-900 flex items-center justify-center">
                      <Icon size={48} className="text-gray-600" strokeWidth={1.5} />
                    </div>
                    <div className="absolute top-2 right-2 flex gap-2">
                      <button
                        onClick={() => handleEliminar(fav.ID_CONTENIDO)}
                        className="bg-red-600 hover:bg-red-700 p-2 rounded-lg transition opacity-0 group-hover:opacity-100"
                        title="Eliminar de favoritos"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                    <div className="absolute bottom-2 left-2">
                      <span className="text-xs bg-gray-900/80 px-2 py-1 rounded">
                        {fav.CLASIFICACION_EDAD}
                      </span>
                    </div>
                  </div>
                  <div className="p-4">
                    <div className="flex items-start justify-between mb-2">
                      <h3 className="font-semibold text-white line-clamp-1">{fav.TITULO}</h3>
                      <span className="text-xs text-gray-400 ml-2 flex-shrink-0">{fav.TIPO}</span>
                    </div>
                    <p className="text-xs text-gray-400 mb-3">
                      {fav.CATEGORIA} · Agregado el {new Date(fav.FECHA_AGREGADO).toLocaleDateString('es-CO')}
                    </p>
                    <button
                      onClick={() => handleVerDetalle(fav.ID_CONTENIDO)}
                      className="w-full bg-brand hover:bg-brand-dark px-4 py-2 rounded-lg text-sm transition"
                    >
                      Ver Detalles
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
