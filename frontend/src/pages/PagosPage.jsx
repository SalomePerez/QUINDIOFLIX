import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../api/axios';
import { CreditCard, CalendarCheck, Coins } from 'lucide-react';

const METODOS_PAGO = ['TARJETA_CREDITO', 'TARJETA_DEBITO', 'PSE', 'NEQUI', 'DAVIPLATA'];

export default function PagosPage() {
  const { user } = useAuth();
  const [pagos, setPagos] = useState([]);
  const [montoProximo, setMontoProximo] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [selectedPago, setSelectedPago] = useState(null);
  const [form, setForm] = useState({ metodo_pago: 'PSE', referencia: '' });
  const [paymentError, setPaymentError] = useState('');
  const [paymentSuccess, setPaymentSuccess] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const pendingPayments = pagos.filter((pago) => pago.ESTADO_PAGO === 'PENDIENTE');

  useEffect(() => {
    async function loadPagos() {
      if (!user) return;
      setLoading(true);
      try {
        const [pagosRes, montoRes] = await Promise.all([
          api.get(`/usuarios/${user.ID_USUARIO}/pagos`),
          api.get(`/usuarios/${user.ID_USUARIO}/monto-proximo`)
        ]);
        setPagos(pagosRes.data);
        setMontoProximo(montoRes.data.monto);
      } catch (err) {
        console.error('Error cargando pagos:', err);
        setError(err.response?.data?.error || 'No se pudo cargar el historial de pagos.');
      } finally {
        setLoading(false);
      }
    }
    loadPagos();
  }, [user]);

  async function handleSubmitPago(event) {
    event.preventDefault();
    if (!selectedPago) {
      setPaymentError('Selecciona primero el pago pendiente que deseas procesar.');
      return;
    }
    setPaymentError('');
    setPaymentSuccess('');
    setSubmitting(true);

    try {
      await api.put(`/usuarios/${user.ID_USUARIO}/pagos/${selectedPago.ID_PAGO}/pagar`, {
        metodo_pago: form.metodo_pago,
        referencia: form.referencia || null
      });

      setPaymentSuccess('Pago procesado correctamente. Historial actualizado.');
      setSelectedPago(null);
      setForm({ metodo_pago: 'PSE', referencia: '' });
      const pagosRes = await api.get(`/usuarios/${user.ID_USUARIO}/pagos`);
      setPagos(pagosRes.data);
      const montoRes = await api.get(`/usuarios/${user.ID_USUARIO}/monto-proximo`);
      setMontoProximo(montoRes.data.monto);
    } catch (err) {
      console.error('Error registrando pago:', err);
      setPaymentError(err.response?.data?.error || 'No se pudo procesar el pago.');
    } finally {
      setSubmitting(false);
    }
  }

  function handleInputChange(event) {
    const { name, value } = event.target;
    setForm(prev => ({ ...prev, [name]: value }));
  }

  function handleSeleccionarPago(pago) {
    setSelectedPago(pago);
    setPaymentError('');
    setPaymentSuccess('');
    setForm({ metodo_pago: 'PSE', referencia: '' });
  }

  function handleCancelarPago() {
    setSelectedPago(null);
    setForm({ metodo_pago: 'PSE', referencia: '' });
    setPaymentError('');
    setPaymentSuccess('');
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
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
          <div>
            <div className="flex items-center gap-3 mb-3">
              <CreditCard size={32} className="text-brand" />
              <div>
                <h1 className="text-3xl font-bold">Pagos y facturación</h1>
                <p className="text-gray-400 text-sm">
                  Revisa tu historial de pagos y el próximo cobro estimado.
                </p>
              </div>
            </div>
            <div className="flex flex-wrap gap-3 text-sm">
              <span className="inline-flex items-center gap-2 px-3 py-2 rounded-lg bg-gray-800 border border-gray-700 text-gray-300">
                <CalendarCheck size={16} />
                Estado de cuenta: <strong className="text-white">{user.ESTADO_CUENTA || 'ACTIVO'}</strong>
              </span>
              <span className="inline-flex items-center gap-2 px-3 py-2 rounded-lg bg-gray-800 border border-gray-700 text-gray-300">
                <Coins size={16} />
                Próximo pago: <strong className="text-white">{montoProximo !== null ? montoProximo.toLocaleString('es-CO', { style: 'currency', currency: 'COP' }) : 'N/A'}</strong>
              </span>
            </div>
          </div>
        </div>

        {error && (
          <div className="mb-4 rounded-xl bg-red-600/20 border border-red-500 p-4 text-red-100">
            {error}
          </div>
        )}

        {pagos.length > 0 && (
          <div className="mb-6 rounded-3xl border border-gray-800 bg-gray-900/80 p-5 text-sm text-gray-300">
            {pendingPayments.length > 0
              ? 'Selecciona un pago pendiente de la lista para confirmar el pago.'
              : 'No hay pagos pendientes. Tu cuenta está al día.'}
          </div>
        )}

        {pagos.length === 0 ? (
          <div className="rounded-3xl border border-dashed border-gray-700 bg-gray-900/70 p-10 text-center">
            <p className="text-gray-400 text-lg mb-2">Aún no tienes pagos registrados.</p>
            <p className="text-sm text-gray-500">Cuando realices tus próximas suscripciones, aparecerán aquí.</p>
          </div>
        ) : (
          <div className="overflow-x-auto rounded-3xl border border-gray-800 bg-gray-900/80 shadow-lg shadow-black/20">
            <table className="min-w-full text-left">
              <thead className="bg-gray-900 text-gray-400 text-xs uppercase tracking-[0.2em]">
                <tr>
                  <th className="px-4 py-4">Fecha</th>
                  <th className="px-4 py-4">Monto</th>
                  <th className="px-4 py-4">Método</th>
                  <th className="px-4 py-4">Estado</th>
                  <th className="px-4 py-4">Período</th>
                  <th className="px-4 py-4">Descuento</th>
                  <th className="px-4 py-4">Referencia</th>
                </tr>
              </thead>
              <tbody>
                {pagos.map((pago) => (
                  <tr key={pago.ID_PAGO} className="border-t border-gray-800 even:bg-gray-950/80">
                    <td className="px-4 py-4 text-sm text-gray-200">
                      {new Date(pago.FECHA_PAGO).toLocaleDateString('es-CO', {
                        year: 'numeric', month: '2-digit', day: '2-digit'
                      })}
                    </td>
                    <td className="px-4 py-4 text-sm text-gray-200">
                      {Number(pago.MONTO).toLocaleString('es-CO', { style: 'currency', currency: 'COP' })}
                    </td>
                    <td className="px-4 py-4 text-sm text-gray-200">{pago.METODO_PAGO}</td>
                    <td className="px-4 py-4 text-sm">
                      <span className={`inline-flex px-2 py-1 rounded-full text-xs font-semibold ${
                        pago.ESTADO_PAGO === 'EXITOSO' ? 'bg-green-600/20 text-green-200' :
                        pago.ESTADO_PAGO === 'FALLIDO' ? 'bg-red-600/20 text-red-200' :
                        pago.ESTADO_PAGO === 'PENDIENTE' ? 'bg-yellow-600/20 text-yellow-200' :
                        'bg-slate-600/20 text-slate-200'
                      }`}>
                        {pago.ESTADO_PAGO}
                      </span>
                    </td>
                    <td className="px-4 py-4 text-sm text-gray-200">{pago.PERIODO_MES}/{pago.PERIODO_ANIO}</td>
                    <td className="px-4 py-4 text-sm text-gray-200">{pago.DESCUENTO_PCT}%</td>
                    <td className="px-4 py-4 text-sm text-gray-200">{pago.REFERENCIA || '---'}</td>
                    <td className="px-4 py-4 text-sm">
                      {pago.ESTADO_PAGO === 'PENDIENTE' ? (
                        <button
                          onClick={() => handleSeleccionarPago(pago)}
                          className="rounded-lg bg-brand px-3 py-2 text-sm text-white hover:bg-brand-dark transition"
                        >
                          Pagar
                        </button>
                      ) : (
                        <span className="text-gray-500">-</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {selectedPago && (
          <div className="mt-8 rounded-3xl border border-gray-800 bg-gray-900/80 p-6 shadow-lg shadow-black/10">
            <div className="flex items-center justify-between mb-5">
              <div>
                <h2 className="text-xl font-semibold">Pagar cuota pendiente</h2>
                <p className="text-gray-400 text-sm">Pago pendiente para el período {selectedPago.PERIODO_MES}/{selectedPago.PERIODO_ANIO}.</p>
              </div>
              <button
                onClick={handleCancelarPago}
                className="text-sm text-gray-400 hover:text-white"
              >
                Cancelar
              </button>
            </div>

            {paymentError && (
              <div className="mb-4 rounded-xl bg-red-600/20 border border-red-500 p-4 text-red-100">
                {paymentError}
              </div>
            )}
            {paymentSuccess && (
              <div className="mb-4 rounded-xl bg-green-600/20 border border-green-500 p-4 text-green-100">
                {paymentSuccess}
              </div>
            )}

            <form onSubmit={handleSubmitPago} className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <label className="space-y-2">
                <span className="text-sm text-gray-300">Método de pago</span>
                <select
                  name="metodo_pago"
                  value={form.metodo_pago}
                  onChange={handleInputChange}
                  className="w-full rounded-xl border border-gray-700 bg-gray-950 px-4 py-3 text-white focus:outline-none focus:border-brand"
                >
                  {METODOS_PAGO.map((metodo) => (
                    <option key={metodo} value={metodo}>{metodo.replace('_', ' ')}</option>
                  ))}
                </select>
              </label>

              <label className="space-y-2 md:col-span-2">
                <span className="text-sm text-gray-300">Referencia (opcional)</span>
                <input
                  type="text"
                  name="referencia"
                  value={form.referencia}
                  onChange={handleInputChange}
                  placeholder="Ej. TRANS12345 o comprobante"
                  className="w-full rounded-xl border border-gray-700 bg-gray-950 px-4 py-3 text-white focus:outline-none focus:border-brand"
                />
                <p className="text-xs text-gray-500">Identificador de la transacción para seguimiento.</p>
              </label>

              <div className="md:col-span-3 text-right">
                <button
                  type="submit"
                  disabled={submitting}
                  className="inline-flex items-center justify-center gap-2 rounded-xl bg-brand px-6 py-3 text-white hover:bg-brand-dark transition disabled:cursor-not-allowed disabled:bg-gray-700"
                >
                  {submitting ? 'Procesando pago...' : 'Confirmar pago'}
                </button>
              </div>
            </form>
          </div>
        )}
      </div>
    </div>
  );
}
