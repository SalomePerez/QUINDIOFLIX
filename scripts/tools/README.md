# Scripts de utilidad

Este directorio contiene utilidades de soporte para el proyecto.

Archivos:
- `count_inserts.py`: cuenta los `INSERT INTO` por tabla dentro de los scripts SQL de datos.
- `profile_map.py`: mapea perfiles y usuarios para análisis de datos.
- `repro_check.py`: valida reglas de reproducción y detecta inconsistencias.
- `simulate_post_calificar.js`: simula peticiones POST para calificar contenido.
- `simulate_play_and_rate.js`: simula reproducciones y votaciones de contenido.

Uso:
```bash
python scripts/tools/count_inserts.py
node scripts/tools/simulate_play_and_rate.js
```
