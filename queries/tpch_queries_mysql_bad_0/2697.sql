SELECT LINEITEM.L_SHIPMODE, PARTSUPP.PS_COMMENT, MIN(LINEITEM.L_SHIPINSTRUCT), COUNT(LINEITEM.L_RETURNFLAG) FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY WHERE LINEITEM.L_EXTENDEDPRICE >= 62897.94 GROUP BY LINEITEM.L_SHIPMODE, PARTSUPP.PS_COMMENT ORDER BY LINEITEM.L_SHIPMODE ASC;
