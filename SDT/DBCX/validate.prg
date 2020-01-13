* Set up the environment and open the TESTDATA database.

clear all
close databases all
set classlib to locfile('DBCXMGR.VCX', 'Visual Class Library (*.vcx):VCX')
lcSampleDir = iif(type('_samples') = 'U', home() + 'samples\', _samples)
open database (lcSampleDir + 'DATA\TESTDATA')

* Instantiate DBCXMgr in "create" mode so the meta data tables are created (the
* fourth parameter is .T. for "create" mode and the third parameter is the
* directory to create the meta data tables in). Point DBCXMgr to the database,
* turn on "show status" mode, and call its Validate method.

oMeta = createobject('DBCXMgr', .F., '', .T.)
oMeta.SetDatabase(dbc())
oMeta.lShowStatus = .T.
oMeta.Validate()
