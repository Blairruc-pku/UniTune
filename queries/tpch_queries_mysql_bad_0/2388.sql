SELECT CUSTOMER.C_PHONE, ORDERS.O_ORDERSTATUS FROM ORDERS, CUSTOMER WHERE CUSTOMER.C_CUSTKEY = 64 ORDER BY ORDERS.O_ORDERSTATUS DESC, CUSTOMER.C_PHONE ASC;
