SELECT SUPPLIER.S_SUPPKEY, PARTSUPP.PS_COMMENT, MIN(SUPPLIER.S_PHONE), COUNT(PARTSUPP.PS_COMMENT) FROM SUPPLIER, PARTSUPP GROUP BY SUPPLIER.S_SUPPKEY, PARTSUPP.PS_COMMENT HAVING COUNT(PARTSUPP.PS_COMMENT) >= 0 ORDER BY MIN(SUPPLIER.S_PHONE) ASC, COUNT(PARTSUPP.PS_COMMENT) ASC;