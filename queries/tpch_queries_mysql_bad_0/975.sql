SELECT LINEITEM.L_COMMITDATE, PARTSUPP.PS_SUPPKEY FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY WHERE LINEITEM.L_DISCOUNT <= 0.10 AND LINEITEM.L_ORDERKEY >= 4002;
