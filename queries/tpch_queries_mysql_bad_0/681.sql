SELECT SUPPLIER.S_NATIONKEY, SUM(SUPPLIER.S_NATIONKEY) FROM SUPPLIER GROUP BY SUPPLIER.S_NATIONKEY HAVING SUM(SUPPLIER.S_NATIONKEY) >= 15;
