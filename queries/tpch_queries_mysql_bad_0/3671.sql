SELECT CUSTOMER.C_ACCTBAL, SUPPLIER.S_SUPPKEY, NATION.N_NATIONKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY;
