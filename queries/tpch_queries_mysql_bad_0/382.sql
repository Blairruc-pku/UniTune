SELECT NATION.N_COMMENT, CUSTOMER.C_NATIONKEY FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY WHERE CUSTOMER.C_PHONE != '21-840-210-3572' ORDER BY CUSTOMER.C_NATIONKEY DESC;
