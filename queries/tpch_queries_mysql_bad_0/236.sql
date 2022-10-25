SELECT SUPPLIER.S_SUPPKEY, PARTSUPP.PS_COMMENT, MAX(SUPPLIER.S_COMMENT) FROM SUPPLIER, PARTSUPP GROUP BY SUPPLIER.S_SUPPKEY, PARTSUPP.PS_COMMENT ORDER BY MAX(SUPPLIER.S_COMMENT) DESC;
