SELECT CUSTOMER.C_PHONE, COUNT(CUSTOMER.C_ACCTBAL) FROM CUSTOMER GROUP BY CUSTOMER.C_PHONE ORDER BY CUSTOMER.C_PHONE DESC;
