SELECT LINEITEM.L_COMMENT, SUPPLIER.S_SUPPKEY, PARTSUPP.PS_PARTKEY FROM LINEITEM, PARTSUPP, SUPPLIER ORDER BY SUPPLIER.S_SUPPKEY ASC, LINEITEM.L_COMMENT DESC, PARTSUPP.PS_PARTKEY DESC;
