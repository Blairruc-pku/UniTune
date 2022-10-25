SELECT PART.P_COMMENT, PARTSUPP.PS_SUPPKEY, MIN(PARTSUPP.PS_AVAILQTY), SUM(PART.P_PARTKEY), MAX(PARTSUPP.PS_PARTKEY), MAX(PART.P_NAME) FROM PART, PARTSUPP GROUP BY PART.P_COMMENT, PARTSUPP.PS_SUPPKEY ORDER BY MAX(PARTSUPP.PS_PARTKEY) DESC;
