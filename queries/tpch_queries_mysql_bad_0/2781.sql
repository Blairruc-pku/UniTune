SELECT LINEITEM.L_RETURNFLAG, PARTSUPP.PS_SUPPKEY FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY LINEITEM.L_RETURNFLAG DESC;
