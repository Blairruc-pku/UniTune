SELECT CUSTOMER.C_MKTSEGMENT, ORDERS.O_CUSTKEY FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE CUSTOMER.C_PHONE <= '17-710-812-5403' ORDER BY ORDERS.O_CUSTKEY DESC;
