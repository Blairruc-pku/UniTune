SELECT ORDERS.O_CLERK, LINEITEM.L_COMMITDATE FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY;
