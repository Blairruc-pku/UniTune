SELECT CUSTOMER.C_CUSTKEY FROM CUSTOMER WHERE CUSTOMER.C_MKTSEGMENT != 'BUILDING  ' AND CUSTOMER.C_NAME < 'CUSTOMER#000000026' AND CUSTOMER.C_NATIONKEY >= 1 ORDER BY CUSTOMER.C_CUSTKEY ASC;
