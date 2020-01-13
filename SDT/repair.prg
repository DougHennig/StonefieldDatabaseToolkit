*==============================================================================
* Program:			Repair
* Purpose:			Wrapper for SDTMgr's Repair method
* Author:			Doug Hennig
* Copyright:		(c) 1997-2001 Stonefield Systems Group Inc.
* Last Revision:	06/14/2001
* Parameters:		tcTable       - the name of the table to repair, "ALL" to
*						repair all tables, or blank or not passed to display
*						a dialog to select the table(s) to repair
*					tlPack        - .T. to pack the table(s)
*					tlUseMetaData - .T. if we should rely solely on meta data
*						for the index definitions
* Environment in:	DBCXREG.DBF can be found
* Environment out:	one or more tables may have been repaired
*==============================================================================

lparameters tcTable, ;
	tlPack, ;
	tlUseMetaData
local oRepair

* Use the Repair class (defined below) to do the job.

oRepair = createobject('Repair')
oRepair.DoRepair(tcTable, tlPack, tlUseMetaData)
return

*****************************
define class Repair as custom
*****************************

* Define some properties.

	cCurrTalk     = ''
	cCurrClassLib = ''
	cCurrPath     = ''
	lError        = .F.
	Name          = 'Repair'

	*************
	function Init
	*************

* Save the current environment.

	if set('TALK') = 'ON'
		set talk off
		This.cCurrTalk = 'ON'
	else
		This.cCurrTalk = 'OFF'
	endif set('TALK') = 'ON'
	This.cCurrClassLib = set('CLASSLIB')
	This.cCurrPath     = set('PATH')

	*****************
	function DoRepair
	*****************

	lparameters tcTable, ;
		tlPack, ;
		tlUseMetaData
	local lcDBCPath, ;
		lcDBCXPath, ;
		lnSelect, ;
		lcSource, ;
		lcFilePath, ;
		lcPath, ;
		oMeta

* Try to find the meta data tables.

	lcDBCPath = iif(empty(dbc()), '', left(dbc(), rat('\', dbc())))
	if file(lcDBCPath + 'DBCXREG.DBF')
		lcDBCXPath = lcDBCPath
	else
		lcDBCXPath = getfile('DBF', 'DBCXREG.DBF')
		if empty(lcDBCXPath)
			return
		endif empty(lcDBCXPath)
	endif file(lcDBCPath + 'DBCXREG.DBF')
	lcDBCXPath = left(lcDBCXPath, rat('\', lcDBCXPath))
	if not file(lcDBCXPath + 'DBCXREG.DBF')
		return
	endif not file(lcDBCXPath + 'DBCXREG.DBF')

* Get the location of DBCXMGR.VCX from either DBCXREG or from the SOURCE
* subdirectory of this program's directory.

	lnSelect = select() 
	select 0
	use (lcDBCXPath + 'DBCXREG')
	locate for lower(cClassname) = 'coremgr' 
	if found() 
		lcSource = trim(MLIBPATH) 
	else 
		lcSource = left(sys(16, 1), rat('\', sys(16, 1))) + 'SOURCE\'
	endif found()
	use
	select (lnSelect)

* Open the DBCX DBCXMgr class library. If everything went OK, instantiate
* DBCXMgr and call the Repair method of SDTMgr.

	if '05.' $ version()
		lcFilePath = fullpath('..\..\SFCommon', lcSource)
		lcPath     = This.cCurrPath
		set path to &lcPath., &lcFilePath
	endif '05.' $ version()
	if not '\DBCXMGR.VCX' $ upper(set('CLASSLIB'))
		set classlib to locfile(lcSource + 'DBCXMGR.VCX', 'VCX', ;
			'DBCXMGR.VCX:') additive
	endif not '\DBCXMGR.VCX' $ upper(set('CLASSLIB'))
	if not This.lError
		oMeta = createobject('DBCXMgr', .T., lcDBCXPath)
		if type('oMeta') = 'O' and not isnull(oMeta)

* Point DBCXMgr to the selected database, then repair.

			oMeta.SetDatabase(dbc())
			oMeta.oSDTMgr.Repair(iif(type('tcTable') <> 'C', '', tcTable), ;
				tlPack, tlUseMetaData)
		endif type('oMeta') = 'O' ...
	endif not This.lError

	*****************
	procedure Destroy
	*****************

	local lcPath
	if not 'DBCXMGR' $ This.cCurrClassLib and 'DBCXMGR' $ set('CLASSLIB')
		release classlib alias DBCXMGR
	endif not 'DBCXMGR' $ This.cCurrClassLib ...
	lcPath = This.cCurrPath
	set path to &lcPath
	if This.cCurrTalk = 'ON'
		set talk on
	endif This.cCurrTalk = 'ON'

	***************
	procedure Error
	***************

	lparameters tnError, ;
		tcMethod, ;
		tnLine
	This.lError = .T.
enddefine
