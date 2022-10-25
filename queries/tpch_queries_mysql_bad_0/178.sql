SELECT SUPPLIER.S_NAME, PARTSUPP.PS_SUPPLYCOST, PART.P_NAME, NATION.N_NATIONKEY FROM NATION JOIN SUPPLIER ON SUPPLIER.S_NATIONKEY=NATION.N_NATIONKEY JOIN PARTSUPP ON PARTSUPP.PS_SUPPKEY=SUPPLIER.S_SUPPKEY JOIN PART ON PART.P_PARTKEY=PARTSUPP.PS_PARTKEY WHERE PARTSUPP.PS_AVAILQTY = 2893 AND SUPPLIER.S_ADDRESS != '89EJ5KSX3IMXJQBVXOBC,' AND SUPPLIER.S_NAME != 'SUPPLIER#000000001       ' AND PART.P_BRAND <= 'BRAND#15  ';