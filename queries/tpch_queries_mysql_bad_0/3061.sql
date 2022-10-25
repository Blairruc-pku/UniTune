SELECT PART.P_PARTKEY, SUPPLIER.S_ACCTBAL, PARTSUPP.PS_SUPPLYCOST, CUSTOMER.C_NAME, NATION.N_NAME, COUNT(PART.P_SIZE) FROM CUSTOMER, NATION, SUPPLIER, PARTSUPP, PART WHERE SUPPLIER.S_NAME < 'SUPPLIER#000000007       ' GROUP BY PART.P_PARTKEY, SUPPLIER.S_ACCTBAL, PARTSUPP.PS_SUPPLYCOST, CUSTOMER.C_NAME, NATION.N_NAME ORDER BY PARTSUPP.PS_SUPPLYCOST DESC, PART.P_PARTKEY DESC, CUSTOMER.C_NAME ASC;
