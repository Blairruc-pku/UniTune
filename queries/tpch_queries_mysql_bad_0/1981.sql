SELECT LINEITEM.L_LINESTATUS, PARTSUPP.PS_PARTKEY FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY ORDER BY LINEITEM.L_LINESTATUS DESC, PARTSUPP.PS_PARTKEY ASC;
