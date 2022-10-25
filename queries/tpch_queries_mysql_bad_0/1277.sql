SELECT LINEITEM.L_EXTENDEDPRICE, ORDERS.O_SHIPPRIORITY, MIN(LINEITEM.L_ORDERKEY), COUNT(LINEITEM.L_PARTKEY), MAX(ORDERS.O_ORDERPRIORITY) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY GROUP BY LINEITEM.L_EXTENDEDPRICE, ORDERS.O_SHIPPRIORITY;
