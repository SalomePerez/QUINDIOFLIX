import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import api from '../api/axios';
import StarRating from '../components/StarRating';
import { useAuth } from '../context/AuthContext';

export default function ContenidoDetailPage() {
  const { id }          = useParams();
  const { perfil }      = useAuth();
  const [contenido,     setContenido]     = useState(null);
  const [calificaciones,setCalificaciones]= useState([]);
  const [loading,       setLoading]       = useState(true);
  const [miEstrellas,   setMiEstrellas]   = useState(0);
  const [miResena,      setMiResena]      = useState('');
  const [calMsg,        setCalMsg]        = useState('');
  const [favMsg,        setFavMsg]        = useState('');
  const [tempActiva,    setTempActiva]    = useState(null);
  const [episodios,     setEpisodios]     = useState([]);

  useEffect(() => {
    setLoading(true);
    Promise.all([
      api.get(`/contenido/${id}`),
      api.get(`/contenido/${id}/calificaciones`)
    ]).then(([cRes, calRes]) => {
      setContenido(cRes.data);
      setCalificaciones(calRes.data);
    }).finally(() => setLoading(false));
  }, [id]);

  async function loadEpisodios(idTemp) {
    if (tempActiva === idTemp) { setTempActiva(null); return; }
    const { data } = await api.get(`/contenido/${id}/episodios/${idTemp}`);
    setEpisodios(data);
    setTempActiva(idTemp);
  }

  async function handleCalificar(e) {
    e.preventDefault();
    if (!perfil) return setCalMsg('Selecciona un perfil primero.');
    try {
      await api.post(`/contenido/${id}/calificar`, {
        id_perfil: perfil.ID_PERFIL, estrellas: miEstrellas, resena: miResena
      });
      setCalMsg('¡Calificación enviada!');
      const { data } = await api.get(`/contenido/${id}/calificaciones`);
      setCalificaciones(data);
    } catch (err) {
      setCalMsg(err.response?.data?.error || 'Error al calificar.');
    }
  }

  async function handleFavorito() {
    if (!perfil) return setFavMsg('Selecciona un perfil primero.');
    try {
      await api.post(`/contenido/${id}/favorito`, { id_perfil: perfil.ID_PERFIL });
      setFavMsg('Agregado a favoritos ❤️');
    } catch (err) {
      setFavMsg(err.response?.data?.error || 'Error.');
    }
  }

  if (loading) return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center">
      <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
    </div>
  );
  if (!contenido) return <div className="text-center py-20 text-gray-400">Contenido no encontrado.</div>;

  const c = contenido;

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      {/* Header */}
      <div className="bg-gradient-to-b from-gray-800 to-gray-950 px-6 py-10">
        <div className="max-w-4xl mx-auto flex gap-8">
          <div className="w-32 h-44 bg-gray-700 rounded-xl flex items-center justify-center text-5xl flex-shrink-0">
            {c.TIPO === 'PELICULA' ? '🎬' : c.TIPO === 'SERIE' ? '📺' :
             c.TIPO === 'DOCUMENTAL' ? '🎥' : c.TIPO === 'MUSICA' ? '🎵' : '🎙️'}
          </div>
          <div className="flex-1">
            <div className="flex items-center gap-3 mb-2">
              <h1 className="text-3xl font-bold">{c.TITULO}</h1>
              {c.ES_ORIGINAL === 'S' && (
                <span className="text-xs bg-brand px-2 py-1 rounded font-semibold">ORIGINAL</span>
              )}
            </div>
            <div className="flex flex-wrap gap-2 text-sm text-gray-400 mb-3">
              <span>{c.ANIO_LANZAMIENTO}</span>
              <span>·</span>
              <span>{c.DURACION_MIN} min</span>
              <span>·</span>
              <span className="bg-gray-700 px-2 py-0.5 rounded">{c.CLASIFICACION_EDAD}</span>
              <span>·</span>
              <span>{c.CATEGORIA}</span>
            </div>
            <div className="flex items-center gap-2 mb-3">
              <StarRating value={Math.round(c.CALIFICACION_PROMEDIO || 0)} readonly size="sm" />
              <span className="text-sm text-gray-400">
                {c.CALIFICACION_PROMEDIO ?? '—'} ({c.TOTAL_CALIFICACIONES} reseñas)
              </span>
            </div>
            <p className="text-gray-300 text-sm leading-relaxed mb-4">{c.SINOPSIS}</p>
            <div className="flex flex-wrap gap-2 mb-4">
              {(c.GENEROS || []).map(g => (
                <span key={g} className="text-xs bg-gray-700 px-3 py-1 rounded-full">{g}</span>
              ))}
            </div>
            <div className="flex gap-3">
              <button onClick={handleFavorito}
                className="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-lg text-sm transition">
                ❤️ Favorito
              </button>
              {favMsg && <span className="text-sm text-green-400 self-center">{favMsg}</span>}
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-4xl mx-auto px-6 py-8 space-y-8">
        {/* Temporadas */}
        {c.TEMPORADAS?.length > 0 && (
          <section>
            <h2 className="text-xl font-semibold mb-4">Temporadas</h2>
            <div className="space-y-3">
              {c.TEMPORADAS.map(t => (
                <div key={t.ID_TEMPORADA} className="bg-gray-800 rounded-lg overflow-hidden">
                  <button
                    onClick={() => loadEpisodios(t.ID_TEMPORADA)}
                    className="w-full flex items-center justify-between px-4 py-3 hover:bg-gray-700 transition"
                  >
                    <span className="font-medium">{t.TITULO || `Temporada ${t.NUMERO}`}</span>
                    <span className="text-gray-400 text-sm">{t.NUM_EPISODIOS} episodios {tempActiva === t.ID_TEMPORADA ? '▲' : '▼'}</span>
                  </button>
                  {tempActiva === t.ID_TEMPORADA && (
                    <div className="border-t border-gray-700 divide-y divide-gray-700">
                      {episodios.map(ep => (
                        <div key={ep.ID_EPISODIO} className="px-4 py-2.5 flex justify-between text-sm">
                          <span className="text-gray-300">{ep.NUMERO}. {ep.TITULO}</span>
                          <span className="text-gray-500">{ep.DURACION_MIN} min</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Contenido relacionado */}
        {c.RELACIONADOS?.length > 0 && (
          <section>
            <h2 className="text-xl font-semibold mb-4">Relacionados</h2>
            <div className="flex flex-wrap gap-3">
              {c.RELACIONADOS.map((r, i) => (
                <div key={i} className="bg-gray-800 px-4 py-2 rounded-lg text-sm">
                  <span className="text-gray-400">{r.TIPO_RELACION}: </span>
                  <span className="text-white">{r.TITULO_RELACIONADO}</span>
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Calificar */}
        <section className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-xl font-semibold mb-4">Calificar</h2>
          <form onSubmit={handleCalificar} className="space-y-4">
            <StarRating value={miEstrellas} onChange={setMiEstrellas} size="lg" />
            <textarea
              value={miResena}
              onChange={e => setMiResena(e.target.value)}
              placeholder="Escribe tu reseña (opcional)..."
              rows={3}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white
                         placeholder-gray-500 focus:outline-none focus:border-brand resize-none"
            />
            {calMsg && <p className={`text-sm ${calMsg.includes('Error') || calMsg.includes('50%') ? 'text-red-400' : 'text-green-400'}`}>{calMsg}</p>}
            <button type="submit" disabled={!miEstrellas}
              className="bg-brand hover:bg-brand-dark text-white px-6 py-2 rounded-lg text-sm
                         transition disabled:opacity-40">
              Enviar calificación
            </button>
          </form>
        </section>

        {/* Reseñas */}
        {calificaciones.length > 0 && (
          <section>
            <h2 className="text-xl font-semibold mb-4">Reseñas ({calificaciones.length})</h2>
            <div className="space-y-4">
              {calificaciones.map((cal, i) => (
                <div key={i} className="bg-gray-800 rounded-lg p-4">
                  <div className="flex items-center gap-3 mb-2">
                    <span className="font-medium text-sm">{cal.PERFIL}</span>
                    <StarRating value={cal.ESTRELLAS} readonly size="sm" />
                    <span className="text-gray-500 text-xs ml-auto">
                      {new Date(cal.FECHA).toLocaleDateString('es-CO')}
                    </span>
                  </div>
                  {cal.RESENA && <p className="text-gray-300 text-sm">{cal.RESENA}</p>}
                </div>
              ))}
            </div>
          </section>
        )}
      </div>
    </div>
  );
}

