* Set up the environment.

set talk off
set fullpath on
set deleted on
set exact off
set safety off
set notify off
set exclusive off

* Set some file location variables.

lcRunDir    = left(sys(16), rat('\', sys(16)))
lcSDTDir    = fullpath('..\', lcRunDir)
lcSDTDir    = lcSDTDir + iif(right(lcSDTDir, 1) = '\', '', '\')
lcCommonDir = fullpath('..\SFCOMMON\', lcSDTDir)
#if type('version(4)') = 'U'
lcSampleDir = home() + 'samples\'
#else
lcSampleDir = home(2)
#endif
lcSampleDir = lcSampleDir + iif(right(lcSampleDir, 1) = '\' or ;
	empty(lcSampleDir), '', '\')

* Ensure we have some test data.

lnFiles = adir(laFiles, lcSampleDir + 'data\*.*')
if lnFiles = 0
	= messagebox('This program requires the TESTDATA sample database that ' + ;
		'comes with VFP, but it cannot be located on your system.' + ;
		iif(' 05.' $ version(), '', chr(13) + chr(13) + 'Use the File ' + ;
		'Locations page of the Tools Options dialog to set the Samples ' + ;
		'Directory value, then run this program again.'), 16, 'SDT Tutorial')
	return .F.
endif lnFiles = 0

* Set the path so sample programs can find various files

set path to &lcSDTDir, &lcSDTDir.source, &lcSDTDir.tutorial, &lcCommonDir

* Create the subdirectories we'll need.

close all
if adir(laDir, 'datasrc', 'D') = 0
	md datasrc
endif adir(laDir, 'datasrc', 'D') = 0
if adir(laDir, 'dev', 'D') = 0
	md dev
endif adir(laDir, 'dev', 'D') = 0
if adir(laDir, 'client', 'D') = 0
	md client
endif adir(laDir, 'client', 'D') = 0

* Copy the VFP TESTDATA database and tables to the DATASRC subdirectory.

for lnI = 1 to lnFiles
	lcFile = laFiles[lnI, 1]
	if inlist(right(lcFile, 3), 'DBF', 'FPT', 'CDX', 'DBC', 'DCX', 'DCT')
		copy file (lcSampleDir + 'data\' + lcFile) to ('datasrc\' + lcFile)
	endif inlist(right(lcFile, 3), ...
next lnI
erase datasrc\country.*
erase datasrc\queries.*

* Create a view and make a slight change to ORDERS.

open data datasrc\testdata
create sql view cust_view as ;
	select * from testdata!customer order by company
alter table orders alter column cust_id set default customer.cust_id
use in ORDERS
use in CUSTOMER

* Create a free table.

create table datasrc\test free (field1 c(10), field2 c(10))
index on field1 tag field1
index on field2 tag field2
use in TEST

* Open the DBCXMgr class library. If everything went OK, instantiate DBCXMgr
* and call its Validate method.

set classlib to (lcSDTDir + 'source\dbcxmgr')
oMeta = createobject('DBCXMgr', .T., 'DATASRC', .T.)
if type('oMeta') = 'O' and not isnull(oMeta)

* If the SDT Manager isn't registered, do it now.

	if not oMeta.IsManagerRegistered('oSDTMgr')
		oMeta.RegisterManager('Stonefield Database Toolkit', ;
			lcSDTDir + 'source\', 'SDT.VCX', 'SDTMgr')
	endif not oMeta.IsManagerRegistered('oSDTMgr')

* Point DBCXMgr to the selected database and turn on "show status" mode.

	oMeta.SetDatabase(dbc())
	oMeta.lShowStatus = .T.

* Validate the database.

	oMeta.Validate()

* Create a database with just views.

	create database datasrc\views
	create sql view customer_view as select * from testdata!customer
	use in customer
	oMeta.Validate('Views', 'Database')
	set database to testdata

* Add the free table to the meta data.

	oMeta.Validate('!datasrc\test.dbf', 'Table')

* Create a calculated field and set some properties for it.

	oMeta.AddRow('orditems.total_price', 'User')
	oMeta.DBCXSetProp('Expression', ;
		'orditems.unit_price * orditems.quantity')
	oMeta.DBCXSetProp('Type', 'Y')
	oMeta.DBCXSetProp('Size', 8)
	oMeta.DBCXSetProp('Decimals', 4)
	oMeta.DBCXSetProp('InputMask', '99999.99')

* Make some fields non-filterable.

	oMeta.DBCXSetProp('customer.cust_id',    'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('orders.order_id',     'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('orders.emp_id',       'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('employee.emp_id',     'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('products.product_id', 'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('products.prod_name',  'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('orditems.line_no',    'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('orditems.order_id',   'Field', 'Filter', .F.)
	oMeta.DBCXSetProp('orditems.product_id', 'Field', 'Filter', .F.)

* Set a table caption for ORDITEMS.

	oMeta.DBCXSetProp('orditems', 'Table', 'Caption', 'Order Items')
endif type('oMeta') = 'O' ...

* Set the caption for some fields.

= dbsetprop('customer.postalcode', 'Field', 'Caption', 'Postal Code')
= dbsetprop('customer.maxordamt',  'Field', 'Caption', 'Maximum Order')
= dbsetprop('orders.cust_id',      'Field', 'Caption', 'Customer')
= dbsetprop('orders.postalcode',   'Field', 'Caption', 'Postal Code')
= dbsetprop('orders.order_amt',    'Field', 'Caption', 'Order Amount')
= dbsetprop('orders.order_dsc',    'Field', 'Caption', 'Discount')
= dbsetprop('products.discontinu', 'Field', 'Caption', 'Discontinued')
= dbsetprop('employee.postalcode', 'Field', 'Caption', 'Postal Code')

* Clean up.

release oMeta
close databases all

* Copy the test data to the DEV and CLIENT subdirectories.

do COPYSRC with 'DEV'
do COPYSRC with 'CLIENT'
