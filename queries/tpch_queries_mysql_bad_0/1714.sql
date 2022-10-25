SELECT REGION.R_NAME, NATION.N_COMMENT, SUPPLIER.S_COMMENT FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY ORDER BY SUPPLIER.S_COMMENT ASC;
