-- Migration 001: cria as views analiticas sem alterar tabelas ou colunas existentes.
-- Banco-alvo: MySQL 8.0+
-- Execucao: aplicar uma vez no banco techlog_logistica.
-- Compatibilidade: preserva os nomes de colunas usados pelas consultas atuais.

USE techlog_logistica;

CREATE OR REPLACE VIEW vw_avarias AS
SELECT
    p.nome_produto,
    SUM(COALESCE(ir.quantidade_avariada, 0)) AS total_avarias
FROM produtos AS p
LEFT JOIN itens_recebimento AS ir
    ON ir.id_produto = p.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto;

CREATE OR REPLACE VIEW vw_lead_time AS
SELECT
    e.numero_pedido,
    e.data_saida,
    e.data_entrega,
    CASE
        WHEN e.data_saida IS NULL OR e.data_entrega IS NULL THEN NULL
        ELSE DATEDIFF(e.data_entrega, e.data_saida)
    END AS lead_time_dias
FROM expedicoes AS e;

CREATE OR REPLACE VIEW vw_produtos_expedidos AS
SELECT
    p.nome_produto,
    SUM(ie.quantidade_enviada) AS total_saida
FROM itens_expedicao AS ie
INNER JOIN produtos AS p
    ON p.id_produto = ie.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto;
