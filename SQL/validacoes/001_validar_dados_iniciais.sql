-- Validacao 001: diagnosticos de integridade para a carga inicial.
-- Este arquivo e somente leitura: nao insere, atualiza ou exclui dados.
-- Banco-alvo: MySQL 8.0+

USE techlog_logistica;

-- 1. Categorias referenciadas pelos produtos, mas ainda nao cadastradas.
SELECT
    p.id_categoria,
    COUNT(*) AS produtos_referenciando
FROM produtos AS p
LEFT JOIN categorias AS c
    ON c.id_categoria = p.id_categoria
WHERE c.id_categoria IS NULL
GROUP BY p.id_categoria
ORDER BY p.id_categoria;

-- 2. Produtos com campos essenciais vazios ou valores fora do esperado.
SELECT
    id_produto,
    nome_produto,
    id_categoria,
    peso,
    valor_unitario,
    estoque_minimo
FROM produtos
WHERE nome_produto IS NULL
   OR TRIM(nome_produto) = ''
   OR id_categoria IS NULL
   OR peso < 0
   OR valor_unitario < 0
   OR estoque_minimo < 0;

-- 3. Linhas de estoque com quantidades negativas ou sem produto.
SELECT
    e.id_estoque,
    e.id_produto,
    e.quantidade_atual,
    e.localizacao
FROM estoque AS e
LEFT JOIN produtos AS p
    ON p.id_produto = e.id_produto
WHERE p.id_produto IS NULL
   OR e.quantidade_atual < 0;

-- 4. Estoque consolidado por produto (soma todas as localizacoes).
SELECT
    p.id_produto,
    p.nome_produto,
    COALESCE(SUM(e.quantidade_atual), 0) AS quantidade_total,
    p.estoque_minimo,
    CASE
        WHEN COALESCE(SUM(e.quantidade_atual), 0) <= p.estoque_minimo
            THEN 'BAIXO'
        ELSE 'OK'
    END AS situacao_estoque
FROM produtos AS p
LEFT JOIN estoque AS e
    ON e.id_produto = p.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto,
    p.estoque_minimo
ORDER BY p.id_produto;

-- 5. Produtos com nomes repetidos (o agrupamento analitico deve usar o ID).
SELECT
    nome_produto,
    COUNT(*) AS quantidade_registros
FROM produtos
GROUP BY nome_produto
HAVING COUNT(*) > 1;

-- 6. Itens de recebimento com quantidades inconsistentes.
SELECT
    id_item_recebimento,
    id_recebimento,
    id_produto,
    quantidade_recebida,
    quantidade_avariada
FROM itens_recebimento
WHERE quantidade_recebida < 0
   OR quantidade_avariada < 0
   OR quantidade_avariada > quantidade_recebida;

-- 7. Itens de expedicao com quantidades ou valores invalidos.
SELECT
    id_item_expedicao,
    id_expedicao,
    id_produto,
    quantidade_enviada,
    valor_unitario
FROM itens_expedicao
WHERE quantidade_enviada < 0
   OR valor_unitario < 0;

-- 8. Conferencia de IDs explicitamente usados nos scripts de carga.
SELECT
    id_produto,
    nome_produto,
    id_categoria
FROM produtos
WHERE id_produto BETWEEN 40 AND 47
ORDER BY id_produto;

SELECT
    id_produto,
    quantidade_atual,
    localizacao
FROM estoque
WHERE id_produto BETWEEN 40 AND 47
ORDER BY id_produto, localizacao;
