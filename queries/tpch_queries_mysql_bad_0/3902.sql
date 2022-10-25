SELECT SUPPLIER.S_NATIONKEY, PARTSUPP.PS_PARTKEY, PART.P_BRAND, MAX(PARTSUPP.PS_PARTKEY) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY GROUP BY SUPPLIER.S_NATIONKEY, PARTSUPP.PS_PARTKEY, PART.P_BRAND HAVING MAX(PARTSUPP.PS_PARTKEY) != 183 ORDER BY MAX(PARTSUPP.PS_PARTKEY) DESC;
