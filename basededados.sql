CREATE SCHEMA IF NOT EXISTS hospital;

USE hospital;

DROP TABLE IF EXISTS ConsultaHistorial;
DROP TABLE IF EXISTS HistorialMedico;
DROP TABLE IF EXISTS Medicamentos;
DROP TABLE IF EXISTS Exames;
DROP TABLE IF EXISTS Consulta;
DROP TABLE IF EXISTS Paciente;
DROP TABLE IF EXISTS Medico;
DROP TABLE IF EXISTS Especialidade;
DROP TABLE IF EXISTS SeguroSaude;
DROP TABLE IF EXISTS Inventario;

CREATE TABLE IF NOT EXISTS SeguroSaude(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    seguradora VARCHAR(100),
    validade date,
    percentgem FLOAT
);

CREATE TABLE IF NOT EXISTS Paciente(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    nascimento date,
    idade INTEGER,
    genero char,
    morada VARCHAR(100),
    telefone INTEGER,
    email VARCHAR(100),
    emergencia INTEGER,
    id_seguro INT,
    FOREIGN KEY (id_seguro) REFERENCES SeguroSaude(identificador)
);

CREATE TABLE IF NOT EXISTS Especialidade(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Medico(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    idade INTEGER,
    genero char,
    morada VARCHAR(100),
    telefone INTEGER,
    email VARCHAR(100),
    idEspecialidade INTEGER,
    FOREIGN KEY (idEspecialidade) REFERENCES Especialidade(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Consulta(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    data_consulta DATE,
    idMedico INTEGER,
    idPaciente INTEGER,
    FOREIGN KEY (idMedico) REFERENCES Medico(identificador) ON DELETE CASCADE,
    FOREIGN KEY (idPaciente) REFERENCES Paciente(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Medicamentos(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    idConsulta INT,
    FOREIGN KEY (idConsulta) REFERENCES Consulta(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Inventario(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Exames(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    descricao VARCHAR(1000),
    idPaciente INTEGER,
    idInventario INT,
    idConsulta INT,
    FOREIGN KEY (idInventario) REFERENCES Inventario(identificador) ON DELETE CASCADE,
    FOREIGN KEY (idConsulta) REFERENCES Consulta(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS HistorialMedico(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT,
	idPaciente INTEGER,
    medicamentos VARCHAR(100),
    diagnosticos VARCHAR(100),
    FOREIGN KEY (idPaciente) REFERENCES Paciente(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ConsultaHistorial(
	idConsulta INT,
    FOREIGN KEY (idConsulta) REFERENCES Consulta(identificador) ON DELETE CASCADE,
    idHistorial INT,
    FOREIGN KEY (idHistorial) REFERENCES HistorialMedico(identificador) ON DELETE CASCADE,
    atualizacao VARCHAR(100)
);
