SELECT PART.P_PARTKEY, PARTSUPP.PS_COMMENT FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY WHERE PART.P_MFGR > 'MANUFACTURER#5           ' ORDER BY PARTSUPP.PS_COMMENT ASC;
