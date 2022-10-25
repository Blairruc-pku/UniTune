SELECT SUPPLIER.S_SUPPKEY, PARTSUPP.PS_AVAILQTY, MAX(PARTSUPP.PS_AVAILQTY) FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY GROUP BY SUPPLIER.S_SUPPKEY, PARTSUPP.PS_AVAILQTY HAVING MAX(PARTSUPP.PS_AVAILQTY) <= 2927 ORDER BY PARTSUPP.PS_AVAILQTY DESC, SUPPLIER.S_SUPPKEY ASC;
