SELECT ORDERS.O_ORDERSTATUS, CUSTOMER.C_MKTSEGMENT, COUNT(CUSTOMER.C_NATIONKEY) FROM ORDERS, CUSTOMER GROUP BY ORDERS.O_ORDERSTATUS, CUSTOMER.C_MKTSEGMENT ORDER BY COUNT(CUSTOMER.C_NATIONKEY) DESC;
