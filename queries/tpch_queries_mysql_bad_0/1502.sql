SELECT REGION.R_COMMENT, NATION.N_NATIONKEY, SUPPLIER.S_SUPPKEY FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_PHONE = '21-151-690-3663';