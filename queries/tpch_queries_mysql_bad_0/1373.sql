SELECT PARTSUPP.PS_SUPPKEY, SUPPLIER.S_NAME, LINEITEM.L_LINESTATUS FROM LINEITEM, PARTSUPP, SUPPLIER ORDER BY PARTSUPP.PS_SUPPKEY ASC, SUPPLIER.S_NAME DESC;
