import mysql.connector

config = {
    'user': 'root',
    'password': '',
    'host': 'localhost',
    'database': 'Hospital',
}

files = [
    {'name': 'Paciente.txt', 'table': 'Paciente'},
    {'name': 'Especialidade.txt', 'table': 'Especialidade'},
    {'name': 'Medico.txt', 'table': 'Medico'},
    {'name': 'Consulta.txt', 'table': 'Consulta'},
    {'name': 'SeguroSaude.txt', 'table': 'SeguroSaude'},
    {'name': 'Medicamentos.txt', 'table': 'Medicamentos'},
    {'name': 'Exames.txt', 'table': 'Exames'},
    {'name': 'Inventario.txt', 'table': 'Inventario'},
    {'name': 'HistorialMedico.txt', 'table': 'HistorialMedico'},
]

connection = mysql.connector.connect(**config)
cursor = connection.cursor()

def import_data(file_path, table_name):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        lines = [line.strip(',') for line in lines]
        query = f"INSERT INTO {table_name} VALUES {''.join(lines)}"
        cursor.execute(query)
        connection.commit()

for file in files:
    file_name = file['name']
    table_name = file['table']
    file_path = f"path/to/file/data/{file_name}"
    import_data(file_path, table_name)

cursor.close()
connection.close()