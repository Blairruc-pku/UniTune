SELECT LINEITEM.L_SHIPMODE, ORDERS.O_ORDERPRIORITY FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY ORDER BY LINEITEM.L_SHIPMODE ASC, ORDERS.O_ORDERPRIORITY ASC;
