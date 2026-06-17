SELECT
    numero_pedido,
    data_saida,
    data_entrega,
    DATEDIFF(data_entrega, data_saida) AS lead_time_dias
FROM expedicoes;