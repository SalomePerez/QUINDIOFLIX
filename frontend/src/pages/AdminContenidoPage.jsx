import { useState, useEffect } from 'react';
import { Plus, Edit2, Trash2, ChevronRight, Film, Tv } from 'lucide-react';
import api from '../api/axios';

export default function AdminContenidoPage() {
  const [contenido, setContenido] = useState([]);
  const [categorias,setCategorias]= useState([]);
  const [generos, setGeneros] = useState([]);
  const [empleados, setEmpleados] = useState([]);
  const [loading,   setLoading]   = useState(true);
  const [selectedContent, setSelectedContent] = useState(null);
  const [temporadas, setTemporadas] = useState([]);
  const [selectedTemporada, setSelectedTemporada] = useState(null);
  const [episodios, setEpisodios] = useState([]);
  const [view, setView] = useState('list'); // list, form, temporadas, episodios
  const [form, setForm] = useState({
    titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
    duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
    es_original: 'N', id_categoria: '', id_empleado_resp: '', generos: []
  });
  const [temporadaForm, setTemporadaForm] = useState({
    numero: '', titulo: '', anio: new Date().getFullYear(), descripcion: ''
  });
  const [episodioForm, setEpisodioForm] = useState({
    numero: '', titulo: '', duracion_min: '', sinopsis: '', fecha_estreno: ''
  });
  const [msg, setMsg] = useState('');

  useEffect(() => {
    loadData();
  }, []);

  async function loadData() {
    try {
      const [cRes, catRes, genRes, empRes] = await Promise.all([
        api.get('/contenido?limit=200'),
        api.get('/contenido/categorias/lista'),
        api.get('/contenido/generos/lista'),
        api.get('/admin/empleados')
      ]);
      setContenido(cRes.data);
      setCategorias(catRes.data);
      setGeneros(genRes.data);
      setEmpleados(empRes.data);
    } catch (err) {
      console.error('Error cargando datos:', err);
    } finally {
      setLoading(false);
    }
  }

  function handleChange(e) {
    setForm(f => ({ ...f, [e.target.name]: e.target.value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setMsg('');
    try {
      // Encontrar la categoría que coincide con el tipo
      const categoria = categorias.find(c => c.NOMBRE === form.tipo);
      if (!categoria) {
        return setMsg('Error: No se encontró la categoría para el tipo seleccionado.');
      }

      // Crear el contenido
      const { data } = await api.post('/admin/contenido', {
        ...form,
        id_categoria: categoria.ID_CATEGORIA
      });

      // Asignar géneros al contenido
      if (form.generos.length > 0) {
        await Promise.all(
          form.generos.map(id_genero =>
            api.post(`/admin/contenido/${data.id_contenido}/generos`, { id_genero })
          )
        );
      }

      setMsg('Contenido creado exitosamente.');
      setForm({
        titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
        duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
        es_original: 'N', id_categoria: '', id_empleado_resp: '', generos: []
      });
      loadData();
      setTimeout(() => setView('list'), 1500);
    } catch (err) {
      setMsg(err.response?.data?.error || 'Error al crear contenido.');
    }
  }

  async function handleDelete(id) {
    if (!confirm('¿Estás seguro de eliminar este contenido?')) return;
    try {
      await api.delete(`/admin/contenido/${id}`);
      loadData();
    } catch (err) {
      alert(err.response?.data?.error || 'Error al eliminar.');
    }
  }

  async function loadTemporadas(contenido) {
    setSelectedContent(contenido);
    try {
      const { data } = await api.get(`/admin/contenido/${contenido.ID_CONTENIDO}/temporadas`);
      setTemporadas(data);
      setView('temporadas');
    } catch (err) {
      alert('Error al cargar temporadas.');
    }
  }

  async function handleCreateTemporada(e) {
    e.preventDefault();
    try {
      await api.post(`/admin/contenido/${selectedContent.ID_CONTENIDO}/temporadas`, temporadaForm);
      setTemporadaForm({ numero: '', titulo: '', anio: new Date().getFullYear(), descripcion: '' });
      loadTemporadas(selectedContent);
    } catch (err) {
      alert(err.response?.data?.error || 'Error al crear temporada.');
    }
  }

  async function handleDeleteTemporada(id) {
    if (!confirm('¿Eliminar esta temporada y todos sus episodios?')) return;
    try {
      await api.delete(`/admin/temporadas/${id}`);
      loadTemporadas(selectedContent);
    } catch (err) {
      alert('Error al eliminar temporada.');
    }
  }

  async function loadEpisodios(temporada) {
    setSelectedTemporada(temporada);
    try {
      const { data } = await api.get(`/admin/temporadas/${temporada.ID_TEMPORADA}/episodios`);
      setEpisodios(data);
      setView('episodios');
    } catch (err) {
      alert('Error al cargar episodios.');
    }
  }

  async function handleCreateEpisodio(e) {
    e.preventDefault();
    try {
      await api.post(`/admin/temporadas/${selectedTemporada.ID_TEMPORADA}/episodios`, episodioForm);
      setEpisodioForm({ numero: '', titulo: '', duracion_min: '', sinopsis: '', fecha_estreno: '' });
      loadEpisodios(selectedTemporada);
    } catch (err) {
      alert(err.response?.data?.error || 'Error al crear episodio.');
    }
  }

  async function handleDeleteEpisodio(id) {
    if (!confirm('¿Eliminar este episodio?')) return;
    try {
      await api.delete(`/admin/episodios/${id}`);
      loadEpisodios(selectedTemporada);
    } catch (err) {
      alert('Error al eliminar episodio.');
    }
  }

  const TIPOS = ['PELICULA','SERIE','DOCUMENTAL','MUSICA','PODCAST'];
  const CLASES = ['TP','+7','+13','+16','+18'];

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-950 flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  // Vista de lista de contenido
  if (view === 'list') {
    return (
      <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
        <div className="max-w-7xl mx-auto">
          <div className="flex items-center justify-between mb-8">
            <h1 className="text-3xl font-bold">Gestión de Catálogo</h1>
            <button
              onClick={() => setView('form')}
              className="bg-brand hover:bg-brand-dark px-4 py-2 rounded-lg flex items-center gap-2 transition"
            >
              <Plus size={20} />
              Agregar Contenido
            </button>
          </div>

          <div className="bg-gray-800 rounded-xl p-6">
            <h2 className="text-lg font-semibold mb-4">Catálogo ({contenido.length})</h2>
            <div className="space-y-2">
              {contenido.map(c => (
                <div key={c.ID_CONTENIDO} className="flex items-center justify-between bg-gray-700 rounded-lg px-4 py-3 hover:bg-gray-600 transition">
                  <div className="flex items-center gap-3 min-w-0 flex-1">
                    {c.TIPO === 'SERIE' || c.TIPO === 'PODCAST' ? (
                      <Tv size={20} className="text-brand flex-shrink-0" />
                    ) : (
                      <Film size={20} className="text-gray-400 flex-shrink-0" />
                    )}
                    <div className="min-w-0 flex-1">
                      <p className="text-sm font-medium text-white truncate">{c.TITULO}</p>
                      <p className="text-xs text-gray-400">{c.CATEGORIA} · {c.TIPO} · {c.ANIO_LANZAMIENTO}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2 flex-shrink-0">
                    <span className="text-xs bg-gray-600 px-2 py-1 rounded">{c.CLASIFICACION_EDAD}</span>
                    {c.ES_ORIGINAL === 'S' && (
                      <span className="text-xs bg-brand px-2 py-1 rounded font-semibold">ORIGINAL</span>
                    )}
                    {(c.TIPO === 'SERIE' || c.TIPO === 'PODCAST') && (
                      <button
                        onClick={() => loadTemporadas(c)}
                        className="text-xs bg-blue-600 hover:bg-blue-700 px-3 py-1 rounded transition flex items-center gap-1"
                      >
                        <Tv size={14} />
                        Temporadas
                      </button>
                    )}
                    <button
                      onClick={() => handleDelete(c.ID_CONTENIDO)}
                      className="text-red-400 hover:text-red-300 p-1 transition"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Vista de formulario de nuevo contenido
  if (view === 'form') {
    return (
      <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
        <div className="max-w-3xl mx-auto">
          <button
            onClick={() => setView('list')}
            className="text-gray-400 hover:text-white mb-6 flex items-center gap-2"
          >
            ← Volver al catálogo
          </button>

          <div className="bg-gray-800 rounded-xl p-6">
            <h2 className="text-2xl font-bold mb-6">Agregar Nuevo Contenido</h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm text-gray-400 mb-1">Título *</label>
                <input name="titulo" value={form.titulo} onChange={handleChange} required
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand" />
              </div>
              
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Tipo *</label>
                  <select name="tipo" value={form.tipo} onChange={handleChange}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none">
                    {TIPOS.map(t => <option key={t}>{t}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Clasificación *</label>
                  <select name="clasificacion_edad" value={form.clasificacion_edad} onChange={handleChange}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none">
                    {CLASES.map(c => <option key={c}>{c}</option>)}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Año *</label>
                  <input name="anio_lanzamiento" type="number" value={form.anio_lanzamiento} onChange={handleChange}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none" />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Duración (min) *</label>
                  <input name="duracion_min" type="number" value={form.duracion_min} onChange={handleChange} required
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none" />
                </div>
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-2">Géneros * (selecciona uno o más)</label>
                <div className="grid grid-cols-3 gap-2 max-h-40 overflow-y-auto bg-gray-700 border border-gray-600 rounded-lg p-3">
                  {generos.map(g => (
                    <label key={g.ID_GENERO} className="flex items-center gap-2 text-sm cursor-pointer hover:text-brand transition">
                      <input
                        type="checkbox"
                        checked={form.generos.includes(g.ID_GENERO)}
                        onChange={(e) => {
                          if (e.target.checked) {
                            setForm(f => ({ ...f, generos: [...f.generos, g.ID_GENERO] }));
                          } else {
                            setForm(f => ({ ...f, generos: f.generos.filter(id => id !== g.ID_GENERO) }));
                          }
                        }}
                        className="w-4 h-4 accent-brand"
                      />
                      <span>{g.NOMBRE}</span>
                    </label>
                  ))}
                </div>
                {form.generos.length === 0 && (
                  <p className="text-xs text-yellow-400 mt-1">Selecciona al menos un género</p>
                )}
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-1">Empleado Responsable (opcional)</label>
                <select name="id_empleado_resp" value={form.id_empleado_resp} onChange={handleChange}
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none">
                  <option value="">Sin asignar</option>
                  {empleados.map(e => (
                    <option key={e.ID_EMPLEADO} value={e.ID_EMPLEADO}>
                      {e.NOMBRE} {e.APELLIDO} - {e.CARGO}
                    </option>
                  ))}
                </select>
                {empleados.length === 0 && (
                  <p className="text-xs text-yellow-400 mt-1">No se pudieron cargar los empleados</p>
                )}
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-1">Sinopsis</label>
                <textarea name="sinopsis" value={form.sinopsis} onChange={handleChange} rows={4}
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none resize-none" />
              </div>

              <div className="flex items-center gap-3">
                <input type="checkbox" id="original" checked={form.es_original === 'S'}
                  onChange={e => setForm(f => ({ ...f, es_original: e.target.checked ? 'S' : 'N' }))}
                  className="w-4 h-4 accent-brand" />
                <label htmlFor="original" className="text-sm text-gray-300">Producción original QuindioFlix</label>
              </div>

              {msg && <p className={`text-sm ${msg.includes('Error') ? 'text-red-400' : 'text-green-400'}`}>{msg}</p>}

              <div className="flex gap-3">
                <button type="button" onClick={() => setView('list')}
                  className="flex-1 bg-gray-700 hover:bg-gray-600 text-white font-semibold py-2.5 rounded-lg transition">
                  Cancelar
                </button>
                <button type="submit"
                  className="flex-1 bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition">
                  Crear Contenido
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }


  // Vista de gestión de temporadas
  if (view === 'temporadas') {
    return (
      <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
        <div className="max-w-5xl mx-auto">
          <button
            onClick={() => setView('list')}
            className="text-gray-400 hover:text-white mb-6 flex items-center gap-2"
          >
            ← Volver al catálogo
          </button>

          <div className="mb-6">
            <h1 className="text-3xl font-bold">{selectedContent.TITULO}</h1>
            <p className="text-gray-400">{selectedContent.TIPO} · {selectedContent.ANIO_LANZAMIENTO}</p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Formulario de nueva temporada */}
            <div className="bg-gray-800 rounded-xl p-6">
              <h2 className="text-lg font-semibold mb-4">Agregar Temporada</h2>
              <form onSubmit={handleCreateTemporada} className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm text-gray-400 mb-1">Número *</label>
                    <input
                      type="number"
                      value={temporadaForm.numero}
                      onChange={e => setTemporadaForm(f => ({ ...f, numero: e.target.value }))}
                      required
                      className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-sm text-gray-400 mb-1">Año</label>
                    <input
                      type="number"
                      value={temporadaForm.anio}
                      onChange={e => setTemporadaForm(f => ({ ...f, anio: e.target.value }))}
                      className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                    />
                  </div>
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Título</label>
                  <input
                    value={temporadaForm.titulo}
                    onChange={e => setTemporadaForm(f => ({ ...f, titulo: e.target.value }))}
                    placeholder="Ej: Temporada 1"
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Descripción</label>
                  <textarea
                    value={temporadaForm.descripcion}
                    onChange={e => setTemporadaForm(f => ({ ...f, descripcion: e.target.value }))}
                    rows={3}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none resize-none"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition"
                >
                  Crear Temporada
                </button>
              </form>
            </div>

            {/* Lista de temporadas */}
            <div className="bg-gray-800 rounded-xl p-6">
              <h2 className="text-lg font-semibold mb-4">Temporadas ({temporadas.length})</h2>
              <div className="space-y-2">
                {temporadas.map(t => (
                  <div key={t.ID_TEMPORADA} className="bg-gray-700 rounded-lg px-4 py-3">
                    <div className="flex items-center justify-between mb-2">
                      <div>
                        <p className="font-medium">{t.TITULO || `Temporada ${t.NUMERO}`}</p>
                        <p className="text-xs text-gray-400">{t.NUM_EPISODIOS} episodios · {t.ANIO}</p>
                      </div>
                      <div className="flex gap-2">
                        <button
                          onClick={() => loadEpisodios(t)}
                          className="text-xs bg-blue-600 hover:bg-blue-700 px-3 py-1 rounded transition"
                        >
                          Episodios
                        </button>
                        <button
                          onClick={() => handleDeleteTemporada(t.ID_TEMPORADA)}
                          className="text-red-400 hover:text-red-300 p-1"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                    {t.DESCRIPCION && (
                      <p className="text-xs text-gray-400 mt-2">{t.DESCRIPCION}</p>
                    )}
                  </div>
                ))}
                {temporadas.length === 0 && (
                  <p className="text-center text-gray-500 py-8">No hay temporadas aún</p>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Vista de gestión de episodios
  if (view === 'episodios') {
    return (
      <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
        <div className="max-w-5xl mx-auto">
          <button
            onClick={() => setView('temporadas')}
            className="text-gray-400 hover:text-white mb-6 flex items-center gap-2"
          >
            ← Volver a temporadas
          </button>

          <div className="mb-6">
            <h1 className="text-3xl font-bold">{selectedContent.TITULO}</h1>
            <p className="text-gray-400">
              {selectedTemporada.TITULO || `Temporada ${selectedTemporada.NUMERO}`}
            </p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Formulario de nuevo episodio */}
            <div className="bg-gray-800 rounded-xl p-6">
              <h2 className="text-lg font-semibold mb-4">Agregar Episodio</h2>
              <form onSubmit={handleCreateEpisodio} className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm text-gray-400 mb-1">Número *</label>
                    <input
                      type="number"
                      value={episodioForm.numero}
                      onChange={e => setEpisodioForm(f => ({ ...f, numero: e.target.value }))}
                      required
                      className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                    />
                  </div>
                  <div>
                    <label className="block text-sm text-gray-400 mb-1">Duración (min) *</label>
                    <input
                      type="number"
                      value={episodioForm.duracion_min}
                      onChange={e => setEpisodioForm(f => ({ ...f, duracion_min: e.target.value }))}
                      required
                      className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                    />
                  </div>
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Título *</label>
                  <input
                    value={episodioForm.titulo}
                    onChange={e => setEpisodioForm(f => ({ ...f, titulo: e.target.value }))}
                    required
                    placeholder="Ej: El Primer Caso"
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Fecha de Estreno</label>
                  <input
                    type="date"
                    value={episodioForm.fecha_estreno}
                    onChange={e => setEpisodioForm(f => ({ ...f, fecha_estreno: e.target.value }))}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                  />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Sinopsis</label>
                  <textarea
                    value={episodioForm.sinopsis}
                    onChange={e => setEpisodioForm(f => ({ ...f, sinopsis: e.target.value }))}
                    rows={3}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none resize-none"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition"
                >
                  Crear Episodio
                </button>
              </form>
            </div>

            {/* Lista de episodios */}
            <div className="bg-gray-800 rounded-xl p-6">
              <h2 className="text-lg font-semibold mb-4">Episodios ({episodios.length})</h2>
              <div className="space-y-2 max-h-[600px] overflow-y-auto">
                {episodios.map(ep => (
                  <div key={ep.ID_EPISODIO} className="bg-gray-700 rounded-lg px-4 py-3">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <p className="font-medium">
                          {ep.NUMERO}. {ep.TITULO}
                        </p>
                        <p className="text-xs text-gray-400 mt-1">{ep.DURACION_MIN} min</p>
                        {ep.SINOPSIS && (
                          <p className="text-xs text-gray-400 mt-2">{ep.SINOPSIS}</p>
                        )}
                      </div>
                      <button
                        onClick={() => handleDeleteEpisodio(ep.ID_EPISODIO)}
                        className="text-red-400 hover:text-red-300 p-1 ml-2"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </div>
                ))}
                {episodios.length === 0 && (
                  <p className="text-center text-gray-500 py-8">No hay episodios aún</p>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return null;
}
