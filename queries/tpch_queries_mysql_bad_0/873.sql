SELECT PARTSUPP.PS_COMMENT, SUPPLIER.S_SUPPKEY FROM SUPPLIER, PARTSUPP WHERE SUPPLIER.S_NAME <= 'SUPPLIER#000000007       ' AND SUPPLIER.S_NATIONKEY < 11 AND SUPPLIER.S_COMMENT >= 'BLITHELY SILENT REQUESTS AFTER THE EXPRESS DEPENDENCIES ARE SL' AND PARTSUPP.PS_SUPPLYCOST = 348.82;
