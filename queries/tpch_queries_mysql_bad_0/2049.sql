SELECT ORDERS.O_ORDERPRIORITY, NATION.N_REGIONKEY, CUSTOMER.C_PHONE, REGION.R_NAME, COUNT(CUSTOMER.C_PHONE) FROM REGION, NATION, CUSTOMER, ORDERS GROUP BY ORDERS.O_ORDERPRIORITY, NATION.N_REGIONKEY, CUSTOMER.C_PHONE, REGION.R_NAME;