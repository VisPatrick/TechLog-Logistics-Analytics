SELECT
    p.nome_produto,
    e.quantidade_atual,
    p.estoque_minimo
FROM estoque e
JOIN produtos p
ON e.id_produto = p.id_produto
WHERE e.quantidade_atual <= p.estoque_minimo;