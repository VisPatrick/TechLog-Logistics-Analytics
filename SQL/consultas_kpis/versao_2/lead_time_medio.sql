-- Media calculada somente para expedicoes com saida e entrega registradas.
SELECT
    AVG(DATEDIFF(e.data_entrega, e.data_saida)) AS lead_time_medio
FROM expedicoes AS e
WHERE e.data_saida IS NOT NULL
  AND e.data_entrega IS NOT NULL;
