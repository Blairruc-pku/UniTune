SELECT PARTSUPP.PS_SUPPKEY, CUSTOMER.C_NAME, NATION.N_REGIONKEY, SUPPLIER.S_ACCTBAL FROM PARTSUPP, SUPPLIER, NATION, CUSTOMER ORDER BY SUPPLIER.S_ACCTBAL ASC, PARTSUPP.PS_SUPPKEY DESC, NATION.N_REGIONKEY DESC, CUSTOMER.C_NAME ASC;
