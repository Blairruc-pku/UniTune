SELECT LINEITEM.L_PARTKEY, ORDERS.O_TOTALPRICE, CUSTOMER.C_NAME, MAX(ORDERS.O_SHIPPRIORITY) FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY GROUP BY LINEITEM.L_PARTKEY, ORDERS.O_TOTALPRICE, CUSTOMER.C_NAME ORDER BY LINEITEM.L_PARTKEY ASC;