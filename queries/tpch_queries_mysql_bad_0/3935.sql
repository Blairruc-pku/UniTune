SELECT LINEITEM.L_COMMITDATE, PART.P_COMMENT, PARTSUPP.PS_SUPPKEY FROM LINEITEM, PARTSUPP, PART WHERE PARTSUPP.PS_PARTKEY >= 136 ORDER BY PARTSUPP.PS_SUPPKEY ASC;
