-- Agrupa pelo identificador do produto para evitar juntar nomes repetidos.
SELECT
    p.nome_produto,
    SUM(ir.quantidade_avariada) AS total_avarias
FROM itens_recebimento AS ir
INNER JOIN produtos AS p
    ON p.id_produto = ir.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto
ORDER BY total_avarias DESC;
