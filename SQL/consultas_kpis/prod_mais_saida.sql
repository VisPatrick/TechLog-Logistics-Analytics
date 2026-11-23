SELECT
    p.nome_produto,
    SUM(ie.quantidade_enviada) AS total_saida
FROM itens_expedicao ie
JOIN produtos p
ON ie.id_produto = p.id_produto
GROUP BY p.nome_produto
ORDER BY total_saida DESC;