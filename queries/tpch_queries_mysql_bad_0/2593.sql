SELECT NATION.N_REGIONKEY, SUPPLIER.S_SUPPKEY, PARTSUPP.PS_SUPPKEY, REGION.R_REGIONKEY, MAX(SUPPLIER.S_COMMENT) FROM PARTSUPP, SUPPLIER, NATION, REGION GROUP BY NATION.N_REGIONKEY, SUPPLIER.S_SUPPKEY, PARTSUPP.PS_SUPPKEY, REGION.R_REGIONKEY;