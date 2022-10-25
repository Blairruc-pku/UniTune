SELECT CUSTOMER.C_ACCTBAL, MAX(CUSTOMER.C_NAME), MIN(CUSTOMER.C_CUSTKEY), MIN(CUSTOMER.C_PHONE), AVG(CUSTOMER.C_CUSTKEY) FROM CUSTOMER GROUP BY CUSTOMER.C_ACCTBAL HAVING MAX(CUSTOMER.C_NAME) < 'CUSTOMER#000000114' AND MIN(CUSTOMER.C_PHONE) >= '22-603-468-3533' ORDER BY CUSTOMER.C_ACCTBAL DESC;