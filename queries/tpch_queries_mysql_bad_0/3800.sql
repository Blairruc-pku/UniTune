SELECT ORDERS.O_ORDERKEY, CUSTOMER.C_COMMENT FROM CUSTOMER, ORDERS WHERE CUSTOMER.C_NAME > 'CUSTOMER#000000141' ORDER BY CUSTOMER.C_COMMENT DESC, ORDERS.O_ORDERKEY ASC;
