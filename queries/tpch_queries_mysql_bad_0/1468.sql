SELECT ORDERS.O_ORDERSTATUS, CUSTOMER.C_COMMENT, MAX(ORDERS.O_ORDERPRIORITY) FROM ORDERS, CUSTOMER GROUP BY ORDERS.O_ORDERSTATUS, CUSTOMER.C_COMMENT HAVING MAX(ORDERS.O_ORDERPRIORITY) > '5-LOW          ';
