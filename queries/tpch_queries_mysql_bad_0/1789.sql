SELECT PART.P_BRAND, PARTSUPP.PS_SUPPLYCOST FROM PARTSUPP, PART WHERE PART.P_TYPE != 'PROMO BRUSHED NICKEL' ORDER BY PART.P_BRAND ASC;