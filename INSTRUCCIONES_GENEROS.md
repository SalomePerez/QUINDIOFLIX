# Instrucciones para Agregar Géneros a los Contenidos

## Problema Identificado

Algunos contenidos en la base de datos no tienen géneros asignados en la tabla `CONTENIDO_GENEROS`. Esto causa que cuando se visualiza el detalle de un contenido, no se muestren los géneros a los que pertenece.

## Solución

Se han creado dos scripts SQL para solucionar este problema:

### 1. Script de Verificación
**Archivo:** `02_dml/04_agregar_generos_faltantes.sql`

Este script te permite:
- Ver qué contenidos no tienen géneros asignados
- Verificar cuántos contenidos tienen y no tienen géneros

### 2. Script de Asignación Automática
**Archivo:** `02_dml/05_asignar_generos_automatico.sql`

Este script asigna automáticamente géneros a todos los contenidos que no tienen ninguno, basándose en su tipo:
- **PELICULA** → Acción (id_genero=1)
- **SERIE** → Drama (id_genero=3)
- **DOCUMENTAL** → Documental (id_genero=10)
- **MUSICA** → Musical (id_genero=9)
- **PODCAST** → Documental (id_genero=10)

## Cómo Ejecutar

### Opción 1: Usando SQL Developer o SQL*Plus

1. Conéctate a la base de datos como usuario QUINDIOFLIX
2. Ejecuta el script de asignación automática:
   ```sql
   @02_dml/05_asignar_generos_automatico.sql
   ```

### Opción 2: Copiar y pegar en tu cliente SQL

1. Abre el archivo `02_dml/05_asignar_generos_automatico.sql`
2. Copia todo el contenido
3. Pégalo en tu cliente SQL (SQL Developer, DBeaver, etc.)
4. Ejecuta el script

## Verificación

Después de ejecutar el script, verifica que todos los contenidos tengan géneros:

```sql
SELECT 
    COUNT(DISTINCT c.id_contenido) AS total_contenidos,
    COUNT(DISTINCT cg.id_contenido) AS contenidos_con_genero
FROM CONTENIDO c
LEFT JOIN CONTENIDO_GENEROS cg ON c.id_contenido = cg.id_contenido;
```

Los dos números deberían ser iguales.

## Personalización de Géneros

Si deseas asignar géneros más específicos a ciertos contenidos, puedes hacerlo manualmente después de ejecutar el script automático:

```sql
-- Ejemplo: Agregar género "Ciencia Ficción" al contenido ID 61
INSERT INTO CONTENIDO_GENEROS VALUES (61, 6);  -- 6 = Ciencia Ficción

-- Ejemplo: Agregar género "Aventura" al contenido ID 61
INSERT INTO CONTENIDO_GENEROS VALUES (61, 12); -- 12 = Aventura

COMMIT;
```

## Géneros Disponibles

| ID | Nombre |
|----|--------|
| 1  | Acción |
| 2  | Comedia |
| 3  | Drama |
| 4  | Suspenso |
| 5  | Romance |
| 6  | Ciencia Ficción |
| 7  | Terror |
| 8  | Infantil |
| 9  | Musical |
| 10 | Documental |
| 11 | Thriller |
| 12 | Aventura |

## Resultado Esperado

Después de ejecutar el script y recargar la página del contenido en el frontend, deberías ver una sección de "Géneros" con etiquetas visuales mostrando los géneros a los que pertenece cada contenido.

![Ejemplo de visualización de géneros](https://via.placeholder.com/600x200?text=G%C3%A9neros:+Aventura,+Ciencia+Ficci%C3%B3n)
