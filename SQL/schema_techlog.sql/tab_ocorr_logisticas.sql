CREATE TABLE ocorrencias_logisticas (
    id_ocorrencia INT PRIMARY KEY AUTO_INCREMENT,
    tipo_ocorrencia VARCHAR(50),
    descricao TEXT,
    data_ocorrencia DATETIME,
    setor VARCHAR(50),
    status_ocorrencia VARCHAR(30)
);