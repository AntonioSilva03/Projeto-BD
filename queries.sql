USE hospital;

DROP PROCEDURE IF EXISTS size;
DROP PROCEDURE IF EXISTS limpaTudo;
DROP PROCEDURE IF EXISTS removePaciente;
DROP PROCEDURE IF EXISTS adicionaPaciente;
DROP PROCEDURE IF EXISTS mudarMoradaPaciente;
DROP PROCEDURE IF EXISTS mudarContactoPaciente;
DROP PROCEDURE IF EXISTS getPacientes;
DROP PROCEDURE IF EXISTS removeMedico;
DROP PROCEDURE IF EXISTS adicionaMedico;
DROP PROCEDURE IF EXISTS mudarMoradaMedico;
DROP PROCEDURE IF EXISTS mudarContactoMedico;
DROP PROCEDURE IF EXISTS getMedicos;
DROP PROCEDURE IF EXISTS getMedicosEspecialidade;
DROP PROCEDURE IF EXISTS getConsultas;
DROP PROCEDURE IF EXISTS consultasPaciente;
DROP PROCEDURE IF EXISTS historicoMedicoPaciente;
DROP PROCEDURE IF EXISTS numeroConsultasEspecialidade;
DROP PROCEDURE IF EXISTS medicacaoPaciente;
DROP PROCEDURE IF EXISTS pacientesExame;
DROP VIEW consultasFuturas;

-- size: Calcula o tamanho da base de dados.

delimiter &&
CREATE PROCEDURE size()
BEGIN
	SELECT table_schema as 'Database', SUM(data_length + index_length) / (1024 * 1024) AS 'Size(MB)'
    FROM information_schema.TABLES
    WHERE table_schema = 'Hospital'
    GROUP BY table_schema;
END &&
    
-- limpaTudo: Limpa a base de dados toda

delimiter &&
CREATE PROCEDURE limpaTudo()
BEGIN
	DELETE FROM Consulta;
	DELETE FROM HistorialMedico;
	DELETE FROM Paciente;
	DELETE FROM Medico;
	DELETE FROM Especialidade;
	DELETE FROM SeguroSaude;
	DELETE FROM Medicamentos;
	DELETE FROM Exames;
	DELETE FROM Inventario;
END &&
-- removePaciente: Remove um paciente

delimiter &&
CREATE PROCEDURE removePaciente(IN idPaciente INT)
BEGIN
	DELETE FROM Paciente WHERE identificador = idPaciente; -- Seleciona o paciente que corresponte ao id atribuido.
	SELECT 'Paciente removed successfully'; -- Mensagem de sucesso.
END &&

-- adicionaPaciente: Adiciona um paciente

delimiter &&
CREATE PROCEDURE adicionaPaciente(IN nome_p VARCHAR(100), IN nascimento_p DATE, IN idade_p INT, IN genero_p CHAR, IN morada_p VARCHAR(100), IN telefone_p INT, IN email_p VARCHAR(100), IN emergencia_ INT)
BEGIN
	DECLARE last_id INT; -- Variavel que vai guardar o id atribuido ao novo paciente.
    
	INSERT INTO Paciente (nome, nascimento, idade, genero, morada, telefone, email, emergencia)
    VALUES (nome_p, nascimento_p, idade_p, genero_p, morada_p, telefone_p, email_p, emergencia_p); -- Insere o paciente novo na lista. É necessário fornecer todas as informações acerca do paciente.
    
    SET last_id = last_insert_id(); -- Retorna o id que foi atrubuído ao novo paciente.
    
    INSERT INTO HistorialMedico(idPaciente, medicamentos, diagnosticos) -- Usando o id, cria um historial médico para esse paciente.
    VALUES (last_id, '', ''); -- Insere o historial médico vazio na lista.
END &&

-- mudarMoradaPaciente: Alterar morada do paciente

delimiter &&
CREATE PROCEDURE mudarMoradaPaciente(IN id_paciente INT, IN nova_morada VARCHAR(100))
BEGIN
	UPDATE Paciente
    SET Morada = nova_morada
    WHERE identificador = id_paciente;
END &&

-- mudarContactoPaciente: Alterar contacto do paciente

delimiter &&
CREATE PROCEDURE mudarContactoPaciente(in id_paciente INT, IN novo_contacto INT)
BEGIN
	UPDATE Paciente
    SET Telefone = novo_contacto
    WHERE identificador = id_paciente;
END &&

-- getPacientes: Devolve todos os pacientes

delimiter &&
CREATE PROCEDURE getPacientes()
BEGIN
	SELECT * FROM Paciente; -- Seleciona todas as informações de todos os pacientes do hospital e mostra-os na tela.
END &&

-- removeMedico: Remove um medico

delimiter &&
CREATE PROCEDURE removeMedico(IN idMedico INT)
BEGIN
	DELETE FROM Medico WHERE identificador = idMedico; -- Procura o médico correspondente ao ID e apaga-o.
	SELECT 'Médico removed successfully';
END &&

-- adicionaMedico: Adiciona um médico

delimiter &&
CREATE PROCEDURE adicionaMedico(IN nome_m VARCHAR(100), IN idade_m INT, IN genero_m CHAR, IN morada_m VARCHAR(100), IN telefone_m INT, IN email_m VARCHAR(100), IN especialidade_m INT)
BEGIN
	INSERT INTO Medico (nome, idade, genero, morada, telefone, email, idEspecialidade)
    VALUES (nome_m, idade_m, genero_m, morada_m, telefone_m, email_m, especialidade_m); -- Insere o médico na lista. É necessário fornecer todas as informações relativas ao novo médico.
