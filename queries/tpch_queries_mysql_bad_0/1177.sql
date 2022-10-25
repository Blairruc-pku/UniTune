SELECT LINEITEM.L_RETURNFLAG, ORDERS.O_ORDERKEY, MIN(LINEITEM.L_LINESTATUS) FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY WHERE LINEITEM.L_SHIPDATE != '1992-07-10' GROUP BY LINEITEM.L_RETURNFLAG, ORDERS.O_ORDERKEY;
