SELECT ORDERS.O_TOTALPRICE, CUSTOMER.C_NAME FROM ORDERS JOIN CUSTOMER ON CUSTOMER.C_CUSTKEY=ORDERS.O_CUSTKEY WHERE CUSTOMER.C_PHONE = '19-407-425-2584';
