SELECT SUPPLIER.S_NAME, MIN(SUPPLIER.S_PHONE) FROM SUPPLIER GROUP BY SUPPLIER.S_NAME;
