SELECT SUPPLIER.S_NAME, SUM(SUPPLIER.S_NATIONKEY) FROM SUPPLIER GROUP BY SUPPLIER.S_NAME;
