SELECT NATION.N_REGIONKEY, SUPPLIER.S_PHONE FROM SUPPLIER, NATION WHERE SUPPLIER.S_PHONE <= '15-679-861-2259' ORDER BY SUPPLIER.S_PHONE DESC, NATION.N_REGIONKEY ASC;
