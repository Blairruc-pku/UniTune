SELECT PARTSUPP.PS_AVAILQTY, PART.P_MFGR FROM PARTSUPP JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY ORDER BY PART.P_MFGR ASC;