SELECT PARTSUPP.PS_SUPPKEY, SUPPLIER.S_COMMENT, CUSTOMER.C_PHONE, NATION.N_COMMENT FROM CUSTOMER, NATION, SUPPLIER, PARTSUPP WHERE PARTSUPP.PS_PARTKEY <= 26;
