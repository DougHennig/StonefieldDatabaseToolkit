*==============================================================================
* Program:			XCAS2DBC
* Purpose:			Imports xCase information for a DBC into DBCX
* Author:			Doug Hennig
* Copyright:		(c) 1996-2002 Stonefield Systems Group Inc.
* Last Revision:	07/25/2002
* Parameters:		tcxCaseDir - the directory where the xCase DD files are
*						located
* Returns:			.T. if everything went OK
* Environment in:	the database and its tables must exist (use FoxCase before
*						running XCAS2DBC)
*					this is either running in VFP 6 (or later) or FOXTOOLS is
*						loaded
* Environment out:	if everything went OK, the xCase information has been
*						imported into DBCX
*==============================================================================

lparameters tcxCaseDir
#define ccPREF_FIELD_REP_DIR    'Field Repository Directory'
#define ccREG_KEY               'Software\Stonefield Systems Group Inc.\SDT\6.0\Properties'
local lcCurrTalk, ;
	lcxCaseDir, ;
	oImport, ;
	llReturn

* Ensure TALK is off.

if set('TALK') = 'ON'
	set talk off
	lcCurrTalk = 'ON'
else
	lcCurrTalk = 'OFF'
endif set('TALK') = 'ON'

* If the directory for the xCase DD files wasn't passed, ask for it.

lcxCaseDir = iif(type('tcxCaseDir') = 'C', tcxCaseDir, ;
	getdir(curdir(), 'xCase files location:'))
lcxCaseDir = addbs(lcxCaseDir)

* If the directory doesn't contain any xCase DD files, give an error.

if not file(lcxCaseDir + 'DDGLB.DBF')
	wait window 'The xCase DD files cannot be found in ' + ;
		fullpath(lcxCaseDir, curdir()) + '.'
	return .F.
endif not file(lcxCaseDir + 'DDGLB.DBF')

* Use the xCaseImport class (defined below) to do the job.

oImport  = createobject('xCaseImport')
llReturn = oImport.DoImport(lcxCaseDir, sys(16))
if lcCurrTalk = 'ON'
	set talk on
endif lcCurrTalk = 'ON'
return llReturn

**********************************
define class xCaseImport as custom
**********************************

* Define some properties.

	cCurrClassLib = ''
	lError        = .F.
	Name          = 'xCaseImport'

	*************
	function Init
	*************

* Save the current environment.

	with This
		.cCurrClassLib = set('CLASSLIB')
	endwith

	*****************
	function DoImport
	*****************

	lparameters tcxCaseDir, ;
		tcProgramDir
	local lcPath, ;
		lcDBC, ;
		lcClassDir, ;
		oMeta, ;
		lcDirectory, ;
		lcTable, ;
		llFree, ;
		lcField, ;
		lcTag, ;
		oRegistry, ;
		lcFieldPath, ;
		oFieldMeta
	with This

* Open the xCase files.

		use (tcxCaseDir + 'DDFLD') again shared in 0 order DDFLDENN
		use (tcxCaseDir + 'DDIDX') again shared in 0 order DDIDXENN
		use (tcxCaseDir + 'DDENT') again shared in 0
		use (tcxCaseDir + 'DDGLB') again shared in 0
		use (tcxCaseDir + 'DDDOM') again shared in 0
		if file(tcxCaseDir + 'DDDBC.DBF')
			use (tcxCaseDir + 'DDDBC') again shared in 0 order DDDBCID
		endif file(tcxCaseDir + 'DDDBC.DBF')
		if .lError
			return .F.
		endif .lError

* Get the name and path for the database, and open it.

		if used('DDDBC')
			select DDDBC
			locate for not empty(LOCATIONDB)
			lcPath = addbs(trim(LOCATIONDB))
			lcDBC  = lcPath + trim(NAME) + '.DBC'
		else	
			lcPath = addbs(trim(DDGLB.LOCATIONPH))
			lcDBC  = lcPath + trim(DDGLB.MODEL_NAME) + '.DBC'
		endif used('DDDBC')
		if file(lcDBC)
			open database (lcDBC)
		else
			wait window lcDBC + ' does not exist. Use FoxCase to create it.'
			return .F.
		endif file(lcDBC)

