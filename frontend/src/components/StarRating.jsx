import { Star } from 'lucide-react';

export default function StarRating({ value = 0, onChange, readonly = false, size = 'md' }) {
  const sizes = { 
    sm: 18, 
    md: 24, 
    lg: 32 
  };

  return (
    <div className="flex gap-1">
      {[1, 2, 3, 4, 5].map(star => (
        <button
          key={star}
          type="button"
          disabled={readonly}
          onClick={() => !readonly && onChange && onChange(star)}
          className={`transition-all ${!readonly ? 'hover:scale-110 cursor-pointer' : 'cursor-default'}`}
          aria-label={`${star} estrella${star > 1 ? 's' : ''}`}
        >
          <Star
            size={sizes[size]}
            className={`transition-colors ${
              star <= value 
                ? 'fill-yellow-400 text-yellow-400' 
                : 'fill-transparent text-gray-600'
            }`}
            strokeWidth={1.5}
          />
        </button>
      ))}
    </div>
  );
}

