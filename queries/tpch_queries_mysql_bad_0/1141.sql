SELECT ORDERS.O_ORDERSTATUS, LINEITEM.L_ORDERKEY FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY ORDER BY ORDERS.O_ORDERSTATUS DESC, LINEITEM.L_ORDERKEY DESC;
