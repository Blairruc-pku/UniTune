SELECT SUPPLIER.S_ADDRESS, NATION.N_COMMENT, MAX(SUPPLIER.S_ADDRESS) FROM NATION, SUPPLIER GROUP BY SUPPLIER.S_ADDRESS, NATION.N_COMMENT;