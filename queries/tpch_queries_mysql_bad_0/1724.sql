SELECT PART.P_NAME, PARTSUPP.PS_PARTKEY, COUNT(PART.P_NAME) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY GROUP BY PART.P_NAME, PARTSUPP.PS_PARTKEY;