SELECT PART.P_TYPE, PARTSUPP.PS_COMMENT FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_SUPPKEY < 367;
