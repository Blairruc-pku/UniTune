SELECT CUSTOMER.C_NATIONKEY, ORDERS.O_CUSTKEY FROM CUSTOMER, ORDERS WHERE CUSTOMER.C_NATIONKEY != 23 ORDER BY CUSTOMER.C_NATIONKEY ASC, ORDERS.O_CUSTKEY DESC;
