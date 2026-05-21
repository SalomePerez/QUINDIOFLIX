import { useState } from 'react';
import { Upload, CheckCircle, XCircle, Loader } from 'lucide-react';
import api from '../api/axios';

export default function FileUploader({ 
  contenidoId, 
  episodioId, 
  currentUrl, 
  onSuccess, 
  tipo 
}) {
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState(0);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  const isVideo = tipo === 'PELICULA' || tipo === 'SERIE' || tipo === 'DOCUMENTAL';
  const acceptedTypes = isVideo 
    ? 'video/mp4,video/mpeg,video/quicktime,video/x-msvideo,video/webm'
    : 'audio/mpeg,audio/mp3,audio/wav,audio/ogg,audio/webm';

  async function handleFileSelect(e) {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validar tamaño (máx 500MB)
    if (file.size > 500 * 1024 * 1024) {
      setError('El archivo es demasiado grande. Máximo 500MB.');
      return;
    }

    setUploading(true);
    setError('');
    setMessage('');
    setProgress(0);

    const formData = new FormData();
    formData.append('archivo', file);

    try {
      const endpoint = episodioId 
        ? `/upload/episodio/${episodioId}`
        : `/upload/contenido/${contenidoId}`;

      const { data } = await api.post(endpoint, formData, {
        onUploadProgress: (progressEvent) => {
          const percentCompleted = Math.round(
            (progressEvent.loaded * 100) / progressEvent.total
          );
          setProgress(percentCompleted);
        }
      });

      setMessage('Archivo subido exitosamente');
      setProgress(100);
      
      if (onSuccess) {
        onSuccess(data.url_archivo);
      }

      // Limpiar mensaje después de 3 segundos
      setTimeout(() => {
        setMessage('');
        setProgress(0);
      }, 3000);
    } catch (err) {
      setError(err.response?.data?.error || 'Error al subir archivo');
      setProgress(0);
    } finally {
      setUploading(false);
      // Limpiar el input
      e.target.value = '';
    }
  }

  async function handleDelete() {
    if (!confirm('¿Estás seguro de eliminar este archivo?')) return;

    try {
      await api.delete(`/upload/contenido/${contenidoId}`);
      setMessage('Archivo eliminado');
      if (onSuccess) {
        onSuccess(null);
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Error al eliminar archivo');
    }
  }

  return (
    <div className="bg-gray-800 rounded-lg p-4">
      <h3 className="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3">
        Archivo Multimedia
      </h3>

      {currentUrl ? (
        <div className="space-y-3">
          <div className="flex items-center gap-2 text-sm text-green-400">
            <CheckCircle size={16} />
            <span>Archivo cargado</span>
          </div>
          <div className="bg-gray-700 rounded px-3 py-2 text-xs text-gray-300 break-all">
            {currentUrl}
          </div>
          <div className="flex gap-2">
            <label className="flex-1 bg-blue-600 hover:bg-blue-700 px-4 py-2 rounded-lg text-sm text-center cursor-pointer transition">
              Reemplazar Archivo
              <input
                type="file"
                accept={acceptedTypes}
                onChange={handleFileSelect}
                disabled={uploading}
                className="hidden"
              />
            </label>
            <button
              onClick={handleDelete}
              className="bg-red-600 hover:bg-red-700 px-4 py-2 rounded-lg text-sm transition"
            >
              Eliminar
            </button>
          </div>
        </div>
      ) : (
        <div>
          <label className="block w-full border-2 border-dashed border-gray-600 rounded-lg p-6 text-center cursor-pointer hover:border-brand transition">
            <Upload size={32} className="mx-auto mb-2 text-gray-500" />
            <p className="text-sm text-gray-400 mb-1">
              {uploading ? 'Subiendo...' : 'Haz clic para seleccionar archivo'}
            </p>
            <p className="text-xs text-gray-500">
              {isVideo ? 'MP4, MPEG, MOV, AVI, WEBM' : 'MP3, WAV, OGG, WEBM'} (máx 500MB)
            </p>
            <input
              type="file"
              accept={acceptedTypes}
              onChange={handleFileSelect}
              disabled={uploading}
              className="hidden"
            />
          </label>
        </div>
      )}

      {/* Barra de progreso */}
      {uploading && (
        <div className="mt-3">
          <div className="flex items-center justify-between text-xs text-gray-400 mb-1">
            <span>Subiendo...</span>
            <span>{progress}%</span>
          </div>
          <div className="w-full h-2 bg-gray-700 rounded-full overflow-hidden">
            <div 
              className="h-full bg-brand transition-all duration-300"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>
      )}

      {/* Mensajes */}
      {message && (
        <div className="mt-3 flex items-center gap-2 text-sm text-green-400">
          <CheckCircle size={16} />
          {message}
        </div>
      )}

      {error && (
        <div className="mt-3 flex items-center gap-2 text-sm text-red-400">
          <XCircle size={16} />
          {error}
        </div>
      )}
    </div>
  );
}
