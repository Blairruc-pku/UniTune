SELECT CUSTOMER.C_COMMENT, ORDERS.O_ORDERKEY, AVG(CUSTOMER.C_NATIONKEY), MIN(CUSTOMER.C_NAME) FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY GROUP BY CUSTOMER.C_COMMENT, ORDERS.O_ORDERKEY ORDER BY MIN(CUSTOMER.C_NAME) ASC, AVG(CUSTOMER.C_NATIONKEY) ASC;