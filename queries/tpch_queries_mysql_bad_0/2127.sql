SELECT PARTSUPP.PS_COMMENT, LINEITEM.L_COMMENT FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY ORDER BY LINEITEM.L_COMMENT DESC, PARTSUPP.PS_COMMENT ASC;
