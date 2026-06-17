SELECT
    numero_pedido,
    status_entrega
FROM expedicoes
WHERE status_entrega = 'Atrasado';