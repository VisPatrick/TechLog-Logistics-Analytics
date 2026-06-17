SELECT
    AVG(DATEDIFF(data_entrega, data_saida)) AS lead_time_medio
FROM expedicoes;