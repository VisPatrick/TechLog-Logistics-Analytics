-- Estoque consolidado por produto, somando todas as localizacoes.
-- Mantem os nomes das colunas da consulta original.
SELECT
    p.nome_produto,
    COALESCE(SUM(e.quantidade_atual), 0) AS quantidade_atual,
    p.estoque_minimo
FROM produtos AS p
LEFT JOIN estoque AS e
    ON e.id_produto = p.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto,
    p.estoque_minimo
HAVING COALESCE(SUM(e.quantidade_atual), 0) <= p.estoque_minimo
ORDER BY p.nome_produto;
