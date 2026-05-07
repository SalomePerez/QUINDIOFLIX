import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/axios';
import ContentCard from '../components/ContentCard';
import { useAuth } from '../context/AuthContext';

const TIPOS = ['', 'PELICULA', 'SERIE', 'DOCUMENTAL', 'MUSICA', 'PODCAST'];

export default function HomePage() {
  const { perfil } = useAuth();
  const navigate   = useNavigate();
  const [contenido,   setContenido]   = useState([]);
  const [categorias,  setCategorias]  = useState([]);
  const [generos,     setGeneros]     = useState([]);
  const [loading,     setLoading]     = useState(true);
  const [busqueda,    setBusqueda]    = useState('');
  const [filtroTipo,  setFiltroTipo]  = useState('');
  const [filtroGen,   setFiltroGen]   = useState('');
  const [recomendado, setRecomendado] = useState('');

  useEffect(() => {
    Promise.all([
      api.get('/contenido/categorias/lista'),
      api.get('/contenido/generos/lista'),
    ]).then(([catRes, genRes]) => {
      setCategorias(catRes.data);
      setGeneros(genRes.data);
    });
  }, []);

  useEffect(() => {
    if (perfil) {
      api.get(`/usuarios/${perfil.ID_USUARIO || 1}/recomendacion/${perfil.ID_PERFIL}`)
        .then(r => setRecomendado(r.data.recomendado))
        .catch(() => {});
    }
  }, [perfil]);

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams();
    if (busqueda)   params.set('busqueda', busqueda);
    if (filtroTipo) params.set('tipo', filtroTipo);
    if (filtroGen)  params.set('genero', filtroGen);
    params.set('limit', '40');

    api.get(`/contenido?${params}`)
      .then(r => setContenido(r.data))
      .catch(() => setContenido([]))
      .finally(() => setLoading(false));
  }, [busqueda, filtroTipo, filtroGen]);

  return (
    <div className="min-h-screen bg-gray-950 text-white">
      {/* Hero */}
      <div className="bg-gradient-to-b from-gray-900 to-gray-950 px-6 py-10">
        <h1 className="text-3xl font-bold mb-1">
          {perfil ? `Hola, ${perfil.NOMBRE} 👋` : 'Bienvenido a QuindioFlix'}
        </h1>
        {recomendado && (
          <p className="text-gray-400 text-sm mt-1">
            Recomendado para ti: <span className="text-brand font-medium">{recomendado}</span>
          </p>
        )}
      </div>

      {/* Filtros */}
      <div className="px-6 py-4 flex flex-wrap gap-3 bg-gray-900 border-b border-gray-800">
        <input
          type="text"
          placeholder="Buscar contenido..."
          value={busqueda}
          onChange={e => setBusqueda(e.target.value)}
          className="bg-gray-800 border border-gray-700 rounded-lg px-4 py-2 text-sm text-white
                     placeholder-gray-500 focus:outline-none focus:border-brand w-64"
        />
        <select value={filtroTipo} onChange={e => setFiltroTipo(e.target.value)}
          className="bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none">
          {TIPOS.map(t => <option key={t} value={t}>{t || 'Todos los tipos'}</option>)}
        </select>
        <select value={filtroGen} onChange={e => setFiltroGen(e.target.value)}
          className="bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-sm text-white focus:outline-none">
          <option value="">Todos los géneros</option>
          {generos.map(g => <option key={g.ID_GENERO} value={g.NOMBRE}>{g.NOMBRE}</option>)}
        </select>
        {(busqueda || filtroTipo || filtroGen) && (
          <button onClick={() => { setBusqueda(''); setFiltroTipo(''); setFiltroGen(''); }}
            className="text-sm text-gray-400 hover:text-white transition">
            ✕ Limpiar
          </button>
        )}
      </div>

      {/* Catálogo */}
      <div className="px-6 py-6">
        {loading ? (
          <div className="flex justify-center py-20">
            <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
          </div>
        ) : contenido.length === 0 ? (
          <p className="text-gray-500 text-center py-20">No se encontró contenido.</p>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {contenido.map(c => <ContentCard key={c.ID_CONTENIDO} contenido={c} />)}
          </div>
        )}
      </div>
    </div>
  );
}

