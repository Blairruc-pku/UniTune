SELECT CUSTOMER.C_PHONE, NATION.N_REGIONKEY FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY WHERE NATION.N_COMMENT >= '1992-07-29';
