SELECT CUSTOMER.C_CUSTKEY, ORDERS.O_COMMENT FROM CUSTOMER, ORDERS WHERE ORDERS.O_ORDERPRIORITY > '5-LOW          ' AND ORDERS.O_COMMENT > 'E SLYLY ABOUT THE FINAL PL';
