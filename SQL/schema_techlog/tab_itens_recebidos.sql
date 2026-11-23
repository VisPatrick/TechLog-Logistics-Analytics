CREATE TABLE itens_recebimento (
    id_item_recebimento INT PRIMARY KEY AUTO_INCREMENT,
    id_recebimento INT,
    id_produto INT,
    quantidade_recebida INT,
    quantidade_avariada INT,
    valor_unitario DECIMAL(10,2),

    FOREIGN KEY (id_recebimento)
    REFERENCES recebimentos(id_recebimento),

    FOREIGN KEY (id_produto)
    REFERENCES produtos(id_produto)
);