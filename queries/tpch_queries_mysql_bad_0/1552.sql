SELECT NATION.N_REGIONKEY, SUPPLIER.S_PHONE, COUNT(SUPPLIER.S_PHONE), SUM(NATION.N_REGIONKEY) FROM NATION, SUPPLIER GROUP BY NATION.N_REGIONKEY, SUPPLIER.S_PHONE;
