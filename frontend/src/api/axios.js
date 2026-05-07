import axios from 'axios';

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' }
});

// Inyectar x-user-id en cada request si hay sesión activa
api.interceptors.request.use(config => {
  const session = JSON.parse(localStorage.getItem('qf_session') || 'null');
  if (session?.user?.ID_USUARIO) {
    config.headers['x-user-id'] = session.user.ID_USUARIO;
  }
  return config;
});

export default api;

