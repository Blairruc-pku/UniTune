SELECT CUSTOMER.C_NATIONKEY, MIN(CUSTOMER.C_NAME) FROM CUSTOMER GROUP BY CUSTOMER.C_NATIONKEY;
