SELECT LINEITEM.L_DISCOUNT, ORDERS.O_CLERK FROM ORDERS JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY ORDER BY LINEITEM.L_DISCOUNT DESC;
