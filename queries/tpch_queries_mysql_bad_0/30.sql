SELECT CUSTOMER.C_NAME, NATION.N_NAME, SUPPLIER.S_ACCTBAL FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY;
