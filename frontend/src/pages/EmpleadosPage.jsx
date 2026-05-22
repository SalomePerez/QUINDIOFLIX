import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { Users, Building2, UserPlus, Edit2, Trash2, TrendingUp, DollarSign, Shield } from 'lucide-react';
import api from '../api/axios';

export default function EmpleadosPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [empleados, setEmpleados] = useState([]);
  const [departamentos, setDepartamentos] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [view, setView] = useState('list'); // list, create, edit, departamentos
  const [selectedDepartamento, setSelectedDepartamento] = useState('all');
  const [form, setForm] = useState({
    nombre: '', apellido: '', email: '', telefono: '', cargo: '',
    salario: '', id_departamento: '', id_supervisor: ''
  });
  const [editingId, setEditingId] = useState(null);
  const [msg, setMsg] = useState('');

  useEffect(() => {
    if (!user || user.ES_MODERADOR !== 'S') {
      navigate('/');
      return;
    }
    loadData();
  }, [user, navigate]);

  async function loadData() {
    try {
      const [empRes, depRes, statsRes] = await Promise.all([
        api.get('/empleados'),
        api.get('/empleados/departamentos'),
        api.get('/empleados/stats/general')
      ]);
      setEmpleados(empRes.data);
      setDepartamentos(depRes.data);
      setStats(statsRes.data);
    } catch (err) {
      console.error('Error cargando datos:', err);
      setMsg('Error al cargar datos');
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
      if (editingId) {
        await api.put(`/empleados/${editingId}`, form);
        setMsg('Empleado actualizado exitosamente');
      } else {
        await api.post('/empleados', form);
        setMsg('Empleado creado exitosamente');
      }

      setForm({
        nombre: '', apellido: '', email: '', telefono: '', cargo: '',
        salario: '', id_departamento: '', id_supervisor: ''
      });
      setEditingId(null);
      setView('list');
      loadData();
    } catch (err) {
      setMsg(err.response?.data?.error || 'Error al guardar empleado');
    }
  }

  function handleEdit(empleado) {
    setForm({
      nombre: empleado.NOMBRE,
      apellido: empleado.APELLIDO,
      email: empleado.EMAIL,
      telefono: empleado.TELEFONO || '',
      cargo: empleado.CARGO,
      salario: empleado.SALARIO || '',
      id_departamento: empleado.ID_DEPARTAMENTO,
      id_supervisor: empleado.ID_SUPERVISOR || ''
    });
    setEditingId(empleado.ID_EMPLEADO);
    setView('edit');
  }

  async function handleDelete(id) {
    if (!confirm('¿Estás seguro de desactivar este empleado?')) return;

    try {
      await api.delete(`/empleados/${id}`);
      setMsg('Empleado desactivado exitosamente');
      loadData();
    } catch (err) {
      setMsg(err.response?.data?.error || 'Error al desactivar empleado');
    }
  }

  const empleadosFiltrados = selectedDepartamento === 'all'
    ? empleados
    : empleados.filter(e => e.ID_DEPARTAMENTO === Number(selectedDepartamento));

  const empleadosActivos = empleadosFiltrados.filter(e => e.ACTIVO === 'S');

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-950 flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  // Vista de formulario
  if (view === 'create' || view === 'edit') {
    return (
      <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
        <div className="max-w-3xl mx-auto">
          <button
            onClick={() => {
              setView('list');
              setEditingId(null);
              setForm({
                nombre: '', apellido: '', email: '', telefono: '', cargo: '',
                salario: '', id_departamento: '', id_supervisor: ''
              });
            }}
            className="text-gray-400 hover:text-white mb-6 flex items-center gap-2"
          >
            ← Volver a la lista
          </button>

          <div className="bg-gray-800 rounded-xl p-6">
            <h2 className="text-2xl font-bold mb-6">
              {editingId ? 'Editar Empleado' : 'Nuevo Empleado'}
            </h2>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Nombre *</label>
                  <input
                    name="nombre"
                    value={form.nombre}
                    onChange={handleChange}
                    required
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                  />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Apellido *</label>
                  <input
                    name="apellido"
                    value={form.apellido}
                    onChange={handleChange}
                    required
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Email *</label>
                  <input
                    name="email"
                    type="email"
                    value={form.email}
                    onChange={handleChange}
                    required
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                  />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Teléfono</label>
                  <input
                    name="telefono"
                    value={form.telefono}
                    onChange={handleChange}
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Cargo *</label>
                  <input
                    name="cargo"
                    value={form.cargo}
                    onChange={handleChange}
                    required
                    placeholder="Ej: Desarrollador Senior"
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                  />
                </div>
                <div>
                  <label className="block text-sm text-gray-400 mb-1">Salario</label>
                  <input
                    name="salario"
                    type="number"
                    value={form.salario}
                    onChange={handleChange}
                    placeholder="Opcional"
                    className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-1">Departamento *</label>
                <select
                  name="id_departamento"
                  value={form.id_departamento}
                  onChange={handleChange}
                  required
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                >
                  <option value="">Selecciona un departamento</option>
                  {departamentos.map(d => (
                    <option key={d.ID_DEPARTAMENTO} value={d.ID_DEPARTAMENTO}>
                      {d.NOMBRE}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm text-gray-400 mb-1">Supervisor (opcional)</label>
                <select
                  name="id_supervisor"
                  value={form.id_supervisor}
                  onChange={handleChange}
                  className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white focus:outline-none focus:border-brand"
                >
                  <option value="">Sin supervisor</option>
                  {empleados
                    .filter(e => 
                      e.ACTIVO === 'S' && 
                      e.ID_DEPARTAMENTO === Number(form.id_departamento) &&
                      e.ID_EMPLEADO !== editingId
                    )
                    .map(e => (
                      <option key={e.ID_EMPLEADO} value={e.ID_EMPLEADO}>
                        {e.NOMBRE} {e.APELLIDO} - {e.CARGO}
                      </option>
                    ))}
                </select>
                <p className="text-xs text-gray-500 mt-1">
                  Solo se muestran empleados del mismo departamento
                </p>
              </div>

              {msg && (
                <p className={`text-sm ${msg.includes('Error') ? 'text-red-400' : 'text-green-400'}`}>
                  {msg}
                </p>
              )}

              <div className="flex gap-3">
                <button
                  type="button"
                  onClick={() => {
                    setView('list');
                    setEditingId(null);
                    setForm({
                      nombre: '', apellido: '', email: '', telefono: '', cargo: '',
                      salario: '', id_departamento: '', id_supervisor: ''
                    });
                  }}
                  className="flex-1 bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-lg transition"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="flex-1 bg-brand hover:bg-brand-dark px-4 py-2 rounded-lg transition"
                >
                  {editingId ? 'Actualizar' : 'Crear'} Empleado
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }

  // Vista principal
  return (
    <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2 flex items-center gap-3">
            <Users className="text-brand" size={32} />
            Gestión de Empleados
          </h1>
          <p className="text-gray-400">Administra el equipo de trabajo de QuindioFlix</p>
        </div>

        {/* Estadísticas */}
        {stats && (
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            <div className="bg-gray-800 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <Users size={20} className="text-green-400" />
                <span className="text-sm text-gray-400">Activos</span>
              </div>
              <div className="text-2xl font-bold">{stats.TOTAL_ACTIVOS}</div>
            </div>
            <div className="bg-gray-800 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <Users size={20} className="text-gray-400" />
                <span className="text-sm text-gray-400">Inactivos</span>
              </div>
              <div className="text-2xl font-bold">{stats.TOTAL_INACTIVOS}</div>
            </div>
            <div className="bg-gray-800 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <Building2 size={20} className="text-blue-400" />
                <span className="text-sm text-gray-400">Departamentos</span>
              </div>
              <div className="text-2xl font-bold">{stats.DEPARTAMENTOS_CON_EMPLEADOS}</div>
            </div>
            <div className="bg-gray-800 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <Shield size={20} className="text-yellow-400" />
                <span className="text-sm text-gray-400">Sin Supervisor</span>
              </div>
              <div className="text-2xl font-bold">{stats.SIN_SUPERVISOR}</div>
            </div>
            <div className="bg-gray-800 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <DollarSign size={20} className="text-green-400" />
                <span className="text-sm text-gray-400">Salario Promedio</span>
              </div>
              <div className="text-lg font-bold">
                ${stats.SALARIO_PROMEDIO ? Number(stats.SALARIO_PROMEDIO).toLocaleString() : '—'}
              </div>
            </div>
          </div>
        )}

        {/* Acciones y Filtros */}
        <div className="flex flex-wrap items-center justify-between gap-4 mb-6">
          <div className="flex gap-2">
            <button
              onClick={() => setView('list')}
              className={`px-4 py-2 rounded-lg transition ${
                view === 'list' ? 'bg-brand text-white' : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
              }`}
            >
              Empleados
            </button>
            <button
              onClick={() => setView('departamentos')}
              className={`px-4 py-2 rounded-lg transition ${
                view === 'departamentos' ? 'bg-brand text-white' : 'bg-gray-800 text-gray-300 hover:bg-gray-700'
              }`}
            >
              Departamentos
            </button>
          </div>

          <div className="flex gap-3">
            <select
              value={selectedDepartamento}
              onChange={e => setSelectedDepartamento(e.target.value)}
              className="bg-gray-800 border border-gray-700 rounded-lg px-4 py-2 text-white focus:outline-none focus:border-brand"
            >
              <option value="all">Todos los departamentos</option>
              {departamentos.map(d => (
                <option key={d.ID_DEPARTAMENTO} value={d.ID_DEPARTAMENTO}>
                  {d.NOMBRE}
                </option>
              ))}
            </select>

            <button
              onClick={() => setView('create')}
              className="bg-brand hover:bg-brand-dark px-4 py-2 rounded-lg transition flex items-center gap-2"
            >
              <UserPlus size={16} />
              Nuevo Empleado
            </button>
          </div>
        </div>

        {msg && (
          <div className={`mb-6 p-4 rounded-lg ${
            msg.includes('Error') ? 'bg-red-600/20 border border-red-600/40 text-red-400' :
            'bg-green-600/20 border border-green-600/40 text-green-400'
          }`}>
            {msg}
          </div>
        )}

        {/* Vista de Departamentos */}
        {view === 'departamentos' && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {departamentos.map(dept => (
              <div key={dept.ID_DEPARTAMENTO} className="bg-gray-800 rounded-xl p-6">
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h3 className="text-lg font-semibold">{dept.NOMBRE}</h3>
                    {dept.DESCRIPCION && (
                      <p className="text-sm text-gray-400 mt-1">{dept.DESCRIPCION}</p>
                    )}
                  </div>
                  <Building2 size={24} className="text-brand" />
                </div>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-gray-400">Jefe:</span>
                    <span className="text-white">{dept.JEFE || 'Sin asignar'}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-400">Empleados:</span>
                    <span className="text-white">{dept.NUM_EMPLEADOS}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Lista de Empleados */}
        {view === 'list' && (
          <div className="bg-gray-800 rounded-xl overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-700">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-400 uppercase">Nombre</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-400 uppercase">Cargo</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-400 uppercase">Departamento</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-400 uppercase">Supervisor</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-400 uppercase">Supervisados</th>
                    <th className="px-4 py-3 text-left text-xs font-semibold text-gray-400 uppercase">Estado</th>
                    <th className="px-4 py-3 text-right text-xs font-semibold text-gray-400 uppercase">Acciones</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-700">
                  {empleadosActivos.map(emp => (
                    <tr key={emp.ID_EMPLEADO} className="hover:bg-gray-700/50 transition">
                      <td className="px-4 py-3">
                        <div>
                          <div className="font-medium">{emp.NOMBRE} {emp.APELLIDO}</div>
                          <div className="text-xs text-gray-400">{emp.EMAIL}</div>
                        </div>
                      </td>
                      <td className="px-4 py-3 text-sm">{emp.CARGO}</td>
                      <td className="px-4 py-3 text-sm">{emp.DEPARTAMENTO}</td>
                      <td className="px-4 py-3 text-sm text-gray-400">{emp.SUPERVISOR || '—'}</td>
                      <td className="px-4 py-3 text-sm text-center">{emp.NUM_SUPERVISADOS}</td>
                      <td className="px-4 py-3">
                        <span className={`text-xs px-2 py-1 rounded ${
                          emp.ACTIVO === 'S' ? 'bg-green-600 text-white' : 'bg-gray-600 text-gray-300'
                        }`}>
                          {emp.ACTIVO === 'S' ? 'Activo' : 'Inactivo'}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <div className="flex items-center justify-end gap-2">
                          <button
                            onClick={() => handleEdit(emp)}
                            className="text-blue-400 hover:text-blue-300 p-1"
                            title="Editar"
                          >
                            <Edit2 size={16} />
                          </button>
                          <button
                            onClick={() => handleDelete(emp.ID_EMPLEADO)}
                            className="text-red-400 hover:text-red-300 p-1"
                            title="Desactivar"
                          >
                            <Trash2 size={16} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {empleadosActivos.length === 0 && (
              <div className="text-center py-12 text-gray-400">
                <Users size={48} className="mx-auto mb-3 text-gray-600" />
                <p>No hay empleados en este departamento</p>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
