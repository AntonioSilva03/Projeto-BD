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
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    seguradora VARCHAR(100) NOT NULL,
    validade date NOT NULL,
    percentgem FLOAT NOT NULL
);

CREATE TABLE IF NOT EXISTS Paciente(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    nascimento date NOT NULL,
    idade INTEGER NOT NULL,
    genero char NOT NULL,
    morada VARCHAR(100) NOT NULL,
    telefone INTEGER NOT NULL,
    email VARCHAR(100) NOT NULL,
    emergencia INTEGER NOT NULL,
    id_seguro INT,
    FOREIGN KEY (id_seguro) REFERENCES SeguroSaude(identificador)
);

CREATE TABLE IF NOT EXISTS Especialidade(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Medico(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    idade INTEGER NOT NULL,
    genero char NOT NULL,
    morada VARCHAR(100) NOT NULL,
    telefone INTEGER NOT NULL,
    email VARCHAR(100) NOT NULL,
    idEspecialidade INTEGER NOT NULL,
    FOREIGN KEY (idEspecialidade) REFERENCES Especialidade(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Consulta(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    data_consulta DATE NOT NULL,
    idMedico INTEGER NOT NULL,
    idPaciente INTEGER NOT NULL,
    FOREIGN KEY (idMedico) REFERENCES Medico(identificador) ON DELETE CASCADE,
    FOREIGN KEY (idPaciente) REFERENCES Paciente(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Medicamentos(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    idConsulta INT NOT NULL,
    FOREIGN KEY (idConsulta) REFERENCES Consulta(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Inventario(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Exames(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(1000) NOT NULL,
    idPaciente INTEGER NOT NULL,
    idInventario INT NOT NULL,
    idConsulta INT NOT NULL,
    FOREIGN KEY (idInventario) REFERENCES Inventario(identificador) ON DELETE CASCADE,
    FOREIGN KEY (idConsulta) REFERENCES Consulta(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS HistorialMedico(
	identificador INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
	idPaciente INTEGER NOT NULL,
    medicamentos VARCHAR(100),
    diagnosticos VARCHAR(100),
    FOREIGN KEY (idPaciente) REFERENCES Paciente(identificador) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ConsultaHistorial(
	idConsulta INT NOT NULL,
    FOREIGN KEY (idConsulta) REFERENCES Consulta(identificador) ON DELETE CASCADE,
    idHistorial INT NOT NULL,
    FOREIGN KEY (idHistorial) REFERENCES HistorialMedico(identificador) ON DELETE CASCADE,
    atualizacao VARCHAR(100) NOT NULL
);
