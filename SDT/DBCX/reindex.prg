* Set up the environment and open the TESTDATA database.

clear all
close databases all
set classlib to locfile('DBCXMGR.VCX', 'Visual Class Library (*.vcx):VCX')
lcSampleDir = iif(type('_samples') = 'U', home() + 'samples\', _samples)
open database (lcSampleDir + 'DATA\TESTDATA')

* Instantiate DBCXMgr, point it to the database, and turn on "show status"
* mode. Note: this assumes you've already run VALIDATE.PRG.

oMeta = createobject('DBCXMgr')
oMeta.SetDatabase(dbc())
oMeta.lShowStatus = .T.

* Create a free table and some indexes.

create table TEST free (FIELD1 C(10), FIELD2 C(10))
index on FIELD1 tag FIELD1
index on FIELD2 tag FIELD2
use

* Now validate the table. Notice the leading "!" so we indicate this table
* isn't part of the default database.

oMeta.Validate('!test', 'Table')

* Now blow away the indexes.

use TEST exclusive
delete tag all

* Let's try to recreate the indexes using very simple code. This really isn't
* suitable for a production environment, but demonstrates how extended
* properties are availabke for free tables.

lcExpr = oMeta.DBCXGetProp('!test.field1', 'Index', 'TagExpr')
index on &lcExpr tag FIELD1
lcExpr = oMeta.DBCXGetProp('!test.field2', 'Index', 'TagExpr')
index on &lcExpr tag FIELD2
clear
display status
use
