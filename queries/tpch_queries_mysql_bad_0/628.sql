SELECT PART.P_NAME, COUNT(PART.P_TYPE), COUNT(PART.P_RETAILPRICE) FROM PART WHERE PART.P_TYPE != 'MEDIUM BURNISHED TIN' GROUP BY PART.P_NAME;
