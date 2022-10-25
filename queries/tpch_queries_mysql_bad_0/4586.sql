SELECT NATION.N_NAME, CUSTOMER.C_ACCTBAL, AVG(NATION.N_NATIONKEY) FROM NATION, CUSTOMER GROUP BY NATION.N_NAME, CUSTOMER.C_ACCTBAL HAVING AVG(NATION.N_NATIONKEY) > NATION;