SELECT ORDERS.O_TOTALPRICE, LINEITEM.L_ORDERKEY FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY;