SELECT PARTSUPP.PS_SUPPKEY, PART.P_COMMENT FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_SUPPLYCOST != 348.27 ORDER BY PART.P_COMMENT ASC, PARTSUPP.PS_SUPPKEY DESC;
