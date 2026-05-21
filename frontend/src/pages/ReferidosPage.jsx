import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { Copy, Check, Users, Gift } from 'lucide-react';
import api from '../api/axios';

export default function ReferidosPage() {
  const { user } = useAuth();
  const [referidos, setReferidos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (user) {
      loadReferidos();
    }
  }, [user]);

  async function loadReferidos() {
    try {
      // Obtener usuarios que este usuario ha referido
      const { data } = await api.get(`/usuarios/${user.ID_USUARIO}/referidos`);
      setReferidos(data);
    } catch (err) {
      console.error('Error cargando referidos:', err);
    } finally {
      setLoading(false);
    }
  }

  function copyReferralCode() {
    navigator.clipboard.writeText(user.ID_USUARIO.toString());
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
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
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-2">Programa de Referidos</h1>
        <p className="text-gray-400 mb-8">
          Invita a tus amigos y ambos recibirán beneficios especiales
        </p>

        {/* Tarjeta de código de referido */}
        <div className="bg-gradient-to-br from-brand/20 to-purple-600/20 border border-brand/40 rounded-xl p-6 mb-8">
          <div className="flex items-start justify-between mb-4">
            <div>
              <h2 className="text-xl font-semibold mb-1">Tu Código de Referido</h2>
              <p className="text-sm text-gray-300">Comparte este código con tus amigos</p>
            </div>
            <Gift size={32} className="text-brand" />
          </div>

          <div className="bg-gray-900 rounded-lg p-4 flex items-center justify-between mb-4">
            <div>
              <div className="text-xs text-gray-400 mb-1">Código de Referido</div>
              <div className="text-3xl font-bold text-brand">{user.ID_USUARIO}</div>
            </div>
            <button
              onClick={copyReferralCode}
              className="bg-brand hover:bg-brand-dark px-4 py-2 rounded-lg transition flex items-center gap-2"
            >
              {copied ? (
                <>
                  <Check size={16} />
                  Copiado
                </>
              ) : (
                <>
                  <Copy size={16} />
                  Copiar
                </>
              )}
            </button>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="bg-gray-900/50 rounded-lg p-3">
              <div className="text-xs text-gray-400 mb-1">Beneficio para ti</div>
              <div className="text-sm font-semibold text-green-400">10% descuento próximo mes</div>
            </div>
            <div className="bg-gray-900/50 rounded-lg p-3">
              <div className="text-xs text-gray-400 mb-1">Beneficio para tu amigo</div>
              <div className="text-sm font-semibold text-green-400">10% descuento primer mes</div>
            </div>
          </div>
        </div>

        {/* Cómo funciona */}
        <div className="bg-gray-800 rounded-xl p-6 mb-8">
          <h2 className="text-xl font-semibold mb-4">¿Cómo funciona?</h2>
          <div className="space-y-3">
            <div className="flex gap-3">
              <div className="w-8 h-8 rounded-full bg-brand flex items-center justify-center flex-shrink-0 font-bold">
                1
              </div>
              <div>
                <div className="font-medium">Comparte tu código</div>
                <div className="text-sm text-gray-400">
                  Envía tu código de referido <span className="text-brand font-bold">{user.ID_USUARIO}</span> a tus amigos
                </div>
              </div>
            </div>
            <div className="flex gap-3">
              <div className="w-8 h-8 rounded-full bg-brand flex items-center justify-center flex-shrink-0 font-bold">
                2
              </div>
              <div>
                <div className="font-medium">Tu amigo se registra</div>
                <div className="text-sm text-gray-400">
                  Al registrarse, debe ingresar tu código en el campo "ID de quien te refirió"
                </div>
              </div>
            </div>
            <div className="flex gap-3">
              <div className="w-8 h-8 rounded-full bg-brand flex items-center justify-center flex-shrink-0 font-bold">
                3
              </div>
              <div>
                <div className="font-medium">Ambos reciben beneficios</div>
                <div className="text-sm text-gray-400">
                  Tú recibes 10% de descuento en tu próximo pago y tu amigo en su primer mes
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Lista de referidos */}
        <div className="bg-gray-800 rounded-xl p-6">
          <div className="flex items-center gap-2 mb-4">
            <Users size={20} className="text-brand" />
            <h2 className="text-xl font-semibold">Tus Referidos ({referidos.length})</h2>
          </div>

          {referidos.length > 0 ? (
            <div className="space-y-2">
              {referidos.map((ref, index) => (
                <div key={index} className="bg-gray-700 rounded-lg px-4 py-3 flex items-center justify-between">
                  <div>
                    <div className="font-medium">{ref.NOMBRE} {ref.APELLIDO}</div>
                    <div className="text-xs text-gray-400">
                      Registrado el {new Date(ref.FECHA_REGISTRO).toLocaleDateString('es-CO')}
                    </div>
                  </div>
                  <div className="text-xs bg-green-600 px-2 py-1 rounded">
                    Activo
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center py-8 text-gray-400">
              <Users size={48} className="mx-auto mb-3 text-gray-600" />
              <p>Aún no has referido a nadie</p>
              <p className="text-sm mt-1">¡Comparte tu código y empieza a ganar beneficios!</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
