SELECT SUPPLIER.S_PHONE, PARTSUPP.PS_COMMENT, AVG(PARTSUPP.PS_AVAILQTY), MIN(SUPPLIER.S_NAME), MIN(SUPPLIER.S_ACCTBAL) FROM PARTSUPP, SUPPLIER GROUP BY SUPPLIER.S_PHONE, PARTSUPP.PS_COMMENT HAVING AVG(PARTSUPP.PS_AVAILQTY) >= 8893;
