CREATE TABLE recebimentos (
    id_recebimento INT PRIMARY KEY AUTO_INCREMENT,
    id_fornecedor INT,
    data_recebimento DATETIME,
    numero_nf VARCHAR(20),
    status_conferencia VARCHAR(30),
    observacoes TEXT,

    FOREIGN KEY (id_fornecedor)
    REFERENCES fornecedores(id_fornecedor)
);