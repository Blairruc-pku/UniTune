SELECT ORDERS.O_CUSTKEY, CUSTOMER.C_NAME, MAX(CUSTOMER.C_PHONE) FROM ORDERS, CUSTOMER GROUP BY ORDERS.O_CUSTKEY, CUSTOMER.C_NAME;
