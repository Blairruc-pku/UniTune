SELECT NATION.N_NAME, SUPPLIER.S_PHONE, CUSTOMER.C_CUSTKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY;