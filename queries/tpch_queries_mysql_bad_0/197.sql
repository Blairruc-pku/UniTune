SELECT SUPPLIER.S_SUPPKEY, NATION.N_NATIONKEY, MIN(NATION.N_NATIONKEY), COUNT(SUPPLIER.S_COMMENT) FROM NATION, SUPPLIER GROUP BY SUPPLIER.S_SUPPKEY, NATION.N_NATIONKEY;