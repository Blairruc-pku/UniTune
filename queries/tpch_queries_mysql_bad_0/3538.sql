SELECT PART.P_COMMENT, PARTSUPP.PS_SUPPKEY FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY ORDER BY PART.P_COMMENT DESC;
