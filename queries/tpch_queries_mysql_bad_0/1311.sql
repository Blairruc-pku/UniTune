SELECT PARTSUPP.PS_COMMENT, PART.P_PARTKEY, AVG(PART.P_PARTKEY) FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY GROUP BY PARTSUPP.PS_COMMENT, PART.P_PARTKEY;