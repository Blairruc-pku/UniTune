SELECT CUSTOMER.C_COMMENT, MAX(CUSTOMER.C_PHONE) FROM CUSTOMER GROUP BY CUSTOMER.C_COMMENT HAVING MAX(CUSTOMER.C_PHONE) >= '17-697-919-8406';
