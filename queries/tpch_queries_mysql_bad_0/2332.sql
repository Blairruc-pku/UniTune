SELECT ORDERS.O_COMMENT, CUSTOMER.C_NATIONKEY FROM CUSTOMER, ORDERS WHERE CUSTOMER.C_CUSTKEY <= 150 ORDER BY CUSTOMER.C_NATIONKEY ASC, ORDERS.O_COMMENT ASC;
