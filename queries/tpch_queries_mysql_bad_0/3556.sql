SELECT LINEITEM.L_SUPPKEY, ORDERS.O_TOTALPRICE, MAX(ORDERS.O_ORDERPRIORITY) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY GROUP BY LINEITEM.L_SUPPKEY, ORDERS.O_TOTALPRICE HAVING MAX(ORDERS.O_ORDERPRIORITY) < '1-URGENT       ';
