SELECT PART.P_PARTKEY, PARTSUPP.PS_COMMENT FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_PARTKEY > 197 ORDER BY PARTSUPP.PS_COMMENT ASC;
