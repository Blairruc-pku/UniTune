SELECT ORDERS.O_ORDERPRIORITY, LINEITEM.L_SHIPDATE, MIN(ORDERS.O_ORDERKEY) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY GROUP BY ORDERS.O_ORDERPRIORITY, LINEITEM.L_SHIPDATE;
