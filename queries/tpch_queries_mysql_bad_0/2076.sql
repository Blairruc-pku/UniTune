SELECT CUSTOMER.C_COMMENT, MIN(CUSTOMER.C_ACCTBAL) FROM CUSTOMER GROUP BY CUSTOMER.C_COMMENT HAVING MIN(CUSTOMER.C_ACCTBAL) > 3582.37;
