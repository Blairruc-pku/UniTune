SELECT CUSTOMER.C_NATIONKEY, NATION.N_COMMENT FROM NATION JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY WHERE CUSTOMER.C_COMMENT != 'RE FLUFFILY PENDING FOXES. PENDING, BOLD PLATELETS SLEEP SLYLY. EVEN PLATELETS CAJO' AND CUSTOMER.C_CUSTKEY > 147;
