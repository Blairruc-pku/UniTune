SELECT SUPPLIER.S_NAME, CUSTOMER.C_PHONE, NATION.N_NAME, MIN(NATION.N_REGIONKEY) FROM SUPPLIER, NATION, CUSTOMER GROUP BY SUPPLIER.S_NAME, CUSTOMER.C_PHONE, NATION.N_NAME;
