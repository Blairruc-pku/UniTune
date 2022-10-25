SELECT SUPPLIER.S_ACCTBAL, NATION.N_NAME, REGION.R_NAME FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_COMMENT >= ' SLYLY BOLD INSTRUCTIONS. IDLE DEPENDEN' ORDER BY SUPPLIER.S_ACCTBAL ASC;
