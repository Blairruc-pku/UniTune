SELECT ORDERS.O_ORDERKEY, LINEITEM.L_SHIPINSTRUCT FROM ORDERS, LINEITEM ORDER BY ORDERS.O_ORDERKEY DESC, LINEITEM.L_SHIPINSTRUCT DESC;
