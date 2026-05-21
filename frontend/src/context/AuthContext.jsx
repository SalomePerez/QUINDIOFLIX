import { createContext, useContext, useState, useEffect } from 'react';
import api from '../api/axios';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user,    setUser]    = useState(null);
  const [perfil,  setPerfil]  = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const saved = localStorage.getItem('qf_session');
    if (saved) {
      const { user: u, perfil: p } = JSON.parse(saved);
      setUser(u);
      setPerfil(p);
    }
    setLoading(false);
  }, []);

  async function login(email, password) {
    const { data } = await api.post('/auth/login', { email, password });
    setUser(data.user);
    localStorage.setItem('qf_session', JSON.stringify({ user: data.user, perfil: null }));
    return data.user;
  }

  function selectPerfil(p) {
    setPerfil(p);
    const saved = JSON.parse(localStorage.getItem('qf_session') || '{}');
    localStorage.setItem('qf_session', JSON.stringify({ ...saved, perfil: p }));
  }

  function logout() {
    setUser(null);
    setPerfil(null);
    localStorage.removeItem('qf_session');
  }

  return (
    <AuthContext.Provider value={{ user, perfil, loading, login, logout, selectPerfil }}>
      {!loading && children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}

