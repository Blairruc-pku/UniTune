SELECT CUSTOMER.C_CUSTKEY, MIN(CUSTOMER.C_MKTSEGMENT) FROM CUSTOMER GROUP BY CUSTOMER.C_CUSTKEY ORDER BY CUSTOMER.C_CUSTKEY DESC;