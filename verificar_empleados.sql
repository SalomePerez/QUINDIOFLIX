-- Verificar si hay empleados en la base de datos
SELECT COUNT(*) AS total_empleados FROM EMPLEADOS WHERE activo = 'S';

-- Ver los primeros 10 empleados
SELECT e.id_empleado, e.nombre, e.apellido, e.cargo, d.nombre AS departamento
FROM EMPLEADOS e
JOIN DEPARTAMENTOS d ON e.id_departamento = d.id_departamento
WHERE e.activo = 'S'
ORDER BY e.nombre, e.apellido
FETCH FIRST 10 ROWS ONLY;

-- Verificar departamentos
SELECT * FROM DEPARTAMENTOS ORDER BY nombre;
