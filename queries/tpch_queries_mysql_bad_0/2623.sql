SELECT SUPPLIER.S_SUPPKEY, NATION.N_NAME FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY ORDER BY SUPPLIER.S_SUPPKEY ASC;
