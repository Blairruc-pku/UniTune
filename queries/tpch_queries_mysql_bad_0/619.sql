SELECT CUSTOMER.C_COMMENT, ORDERS.O_TOTALPRICE, COUNT(CUSTOMER.C_ACCTBAL) FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY GROUP BY CUSTOMER.C_COMMENT, ORDERS.O_TOTALPRICE ORDER BY ORDERS.O_TOTALPRICE ASC, CUSTOMER.C_COMMENT DESC;
