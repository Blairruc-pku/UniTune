SELECT PART.P_TYPE, LINEITEM.L_COMMITDATE, PARTSUPP.PS_COMMENT FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY;
