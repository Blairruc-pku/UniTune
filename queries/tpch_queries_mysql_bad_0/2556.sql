SELECT PARTSUPP.PS_COMMENT, SUPPLIER.S_PHONE, COUNT(SUPPLIER.S_PHONE) FROM PARTSUPP, SUPPLIER GROUP BY PARTSUPP.PS_COMMENT, SUPPLIER.S_PHONE ORDER BY SUPPLIER.S_PHONE ASC;
