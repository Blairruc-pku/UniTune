SELECT PARTSUPP.PS_AVAILQTY, MAX(PARTSUPP.PS_PARTKEY), MIN(PARTSUPP.PS_COMMENT) FROM PARTSUPP GROUP BY PARTSUPP.PS_AVAILQTY;
