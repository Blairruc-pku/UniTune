SELECT CUSTOMER.C_CUSTKEY, MAX(CUSTOMER.C_NAME) FROM CUSTOMER GROUP BY CUSTOMER.C_CUSTKEY HAVING MAX(CUSTOMER.C_NAME) = 'CUSTOMER#000000125' ORDER BY CUSTOMER.C_CUSTKEY DESC;
