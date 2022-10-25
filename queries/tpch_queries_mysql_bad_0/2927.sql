SELECT SUPPLIER.S_COMMENT, PARTSUPP.PS_SUPPKEY, COUNT(PARTSUPP.PS_COMMENT) FROM PARTSUPP, SUPPLIER GROUP BY SUPPLIER.S_COMMENT, PARTSUPP.PS_SUPPKEY HAVING COUNT(PARTSUPP.PS_COMMENT) != 4;