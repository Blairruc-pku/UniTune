SELECT SUPPLIER.S_PHONE, MIN(SUPPLIER.S_ADDRESS) FROM SUPPLIER GROUP BY SUPPLIER.S_PHONE;
