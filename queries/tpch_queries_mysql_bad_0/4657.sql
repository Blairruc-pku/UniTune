SELECT CUSTOMER.C_NATIONKEY, COUNT(CUSTOMER.C_COMMENT) FROM CUSTOMER GROUP BY CUSTOMER.C_NATIONKEY ORDER BY COUNT(CUSTOMER.C_COMMENT) DESC;
