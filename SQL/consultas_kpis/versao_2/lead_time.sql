-- Lead time por expedicao.
-- Expedicoes ainda nao entregues permanecem no resultado com lead_time_dias NULL.
SELECT
    e.numero_pedido,
    e.data_saida,
    e.data_entrega,
    CASE
        WHEN e.data_saida IS NULL OR e.data_entrega IS NULL THEN NULL
        ELSE DATEDIFF(e.data_entrega, e.data_saida)
    END AS lead_time_dias
FROM expedicoes AS e
ORDER BY e.data_saida, e.numero_pedido;
