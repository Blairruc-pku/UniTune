SELECT SUPPLIER.S_PHONE, NATION.N_NATIONKEY, REGION.R_NAME FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY;
