SELECT NATION.N_REGIONKEY, CUSTOMER.C_ACCTBAL, MAX(NATION.N_NATIONKEY) FROM NATION, CUSTOMER GROUP BY NATION.N_REGIONKEY, CUSTOMER.C_ACCTBAL HAVING MAX(NATION.N_NATIONKEY) > SUPPLIER ORDER BY NATION.N_REGIONKEY ASC;
