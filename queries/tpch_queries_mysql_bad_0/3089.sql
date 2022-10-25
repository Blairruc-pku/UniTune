SELECT NATION.N_NATIONKEY, SUPPLIER.S_SUPPKEY, REGION.R_NAME FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY WHERE REGION.R_COMMENT = 'MEDIUM POLISHED TIN' ORDER BY NATION.N_NATIONKEY ASC;