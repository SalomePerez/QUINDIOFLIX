import { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import api from '../api/axios';

const PLANES = [
  { id: 1, nombre: 'BÁSICO',    precio: '$14.900/mes', pantallas: 1, calidad: 'SD',  perfiles: 2 },
  { id: 2, nombre: 'ESTÁNDAR',  precio: '$24.900/mes', pantallas: 2, calidad: 'HD',  perfiles: 3 },
  { id: 3, nombre: 'PREMIUM',   precio: '$34.900/mes', pantallas: 4, calidad: '4K',  perfiles: 5 },
];

export default function RegisterPage() {
  const navigate = useNavigate();
  const [form, setForm] = useState({
    nombre: '', apellido: '', email: '', password: '', confirmPassword: '', telefono: '',
    fecha_nacimiento: '', ciudad: '', id_plan: 2, id_referidor: ''
  });
  const [error,   setError]   = useState('');
  const [loading, setLoading] = useState(false);

  function handleChange(e) {
    setForm(f => ({ ...f, [e.target.name]: e.target.value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    
    // Validar contraseñas
    if (form.password.length < 6) {
      return setError('La contraseña debe tener al menos 6 caracteres.');
    }
    if (form.password !== form.confirmPassword) {
      return setError('Las contraseñas no coinciden.');
    }
    
    setLoading(true);
    try {
      await api.post('/auth/register', {
        nombre: form.nombre,
        apellido: form.apellido,
        email: form.email,
        password: form.password,
        telefono: form.telefono || undefined,
        fecha_nacimiento: form.fecha_nacimiento,
        ciudad: form.ciudad,
        id_plan: Number(form.id_plan),
        id_referidor: form.id_referidor ? Number(form.id_referidor) : undefined
      });
      navigate('/login');
    } catch (err) {
      setError(err.response?.data?.error || 'Error al registrarse.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center p-4">
      <div className="w-full max-w-lg bg-gray-900 rounded-2xl p-8 shadow-2xl">
        <h1 className="text-3xl font-bold text-brand mb-2 text-center">QUINDIOFLIX</h1>
        <h2 className="text-xl font-semibold text-white mb-6 text-center">Crear cuenta</h2>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            {[['nombre','Nombre'],['apellido','Apellido']].map(([name, label]) => (
              <div key={name}>
                <label className="block text-sm text-gray-400 mb-1">{label}</label>
                <input name={name} value={form[name]} onChange={handleChange} required
                  className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                             focus:outline-none focus:border-brand" />
              </div>
            ))}
          </div>

          <div>
            <label className="block text-sm text-gray-400 mb-1">Email</label>
            <input name="email" type="email" value={form.email} onChange={handleChange} required
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                         focus:outline-none focus:border-brand" />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm text-gray-400 mb-1">Contraseña</label>
              <input name="password" type="password" value={form.password} onChange={handleChange} required
                placeholder="Mínimo 6 caracteres"
                className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                           focus:outline-none focus:border-brand" />
            </div>
            <div>
              <label className="block text-sm text-gray-400 mb-1">Confirmar contraseña</label>
              <input name="confirmPassword" type="password" value={form.confirmPassword} onChange={handleChange} required
                placeholder="Repite la contraseña"
                className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                           focus:outline-none focus:border-brand" />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm text-gray-400 mb-1">Teléfono</label>
              <input name="telefono" value={form.telefono} onChange={handleChange}
                className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                           focus:outline-none focus:border-brand" />
            </div>
            <div>
              <label className="block text-sm text-gray-400 mb-1">Fecha de nacimiento</label>
              <input name="fecha_nacimiento" type="date" value={form.fecha_nacimiento} onChange={handleChange} required
                className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                           focus:outline-none focus:border-brand" />
            </div>
          </div>

          <div>
            <label className="block text-sm text-gray-400 mb-1">Ciudad</label>
            <input name="ciudad" value={form.ciudad} onChange={handleChange} required
              placeholder="Ej: Armenia, Bogotá, Medellín..."
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                         focus:outline-none focus:border-brand" />
          </div>

          {/* Selección de plan */}
          <div>
            <label className="block text-sm text-gray-400 mb-2">Plan de suscripción</label>
            <div className="grid grid-cols-3 gap-3">
              {PLANES.map(p => (
                <button key={p.id} type="button"
                  onClick={() => setForm(f => ({ ...f, id_plan: p.id }))}
                  className={`p-3 rounded-lg border text-left transition
                    ${form.id_plan === p.id
                      ? 'border-brand bg-brand/10 text-white'
                      : 'border-gray-700 text-gray-400 hover:border-gray-500'}`}
                >
                  <div className="font-semibold text-sm">{p.nombre}</div>
                  <div className="text-xs mt-1">{p.precio}</div>
                  <div className="text-xs text-gray-500">{p.calidad} · {p.perfiles} perfiles</div>
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-sm text-gray-400 mb-1">ID de quien te refirió (opcional)</label>
            <input name="id_referidor" type="number" value={form.id_referidor} onChange={handleChange}
              placeholder="Ej: 5"
              className="w-full bg-gray-800 border border-gray-700 rounded-lg px-3 py-2 text-white
                         focus:outline-none focus:border-brand" />
          </div>

          {error && <p className="text-red-400 text-sm">{error}</p>}

          <button type="submit" disabled={loading}
            className="w-full bg-brand hover:bg-brand-dark text-white font-semibold py-2.5 rounded-lg
                       transition disabled:opacity-50">
            {loading ? 'Registrando...' : 'Crear cuenta'}
          </button>
        </form>

        <p className="text-center text-gray-500 text-sm mt-6">
          ¿Ya tienes cuenta?{' '}
          <Link to="/login" className="text-brand hover:underline">Inicia sesión</Link>
        </p>
      </div>
    </div>
  );
}

