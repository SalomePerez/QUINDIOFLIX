import { useState, useEffect } from 'react';
import api from '../api/axios';
import { useAuth } from '../context/AuthContext';
import { Users, Film, Play, DollarSign, AlertTriangle, Star, Trophy, MapPin, Smartphone, Tablet, Tv, Monitor } from 'lucide-react';

function StatCard({ label, value, icon: Icon }) {
  return (
    <div className="bg-gray-800 rounded-xl p-5">
      <div className="mb-2">
        <Icon size={32} className="text-brand" strokeWidth={1.5} />
      </div>
      <div className="text-2xl font-bold text-white">{value ?? '—'}</div>
      <div className="text-sm text-gray-400 mt-1">{label}</div>
    </div>
  );
}

export default function DashboardPage() {
  const { user } = useAuth();
  const isModerador = user?.ES_MODERADOR === 'S';
  const [stats,       setStats]       = useState(null);
  const [popular,     setPopular]     = useState([]);
  const [dispositivos,setDispositivos]= useState([]);
  const [ciudades,    setCiudades]    = useState([]);
  const [ingresos,    setIngresos]    = useState([]);
  const [loading,     setLoading]     = useState(true);
  const [error,       setError]       = useState(null);

  useEffect(() => {
    if (!isModerador) {
      setLoading(false);
      return;
    }

    Promise.all([
      api.get('/dashboard/stats'),
      api.get('/dashboard/popular'),
      api.get('/dashboard/reproducciones-por-dispositivo'),
      api.get('/dashboard/usuarios-por-ciudad'),
      api.get('/dashboard/ingresos'),
    ]).then(([s, p, d, c, i]) => {
      setStats(s.data);
      setPopular(p.data);
      setDispositivos(d.data);
      setCiudades(c.data);
      setIngresos(i.data);
    }).catch(err => {
      console.error(err);
      setError(err.response?.data?.error || 'Error al cargar el dashboard.');
    }).finally(() => setLoading(false));
  }, [isModerador]);

  if (loading) return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center">
      <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
    </div>
  );

  if (!isModerador) return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center px-6 text-center">
      <div className="bg-gray-800 p-8 rounded-3xl border border-gray-700 max-w-xl">
        <h1 className="text-2xl font-semibold text-white mb-4">Acceso denegado</h1>
        <p className="text-gray-300 mb-4">Este panel está disponible solo para usuarios con rol de moderador/administrador.</p>
        <p className="text-sm text-gray-500">Si crees que deberías tener acceso, contacta al administrador del sistema.</p>
      </div>
    </div>
  );

  if (error) return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center px-6 text-center">
      <div className="bg-gray-800 p-8 rounded-3xl border border-red-500 max-w-xl">
        <h1 className="text-2xl font-semibold text-white mb-4">Error al cargar el dashboard</h1>
        <p className="text-gray-300 mb-4">{error}</p>
        <p className="text-sm text-gray-500">Verifica que el backend esté reiniciado y que el servidor use la versión actualizada del dashboard.</p>
      </div>
    </div>
  );

  const fmt = n => n != null ? Number(n).toLocaleString('es-CO') : '—';
  const money = n => n != null ? `$${Number(n).toLocaleString('es-CO')}` : '—';

  return (
    <div className="min-h-screen bg-gray-950 text-white px-6 py-8">
      <h1 className="text-3xl font-bold mb-8">Dashboard Analítico</h1>

      {/* Stats generales */}
      {stats && (
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mb-10">
          <StatCard label="Usuarios activos"     value={fmt(stats.USUARIOS_ACTIVOS)}     icon={Users} />
          <StatCard label="Contenido total"      value={fmt(stats.TOTAL_CONTENIDO)}      icon={Film} />
          <StatCard label="Reproducciones"       value={fmt(stats.TOTAL_REPRODUCCIONES)} icon={Play} />
          <StatCard label="Ingresos este mes"    value={money(stats.INGRESOS_MES_ACTUAL)} icon={DollarSign} />
          <StatCard label="Reportes pendientes"  value={fmt(stats.REPORTES_PENDIENTES)}  icon={AlertTriangle} />
          <StatCard label="Calificación global"  value={stats.CALIFICACION_GLOBAL || '—'} icon={Star} />
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-10">
        {/* Top 10 contenido popular */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
            <Trophy size={20} className="text-yellow-400" />
            Top 10 Contenido Más Popular
          </h2>
          <div className="space-y-2">
            {popular.map((c, i) => (
              <div key={i} className="flex items-center gap-3 text-sm">
                <span className="text-gray-500 w-5 text-right">{i + 1}</span>
                <div className="flex-1 min-w-0">
                  <span className="text-white truncate block">{c.TITULO}</span>
                  <span className="text-gray-500 text-xs">{c.CATEGORIA} · {c.TIPO}</span>
                </div>
                <div className="text-right flex-shrink-0">
                  <div className="text-brand font-medium flex items-center gap-1 justify-end">
                    <Play size={12} />
                    {fmt(c.TOTAL_REPRODUCCIONES)}
                  </div>
                  <div className="text-yellow-400 text-xs flex items-center gap-1 justify-end">
                    <Star size={12} className="fill-yellow-400" />
                    {c.CALIFICACION_PROMEDIO ?? '—'}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Usuarios por ciudad y plan */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
            <MapPin size={20} className="text-brand" />
            Usuarios Activos por Ciudad y Plan
          </h2>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="text-gray-400 border-b border-gray-700">
                  <th className="text-left py-2">Ciudad</th>
                  <th className="text-right py-2">Básico</th>
                  <th className="text-right py-2">Estándar</th>
                  <th className="text-right py-2">Premium</th>
                  <th className="text-right py-2">Total</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-700">
                {ciudades.map((c, i) => (
                  <tr key={i}>
                    <td className="py-2 text-white">{c.CIUDAD}</td>
                    <td className="py-2 text-right text-gray-300">{c.BASICO}</td>
                    <td className="py-2 text-right text-gray-300">{c.ESTANDAR}</td>
                    <td className="py-2 text-right text-gray-300">{c.PREMIUM}</td>
                    <td className="py-2 text-right font-semibold text-brand">
                      {(c.BASICO || 0) + (c.ESTANDAR || 0) + (c.PREMIUM || 0)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Reproducciones por dispositivo */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
            <Smartphone size={20} className="text-brand" />
            Reproducciones por Categoría y Dispositivo
          </h2>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="text-gray-400 border-b border-gray-700">
                  <th className="text-left py-2">Categoría</th>
                  <th className="text-right py-2 flex items-center justify-end gap-1">
                    <Smartphone size={14} />
                  </th>
                  <th className="text-right py-2">
                    <Tablet size={14} className="inline" />
                  </th>
                  <th className="text-right py-2">
                    <Tv size={14} className="inline" />
                  </th>
                  <th className="text-right py-2">
                    <Monitor size={14} className="inline" />
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-700">
                {dispositivos.map((d, i) => (
                  <tr key={i}>
                    <td className="py-2 text-white">{d.CATEGORIA}</td>
                    <td className="py-2 text-right text-gray-300">{d.CELULAR}</td>
                    <td className="py-2 text-right text-gray-300">{d.TABLET}</td>
                    <td className="py-2 text-right text-gray-300">{d.TV}</td>
                    <td className="py-2 text-right text-gray-300">{d.COMPUTADOR}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Ingresos mensuales */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4 flex items-center gap-2">
            <DollarSign size={20} className="text-green-400" />
            Ingresos Mensuales 2026
          </h2>
          <div className="overflow-x-auto max-h-72 overflow-y-auto">
            <table className="w-full text-sm">
              <thead className="sticky top-0 bg-gray-800">
                <tr className="text-gray-400 border-b border-gray-700">
                  <th className="text-left py-2">Ciudad</th>
                  <th className="text-left py-2">Plan</th>
                  <th className="text-right py-2">Mes</th>
                  <th className="text-right py-2">Ingresos</th>
                  <th className="text-right py-2">Pagos</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-700">
                {ingresos.map((r, i) => (
                  <tr key={i}>
                    <td className="py-1.5 text-white">{r.CIUDAD}</td>
                    <td className="py-1.5 text-gray-300">{r.PLAN}</td>
                    <td className="py-1.5 text-right text-gray-400">{r.MES}</td>
                    <td className="py-1.5 text-right text-green-400 font-medium">{money(r.INGRESOS_NETOS)}</td>
                    <td className="py-1.5 text-right text-gray-300">{r.PAGOS_EXITOSOS}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
