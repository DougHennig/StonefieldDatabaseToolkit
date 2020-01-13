*==============================================================================
* Program:			FixSCX
* Purpose:			Repairs a corrupted VCX, SCX, or PJX file
* Author:			Doug Hennig
* Copyright:		(c) 1997-2001 Stonefield Systems Group Inc.
* Last Revision:	08/07/2001
* Parameters:		tcFile - the name of the file to repair, or blank or not
*						passed to display a dialog to select the file to repair
* Environment in:	the meta data tables for repairing these file types is in
*						the same directory as this program
* Environment out:	the specified file may have been repaired
*==============================================================================

lparameters tcFile
local oRepair

* Get the name of the file if it isn't passed.

lcFile = iif(empty(tcFile), getfile('VCX;SCX;PJX', 'Repair:'), tcFile)
if empty(lcFile)
	return
endif empty(lcFile)

* Use the Repair class (defined below) to do the job.

oRepair = createobject('Repair')
oRepair.DoRepair(lcFile)
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

	lparameters tcFile
	local lcDBCPath, ;
		lcDBCXPath, ;
		lcSource, ;
		lcFilePath, ;
		lcPath, ;
		oMeta

* Open the DBCX DBCXMgr class library. If everything went OK, instantiate
* DBCXMgr.

	lcDir    = left(sys(16, 1), rat('\', sys(16, 1)))
	lcSource = fullpath('..\SOURCE\', lcDir)
	if '05.' $ version()
		lcFilePath = fullpath('..\..\SFCommon', lcSource)
		lcPath     = This.cCurrPath
		set path to &lcPath., &lcFilePath
	endif '05.' $ version()
	if file(lcSource + 'DBCXMGR.VCX')
		set classlib to (lcSource + 'DBCXMGR.VCX') additive
	else
		set classlib to locfile('DBCXMGR.VCX', 'VCX', 'DBCXMGR.VCX:') additive
	endif file(lcSource + 'DBCXMGR.VCX')
	if not This.lError
		oMeta = createobject('DBCXMgr', .T., lcDir)
		if type('oMeta') = 'O' and not isnull(oMeta)
			lcFile = '!' + justext(tcFile) + 'file'
			oMeta.DBCXSetProp(lcFile, 'Table', 'Path', tcFile)
			oMeta.oSDTMgr.Repair(lcFile)
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
