SELECT CUSTOMER.C_ACCTBAL, ORDERS.O_SHIPPRIORITY FROM ORDERS, CUSTOMER WHERE ORDERS.O_TOTALPRICE < 229431.83 AND CUSTOMER.C_MKTSEGMENT <= 'FURNITURE ';