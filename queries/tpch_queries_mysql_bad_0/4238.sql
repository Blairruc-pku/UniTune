SELECT PARTSUPP.PS_PARTKEY, SUPPLIER.S_NATIONKEY, NATION.N_NAME, MIN(SUPPLIER.S_COMMENT) FROM PARTSUPP, SUPPLIER, NATION WHERE SUPPLIER.S_NATIONKEY > 17 GROUP BY PARTSUPP.PS_PARTKEY, SUPPLIER.S_NATIONKEY, NATION.N_NAME ORDER BY MIN(SUPPLIER.S_COMMENT) ASC;
