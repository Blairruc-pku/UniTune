SELECT PARTSUPP.PS_PARTKEY, LINEITEM.L_LINESTATUS FROM PARTSUPP JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY WHERE LINEITEM.L_DISCOUNT > 0.07;
