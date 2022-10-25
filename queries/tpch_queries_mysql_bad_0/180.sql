SELECT NATION.N_REGIONKEY, SUPPLIER.S_COMMENT, REGION.R_REGIONKEY FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY WHERE SUPPLIER.S_COMMENT != 'BLITHELY SILENT REQUESTS AFTER THE EXPRESS DEPENDENCIES ARE SL' AND SUPPLIER.S_PHONE <= '15-679-861-2259' ORDER BY REGION.R_REGIONKEY ASC;