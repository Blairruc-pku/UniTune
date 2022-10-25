SELECT SUPPLIER.S_PHONE, NATION.N_NATIONKEY, REGION.R_NAME FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY ORDER BY REGION.R_NAME DESC;
