-- Consulta pedidos explicitamente marcados como atrasados.
-- Nao infere atraso por prazo porque o modelo atual nao possui data_prometida.
SELECT
    e.numero_pedido,
    e.status_entrega
FROM expedicoes AS e
WHERE UPPER(TRIM(e.status_entrega)) = 'ATRASADO'
ORDER BY e.data_saida, e.numero_pedido;
