SELECT CUSTOMER.C_CUSTKEY, ORDERS.O_CLERK FROM CUSTOMER, ORDERS WHERE ORDERS.O_ORDERDATE < '1995-11-30' ORDER BY ORDERS.O_CLERK ASC;
