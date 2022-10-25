SELECT CUSTOMER.C_NAME, NATION.N_REGIONKEY FROM CUSTOMER JOIN NATION ON NATION.N_NATIONKEY=CUSTOMER.C_NATIONKEY WHERE CUSTOMER.C_MKTSEGMENT >= 'AUTOMOBILE' AND CUSTOMER.C_ACCTBAL >= 7618.27 AND CUSTOMER.C_NAME != 'CUSTOMER#000000094' ORDER BY CUSTOMER.C_NAME DESC, NATION.N_REGIONKEY DESC;