* Open the DBCX class library. If everything went OK, instantiate DBCXMgr.

		lcClassDir = fullpath('..\SOURCE\', tcProgramDir)
		set classlib to locfile(lcClassDir + 'DBCXMGR.VCX', 'VCX', ;
			'DBCXMGR.VCX:') additive
		if not .lError
			oMeta = createobject('DBCXMgr', .T., lcPath, .T.)
		endif not .lError
		if .lError or type('oMeta') <> 'O' or isnull(oMeta)
			return .F.
		endif .lError ...

* If the SDT Manager isn't registered, do it now.

		if not oMeta.IsManagerRegistered('oSDTMgr')
			lcDirectory = justpath(oMeta.ClassLibrary)
			oMeta.RegisterManager('Stonefield Database Toolkit', ;
				lcDirectory, 'SDT.VCX', 'SDTMgr')
		endif not oMeta.IsManagerRegistered('oSDTMgr')

* Point DBCXMgr to the selected database and turn "show status" mode on and
* "debug" mode off. Then validate the database.

		oMeta.SetDatabase(lcDBC)
		oMeta.lShowStatus = .T.
		oMeta.lDebugMode  = .F.
		oMeta.Validate()

* Process all tables.

		select DDENT
		scan
			lcTable = alltrim(TITLE)
			llFree  = used('DDDBC') and type('DDENT.I_DBC') <> 'U' and ;
				seek(DDENT.I_DBC, 'DDDBC') and empty(DDDBC.LOCATIONDB)
			wait window 'Processing table ' + lcTable + '...' nowait
			lcTable = iif(llFree, '!', '') + lcTable
			if llFree
				oMeta.Validate('!' + addbs(alltrim(PHLOCATION)) + ;
					alltrim(NAME) + '.DBF', 'Table')
			endif llFree
			if not empty(DESCRIPT)
				oMeta.DBCXSetProp(lcTable, 'Table', 'CBcCaption', ;
					alltrim(DESCRIPT))
			endif not empty(DESCRIPT)
			if type('DDENT.FILTER') = 'L'
				oMeta.DBCXSetProp(lcTable, 'Table', 'SDTFilter', FILTER)
			endif type('DDENT.FILTER') = 'L'

* Process all fields for this table: get the custom INPUTMASK, FORMAT, and
* FILTER properties (if they exist) and virtual fields.

			select DDFLD
			seek str(DDENT.IDENTIFIER, 5)
			scan while I_ENTITY = DDENT.IDENTIFIER
				lcField = alltrim(DDENT.TITLE) + '.' + trim(NAME)
				wait window 'Processing field ' + lcField + '...' nowait
				lcField = iif(llFree, '!', '') + lcField
				if LOGICAL
					llExists = oMeta.oCoreMgr.FindObject(lcField, 'User', ;
						dbc())
					if not llExists
						oMeta.AddRow(lcField, 'User')
					endif not llExists
					oMeta.DBCXSetProp(lcField, 'User', 'CBcType', ;
						left(TYPE, 1))
					oMeta.DBCXSetProp('CBlBinary', left(TYPE, 1) $ 'CM' and ;
						substr(TYPE, 2, 1) = 'B')
					oMeta.DBCXSetProp('CBnSize',     LEN)
					oMeta.DBCXSetProp('CBnDecimals', DEC)
					oMeta.DBCXSetProp('CBlNull',     DDENT.NULL)
					if not empty(COMMENTS)
						oMeta.DBCXSetProp('CBmComment', alltrim(COMMENTS))
					endif not empty(COMMENTS)
					if not empty(E_MESSAGE)
						oMeta.DBCXSetProp('CBcCaption', alltrim(E_MESSAGE))
					endif not empty(E_MESSAGE)
					oMeta.DBCXSetProp('CBmExpr', alltrim(EXPRESSION))
				endif LOGICAL
				if llFree
					if not empty(COMMENTS)
						oMeta.DBCXSetProp(lcField, 'Field', 'CBmComment', ;
							alltrim(COMMENTS))
					endif not empty(COMMENTS)
					if not empty(E_MESSAGE)
						oMeta.DBCXSetProp(lcField, 'Field', 'CBcCaption', ;
							alltrim(E_MESSAGE))
					endif not empty(E_MESSAGE)
				endif llFree
				do case
					case type('DDFLD.FILTER') = 'U' and LOGICAL and ;
						not llExists
						oMeta.DBCXSetProp('SDTFilter', not left(TYPE, 1) = 'G')
					case type('DDFLD.FILTER') = 'L'
						oMeta.DBCXSetProp(lcField, 'Field', 'SDTFilter', FILTER)
				endcase
				do case
					case type('DDFLD.INPUTMASK') = 'U'
					case llFree
						oMeta.DBCXSetProp(lcField, 'Field', 'CBmInputMask', ;
							alltrim(MASK))
					case LOGICAL
						oMeta.DBCXSetProp(lcField, 'Field', 'CBmInputMask', ;
							INPUTMASK)
					otherwise
						dbsetprop(lcField, 'Field', 'InputMask', ;
							alltrim(INPUTMASK))
				endcase
				do case
					case type('DDFLD.FORMAT') = 'U'
					case LOGICAL
						oMeta.DBCXSetProp(lcField, 'Field', 'CBmFormat', ;
							FORMAT)
					otherwise
						dbsetprop(lcField, 'Field', 'Format', alltrim(FORMAT))
				endcase
			endscan while I_ENTITY = DDENT.IDENTIFIER

* Process all indexes: get the index caption and a custom SELECT property (if
* it exists).

			select DDIDX
			seek str(DDENT.IDENTIFIER, 5)
			scan while I_ENTITY = DDENT.IDENTIFIER
				lcTag = alltrim(DDENT.TITLE) + '.' + trim(TAG)
				wait window 'Processing index ' + lcTag + '...' nowait
				lcTag = iif(llFree, '!', '') + lcTag
				if not empty(TITLE)
					oMeta.DBCXSetProp(lcTag, 'Index', 'CBcCaption', ;
						alltrim(TITLE))
				endif not empty(TITLE)
				if type('DDIDX.SELECT') = 'L'
					oMeta.DBCXSetProp('SDTSelect', SELECT)
				endif type('DDIDX.SELECT') = 'L'
			endscan while I_ENTITY = DDENT.IDENTIFIER
		endscan

* Process domains: instantiate a DBCXMgr object to manage the Field Repository
* tables, then process the xCase domains table.

		lcClassDir = fullpath('..\..\SFCOMMON\', tcProgramDir)
		set classlib to locfile(lcClassDir + 'SFREGISTRY.VCX', 'VCX', ;
			'SFREGISTRY.VCX:') additive
		oRegistry   = createobject('SFRegistry')
		lcFieldPath = oRegistry.GetKey(ccREG_KEY, ccPREF_FIELD_REP_DIR)
		oFieldMeta  = createobject('DBCXMgr', .T., lcFieldPath)
		if .lError or type('oFieldMeta') <> 'O' or isnull(oFieldMeta)
			return .F.
		endif .lError ...
		oFieldMeta.lDebugMode = .F.
		select DDDOM
		scan
			lcField = '_LIBRARY.' + trim(D_NAME)
			wait window 'Processing field ' + lcField + '...' nowait
			oFieldMeta.AddRow(lcField, 'Field')
			oFieldMeta.DBCXSetProp('CBcType',     left(TYPE, 1))
			oFieldMeta.DBCXSetProp('CBlBinary',   left(TYPE, 1) $ 'CM' and ;
				substr(TYPE, 2, 1) = 'B')
			oFieldMeta.DBCXSetProp('CBnSize',     LEN)
			oFieldMeta.DBCXSetProp('CBnDecimals', DEC)
			oFieldMeta.DBCXSetProp('CBlNull',     DDDOM.NULL)
			oFieldMeta.DBCXSetProp('CBmComment',  alltrim(COMMENTS))
			oFieldMeta.DBCXSetProp('CBcCaption',  alltrim(E_MESSAGE))
			oFieldMeta.DBCXSetProp('CBmExpr',     alltrim(EXPRESSION))
			oFieldMeta.DBCXSetProp('SDTValid',    alltrim(RULE_EXP))
			oFieldMeta.DBCXSetProp('SDTError',    alltrim(RULE_TEXT))
			oFieldMeta.DBCXSetProp('SDTDefValue', alltrim(E_DEFAULT))
			if type('DDFLD.INPUTMASK') = 'C'
				oFieldMeta.DBCXSetProp('CBmInputMask', alltrim(INPUTMASK))
			endif type('DDFLD.INPUTMASK') = 'C'
			if type('DDFLD.FORMAT') = 'C'
				oFieldMeta.DBCXSetProp('CBmFormat', alltrim(FORMAT))
			endif type('DDFLD.FORMAT') = 'C'
			if type('DDDOM.FILTER') = 'L'
				oFieldMeta.DBCXSetProp('SDTFilter', FILTER)
			endif type('DDDOM.FILTER') = 'L'
		endscan
		wait clear
	endwith
	return .T.

	*****************
	procedure Destroy
	*****************

* Close the tables we opened.

	if used('XCAS2DBC')
		use in XCAS2DBC
	endif used('XCAS2DBC')
	if used('DDFLD')
		use in DDFLD
	endif used('DDFLD')
	if used('DDIDX')
		use in DDIDX
	endif used('DDIDX')
	if used('DDREL')
		use in DDREL
	endif used('DDREL')
	if used('DDENT')
		use in DDENT
	endif used('DDENT')
	if used('DDGLB')
		use in DDGLB
	endif used('DDGLB')
	if used('DDVEW')
		use in DDVEW
	endif used('DDVEW')

* Reset other things.

	with This
		if not 'DBCXMGR' $ .cCurrClassLib and 'DBCXMGR' $ set('CLASSLIB')
			release classlib DBCXMGR
		endif not 'DBCXMGR' $ .cCurrClassLib ...
	endwith

	***************
	procedure Error
	***************

	lparameters tnError, ;
		tcMethod, ;
		tnLine
	This.lError = .T.
enddefine
