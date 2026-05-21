import axios from 'axios';

const api = axios.create({
  baseURL: '/api'
});

// Inyectar x-user-id y Content-Type según el payload
api.interceptors.request.use(config => {
  const session = JSON.parse(localStorage.getItem('qf_session') || 'null');
  if (session?.user?.ID_USUARIO) {
    config.headers['x-user-id'] = session.user.ID_USUARIO;
  }

  if (config.data && !(config.data instanceof FormData)) {
    config.headers['Content-Type'] = 'application/json';
  } else {
    // Dejar que el navegador establezca el Content-Type correcto para FormData
    delete config.headers['Content-Type'];
  }

  return config;
});

export default api;

