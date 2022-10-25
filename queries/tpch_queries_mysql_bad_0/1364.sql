SELECT REGION.R_NAME, NATION.N_REGIONKEY, CUSTOMER.C_ACCTBAL, ORDERS.O_ORDERPRIORITY, COUNT(CUSTOMER.C_PHONE) FROM REGION, NATION, CUSTOMER, ORDERS GROUP BY REGION.R_NAME, NATION.N_REGIONKEY, CUSTOMER.C_ACCTBAL, ORDERS.O_ORDERPRIORITY;