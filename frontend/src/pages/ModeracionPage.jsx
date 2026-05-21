import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import api from '../api/axios';
import { Flag, CheckCircle, XCircle, Eye, AlertTriangle, Clock, FileCheck } from 'lucide-react';

export default function ModeracionPage() {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [reportes, setReportes] = useState([]);
  const [stats, setStats] = useState(null);
  const [filtro, setFiltro] = useState('PENDIENTE');
  const [loading, setLoading] = useState(true);
  const [selectedReporte, setSelectedReporte] = useState(null);
  const [resolucionNota, setResolucionNota] = useState('');
  const [msg, setMsg] = useState('');

  useEffect(() => {
    // Verificar que el usuario es moderador
    if (!user || user.ES_MODERADOR !== 'S') {
      navigate('/');
      return;
    }
    loadData();
  }, [user, navigate, filtro]);

  async function loadData() {
    setLoading(true);
    try {
      const [reportesRes, statsRes] = await Promise.all([
        api.get(`/reportes?estado=${filtro}`),
        api.get('/reportes/stats')
      ]);
      setReportes(reportesRes.data);
      setStats(statsRes.data);
    } catch (err) {
      console.error('Error cargando datos:', err);
      setMsg('Error al cargar reportes');
    } finally {
      setLoading(false);
    }
  }

  async function handleRevisar(id) {
    try {
      await api.put(`/reportes/${id}/revisar`);
      setMsg('Reporte marcado como en revisión');
      loadData();
      setTimeout(() => setMsg(''), 3000);
    } catch (err) {
      setMsg('Error al marcar reporte: ' + (err.response?.data?.error || err.message));
    }
  }

  async function handleResolver(id) {
    if (!resolucionNota.trim()) {
      return setMsg('Debes agregar una nota de resolución');
    }
    try {
      await api.put(`/reportes/${id}/resolver`, { resolucion_nota: resolucionNota });
      setMsg('Reporte resuelto exitosamente');
      setSelectedReporte(null);
      setResolucionNota('');
      loadData();
      setTimeout(() => setMsg(''), 3000);
    } catch (err) {
      setMsg('Error al resolver reporte: ' + (err.response?.data?.error || err.message));
    }
  }

  async function handleRechazar(id) {
    if (!resolucionNota.trim()) {
      return setMsg('Debes agregar una nota explicando el rechazo');
    }
    try {
      await api.put(`/reportes/${id}/rechazar`, { resolucion_nota: resolucionNota });
      setMsg('Reporte rechazado');
      setSelectedReporte(null);
      setResolucionNota('');
      loadData();
      setTimeout(() => setMsg(''), 3000);
    } catch (err) {
      setMsg('Error al rechazar reporte: ' + (err.response?.data?.error || err.message));
    }
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
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold mb-2 flex items-center gap-3">
            <Flag className="text-brand" size={32} />
            Panel de Moderación
          </h1>
          <p className="text-gray-400">Gestiona los reportes de contenido inapropiado</p>
        </div>

        {/* Estadísticas */}
        {stats && (
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-8">
            <div className="bg-gray-800 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <Flag size={20} className="text-gray-400" />
                <span className="text-sm text-gray-400">Total</span>
              </div>
              <div className="text-2xl font-bold">{stats.TOTAL}</div>
            </div>
            <div className="bg-yellow-600/20 border border-yellow-600/40 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <AlertTriangle size={20} className="text-yellow-400" />
                <span className="text-sm text-gray-400">Pendientes</span>
              </div>
              <div className="text-2xl font-bold text-yellow-400">{stats.PENDIENTES}</div>
            </div>
            <div className="bg-blue-600/20 border border-blue-600/40 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <Clock size={20} className="text-blue-400" />
                <span className="text-sm text-gray-400">En Revisión</span>
              </div>
              <div className="text-2xl font-bold text-blue-400">{stats.EN_REVISION}</div>
            </div>
            <div className="bg-green-600/20 border border-green-600/40 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <CheckCircle size={20} className="text-green-400" />
                <span className="text-sm text-gray-400">Resueltos</span>
              </div>
              <div className="text-2xl font-bold text-green-400">{stats.RESUELTOS}</div>
            </div>
            <div className="bg-red-600/20 border border-red-600/40 rounded-lg p-4">
              <div className="flex items-center gap-2 mb-2">
                <XCircle size={20} className="text-red-400" />
                <span className="text-sm text-gray-400">Rechazados</span>
              </div>
              <div className="text-2xl font-bold text-red-400">{stats.RECHAZADOS}</div>
            </div>
          </div>
        )}

        {/* Filtros */}
        <div className="bg-gray-800 rounded-lg p-4 mb-6">
          <div className="flex flex-wrap gap-2">
            {['PENDIENTE', 'EN_REVISION', 'RESUELTO', 'RECHAZADO'].map(estado => (
              <button
                key={estado}
                onClick={() => setFiltro(estado)}
                className={`px-4 py-2 rounded-lg text-sm font-medium transition ${
                  filtro === estado
                    ? 'bg-brand text-white'
                    : 'bg-gray-700 text-gray-300 hover:bg-gray-600'
                }`}
              >
                {estado.replace('_', ' ')}
              </button>
            ))}
          </div>
        </div>

        {/* Mensaje de feedback */}
        {msg && (
          <div className={`mb-6 p-4 rounded-lg ${
            msg.includes('Error') ? 'bg-red-600/20 border border-red-600/40 text-red-400' : 
            'bg-green-600/20 border border-green-600/40 text-green-400'
          }`}>
            {msg}
          </div>
        )}

        {/* Lista de Reportes */}
        {reportes.length === 0 ? (
          <div className="bg-gray-800 rounded-lg p-12 text-center">
            <FileCheck size={64} className="mx-auto mb-4 text-gray-600" />
            <p className="text-gray-400 text-lg">No hay reportes con estado: {filtro}</p>
          </div>
        ) : (
          <div className="space-y-4">
            {reportes.map(reporte => (
              <div key={reporte.ID_REPORTE} className="bg-gray-800 rounded-lg p-6">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      <h3 className="text-lg font-semibold">{reporte.CONTENIDO_TITULO}</h3>
                      <span className="text-xs bg-gray-700 px-2 py-1 rounded">
                        {reporte.CONTENIDO_TIPO}
                      </span>
                      <span className="text-xs bg-gray-700 px-2 py-1 rounded">
                        {reporte.CLASIFICACION_EDAD}
                      </span>
                    </div>
                    <div className="flex items-center gap-4 text-sm text-gray-400 mb-3">
                      <span>Reportado por: <span className="text-white">{reporte.PERFIL_REPORTANTE}</span> ({reporte.USUARIO_REPORTANTE})</span>
                      <span>•</span>
                      <span>{new Date(reporte.FECHA_REPORTE).toLocaleString('es-CO')}</span>
                    </div>
                    <div className="mb-3">
                      <span className="text-sm font-medium text-gray-400">Motivo: </span>
                      <span className="text-sm text-white">{reporte.MOTIVO}</span>
                    </div>
                    {reporte.DESCRIPCION && (
                      <div className="bg-gray-700 rounded-lg p-3 mb-3">
                        <p className="text-sm text-gray-300">{reporte.DESCRIPCION}</p>
                      </div>
                    )}
                    {reporte.MODERADOR_NOMBRE && (
                      <div className="text-sm text-gray-400">
                        Moderador: <span className="text-white">{reporte.MODERADOR_NOMBRE}</span>
                      </div>
                    )}
                    {reporte.RESOLUCION_NOTA && (
                      <div className="mt-3 bg-gray-700 rounded-lg p-3">
                        <div className="text-xs text-gray-400 mb-1">Nota de resolución:</div>
                        <p className="text-sm text-gray-300">{reporte.RESOLUCION_NOTA}</p>
                        {reporte.FECHA_RESOLUCION && (
                          <div className="text-xs text-gray-500 mt-2">
                            {new Date(reporte.FECHA_RESOLUCION).toLocaleString('es-CO')}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                  <div className={`px-3 py-1 rounded-lg text-xs font-semibold ${
                    reporte.ESTADO === 'PENDIENTE' ? 'bg-yellow-600 text-white' :
                    reporte.ESTADO === 'EN_REVISION' ? 'bg-blue-600 text-white' :
                    reporte.ESTADO === 'RESUELTO' ? 'bg-green-600 text-white' :
                    'bg-red-600 text-white'
                  }`}>
                    {reporte.ESTADO.replace('_', ' ')}
                  </div>
                </div>

                {/* Acciones */}
                {(reporte.ESTADO === 'PENDIENTE' || reporte.ESTADO === 'EN_REVISION') && (
                  <div className="flex gap-3 pt-4 border-t border-gray-700">
                    {reporte.ESTADO === 'PENDIENTE' && (
                      <button
                        onClick={() => handleRevisar(reporte.ID_REPORTE)}
                        className="bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded-lg text-sm transition flex items-center gap-2"
                      >
                        <Eye size={16} />
                        Revisar
                      </button>
                    )}
                    <button
                      onClick={() => {
                        setSelectedReporte(reporte.ID_REPORTE);
                        setResolucionNota('');
                      }}
                      className="bg-green-600 hover:bg-green-700 px-4 py-2 rounded-lg text-sm transition flex items-center gap-2"
                    >
                      <CheckCircle size={16} />
                      Resolver
                    </button>
                    <button
                      onClick={() => {
                        setSelectedReporte(reporte.ID_REPORTE);
                        setResolucionNota('');
                      }}
                      className="bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg text-sm transition flex items-center gap-2"
                    >
                      <XCircle size={16} />
                      Rechazar
                    </button>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Modal de Resolución/Rechazo */}
      {selectedReporte && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 px-4">
          <div className="bg-gray-800 rounded-xl p-6 max-w-md w-full">
            <h3 className="text-xl font-semibold mb-4">Nota de Resolución</h3>
            <textarea
              value={resolucionNota}
              onChange={e => setResolucionNota(e.target.value)}
              rows={4}
              placeholder="Explica la acción tomada o el motivo del rechazo..."
              className="w-full bg-gray-700 border border-gray-600 rounded-lg px-3 py-2 text-white
                         placeholder-gray-500 focus:outline-none focus:border-brand resize-none mb-4"
            />
            <div className="flex gap-3">
              <button
                onClick={() => handleResolver(selectedReporte)}
                className="flex-1 bg-green-600 hover:bg-green-700 px-4 py-2 rounded-lg transition"
              >
                Resolver
              </button>
              <button
                onClick={() => handleRechazar(selectedReporte)}
                className="flex-1 bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg transition"
              >
                Rechazar
              </button>
              <button
                onClick={() => {
                  setSelectedReporte(null);
                  setResolucionNota('');
                }}
                className="flex-1 bg-gray-700 hover:bg-gray-600 px-4 py-2 rounded-lg transition"
              >
                Cancelar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
