import { useEffect, useRef, useState } from 'react';
import { Play, Pause, Volume2, VolumeX, Maximize, RotateCcw } from 'lucide-react';

export default function MediaPlayer({ 
  url, 
  tipo, 
  onProgress, 
  onStart, 
  onEnd,
  autoPlay = false 
}) {
  const mediaRef = useRef(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [volume, setVolume] = useState(1);
  const [isMuted, setIsMuted] = useState(false);
  const [progress, setProgress] = useState(0);

  const isVideo = tipo === 'PELICULA' || tipo === 'SERIE' || tipo === 'DOCUMENTAL';
  const isAudio = tipo === 'MUSICA' || tipo === 'PODCAST';

  useEffect(() => {
    const media = mediaRef.current;
    if (!media) return;

    const handleLoadedMetadata = () => {
      setDuration(media.duration);
    };

    const handleTimeUpdate = () => {
      setCurrentTime(media.currentTime);
      const prog = (media.currentTime / media.duration) * 100;
      setProgress(prog);
      
      // Notificar progreso cada 5 segundos
      if (Math.floor(media.currentTime) % 5 === 0 && onProgress) {
        onProgress(prog);
      }
    };

    const handlePlay = () => {
      setIsPlaying(true);
      if (onStart) onStart();
    };

    const handlePause = () => {
      setIsPlaying(false);
    };

    const handleEnded = () => {
      setIsPlaying(false);
      if (onEnd) onEnd();
    };

    media.addEventListener('loadedmetadata', handleLoadedMetadata);
    media.addEventListener('timeupdate', handleTimeUpdate);
    media.addEventListener('play', handlePlay);
    media.addEventListener('pause', handlePause);
    media.addEventListener('ended', handleEnded);

    return () => {
      media.removeEventListener('loadedmetadata', handleLoadedMetadata);
      media.removeEventListener('timeupdate', handleTimeUpdate);
      media.removeEventListener('play', handlePlay);
      media.removeEventListener('pause', handlePause);
      media.removeEventListener('ended', handleEnded);
    };
  }, [onProgress, onStart, onEnd]);

  const togglePlay = () => {
    const media = mediaRef.current;
    if (!media) return;

    if (isPlaying) {
      media.pause();
    } else {
      media.play();
    }
  };

  const handleSeek = (e) => {
    const media = mediaRef.current;
    if (!media) return;

    const rect = e.currentTarget.getBoundingClientRect();
    const pos = (e.clientX - rect.left) / rect.width;
    media.currentTime = pos * duration;
  };

  const handleVolumeChange = (e) => {
    const newVolume = parseFloat(e.target.value);
    setVolume(newVolume);
    if (mediaRef.current) {
      mediaRef.current.volume = newVolume;
    }
    setIsMuted(newVolume === 0);
  };

  const toggleMute = () => {
    const media = mediaRef.current;
    if (!media) return;

    if (isMuted) {
      media.volume = volume || 0.5;
      setIsMuted(false);
    } else {
      media.volume = 0;
      setIsMuted(true);
    }
  };

  const toggleFullscreen = () => {
    const media = mediaRef.current;
    if (!media) return;

    if (document.fullscreenElement) {
      document.exitFullscreen();
    } else {
      media.requestFullscreen();
    }
  };

  const restart = () => {
    const media = mediaRef.current;
    if (!media) return;
    media.currentTime = 0;
    media.play();
  };

  const formatTime = (seconds) => {
    if (isNaN(seconds)) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  if (!url) {
    return (
      <div className="bg-gray-800 rounded-xl p-12 text-center">
        <Play size={64} className="mx-auto mb-4 text-gray-600" />
        <p className="text-gray-400 text-lg mb-2">No hay archivo multimedia disponible</p>
        <p className="text-gray-500 text-sm">
          El administrador debe subir el archivo de video o audio para este contenido
        </p>
      </div>
    );
  }

  return (
    <div className="bg-gray-900 rounded-xl overflow-hidden">
      {/* Reproductor */}
      <div className="relative bg-black">
        {isVideo ? (
          <video
            ref={mediaRef}
            src={`http://localhost:3001${url}`}
            className="w-full aspect-video"
            autoPlay={autoPlay}
            controls={false}
          />
        ) : (
          <div className="w-full aspect-video flex items-center justify-center bg-gradient-to-br from-brand/20 to-purple-600/20">
            <div className="text-center">
              <Volume2 size={80} className="mx-auto mb-4 text-brand" />
              <p className="text-white text-xl font-semibold mb-2">Reproduciendo Audio</p>
              <p className="text-gray-400">{formatTime(currentTime)} / {formatTime(duration)}</p>
            </div>
            <audio
              ref={mediaRef}
              src={`http://localhost:3001${url}`}
              autoPlay={autoPlay}
              className="hidden"
            />
          </div>
        )}
      </div>

      {/* Controles */}
      <div className="bg-gray-800 p-4">
        {/* Barra de progreso */}
        <div 
          className="w-full h-2 bg-gray-700 rounded-full mb-4 cursor-pointer relative group"
          onClick={handleSeek}
        >
          <div 
            className="h-full bg-brand rounded-full transition-all"
            style={{ width: `${progress}%` }}
          />
          <div 
            className="absolute top-1/2 -translate-y-1/2 w-4 h-4 bg-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
            style={{ left: `${progress}%`, transform: 'translate(-50%, -50%)' }}
          />
        </div>

        <div className="flex items-center justify-between">
          {/* Controles izquierda */}
          <div className="flex items-center gap-4">
            <button
              onClick={togglePlay}
              className="w-10 h-10 rounded-full bg-brand hover:bg-brand-dark flex items-center justify-center transition"
            >
              {isPlaying ? <Pause size={20} fill="white" /> : <Play size={20} fill="white" />}
            </button>
            
            <button
              onClick={restart}
              className="w-8 h-8 rounded-full bg-gray-700 hover:bg-gray-600 flex items-center justify-center transition"
              title="Reiniciar"
            >
              <RotateCcw size={16} />
            </button>

            <span className="text-sm text-gray-400">
              {formatTime(currentTime)} / {formatTime(duration)}
            </span>
          </div>

          {/* Controles derecha */}
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2">
              <button onClick={toggleMute} className="text-gray-400 hover:text-white transition">
                {isMuted ? <VolumeX size={20} /> : <Volume2 size={20} />}
              </button>
              <input
                type="range"
                min="0"
                max="1"
                step="0.01"
                value={isMuted ? 0 : volume}
                onChange={handleVolumeChange}
                className="w-20 h-1 bg-gray-700 rounded-full appearance-none cursor-pointer
                           [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-3 
                           [&::-webkit-slider-thumb]:h-3 [&::-webkit-slider-thumb]:rounded-full 
                           [&::-webkit-slider-thumb]:bg-white"
              />
            </div>

            {isVideo && (
              <button
                onClick={toggleFullscreen}
                className="text-gray-400 hover:text-white transition"
                title="Pantalla completa"
              >
                <Maximize size={20} />
              </button>
            )}
          </div>
        </div>

        {/* Indicador de progreso */}
        <div className="mt-3 text-xs text-gray-500 text-center">
          Progreso: {Math.round(progress)}%
        </div>
      </div>
    </div>
  );
}
