SELECT PARTSUPP.PS_SUPPKEY, SUM(PARTSUPP.PS_PARTKEY) FROM PARTSUPP GROUP BY PARTSUPP.PS_SUPPKEY;