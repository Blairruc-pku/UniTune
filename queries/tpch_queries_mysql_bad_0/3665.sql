SELECT PARTSUPP.PS_PARTKEY, SUPPLIER.S_ACCTBAL, MIN(SUPPLIER.S_NATIONKEY), MIN(SUPPLIER.S_PHONE) FROM SUPPLIER, PARTSUPP GROUP BY PARTSUPP.PS_PARTKEY, SUPPLIER.S_ACCTBAL HAVING MIN(SUPPLIER.S_PHONE) <= '24-696-997-4969';
