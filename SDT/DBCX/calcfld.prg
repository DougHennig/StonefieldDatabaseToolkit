* Set up the environment and open the TESTDATA database.

clear all
close databases all
set classlib to locfile('DBCXMGR.VCX', 'Visual Class Library (*.vcx):VCX')
lcSampleDir = iif(type('_samples') = 'U', home() + 'samples\', _samples)
open database (lcSampleDir + 'DATA\TESTDATA')

* Instantiate DBCXMgr and point it to the database. Note: this assumes you've
* already run VALIDATE.PRG.

oMeta = createobject('DBCXMgr')
oMeta.SetDatabase(dbc())

* Create a calculated field if it doesn't already exist.

if isnull(oMeta.DBCXGetProp('orditems.total_price', 'User', 'Expression'))
	oMeta.AddRow('orditems.total_price', 'User')
	oMeta.DBCXSetProp('Expression', 'orditems.unit_price * orditems.quantity')
endif isnull(oMeta.DBCXGetProp('orditems.total_price', 'User', 'Expression'))

* Now browse the ORDITEMS table, displaying the calculated field.

lcExpr = oMeta.DBCXGetProp('Expression')
use ORDITEMS
browse fields ORDER_ID, LINE_NO, UNIT_PRICE, QUANTITY, TOTAL_PRICE = &lcExpr
