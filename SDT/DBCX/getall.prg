* Set up the environment and open the TESTDATA database.

clear all
close databases all
set classlib to locfile('DBCXMGR.VCX', 'Visual Class Library (*.vcx):VCX')
lcSampleDir = iif(type('_samples') = 'U', home() + 'samples\', _samples)
open database (lcSampleDir + 'DATA\TESTDATA')

* Instantiate DBCXMgr and point it to the database. Note: this assumes you've
* already run VALIDATE.PRG and REINDEX.PRG.

oMeta = createobject('DBCXMgr')
oMeta.SetDatabase(dbc())

* Create a custom property for indexes and set it for some but not all indexes.

oMeta.DBCXCreateProp('CBlSelect', 'oCoreMgr', 'Select', 'L')
oMeta.DBCXSetProp('customer.company',    'Index', 'Select', .T.)
oMeta.DBCXSetProp('customer.contact',    'Index', 'Select', .T.)
oMeta.DBCXSetProp('customer.postalcode', 'Index', 'Select', .T.)
oMeta.DBCXSetProp('customer.country',    'Index', 'Select', .T.)
oMeta.DBCXSetProp('!test.field1',        'Index', 'Select', .T.)

* Get all selectable indexes from the CUSTOMER table.

dimension laIndexes[1]
lnObjects = oMeta.DBCXGetAllObjects('index customer', @laIndexes, 'Caption', ;
	'Select', .T.)
clear
? ltrim(str(lnObjects)) + ' indexes selectable for CUSTOMER'
display memory like laIndexes

* Get all selectable indexes for the TEST free table.

dimension laIndexes[1]
lnObjects = oMeta.DBCXGetAllObjects('!index test', @laIndexes, 'Caption', ;
	'Select', .T.)
?
?
? ltrim(str(lnObjects)) + ' indexes selectable for TEST'
display memory like laIndexes
