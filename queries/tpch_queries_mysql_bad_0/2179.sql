SELECT ORDERS.O_SHIPPRIORITY, CUSTOMER.C_COMMENT FROM CUSTOMER JOIN ORDERS ON ORDERS.O_CUSTKEY=CUSTOMER.C_CUSTKEY;
