SELECT NATION.N_REGIONKEY, ORDERS.O_ORDERPRIORITY, CUSTOMER.C_ACCTBAL, REGION.R_NAME FROM REGION JOIN NATION ON NATION.N_REGIONKEY=REGION.R_REGIONKEY JOIN CUSTOMER ON CUSTOMER.C_NATIONKEY=NATION.N_NATIONKEY JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY WHERE CUSTOMER.C_CUSTKEY > 21 AND NATION.N_NAME > 'CLERK#000000985' ORDER BY CUSTOMER.C_ACCTBAL ASC, REGION.R_NAME DESC, ORDERS.O_ORDERPRIORITY DESC, NATION.N_REGIONKEY DESC;
