SELECT LINEITEM.L_SHIPINSTRUCT, SUPPLIER.S_COMMENT, PARTSUPP.PS_SUPPLYCOST FROM SUPPLIER JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN LINEITEM ON LINEITEM.L_SUPPKEY=PARTSUPP.PS_SUPPKEY;
