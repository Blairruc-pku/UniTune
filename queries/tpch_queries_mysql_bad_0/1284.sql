SELECT PART.P_MFGR, PARTSUPP.PS_COMMENT FROM PART, PARTSUPP WHERE PARTSUPP.PS_SUPPLYCOST > 275.58 AND PARTSUPP.PS_AVAILQTY >= 694 ORDER BY PART.P_MFGR DESC;
