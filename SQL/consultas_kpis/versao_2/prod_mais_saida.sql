-- Agrupa pelo identificador do produto para evitar juntar nomes repetidos.
-- Mantem os nomes das colunas da consulta original.
SELECT
    p.nome_produto,
    SUM(ie.quantidade_enviada) AS total_saida
FROM itens_expedicao AS ie
INNER JOIN produtos AS p
    ON p.id_produto = ie.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto
ORDER BY total_saida DESC;
