SELECT CUSTOMER.C_ACCTBAL, LINEITEM.L_SUPPKEY, PARTSUPP.PS_PARTKEY, SUPPLIER.S_ADDRESS, ORDERS.O_ORDERDATE FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY ORDERS.O_ORDERDATE ASC, PARTSUPP.PS_PARTKEY ASC;
