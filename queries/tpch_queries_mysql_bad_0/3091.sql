SELECT SUPPLIER.S_NAME, REGION.R_REGIONKEY, NATION.N_NAME FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY WHERE SUPPLIER.S_PHONE >= '15-679-861-2259' AND REGION.R_NAME > '1766' AND SUPPLIER.S_PHONE > '25-843-787-7479' AND NATION.N_COMMENT >= '890.63';
