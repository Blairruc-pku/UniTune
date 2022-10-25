SELECT LINEITEM.L_PARTKEY, ORDERS.O_CUSTKEY, COUNT(ORDERS.O_ORDERPRIORITY) FROM LINEITEM, ORDERS GROUP BY LINEITEM.L_PARTKEY, ORDERS.O_CUSTKEY HAVING COUNT(ORDERS.O_ORDERPRIORITY) != 7;