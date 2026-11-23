CREATE TABLE estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    quantidade_atual INT,
    localizacao VARCHAR(50),
    ultima_movimentacao DATETIME,

    FOREIGN KEY (id_produto)
    REFERENCES produtos(id_produto)
);