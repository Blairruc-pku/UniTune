SELECT LINEITEM.L_RETURNFLAG, ORDERS.O_COMMENT, MIN(ORDERS.O_ORDERKEY) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY GROUP BY LINEITEM.L_RETURNFLAG, ORDERS.O_COMMENT;