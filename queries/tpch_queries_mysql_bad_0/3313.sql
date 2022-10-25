SELECT LINEITEM.L_PARTKEY, CUSTOMER.C_CUSTKEY, ORDERS.O_TOTALPRICE FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY WHERE LINEITEM.L_TAX != 0.00 AND CUSTOMER.C_NAME > 'CUSTOMER#000000118' AND ORDERS.O_ORDERDATE <= '1996-12-12' AND ORDERS.O_ORDERPRIORITY > '4-NOT SPECIFIED' ORDER BY LINEITEM.L_PARTKEY ASC, CUSTOMER.C_CUSTKEY ASC;
