SELECT ORDERS.O_ORDERKEY, LINEITEM.L_COMMENT FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY WHERE LINEITEM.L_COMMITDATE < '1996-05-17';