END &&

-- mudarMoradaMedico: Alterar morada do médico

delimiter &&
CREATE PROCEDURE mudarMoradaMedico(IN id_medico INT, IN nova_morada VARCHAR(100))
BEGIN
	UPDATE Medico
    SET Morada = nova_morada
    WHERE identificador = id_medico;
END &&

-- mudarContactoMedico: Alterar contacto do médico

delimiter &&
CREATE PROCEDURE mudarContactoMedico(in id_medico INT, IN novo_contacto INT)
BEGIN
	UPDATE Medico
    SET Telefone = novo_contacto
    WHERE identificador = id_medico;
END &&

-- getMedicos: Devolve todos os médicos	

delimiter &&
CREATE PROCEDURE getMedicos()
BEGIN
	SELECT * FROM Medico; -- Seleciona todas as informações de todos os médicos do hospital e mostra-os na tela.
END &&

-- getMedicosEspecialidade: Devolve médicos com a sua especialidade

delimiter &&
CREATE PROCEDURE getMedicosEspecialidade()
BEGIN
    SELECT M.nome AS Médicos, E.nome AS Especialidades -- Seleciona o nome de todos os médicos e o nome de todas as especialidades.
    FROM Medico AS M
    JOIN Especialidade AS E ON M.idEspecialidade = E.identificador; -- Junta os médicos de acordo com a sua especialidade.
END &&

-- getConsultas: Devolve todas as consultas com o médico e o paciente associados

delimiter &&
CREATE PROCEDURE getConsultas()
BEGIN
SELECT c.identificador AS Consulta, p.nome AS Patiente, m.nome AS Médico -- Seleciona todos as consultas, os pacientes e médicos.
FROM Consulta c
INNER JOIN Paciente p ON c.idPaciente = p.identificador -- Junta cada paciente à sua respetiva consulta.
INNER JOIN Medico m ON c.idMedico = m.identificador; -- Junta os médicos às suas consultas.
END &&

-- consultasPaciente: Devolve todas as consultas de um paciente

delimiter &&
CREATE PROCEDURE consultasPaciente(IN paciente INT)
BEGIN
SELECT c.identificador AS Consulta, m.nome AS Médico, e.nome AS Especialidade -- Seleciona todas as consultas, médicos e especialidades.
FROM Consulta c
INNER JOIN Medico m ON c.idMedico = m.identificador -- Junta os médicos às suas consultas.
INNER JOIN Especialidade e ON m.idEspecialidade = e.identificador -- Junta as especialidades às suas consultas.
WHERE c.idPaciente = paciente; -- Filtra para mostrar apenas as consultas do paciente pedido.
END &&

-- historicoMedicoPaciente: Devolve o historico médico de um paciente

delimiter &&
CREATE PROCEDURE historicoMedicoPaciente(IN paciente INT)
BEGIN
	SELECT h.identificador AS Historial, h.diagnosticos AS Diagnósticos, h.medicamentos AS Medicamentos -- Seleciona todos os historiais médicos, diagnósticos e medicamentos.
	FROM HistorialMedico h
	WHERE h.idPaciente = paciente; -- Filtra o que pertence ao paciente pedido.
END &&

-- numeroPacientesEspecialidade: Devolve o numero de pacientes de uma especialidade

delimiter &&
CREATE PROCEDURE numeroConsultasEspecialidade()
BEGIN
	SELECT e.nome AS Especialidade, COUNT(*) AS Contagem -- Seleciona todas as especialidades.
	FROM Medico m
	INNER JOIN Especialidade e ON m.idEspecialidade = e.identificador -- Junta os médicos à sua especialidade.
	INNER JOIN Consulta c ON m.identificador = c.idMedico
	GROUP BY e.nome;
END &&

-- medicacaoPaciente: Devolve a medicação atribuida a um específico paciente

delimiter &&
CREATE PROCEDURE medicacaoPaciente(IN id_paciente INT)
BEGIN
    SELECT H.medicamentos -- Seleciona todos os medicamentos.
    FROM HistorialMedico AS H
    JOIN Paciente AS P ON H.idPaciente = P.identificador -- Junta os medicamentos a cada paciente.
    WHERE P.identificador = id_paciente; -- Filtra apenas o paciente pedido.
END &&

-- pacientesExame: Devolve os pacientes que fizeram um exame específico

delimiter &&
CREATE PROCEDURE pacientesExame(IN tipo_exame VARCHAR(100))
BEGIN
    SELECT p.* -- Seleciona todas as informações dos pacientes.
    FROM Paciente p
    JOIN Exames e ON p.identificador = e.idPaciente -- Junta os pacientes aos seus exames.
    WHERE e.nome = tipo_exame; -- Filtra apenas os exames do tipo pedido.
END &&

CREATE VIEW consultasFuturas AS
SELECT C.identificador, C.data_consulta, P.nome AS Paciente, P.telefone AS Telefone
FROM Consulta C
JOIN Paciente P ON C.idPaciente = P.identificador
WHERE C.data_consulta >= CURDATE()
ORDER BY C.data_consulta ASC;
