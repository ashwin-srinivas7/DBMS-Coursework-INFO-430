USE team14_home_decor

SELECT * FROM tblCARRIER
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
DELETE FROM tblLINE_ITEM1
DELETE FROM tblSALES_ORDER
DELETE FROM tblCART
DELETE FROM tblSHIPMENT1
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"




SELECT top 2 * from tblCUSTOMER
SELECT * FROM tblLINE_ITEM1
SELECT * FROM tblSALES_ORDER

SELECT * FROM tblSHIPMENT1
SELECT * FROM tblCART
SELECT * FROM tblVENDOR
SELECT * FROM tblPRODUCT
SELECT top  1 * From tblINVOICE
--------------------------------------------------
EXEC uspPopulateCart
@CT_Cust_FN = 'Loan',
@CT_Cust_LN = 'Boemer',
@CT_Cust_BD = '1947-12-07',
@CT_Prod_Name = 'Glass Chandelier',
@CT_Quantity = 2,
@CT_Date = '3 May, 2019'

SELECT * FROM tblCART

EXEC uspProcessCart1
@C_FN = 'Loan',
@C_LN = 'Boemer',
@C_BD = '1947-12-07',
@Carr_Name = 'Fedex'

-------------------------------------------------------
EXEC uspPopulateCart
@CT_Cust_FN = 'Ismael',
@CT_Cust_LN = 'Acoba',
@CT_Cust_BD = '1989-09-26',
@CT_Prod_Name = 'Green Drape',
@CT_Quantity = 2,
@CT_Date = '3 May, 2019'

EXEC uspProcessCart
@C_FN = 'Ismael',
@C_LN = 'Acoba',
@C_BD = '1989-09-26'

-----------------
EXEC uspPopulateInvoice
@VName = 'Wholesale Accessory Market',
@PName = 'Metallic Curtain Rod',
@Qty = 120


EXEC uspPopulateInvoice
@VName = 'Koehler Home Decor',
@PName = 'The Gray Barn Jartop Square Wall Clock',
@Qty = 102

SELECT * FROM tblSALES_ORDER