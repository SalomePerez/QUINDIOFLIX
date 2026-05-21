import { useState, useEffect } from 'react';
import { Plus, Edit2, Trash2, ChevronRight, Film, Tv } from 'lucide-react';
import api from '../api/axios';
import FileUploader from '../components/FileUploader';

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
  const [uploadingEpisodeId, setUploadingEpisodeId] = useState(null);
  const [view, setView] = useState('list'); // list, form, edit, temporadas, episodios, relacionados
  const [form, setForm] = useState({
    titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
    duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
    es_original: 'N', id_categoria: '', id_empleado_resp: '', generos: []
  });
  const [editingId, setEditingId] = useState(null);
  const [relacionadosForm, setRelacionadosForm] = useState({
    id_contenido_destino: '', tipo_relacion: 'SECUELA', descripcion: ''
  });
  const [relacionados, setRelacionados] = useState([]);
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
    
    // Validar que se haya seleccionado al menos un género
    if (form.generos.length === 0) {
      return setMsg('Debes seleccionar al menos un género.');
    }
    
    try {
      // Encontrar la categoría que coincide con el tipo
      const categoria = categorias.find(c => c.NOMBRE === form.tipo);
      if (!categoria) {
        return setMsg('Error: No se encontró la categoría para el tipo seleccionado.');
      }

      // Crear el contenido
      const { data } = await api.post('/admin/contenido', {
        titulo: form.titulo,
        tipo: form.tipo,
        anio_lanzamiento: form.anio_lanzamiento,
        duracion_min: form.duracion_min,
        sinopsis: form.sinopsis,
        clasificacion_edad: form.clasificacion_edad,
        es_original: form.es_original,
        id_categoria: categoria.ID_CATEGORIA,
        id_empleado_resp: form.id_empleado_resp || null
      });

      // Asignar géneros al contenido
      if (form.generos.length > 0) {
        await Promise.all(
          form.generos.map(id_genero =>
            api.post(`/admin/contenido/${data.id_contenido}/generos`, { id_genero })
          )
        );
      }

      setMsg('Contenido creado exitosamente con ' + form.generos.length + ' género(s). Sube ahora el archivo multimedia.');
      setEditingId(data.id_contenido);
      setView('edit');
      loadData();
    } catch (err) {
      console.error('Error completo:', err);
      setMsg(err.response?.data?.error || 'Error al crear contenido: ' + err.message);
    }
  }

  async function handleDelete(id) {
    if (!confirm('¿Estás seguro de eliminar este contenido? Se eliminarán también sus temporadas, episodios y todas las relaciones.')) return;
    try {
      await api.delete(`/admin/contenido/${id}`);
      setMsg('Contenido eliminado exitosamente.');
      loadData();
    } catch (err) {
      console.error('Error al eliminar:', err);
      alert(err.response?.data?.error || 'Error al eliminar: ' + err.message);
    }
  }

  async function handleEdit(contenido) {
    try {
      // Cargar datos completos del contenido incluyendo géneros
      const { data } = await api.get(`/admin/contenido/${contenido.ID_CONTENIDO}`);
      
      setForm({
        titulo: data.TITULO,
        tipo: data.TIPO,
        anio_lanzamiento: data.ANIO_LANZAMIENTO,
        duracion_min: data.DURACION_MIN,
        sinopsis: data.SINOPSIS || '',
        clasificacion_edad: data.CLASIFICACION_EDAD,
        es_original: data.ES_ORIGINAL,
        id_categoria: data.ID_CATEGORIA,
        id_empleado_resp: data.ID_EMPLEADO_RESP || '',
        generos: data.generos || [],
        url_archivo: data.URL_ARCHIVO || null
      });
      
      setEditingId(contenido.ID_CONTENIDO);
      setView('edit');
    } catch (err) {
      alert('Error al cargar contenido para editar: ' + err.message);
    }
  }

  async function handleUpdate(e) {
    e.preventDefault();
    setMsg('');
    
    if (form.generos.length === 0) {
      return setMsg('Debes seleccionar al menos un género.');
    }
    
    try {
      const categoria = categorias.find(c => c.NOMBRE === form.tipo);
      if (!categoria) {
        return setMsg('Error: No se encontró la categoría para el tipo seleccionado.');
      }

      await api.put(`/admin/contenido/${editingId}`, {
        titulo: form.titulo,
        tipo: form.tipo,
        anio_lanzamiento: form.anio_lanzamiento,
        duracion_min: form.duracion_min,
        sinopsis: form.sinopsis,
        clasificacion_edad: form.clasificacion_edad,
        es_original: form.es_original,
        id_categoria: categoria.ID_CATEGORIA,
        id_empleado_resp: form.id_empleado_resp || null,
        generos: form.generos
      });

      setMsg('Contenido actualizado exitosamente.');
      setForm({
        titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
        duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
        es_original: 'N', id_categoria: '', id_empleado_resp: '', generos: []
      });
      setEditingId(null);
      loadData();
      setTimeout(() => setView('list'), 2000);
    } catch (err) {
      console.error('Error completo:', err);
      setMsg(err.response?.data?.error || 'Error al actualizar contenido: ' + err.message);
    }
  }

  async function loadRelacionados(contenido) {
    setSelectedContent(contenido);
    try {
      const { data } = await api.get(`/admin/contenido/${contenido.ID_CONTENIDO}/relacionados`);
      setRelacionados(data);
      setView('relacionados');
    } catch (err) {
      alert('Error al cargar contenido relacionado.');
    }
  }

  async function handleCreateRelacionado(e) {
    e.preventDefault();
    try {
      await api.post(`/admin/contenido/${selectedContent.ID_CONTENIDO}/relacionados`, relacionadosForm);
      setRelacionadosForm({ id_contenido_destino: '', tipo_relacion: 'SECUELA', descripcion: '' });
      loadRelacionados(selectedContent);
    } catch (err) {
      alert(err.response?.data?.error || 'Error al crear relación.');
    }
  }

  async function handleDeleteRelacionado(id_destino) {
    if (!confirm('¿Eliminar esta relación?')) return;
    try {
      await api.delete(`/admin/contenido/${selectedContent.ID_CONTENIDO}/relacionados/${id_destino}`);
      loadRelacionados(selectedContent);
    } catch (err) {
      alert('Error al eliminar relación.');
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
                      onClick={() => loadRelacionados(c)}
                      className="text-xs bg-purple-600 hover:bg-purple-700 px-3 py-1 rounded transition"
                      title="Contenido relacionado"
                    >
                      <ChevronRight size={14} />
                    </button>
                    <button
                      onClick={() => handleEdit(c)}
                      className="text-blue-400 hover:text-blue-300 p-1 transition"
                      title="Editar"
                    >
                      <Edit2 size={16} />
                    </button>
                    <button
                      onClick={() => handleDelete(c.ID_CONTENIDO)}
                      className="text-red-400 hover:text-red-300 p-1 transition"
                      title="Eliminar"
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
            <p className="text-sm text-gray-400 mb-4">
              Después de crear el contenido, podrás subir el archivo de video o audio para que los usuarios puedan reproducirlo.
              Para películas, series y documentales sube un video; para música y podcasts sube un audio.
            </p>
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


  // Vista de formulario de edición de contenido
  if (view === 'edit') {
    return (
      <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
        <div className="max-w-3xl mx-auto">
          <button
            onClick={() => {
              setView('list');
              setEditingId(null);
              setForm({
                titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
                duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
                es_original: 'N', id_categoria: '', id_empleado_resp: '', generos: []
              });
            }}
            className="text-gray-400 hover:text-white mb-6 flex items-center gap-2"
          >
            ← Volver al catálogo
          </button>

          <div className="bg-gray-800 rounded-xl p-6">
            <h2 className="text-2xl font-bold mb-6">Editar Contenido</h2>
            <form onSubmit={handleUpdate} className="space-y-4">
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
                <button type="button" onClick={() => {
                  setView('list');
                  setEditingId(null);
                  setForm({
                    titulo: '', tipo: 'PELICULA', anio_lanzamiento: new Date().getFullYear(),
                    duracion_min: '', sinopsis: '', clasificacion_edad: 'TP',
                    es_original: 'N', id_categoria: '', id_empleado_resp: '', generos: []
                  });
                }}
                  className="flex-1 bg-gray-700 hover:bg-gray-600 text-white font-semibold py-2.5 rounded-lg transition">
                  Cancelar
                </button>
                <button type="submit"
                  className="flex-1 bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition">
                  Actualizar Contenido
                </button>
              </div>
            </form>
          </div>

          {/* Sección de carga de archivo */}
          {editingId && (
            <div className="mt-6">
              <div className="mb-4 rounded-xl border border-gray-700 bg-gray-900 p-4 text-sm text-gray-300">
                Sube aquí el archivo multimedia para este contenido. Si es una película, serie o documental, carga un video; si es música o podcast, carga un audio.
              </div>
              <FileUploader
                contenidoId={editingId}
                currentUrl={form.url_archivo}
                tipo={form.tipo}
                onSuccess={(newUrl) => {
                  setForm(f => ({ ...f, url_archivo: newUrl }));
                  setMsg('Archivo actualizado exitosamente');
                }}
              />
            </div>
          )}
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

  // Vista de gestión de contenido relacionado
  if (view === 'relacionados') {
    const TIPOS_RELACION = [
      { value: 'SECUELA', label: 'Secuela' },
      { value: 'PRECUELA', label: 'Precuela' },
      { value: 'REMAKE', label: 'Remake' },
      { value: 'SPIN_OFF', label: 'Spin-off' },
      { value: 'VERSION_EXTENDIDA', label: 'Versión Extendida' },
      { value: 'ADAPTACION', label: 'Adaptación' },
      { value: 'OTRO', label: 'Otro' }
    ];

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
            {/* Formulario para agregar relación */}
            <div className="bg-gray-800 rounded-xl p-6">
              <h2 className="text-lg font-semibold mb-4">Agregar Contenido Relacionado</h2>
              <form onSubmit={handleCreateRelacionado} className="space-y-4">
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Contenido Relacionado *</label>
                  <select
                    value={relacionadosForm.id_contenido_destino}
                    onChange={e => setRelacionadosForm(f => ({ ...f, id_contenido_destino: e.target.value }))}
                    required
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                  >
                    <option value="">Seleccionar contenido...</option>
                    {contenido
                      .filter(c => c.ID_CONTENIDO !== selectedContent.ID_CONTENIDO)
                      .map(c => (
                        <option key={c.ID_CONTENIDO} value={c.ID_CONTENIDO}>
                          {c.TITULO} ({c.TIPO}, {c.ANIO_LANZAMIENTO})
                        </option>
                      ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Tipo de Relación *</label>
                  <select
                    value={relacionadosForm.tipo_relacion}
                    onChange={e => setRelacionadosForm(f => ({ ...f, tipo_relacion: e.target.value }))}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none"
                  >
                    {TIPOS_RELACION.map(t => (
                      <option key={t.value} value={t.value}>{t.label}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Descripción</label>
                  <textarea
                    value={relacionadosForm.descripcion}
                    onChange={e => setRelacionadosForm(f => ({ ...f, descripcion: e.target.value }))}
                    rows={3}
                    placeholder="Descripción opcional de la relación..."
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none resize-none"
                  />
                </div>
                <button
                  type="submit"
                  className="w-full bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg transition"
                >
                  Agregar Relación
                </button>
              </form>
            </div>

            {/* Lista de contenido relacionado */}
            <div className="bg-gray-800 rounded-xl p-6">
              <h2 className="text-lg font-semibold mb-4">Contenido Relacionado ({relacionados.length})</h2>
              <div className="space-y-2">
                {relacionados.map(r => (
                  <div key={r.ID_CONTENIDO_DESTINO} className="bg-gray-700 rounded-lg px-4 py-3">
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <span className="text-xs bg-purple-600 px-2 py-0.5 rounded font-semibold">
                            {r.TIPO_RELACION.replace('_', ' ')}
                          </span>
                          <span className="text-xs text-gray-400">{r.TIPO_RELACIONADO}</span>
                        </div>
                        <p className="font-medium">{r.TITULO}</p>
                        <p className="text-xs text-gray-400 mt-1">{r.ANIO_LANZAMIENTO} · {r.CLASIFICACION_EDAD}</p>
                        {r.DESCRIPCION && (
                          <p className="text-xs text-gray-400 mt-2">{r.DESCRIPCION}</p>
                        )}
                      </div>
                      <button
                        onClick={() => handleDeleteRelacionado(r.ID_CONTENIDO_DESTINO)}
                        className="text-red-400 hover:text-red-300 p-1 ml-2"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </div>
                ))}
                {relacionados.length === 0 && (
                  <p className="text-center text-gray-500 py-8">No hay contenido relacionado aún</p>
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
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex-1">
                        <p className="font-medium">
                          {ep.NUMERO}. {ep.TITULO}
                        </p>
                        <p className="text-xs text-gray-400 mt-1">{ep.DURACION_MIN} min</p>
                        {ep.SINOPSIS && (
                          <p className="text-xs text-gray-400 mt-2">{ep.SINOPSIS}</p>
                        )}
                        {ep.URL_ARCHIVO && (
                          <p className="text-xs text-green-400 mt-2 break-all">Archivo: {ep.URL_ARCHIVO}</p>
                        )}
                      </div>
                      <div className="flex flex-col items-end gap-2">
                        <button
                          onClick={() => setUploadingEpisodeId(ep.ID_EPISODIO === uploadingEpisodeId ? null : ep.ID_EPISODIO)}
                          className="bg-blue-600 hover:bg-blue-700 text-white rounded-lg px-3 py-2 text-xs transition"
                        >
                          {ep.ID_EPISODIO === uploadingEpisodeId ? 'Cancelar' : ep.URL_ARCHIVO ? 'Reemplazar archivo' : 'Subir archivo'}
                        </button>
                        <button
                          onClick={() => handleDeleteEpisodio(ep.ID_EPISODIO)}
                          className="text-red-400 hover:text-red-300 p-1"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    </div>
                    {uploadingEpisodeId === ep.ID_EPISODIO && (
                      <div className="mt-4">
                        <FileUploader
                          episodioId={ep.ID_EPISODIO}
                          currentUrl={ep.URL_ARCHIVO || null}
                          tipo={selectedContent?.TIPO || 'SERIE'}
                          onSuccess={async () => {
                            setUploadingEpisodeId(null);
                            await loadEpisodios(selectedTemporada);
                            setMsg('Archivo del episodio subido correctamente.');
                          }}
                        />
                      </div>
                    )}
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
