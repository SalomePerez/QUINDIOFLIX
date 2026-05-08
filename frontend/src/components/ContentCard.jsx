import { Link } from 'react-router-dom';
import { Film, Tv, FileVideo, Music, Mic, Crown, Star, Play } from 'lucide-react';

const BADGE_COLOR = {
  'TP':  'bg-green-700',
  '+7':  'bg-blue-700',
  '+13': 'bg-yellow-700',
  '+16': 'bg-orange-700',
  '+18': 'bg-red-700',
};

const iconMap = {
  PELICULA: Film,
  SERIE: Tv,
  DOCUMENTAL: FileVideo,
  MUSICA: Music,
  PODCAST: Mic
};

export default function ContentCard({ contenido }) {
  const { ID_CONTENIDO, TITULO, TIPO, CATEGORIA, CLASIFICACION_EDAD,
          CALIFICACION_PROMEDIO, TOTAL_REPRODUCCIONES, ES_ORIGINAL } = contenido;

  const Icon = iconMap[TIPO] || Film;

  return (
    <Link to={`/contenido/${ID_CONTENIDO}`} className="group block">
      <div className="bg-gray-800 rounded-lg overflow-hidden hover:ring-2 hover:ring-brand transition-all duration-200 hover:-translate-y-1">
        {/* Poster placeholder */}
        <div className="h-40 bg-gradient-to-br from-gray-700 to-gray-900 flex items-center justify-center relative">
          <Icon size={48} className="text-gray-400 group-hover:text-brand transition" strokeWidth={1.5} />
          {ES_ORIGINAL === 'S' && (
            <span className="absolute top-2 left-2 text-xs bg-brand px-2 py-0.5 rounded font-semibold flex items-center gap-1">
              <Crown size={12} />
              ORIGINAL
            </span>
          )}
          <span className={`absolute top-2 right-2 text-xs px-2 py-0.5 rounded font-bold ${BADGE_COLOR[CLASIFICACION_EDAD] || 'bg-gray-600'}`}>
            {CLASIFICACION_EDAD}
          </span>
        </div>

        <div className="p-3">
          <h3 className="font-semibold text-sm text-white truncate group-hover:text-brand transition">
            {TITULO}
          </h3>
          <p className="text-xs text-gray-400 mt-0.5">{CATEGORIA}</p>
          <div className="flex items-center justify-between mt-2 text-xs text-gray-500">
            <span className="flex items-center gap-1">
              <Star size={12} className="fill-yellow-400 text-yellow-400" />
              {CALIFICACION_PROMEDIO ?? '—'}
            </span>
            <span className="flex items-center gap-1">
              <Play size={12} />
              {TOTAL_REPRODUCCIONES ?? 0}
            </span>
          </div>
        </div>
      </div>
    </Link>
  );
}

