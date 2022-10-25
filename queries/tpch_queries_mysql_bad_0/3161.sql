SELECT SUPPLIER.S_SUPPKEY, COUNT(SUPPLIER.S_ADDRESS) FROM SUPPLIER GROUP BY SUPPLIER.S_SUPPKEY HAVING COUNT(SUPPLIER.S_ADDRESS) <= 3;
