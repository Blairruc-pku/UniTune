SELECT CUSTOMER.C_ADDRESS, MIN(CUSTOMER.C_COMMENT) FROM CUSTOMER GROUP BY CUSTOMER.C_ADDRESS ORDER BY MIN(CUSTOMER.C_COMMENT) ASC;
