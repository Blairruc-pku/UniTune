SELECT LINEITEM.L_EXTENDEDPRICE, PARTSUPP.PS_SUPPLYCOST FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY LINEITEM.L_EXTENDEDPRICE DESC;