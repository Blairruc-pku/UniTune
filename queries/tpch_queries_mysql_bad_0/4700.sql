SELECT ORDERS.O_ORDERSTATUS, MIN(ORDERS.O_ORDERPRIORITY) FROM ORDERS GROUP BY ORDERS.O_ORDERSTATUS HAVING MIN(ORDERS.O_ORDERPRIORITY) > '5-LOW          ' ORDER BY ORDERS.O_ORDERSTATUS ASC;