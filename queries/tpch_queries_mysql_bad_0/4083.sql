SELECT CUSTOMER.C_MKTSEGMENT, MIN(CUSTOMER.C_ACCTBAL) FROM CUSTOMER GROUP BY CUSTOMER.C_MKTSEGMENT HAVING MIN(CUSTOMER.C_ACCTBAL) != 794.47 ORDER BY MIN(CUSTOMER.C_ACCTBAL) ASC;
