SELECT PARTSUPP.PS_SUPPKEY, PART.P_NAME, SUM(PARTSUPP.PS_AVAILQTY) FROM PART, PARTSUPP GROUP BY PARTSUPP.PS_SUPPKEY, PART.P_NAME;