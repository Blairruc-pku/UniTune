SELECT PARTSUPP.PS_PARTKEY, SUPPLIER.S_NAME, NATION.N_NATIONKEY FROM PARTSUPP, SUPPLIER, NATION ORDER BY SUPPLIER.S_NAME ASC, NATION.N_NATIONKEY ASC, PARTSUPP.PS_PARTKEY DESC;
