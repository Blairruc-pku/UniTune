SELECT ORDERS.O_ORDERKEY, LINEITEM.L_DISCOUNT FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY ORDER BY LINEITEM.L_DISCOUNT ASC;
