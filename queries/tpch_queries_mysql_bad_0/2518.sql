SELECT ORDERS.O_ORDERSTATUS, MAX(ORDERS.O_ORDERPRIORITY) FROM ORDERS GROUP BY ORDERS.O_ORDERSTATUS HAVING MAX(ORDERS.O_ORDERPRIORITY) != '5-LOW          ' ORDER BY MAX(ORDERS.O_ORDERPRIORITY) DESC;
