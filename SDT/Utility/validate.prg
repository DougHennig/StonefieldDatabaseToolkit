*==============================================================================
* Program:			Validate
* Purpose:			Wrapper for DBCXMgr's Validate method
* Author:			Doug Hennig
* Last Revision:	12/22/98
* Parameters:		none
* Returns:			.T.
*==============================================================================

local lcCurrTalk, ;
	lcDBCPath, ;
	lcDBCXPath, ;
	llCreate, ;
	lcCurrError, ;
	llError, ;
	lcCurrClassLib, ;
	lcDirectory, ;
	oMeta

* Error if no database is open.

if empty(dbc())
	wait window 'Please select a database first.'
	return
endif empty(dbc())

* Save the current environment.

if set('TALK') = 'ON'
	set talk off
	lcCurrTalk = 'ON'
else
	lcCurrTalk = 'OFF'
endif set('TALK') = 'ON'

* Try to find the meta data tables.

lcDBCPath = left(dbc(), rat('\', dbc()))
if file(lcDBCPath + 'DBCXREG.DBF')
	lcDBCXPath = lcDBCPath
else
	lcDBCXPath = getfile('DBF', 'DBCXREG.DBF', 'OK', 1)
endif file(lcDBCPath + 'DBCXREG.DBF')
if not empty(lcDBCXPath)
	llCreate   = 'untitled' $ lower(lcDBCXPath)
	lcDBCXPath = left(lcDBCXPath, rat('\', lcDBCXPath))

* Setup an error handler.

	lcCurrError = on('ERROR')
	llError     = .F.
	on error llError = .T.

* Open the DBCX DBCXMgr class library. If everything went OK, instantiate
* DBCXMgr and call its Validate method.

	lcCurrClassLib = set('CLASSLIB')
	lcDirectory    = left(sys(16), rat('\', sys(16)))
	if file(lcDirectory + 'DBCX\DBCXMGR.VCX')
		set classlib to (lcDirectory + 'DBCX\DBCXMGR.VCX') additive
	else
		set classlib to locfile('DBCXMGR.VCX', 'VCX', 'DBCXMGR.VCX:') additive
	endif file(lcDirectory + 'DBCX\DBCXMGR.VCX')
	if not llError
		oMeta = createobject('DBCXMgr', .F., lcDBCXPath, llCreate)
		if type('oMeta') = 'O' and not isnull(oMeta)

* Point DBCXMgr to the selected database and turn on "show status" mode.

			oMeta.SetDatabase(dbc())
			oMeta.lShowStatus = .T.

* If the SDT Manager is available and it isn't registered, do it now.

			if file(lcDirectory + 'SOURCE\SDT.VCX') and ;
				not oMeta.IsManagerRegistered('oSDTMgr')
				oMeta.RegisterManager('Stonefield Database Toolkit', ;
					lcDirectory + 'SOURCE', 'SDT.VCX', 'SDTMgr')
			endif file(lcDirectory + 'SOURCE\SDT.VCX') ...

* Validate the database.

			oMeta.Validate()
		endif type('oMeta') = 'O' ...
	endif not llError

* Clean up.

	if not 'DBCXMGR' $ lcCurrClassLib and 'DBCXMGR' $ set('CLASSLIB')
		release classlib alias DBCXMGR
	endif not 'DBCXMGR' $ lcCurrClassLib ...
	on error &lcCurrError
endif not empty(lcDBCXPath)
if lcCurrTalk = 'ON'
	set talk on
endif lcCurrTalk = 'ON'
