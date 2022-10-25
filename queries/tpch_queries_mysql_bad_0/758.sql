SELECT PARTSUPP.PS_COMMENT, CUSTOMER.C_NAME, SUPPLIER.S_COMMENT, NATION.N_COMMENT FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY;