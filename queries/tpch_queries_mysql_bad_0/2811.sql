SELECT ORDERS.O_SHIPPRIORITY, SUPPLIER.S_NATIONKEY, CUSTOMER.C_NATIONKEY, PARTSUPP.PS_SUPPKEY, NATION.N_REGIONKEY FROM PARTSUPP JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE PARTSUPP.PS_SUPPLYCOST = 538.58 AND SUPPLIER.S_NATIONKEY < 14;
