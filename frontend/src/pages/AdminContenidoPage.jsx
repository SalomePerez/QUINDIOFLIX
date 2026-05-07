import { useState, useEffect } from 'react';
import api from '../api/axios';

export default function AdminContenidoPage() {
  const [contenido, setContenido] = useState([]);
  const [categorias,setCategorias]= useState([]);
  const [empleados, setEmpleados] = useState([]);
  const [loading,   setLoading]   = useState(true);
  const [form, setForm] = useState({
    titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
    duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
    es_original: 'N', id_categoria: '', id_empleado_resp: ''
  });
  const [msg, setMsg] = useState('');

  useEffect(() => {
    Promise.all([
      api.get('/contenido?limit=100'),
      api.get('/contenido/categorias/lista'),
    ]).then(([cRes, catRes]) => {
      setContenido(cRes.data);
      setCategorias(catRes.data);
    }).finally(() => setLoading(false));
  }, []);

  function handleChange(e) {
    setForm(f => ({ ...f, [e.target.name]: e.target.value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setMsg('');
    try {
      // Inserción directa vía endpoint (en producción sería un endpoint POST /contenido)
      setMsg('✅ Funcionalidad de inserción disponible vía SQL directo en Oracle.');
    } catch (err) {
      setMsg('❌ ' + (err.response?.data?.error || 'Error.'));
    }
  }

  const TIPOS = ['PELICULA','SERIE','DOCUMENTAL','MUSICA','PODCAST'];
  const CLASES = ['TP','+7','+13','+16','+18'];

  return (
    <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
      <h1 className="text-3xl font-bold mb-8">Gestión de Catálogo</h1>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Formulario */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4">Agregar Contenido</h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm text-gray-400 mb-1">Título</label>
              <input name="titulo" value={form.titulo} onChange={handleChange} required
                className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand" />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm text-gray-400 mb-1">Tipo</label>
                <select name="tipo" value={form.tipo} onChange={handleChange}
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none">
                  {TIPOS.map(t => <option key={t}>{t}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm text-gray-400 mb-1">Clasificación</label>
                <select name="clasificacion_edad" value={form.clasificacion_edad} onChange={handleChange}
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none">
                  {CLASES.map(c => <option key={c}>{c}</option>)}
                </select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm text-gray-400 mb-1">Año</label>
                <input name="anio_lanzamiento" type="number" value={form.anio_lanzamiento} onChange={handleChange}
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none" />
              </div>
              <div>
                <label className="block text-sm text-gray-400 mb-1">Duración (min)</label>
                <input name="duracion_min" type="number" value={form.duracion_min} onChange={handleChange} required
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none" />
              </div>
            </div>
            <div>
              <label className="block text-sm text-gray-400 mb-1">Categoría</label>
              <select name="id_categoria" value={form.id_categoria} onChange={handleChange} required
                className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none">
                <option value="">Seleccionar...</option>
                {categorias.map(c => <option key={c.ID_CATEGORIA} value={c.ID_CATEGORIA}>{c.NOMBRE}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-sm text-gray-400 mb-1">Sinopsis</label>
              <textarea name="sinopsis" value={form.sinopsis} onChange={handleChange} rows={3}
                className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none resize-none" />
            </div>
            <div className="flex items-center gap-3">
              <input type="checkbox" id="original" checked={form.es_original === 'S'}
                onChange={e => setForm(f => ({ ...f, es_original: e.target.checked ? 'S' : 'N' }))}
                className="w-4 h-4 accent-brand" />
              <label htmlFor="original" className="text-sm text-gray-300">Producción original QuindioFlix</label>
            </div>
            {msg && <p className="text-sm text-green-400">{msg}</p>}
            <button type="submit"
              className="w-full bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition">
              Agregar al catálogo
            </button>
          </form>
        </div>

        {/* Lista de contenido */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4">Catálogo actual ({contenido.length})</h2>
          {loading ? (
            <div className="flex justify-center py-10">
              <div className="w-8 h-8 border-4 border-brand border-t-transparent rounded-full animate-spin" />
            </div>
          ) : (
            <div className="overflow-y-auto max-h-[500px] space-y-2">
              {contenido.map(c => (
                <div key={c.ID_CONTENIDO} className="flex items-center justify-between bg-gray-700 rounded-lg px-4 py-2.5">
                  <div className="min-w-0">
                    <p className="text-sm font-medium text-white truncate">{c.TITULO}</p>
                    <p className="text-xs text-gray-400">{c.CATEGORIA} · {c.TIPO} · {c.ANIO_LANZAMIENTO}</p>
                  </div>
                  <div className="flex items-center gap-2 flex-shrink-0 ml-3">
                    <span className="text-xs bg-gray-600 px-2 py-0.5 rounded">{c.CLASIFICACION_EDAD}</span>
                    {c.ES_ORIGINAL === 'S' && (
                      <span className="text-xs bg-brand px-2 py-0.5 rounded">ORIG</span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

