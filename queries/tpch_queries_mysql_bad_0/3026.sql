SELECT PARTSUPP.PS_PARTKEY, PART.P_TYPE FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PART.P_MFGR = 'MANUFACTURER#3           ';
