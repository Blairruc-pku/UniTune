SELECT LINEITEM.L_RECEIPTDATE, PARTSUPP.PS_COMMENT, SUPPLIER.S_COMMENT, ORDERS.O_CUSTKEY, CUSTOMER.C_NATIONKEY, NATION.N_COMMENT FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY JOIN LINEITEM ON LINEITEM.L_ORDERKEY=ORDERS.O_ORDERKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY;