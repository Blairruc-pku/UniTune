SELECT CUSTOMER.C_NATIONKEY, SUPPLIER.S_COMMENT, NATION.N_NAME, COUNT(NATION.N_COMMENT) FROM SUPPLIER, NATION, CUSTOMER WHERE NATION.N_REGIONKEY >= 2174.36 GROUP BY CUSTOMER.C_NATIONKEY, SUPPLIER.S_COMMENT, NATION.N_NAME;