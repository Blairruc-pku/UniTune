SELECT LINEITEM.L_SHIPINSTRUCT, PARTSUPP.PS_COMMENT, MAX(LINEITEM.L_RETURNFLAG) FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY GROUP BY LINEITEM.L_SHIPINSTRUCT, PARTSUPP.PS_COMMENT ORDER BY LINEITEM.L_SHIPINSTRUCT ASC;
