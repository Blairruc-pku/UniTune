SELECT CUSTOMER.C_PHONE, NATION.N_REGIONKEY FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY ORDER BY NATION.N_REGIONKEY ASC;
