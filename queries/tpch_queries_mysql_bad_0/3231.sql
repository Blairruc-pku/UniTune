SELECT LINEITEM.L_ORDERKEY, ORDERS.O_ORDERSTATUS FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY;