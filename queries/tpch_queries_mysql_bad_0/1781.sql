SELECT ORDERS.O_ORDERSTATUS, LINEITEM.L_SUPPKEY, MAX(LINEITEM.L_COMMENT) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY GROUP BY ORDERS.O_ORDERSTATUS, LINEITEM.L_SUPPKEY ORDER BY LINEITEM.L_SUPPKEY DESC, ORDERS.O_ORDERSTATUS DESC;
