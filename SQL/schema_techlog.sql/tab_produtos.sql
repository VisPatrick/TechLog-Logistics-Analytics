CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100),
    id_categoria INT,
    codigo_barras VARCHAR(50),
    peso DECIMAL(10,2),
    valor_unitario DECIMAL(10,2),
    estoque_minimo INT,
    unidade_medida VARCHAR(20),

    FOREIGN KEY (id_categoria)
    REFERENCES categorias(id_categoria)
);