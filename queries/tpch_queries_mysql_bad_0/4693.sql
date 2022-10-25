SELECT PART.P_TYPE, SUPPLIER.S_COMMENT, PARTSUPP.PS_AVAILQTY, MAX(PART.P_MFGR), MAX(PART.P_BRAND) FROM PART JOIN PARTSUPP ON PARTSUPP.PS_PARTKEY=PART.P_PARTKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY GROUP BY PART.P_TYPE, SUPPLIER.S_COMMENT, PARTSUPP.PS_AVAILQTY HAVING MAX(PART.P_BRAND) != 'BRAND#53  ' ORDER BY MAX(PART.P_BRAND) DESC, MAX(PART.P_MFGR) DESC;
