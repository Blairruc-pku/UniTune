SELECT CUSTOMER.C_PHONE, ORDERS.O_ORDERKEY, LINEITEM.L_SUPPKEY, NATION.N_COMMENT, PARTSUPP.PS_COMMENT FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN ORDERS ON ORDERS.O_ORDERKEY=LINEITEM.L_ORDERKEY JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY ORDER BY CUSTOMER.C_PHONE ASC, NATION.N_COMMENT DESC, ORDERS.O_ORDERKEY ASC, PARTSUPP.PS_COMMENT DESC;
