import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import api from '../api/axios';
import StarRating from '../components/StarRating';
import MediaPlayer from '../components/MediaPlayer';
import { useAuth } from '../context/AuthContext';
import { Film, Tv, FileVideo, Music, Mic, Heart, Crown, Play, Flag } from 'lucide-react';

const iconMap = {
  PELICULA: Film,
  SERIE: Tv,
  DOCUMENTAL: FileVideo,
  MUSICA: Music,
  PODCAST: Mic
};

export default function ContenidoDetailPage() {
  const { id }          = useParams();
  const { perfil, user } = useAuth();
  const [contenido,     setContenido]     = useState(null);
  const [calificaciones,setCalificaciones]= useState([]);
  const [loading,       setLoading]       = useState(true);
  const [miEstrellas,   setMiEstrellas]   = useState(0);
  const [miResena,      setMiResena]      = useState('');
  const [calMsg,        setCalMsg]        = useState('');
  const [porcentajeAvance, setPorcentajeAvance] = useState(0);
  const [reproId, setReproId] = useState(null);
  const [playingMsg, setPlayingMsg] = useState('');
  const [favMsg, setFavMsg] = useState('');
  const [device, setDevice] = useState('COMPUTADOR');
  const [reproStarted, setReproStarted] = useState(false);
  const DEVICE_OPTIONS = ['COMPUTADOR', 'TV', 'TABLET', 'CELULAR'];
  const [tempActiva,    setTempActiva]    = useState(null);
  const [episodios,     setEpisodios]     = useState([]);
  const [showReportModal, setShowReportModal] = useState(false);
  const [reportMotivo, setReportMotivo] = useState('');
  const [reportDesc, setReportDesc] = useState('');
  const [reportMsg, setReportMsg] = useState('');

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

  // cargar progreso de reproducción del perfil para este contenido
  useEffect(() => {
    async function loadProgreso() {
      if (!contenido || !perfil) return;
      try {
        const { data } = await api.get(`/reproducciones/perfil/${perfil.ID_PERFIL}`);
        const match = data.find(r => r.TITULO === contenido.TITULO || r.TITULO === contenido.TITULO);
        if (match) {
          setPorcentajeAvance(Number(match.PORCENTAJE_AVANCE || 0));
          setReproId(match.ID_REPRODUCCION || match.id_reproduccion);
        } else {
          setPorcentajeAvance(0);
          setReproId(null);
        }
      } catch (err) {
        // no bloquear la página por este fallo
      }
    }
    loadProgreso();
  }, [contenido, perfil]);

  useEffect(() => {
    if (!contenido?.TEMPORADAS?.length) {
      setTempActiva(null);
      setEpisodios([]);
      return;
    }
    // Auto-cargar la primera temporada al cargar el contenido
    const primeraTemporada = contenido.TEMPORADAS[0].ID_TEMPORADA;
    fetchEpisodios(primeraTemporada);
  }, [contenido?.TEMPORADAS]);

  async function fetchEpisodios(idTemp) {
    try {
      const { data } = await api.get(`/contenido/${id}/episodios/${idTemp}`);
      setEpisodios(data);
      setTempActiva(idTemp);
    } catch (err) {
      console.error('Error cargando episodios:', err);
      setEpisodios([]);
    }
  }

  async function loadEpisodios(idTemp) {
    if (tempActiva === idTemp) {
      setTempActiva(null);
      setEpisodios([]);
      return;
    }
    await fetchEpisodios(idTemp);
  }

  async function handleCalificar(e) {
    e.preventDefault();
    if (!perfil) return setCalMsg('Selecciona un perfil primero.');
    if (porcentajeAvance < 50) return setCalMsg('Debes reproducir al menos el 50% antes de calificar.');
    try {
      await api.post(`/contenido/${id}/calificar`, {
        id_perfil: perfil.ID_PERFIL, estrellas: miEstrellas, resena: miResena
      });
      setCalMsg('¡Calificación enviada!');
      const { data } = await api.get(`/contenido/${id}/calificaciones`);
      setCalificaciones(data);
    } catch (err) {
      const errorMessage = err.response?.data?.error || 'Error al calificar.';
      setCalMsg(errorMessage);
    }
  }

  async function handleReproducirAhora() {
    if (!perfil) return setPlayingMsg('Selecciona un perfil primero.');
    if (!contenido?.URL_ARCHIVO) return setPlayingMsg('No hay archivo multimedia disponible para reproducir.');
    setPlayingMsg('Iniciando reproducción...');
    try {
      const { data } = await api.post('/reproducciones', {
        id_perfil: perfil.ID_PERFIL,
        id_contenido: id,
        dispositivo: device
      });
      const idr = Array.isArray(data.id_reproduccion) ? data.id_reproduccion[0] : data.id_reproduccion;
      setReproId(idr);
      setReproStarted(true);
      await api.put(`/reproducciones/${idr}`, { porcentaje_avance: 100, finalizar: true });
      setPorcentajeAvance(100);
      setPlayingMsg('Reproducción completada, ya puedes calificar.');
    } catch (err) {
      setPlayingMsg(err.response?.data?.error || 'Error al iniciar reproducción.');
    }
  }

  async function handleFavorito() {
    if (!perfil) return setFavMsg('Selecciona un perfil primero.');
    try {
      await api.post(`/contenido/${id}/favorito`, { id_perfil: perfil.ID_PERFIL });
      setFavMsg('Agregado a favoritos');
    } catch (err) {
      setFavMsg(err.response?.data?.error || 'Error.');
    }
  }

  async function handleReportar(e) {
    e.preventDefault();
    if (!perfil) return setReportMsg('Selecciona un perfil primero.');
    if (!reportMotivo) return setReportMsg('Selecciona un motivo.');
    
    try {
      await api.post(`/contenido/${id}/reportar`, {
        id_perfil: perfil.ID_PERFIL,
        motivo: reportMotivo,
        descripcion: reportDesc
      });
      setReportMsg('Reporte enviado. Será revisado por un moderador.');
      setTimeout(() => {
        setShowReportModal(false);
        setReportMotivo('');
        setReportDesc('');
        setReportMsg('');
      }, 2000);
    } catch (err) {
      setReportMsg(err.response?.data?.error || 'Error al enviar reporte.');
    }
  }

  if (loading) return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center">
      <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
    </div>
  );
  if (!contenido) return <div className="text-center py-20 text-gray-400">Contenido no encontrado.</div>;

  const c = contenido;
  const Icon = iconMap[c.TIPO] || Film;

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      {/* Header */}
      <div className="bg-gradient-to-b from-gray-800 to-gray-950 px-6 py-10">
        <div className="max-w-4xl mx-auto flex gap-8">
          <div className="w-32 h-44 bg-gradient-to-br from-gray-700 to-gray-900 rounded-xl flex items-center justify-center flex-shrink-0">
            <Icon size={64} className="text-gray-400" strokeWidth={1.5} />
          </div>
          <div className="flex-1">
            <div className="flex items-center gap-3 mb-2">
              <h1 className="text-3xl font-bold">{c.TITULO}</h1>
              {c.ES_ORIGINAL === 'S' && (
                <span className="text-xs bg-brand px-2 py-1 rounded font-semibold flex items-center gap-1">
                  <Crown size={12} />
                  ORIGINAL
                </span>
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
            {(c.GENEROS && c.GENEROS.length > 0) && (
              <div className="mb-4">
                <h3 className="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Géneros</h3>
                <div className="flex flex-wrap gap-2">
                  {c.GENEROS.map(g => (
                    <span key={g} className="text-sm bg-gradient-to-r from-brand/20 to-purple-600/20 border border-brand/40 text-white px-3 py-1.5 rounded-lg font-medium">
                      {g}
                    </span>
                  ))}
                </div>
              </div>
            )}
            <div className="flex gap-3">
              <button onClick={handleFavorito}
                className="bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-lg text-sm transition flex items-center gap-2">
                <Heart size={16} />
                Favorito
              </button>
              <button onClick={() => setShowReportModal(true)}
                className="bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg text-sm transition flex items-center gap-2">
                <Flag size={16} />
                Reportar
              </button>
              {favMsg && <span className="text-sm text-green-400 self-center">{favMsg}</span>}
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-4xl mx-auto px-6 py-8 space-y-8">
        {/* Reproductor de Video/Audio */}
        <section>
          <div className="flex flex-wrap items-center gap-3 mb-4">
            <label className="text-sm text-gray-400">Dispositivo</label>
            <select
              value={device}
              onChange={e => setDevice(e.target.value)}
              className="bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none"
            >
              {DEVICE_OPTIONS.map(d => <option key={d} value={d}>{d}</option>)}
            </select>
            <span className="text-sm text-gray-500">Se registrará el dispositivo utilizado en la reproducción.</span>
          </div>
          <MediaPlayer
            url={c.URL_ARCHIVO}
            tipo={c.TIPO}
            onProgress={(prog) => {
              if (reproId) {
                api.put(`/reproducciones/${reproId}`, { porcentaje_avance: Math.round(prog) })
                  .catch(err => console.error('Error actualizando progreso:', err));
              }
            }}
            onStart={async () => {
              if (!perfil || reproStarted) return;
              setPlayingMsg('Iniciando reproducción...');
              try {
                const { data } = await api.post('/reproducciones', {
                  id_perfil: perfil.ID_PERFIL,
                  id_contenido: id,
                  dispositivo: device
                });
                const idr = Array.isArray(data.id_reproduccion) ? data.id_reproduccion[0] : data.id_reproduccion;
                setReproId(idr);
                setReproStarted(true);
                setPlayingMsg('');
              } catch (err) {
                setPlayingMsg(err.response?.data?.error || 'Error al iniciar reproducción.');
              }
            }}
            onEnd={async () => {
              if (reproId) {
                try {
                  await api.put(`/reproducciones/${reproId}`, { porcentaje_avance: 100, finalizar: true });
                  setPorcentajeAvance(100);
                } catch (err) {
                  console.error('Error finalizando reproducción:', err);
                }
              }
            }}
          />
          {!c.URL_ARCHIVO && user?.ES_MODERADOR === 'S' && (
            <div className="mt-4 rounded-xl border border-yellow-500 bg-yellow-950/10 p-4 text-sm text-yellow-200">
              Este contenido aún no tiene archivo multimedia. Sube un video o audio en el <Link to="/admin/contenido" className="underline text-brand">panel de administración</Link> para que los usuarios puedan visualizar o escuchar.
            </div>
          )}
        </section>

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
                      {episodios.length > 0 ? episodios.map(ep => (
                        <div key={ep.ID_EPISODIO} className="px-4 py-2.5 flex justify-between text-sm">
                          <span className="text-gray-300">{ep.NUMERO}. {ep.TITULO}</span>
                          <span className="text-gray-500">{ep.DURACION_MIN} min</span>
                        </div>
                      )) : (
                        <div className="px-4 py-3 text-sm text-gray-400">
                          No hay episodios disponibles para esta temporada.
                        </div>
                      )}
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
            <h2 className="text-xl font-semibold mb-4">Contenido Relacionado</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {c.RELACIONADOS.map((r, i) => (
                <div key={i} className="bg-gray-800 rounded-lg p-4 hover:bg-gray-700 transition">
                  <div className="flex items-start justify-between mb-2">
                    <span className="text-xs bg-purple-600 px-2 py-1 rounded font-semibold uppercase">
                      {r.TIPO_RELACION.replace('_', ' ')}
                    </span>
                    <span className="text-xs text-gray-400">{r.TIPO_RELACIONADO}</span>
                  </div>
                  <h3 className="font-medium text-white mb-1">{r.TITULO_RELACIONADO}</h3>
                  {r.DESCRIPCION && (
                    <p className="text-sm text-gray-400">{r.DESCRIPCION}</p>
                  )}
                </div>
              ))}
            </div>
          </section>
        )}

        {/* Calificar */}
        <section className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-xl font-semibold mb-4">Calificar</h2>
          <form onSubmit={handleCalificar} className="space-y-4">
            {porcentajeAvance < 50 && (
              <div className="text-sm text-yellow-300">
                Debes reproducir al menos el 50% para calificar.
                <button type="button" onClick={handleReproducirAhora} className="ml-3 bg-brand px-3 py-1 rounded text-sm">
                  Reproducir ahora
                </button>
                {playingMsg && <span className="ml-3 text-sm text-green-400">{playingMsg}</span>}
              </div>
            )}
            <StarRating value={miEstrellas} onChange={setMiEstrellas} size="lg" readonly={porcentajeAvance < 50} />
            <textarea
              value={miResena}
              onChange={e => setMiResena(e.target.value)}
              placeholder="Escribe tu reseña (opcional)..."
              rows={3}
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white
                         placeholder-gray-500 focus:outline-none focus:border-brand resize-none"
            />
            {calMsg && <p className={`text-sm ${/Error|50%|Ya calificaste/i.test(calMsg) ? 'text-red-400' : 'text-green-400'}`}>{calMsg}</p>}
            <button type="submit" disabled={!miEstrellas || porcentajeAvance < 50}
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

      {/* Modal de Reporte */}
      {showReportModal && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 px-4">
          <div className="bg-gray-800 rounded-xl p-6 max-w-md w-full">
            <h3 className="text-xl font-semibold mb-4">Reportar Contenido</h3>
            <form onSubmit={handleReportar} className="space-y-4">
              <div>
                <label className="block text-sm text-gray-400 mb-2">Motivo *</label>
                <select 
                  value={reportMotivo} 
                  onChange={e => setReportMotivo(e.target.value)}
                  required
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white
                             focus:outline-none focus:border-brand">
                  <option value="">Selecciona un motivo</option>
                  <option value="Contenido inapropiado">Contenido inapropiado</option>
                  <option value="Violencia excesiva">Violencia excesiva</option>
                  <option value="Lenguaje ofensivo">Lenguaje ofensivo</option>
                  <option value="Clasificación incorrecta">Clasificación incorrecta</option>
                  <option value="Contenido engañoso">Contenido engañoso</option>
                  <option value="Otro">Otro</option>
                </select>
              </div>
              <div>
                <label className="block text-sm text-gray-400 mb-2">Descripción (opcional)</label>
                <textarea 
                  value={reportDesc} 
                  onChange={e => setReportDesc(e.target.value)}
                  rows={3} 
                  placeholder="Describe el problema con más detalle..."
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white
                             placeholder-gray-500 focus:outline-none focus:border-brand resize-none" />
              </div>
              {reportMsg && (
                <p className={`text-sm ${reportMsg.includes('enviado') ? 'text-green-400' : 'text-red-400'}`}>
                  {reportMsg}
                </p>
              )}
              <div className="flex gap-3">
                <button 
                  type="submit" 
                  disabled={!reportMotivo}
                  className="flex-1 bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg transition
                             disabled:opacity-50 disabled:cursor-not-allowed">
                  Enviar Reporte
                </button>
                <button 
                  type="button" 
                  onClick={() => {
                    setShowReportModal(false);
                    setReportMotivo('');
                    setReportDesc('');
                    setReportMsg('');
                  }}
                  className="flex-1 bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-lg transition">
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

