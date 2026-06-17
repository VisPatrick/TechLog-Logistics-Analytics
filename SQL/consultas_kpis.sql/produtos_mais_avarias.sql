SELECT
    p.nome_produto,
    SUM(ir.quantidade_avariada) AS total_avarias
FROM itens_recebimento ir
JOIN produtos p
ON ir.id_produto = p.id_produto
GROUP BY p.nome_produto
ORDER BY total_avarias DESC;