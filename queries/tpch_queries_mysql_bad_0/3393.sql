SELECT PARTSUPP.PS_PARTKEY, LINEITEM.L_ORDERKEY FROM LINEITEM, PARTSUPP ORDER BY LINEITEM.L_ORDERKEY ASC, PARTSUPP.PS_PARTKEY ASC;
