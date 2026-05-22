import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../api/axios';
import MediaPlayer from '../components/MediaPlayer';
import StarRating from '../components/StarRating';
import { useAuth } from '../context/AuthContext';
import { ArrowLeft, Tv } from 'lucide-react';

export default function EpisodioDetailPage() {
  const { idContenido, idTemporada, idEpisodio } = useParams();
  const navigate = useNavigate();
  const { perfil } = useAuth();
  const [episodio, setEpisodio] = useState(null);
  const [contenido, setContenido] = useState(null);
  const [temporada, setTemporada] = useState(null);
  const [loading, setLoading] = useState(true);
  const [reproId, setReproId] = useState(null);
  const [porcentajeAvance, setPorcentajeAvance] = useState(0);

  useEffect(() => {
    loadData();
  }, [idEpisodio]);

  async function loadData() {
    try {
      // Cargar información del contenido (serie)
      const contRes = await api.get(`/contenido/${idContenido}`);
      setContenido(contRes.data);

      // Cargar información de la temporada
      const tempRes = contRes.data.TEMPORADAS?.find(t => t.ID_TEMPORADA === Number(idTemporada));
      setTemporada(tempRes);

      // Cargar episodios de la temporada
      const episRes = await api.get(`/contenido/${idContenido}/episodios/${idTemporada}`);
      const ep = episRes.data.find(e => e.ID_EPISODIO === Number(idEpisodio));
      setEpisodio(ep);

      // Cargar progreso si existe
      if (perfil) {
        try {
          const { data } = await api.get(`/reproducciones/perfil/${perfil.ID_PERFIL}`);
          const match = data.find(r => r.ID_EPISODIO === Number(idEpisodio));
          if (match) {
            setPorcentajeAvance(Number(match.PORCENTAJE_AVANCE || 0));
            setReproId(match.ID_REPRODUCCION || match.id_reproduccion);
          }
        } catch (err) {
          console.error('Error cargando progreso:', err);
        }
      }
    } catch (err) {
      console.error('Error cargando datos:', err);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-950 flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!episodio || !contenido) {
    return (
      <div className="min-h-screen bg-gray-950 text-white flex items-center justify-center">
        <div className="text-center">
          <p className="text-xl mb-4">Episodio no encontrado</p>
          <button
            onClick={() => navigate(`/contenido/${idContenido}`)}
            className="bg-brand hover:bg-brand-dark px-6 py-2 rounded-lg transition"
          >
            Volver a la serie
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      {/* Header */}
      <div className="bg-gradient-to-b from-gray-800 to-gray-950 px-6 py-6">
        <div className="max-w-4xl mx-auto">
          <button
            onClick={() => navigate(`/contenido/${idContenido}`)}
            className="text-gray-400 hover:text-white mb-4 flex items-center gap-2 transition"
          >
            <ArrowLeft size={20} />
            Volver a {contenido.TITULO}
          </button>

          <div className="flex items-start gap-4">
            <div className="w-20 h-20 bg-gradient-to-br from-gray-700 to-gray-900 rounded-lg flex items-center justify-center flex-shrink-0">
              <Tv size={32} className="text-gray-400" />
            </div>
            <div className="flex-1">
              <div className="text-sm text-gray-400 mb-1">
                {temporada?.TITULO || `Temporada ${temporada?.NUMERO}`} · Episodio {episodio.NUMERO}
              </div>
              <h1 className="text-2xl font-bold mb-2">{episodio.TITULO}</h1>
              <div className="flex items-center gap-3 text-sm text-gray-400">
                <span>{episodio.DURACION_MIN} minutos</span>
                {episodio.FECHA_ESTRENO && (
                  <>
                    <span>·</span>
                    <span>Estreno: {new Date(episodio.FECHA_ESTRENO).toLocaleDateString('es-CO')}</span>
                  </>
                )}
              </div>
              {episodio.SINOPSIS && (
                <p className="text-gray-300 text-sm mt-3 leading-relaxed">{episodio.SINOPSIS}</p>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Reproductor */}
      <div className="max-w-4xl mx-auto px-6 py-8">
        <MediaPlayer
          url={episodio.URL_ARCHIVO}
          tipo="SERIE"
          onProgress={(prog) => {
            if (reproId) {
              api.put(`/reproducciones/${reproId}`, { 
                porcentaje_avance: Math.round(prog) 
              }).catch(err => console.error('Error actualizando progreso:', err));
            }
          }}
          onStart={async () => {
            if (!perfil) return;
            try {
              const { data } = await api.post('/reproducciones', {
                id_perfil: perfil.ID_PERFIL,
                id_contenido: idContenido,
                id_episodio: idEpisodio,
                dispositivo: 'COMPUTADOR'
              });
              const idr = Array.isArray(data.id_reproduccion) ? data.id_reproduccion[0] : data.id_reproduccion;
              setReproId(idr);
            } catch (err) {
              console.error('Error iniciando reproducción:', err);
            }
          }}
          onEnd={async () => {
            if (reproId) {
              try {
                await api.put(`/reproducciones/${reproId}`, { 
                  porcentaje_avance: 100, 
                  finalizar: true 
                });
                setPorcentajeAvance(100);
              } catch (err) {
                console.error('Error finalizando reproducción:', err);
              }
            }
          }}
        />

        {/* Información adicional */}
        {porcentajeAvance > 0 && (
          <div className="mt-4 bg-gray-800 rounded-lg p-4">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm text-gray-400">Tu progreso</span>
              <span className="text-sm font-semibold text-brand">{Math.round(porcentajeAvance)}%</span>
            </div>
            <div className="w-full h-2 bg-gray-700 rounded-full overflow-hidden">
              <div 
                className="h-full bg-brand transition-all"
                style={{ width: `${porcentajeAvance}%` }}
              />
            </div>
          </div>
        )}

        {/* Navegación entre episodios */}
        <div className="mt-6 flex gap-3">
          <button
            onClick={() => {
              const prevEp = episodio.NUMERO - 1;
              if (prevEp >= 1) {
                // Necesitaríamos cargar todos los episodios para saber el ID
                navigate(`/contenido/${idContenido}`);
              }
            }}
            disabled={episodio.NUMERO === 1}
            className="flex-1 bg-gray-800 hover:bg-gray-700 disabled:opacity-50 disabled:cursor-not-allowed px-4 py-3 rounded-lg transition"
          >
            ← Episodio Anterior
          </button>
          <button
            onClick={() => navigate(`/contenido/${idContenido}`)}
            className="flex-1 bg-gray-800 hover:bg-gray-700 px-4 py-3 rounded-lg transition"
          >
            Ver Todos los Episodios
          </button>
          <button
            onClick={() => {
              // Siguiente episodio
              navigate(`/contenido/${idContenido}`);
            }}
            className="flex-1 bg-gray-800 hover:bg-gray-700 px-4 py-3 rounded-lg transition"
          >
            Episodio Siguiente →
          </button>
        </div>
      </div>
    </div>
  );
}
