SELECT PARTSUPP.PS_COMMENT, PART.P_PARTKEY FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY ORDER BY PART.P_PARTKEY ASC;
