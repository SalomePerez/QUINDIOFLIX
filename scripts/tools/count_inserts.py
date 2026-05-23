from pathlib import Path
base = Path(r'c:\Users\Salome\OneDrive\Escritorio\8vo Semestre 20261\Bases de datos 2\ProyectoFinal\QUINDIOFLIX')
files = [base / '02_dml' / '03_insert_data.sql', base / '02_dml' / '03b_insert_data_resto.sql']
text = ''.join(path.read_text(encoding='utf-8') for path in files)
for table in ['PLANES','CATEGORIAS','GENEROS','DEPARTAMENTOS','EMPLEADOS','JEFES_DEPARTAMENTO','TEMPORADAS','CONTENIDO_RELACIONADO','REPORTES','HISTORIAL_PLANES']:
    count = text.count(f'INSERT INTO {table}')
    print(f'{table}: {count}')
