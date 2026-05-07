import { useState, useEffect } from 'react';
import api from '../api/axios';
import { useAuth } from '../context/AuthContext';

function StatCard({ label, value, icon }) {
  return (
    <div className="bg-gray-800 rounded-xl p-5">
      <div className="text-3xl mb-2">{icon}</div>
      <div className="text-2xl font-bold text-white">{value ?? '—'}</div>
      <div className="text-sm text-gray-400 mt-1">{label}</div>
    </div>
  );
}

export default function DashboardPage() {
  const { user } = useAuth();
  const [stats,       setStats]       = useState(null);
  const [popular,     setPopular]     = useState([]);
  const [dispositivos,setDispositivos]= useState([]);
  const [ciudades,    setCiudades]    = useState([]);
  const [ingresos,    setIngresos]    = useState([]);
  const [loading,     setLoading]     = useState(true);

  useEffect(() => {
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
    }).catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center">
      <div className="w-10 h-10 border-4 border-brand border-t-transparent rounded-full animate-spin" />
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
          <StatCard label="Usuarios activos"     value={fmt(stats.USUARIOS_ACTIVOS)}     icon="👥" />
          <StatCard label="Contenido total"      value={fmt(stats.TOTAL_CONTENIDO)}      icon="🎬" />
          <StatCard label="Reproducciones"       value={fmt(stats.TOTAL_REPRODUCCIONES)} icon="▶️" />
          <StatCard label="Ingresos este mes"    value={money(stats.INGRESOS_MES_ACTUAL)} icon="💰" />
          <StatCard label="Reportes pendientes"  value={fmt(stats.REPORTES_PENDIENTES)}  icon="🚨" />
          <StatCard label="Calificación global"  value={stats.CALIFICACION_GLOBAL ? `⭐ ${stats.CALIFICACION_GLOBAL}` : '—'} icon="⭐" />
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-10">
        {/* Top 10 contenido popular */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4">🏆 Top 10 Contenido Más Popular</h2>
          <div className="space-y-2">
            {popular.map((c, i) => (
              <div key={i} className="flex items-center gap-3 text-sm">
                <span className="text-gray-500 w-5 text-right">{i + 1}</span>
                <div className="flex-1 min-w-0">
                  <span className="text-white truncate block">{c.TITULO}</span>
                  <span className="text-gray-500 text-xs">{c.CATEGORIA} · {c.TIPO}</span>
                </div>
                <div className="text-right flex-shrink-0">
                  <div className="text-brand font-medium">▶ {fmt(c.TOTAL_REPRODUCCIONES)}</div>
                  <div className="text-yellow-400 text-xs">⭐ {c.CALIFICACION_PROMEDIO ?? '—'}</div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Usuarios por ciudad y plan */}
        <div className="bg-gray-800 rounded-xl p-6">
          <h2 className="text-lg font-semibold mb-4">🏙️ Usuarios Activos por Ciudad y Plan</h2>
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
          <h2 className="text-lg font-semibold mb-4">📱 Reproducciones por Categoría y Dispositivo</h2>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="text-gray-400 border-b border-gray-700">
                  <th className="text-left py-2">Categoría</th>
                  <th className="text-right py-2">📱</th>
                  <th className="text-right py-2">📟</th>
                  <th className="text-right py-2">📺</th>
                  <th className="text-right py-2">💻</th>
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
          <h2 className="text-lg font-semibold mb-4">💰 Ingresos Mensuales 2026</h2>
          <div className="overflow-x-auto max-h-72 overflow-y-auto">
            <table className="w-full text-sm">
              <thead className="sticky top-0 bg-gray-800">
                <tr className="text-gray-400 border-b border-gray-700">
                  <th className="text-left py-2">Ciudad</th>
                  <th className="text-left py-2">Plan</th>
                  <th className="text-right py-2">Mes</th>
                  <th className="text-right py-2">Ingresos</th>
                  <th className="text-right py-2">Pagos ✓</th>
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

