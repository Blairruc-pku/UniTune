SELECT CUSTOMER.C_NATIONKEY, ORDERS.O_CUSTKEY FROM ORDERS, CUSTOMER WHERE CUSTOMER.C_ACCTBAL >= 2514.15 AND ORDERS.O_ORDERKEY != 5729 ORDER BY ORDERS.O_CUSTKEY ASC;