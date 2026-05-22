from pathlib import Path
import re
p = Path(r'c:/Users/Salome/OneDrive/Escritorio/8vo Semestre 20261/Bases de datos 2/ProyectoFinal/QUINDIOFLIX/02_dml/03_insert_data.sql')
text = p.read_text(encoding='utf-8').splitlines()
pattern = re.compile(r"INSERT INTO PERFILES \(id_usuario, nombre, avatar, tipo\) VALUES \((\d+), '([^']+)', '([^']+)', '([^']+)'\);$")
profiles = []
for line in text:
    m = pattern.match(line)
    if m:
        profiles.append((len(profiles)+1, int(m.group(1)), m.group(2), m.group(4)))
for pid, uid, nombre, tipo in profiles[:30]:
    print(pid, uid, nombre, tipo)
print('...')
for pid, uid, nombre, tipo in profiles[20:30]:
    print(pid, uid, nombre, tipo)
