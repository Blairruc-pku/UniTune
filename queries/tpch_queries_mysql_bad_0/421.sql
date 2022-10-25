SELECT SUPPLIER.S_COMMENT, COUNT(SUPPLIER.S_NATIONKEY), MIN(SUPPLIER.S_COMMENT) FROM SUPPLIER GROUP BY SUPPLIER.S_COMMENT HAVING COUNT(SUPPLIER.S_NATIONKEY) <= 8 ORDER BY SUPPLIER.S_COMMENT DESC;
