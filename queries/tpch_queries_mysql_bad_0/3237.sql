SELECT PARTSUPP.PS_AVAILQTY, LINEITEM.L_QUANTITY, SUPPLIER.S_ADDRESS FROM LINEITEM JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=LINEITEM.L_SUPPKEY JOIN SUPPLIER ON SUPPLIER.S_SUPPKEY=PARTSUPP.PS_SUPPKEY;