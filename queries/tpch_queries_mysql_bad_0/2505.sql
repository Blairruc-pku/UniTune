SELECT LINEITEM.L_DISCOUNT, PARTSUPP.PS_COMMENT FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY;
