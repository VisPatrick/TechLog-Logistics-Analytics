CREATE TABLE expedicoes (
    id_expedicao INT PRIMARY KEY AUTO_INCREMENT,
    id_transportadora INT,
    data_saida DATETIME,
    data_entrega DATETIME,
    status_entrega VARCHAR(30),
    numero_pedido VARCHAR(30),
    observacoes TEXT,

    FOREIGN KEY (id_transportadora)
    REFERENCES transportadoras(id_transportadora)
);