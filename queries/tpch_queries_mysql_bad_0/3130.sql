SELECT LINEITEM.L_ORDERKEY, PARTSUPP.PS_SUPPKEY FROM LINEITEM, PARTSUPP ORDER BY PARTSUPP.PS_SUPPKEY DESC, LINEITEM.L_ORDERKEY DESC;
