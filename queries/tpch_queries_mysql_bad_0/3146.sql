SELECT ORDERS.O_ORDERKEY, LINEITEM.L_SUPPKEY, CUSTOMER.C_COMMENT FROM LINEITEM JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY;