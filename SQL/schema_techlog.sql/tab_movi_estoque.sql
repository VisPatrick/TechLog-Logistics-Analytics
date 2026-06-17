CREATE TABLE movimentacao_estoque (
    id_movimentacao INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    tipo_movimentacao VARCHAR(20),
    quantidade INT,
    data_movimentacao DATETIME,
    origem VARCHAR(50),
    destino VARCHAR(50),

    FOREIGN KEY (id_produto)
    REFERENCES produtos(id_produto)
);