SELECT ORDERS.O_TOTALPRICE, LINEITEM.L_DISCOUNT FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY WHERE LINEITEM.L_PARTKEY <= 12163 ORDER BY ORDERS.O_TOTALPRICE ASC;