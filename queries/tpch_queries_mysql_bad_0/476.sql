SELECT SUPPLIER.S_SUPPKEY, NATION.N_COMMENT, CUSTOMER.C_COMMENT FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY;
