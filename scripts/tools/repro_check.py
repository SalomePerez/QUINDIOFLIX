from pathlib import Path
import re
path = Path(r'c:/Users/Salome/OneDrive/Escritorio/8vo Semestre 20261/Bases de datos 2/ProyectoFinal/QUINDIOFLIX/02_dml/03_insert_data.sql')
text = path.read_text(encoding='utf-8').splitlines()
content = {}
profiles = {}
content_pattern = re.compile(r"INSERT INTO CONTENIDO \(titulo, tipo, anio_lanzamiento, duracion_min, sinopsis, clasificacion_edad, es_original, id_categoria, id_empleado_resp\) VALUES \('([^']+)', '([^']+)', (\d+), (\d+), '([^']+)', '([^']+)', '([^']+)', (\d+), (\d+)\);")
profile_pattern = re.compile(r"INSERT INTO PERFILES \(id_usuario, nombre, avatar, tipo\) VALUES \((\d+), '([^']+)', '([^']+)', '([^']+)'\);")
repro_pattern = re.compile(r"INSERT INTO REPRODUCCIONES \(id_perfil, id_contenido, (?:id_episodio, )?fecha_hora_inicio, fecha_hora_fin, dispositivo, porcentaje_avance\) VALUES \((\d+), (\d+), .*?\);$")
for line in text:
    m = content_pattern.match(line)
    if m:
        content[len(content)+1] = m.group(6)
    m = profile_pattern.match(line)
    if m:
        profiles[len(profiles)+1] = m.group(4)
for line in text:
    m = repro_pattern.match(line)
    if m:
        pid = int(m.group(1)); cid = int(m.group(2))
        if profiles.get(pid) == 'INFANTIL' and content.get(cid) in ('+16', '+18'):
            print(f'INVALID_REPRO id_perfil={pid} perfil={profiles[pid]} id_contenido={cid} clasificacion={content[cid]} line={line}')
