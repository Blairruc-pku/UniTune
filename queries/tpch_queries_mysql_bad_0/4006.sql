SELECT PARTSUPP.PS_SUPPKEY, MAX(PARTSUPP.PS_PARTKEY) FROM PARTSUPP WHERE PARTSUPP.PS_AVAILQTY != 2064 GROUP BY PARTSUPP.PS_SUPPKEY HAVING MAX(PARTSUPP.PS_PARTKEY) != 73;