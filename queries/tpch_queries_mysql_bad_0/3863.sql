SELECT CUSTOMER.C_CUSTKEY, NATION.N_REGIONKEY, SUPPLIER.S_NATIONKEY FROM SUPPLIER JOIN NATION ON NATION.N_NATIONKEY=SUPPLIER.S_NATIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY WHERE NATION.N_COMMENT = '43235.85' AND NATION.N_COMMENT <= '43241.38';
