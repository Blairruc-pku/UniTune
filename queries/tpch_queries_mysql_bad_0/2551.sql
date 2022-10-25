SELECT PART.P_SIZE, PARTSUPP.PS_SUPPKEY FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_SUPPLYCOST <= 497.26 AND PARTSUPP.PS_SUPPLYCOST != 158.62 ORDER BY PARTSUPP.PS_SUPPKEY DESC, PART.P_SIZE DESC;