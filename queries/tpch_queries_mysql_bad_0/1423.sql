SELECT ORDERS.O_ORDERSTATUS, CUSTOMER.C_COMMENT FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY ORDER BY CUSTOMER.C_COMMENT ASC;
