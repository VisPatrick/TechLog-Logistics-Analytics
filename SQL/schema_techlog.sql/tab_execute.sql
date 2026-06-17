CREATE TABLE itens_expedicao (
    id_item_expedicao INT PRIMARY KEY AUTO_INCREMENT,
    id_expedicao INT,
    id_produto INT,
    quantidade_enviada INT,
    valor_unitario DECIMAL(10,2),

    FOREIGN KEY (id_expedicao)
    REFERENCES expedicoes(id_expedicao),

    FOREIGN KEY (id_produto)
    REFERENCES produtos(id_produto)
);