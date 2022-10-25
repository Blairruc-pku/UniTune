SELECT SUPPLIER.S_SUPPKEY, PARTSUPP.PS_COMMENT, LINEITEM.L_SUPPKEY, NATION.N_COMMENT, REGION.R_REGIONKEY FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN REGION ON REGION.R_REGIONKEY=NATION.N_REGIONKEY;