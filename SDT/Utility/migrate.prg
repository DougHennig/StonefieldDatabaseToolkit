*==============================================================================
* Program:			MIGRATE
* Purpose:			Convert a set of Stonefield Data Dictionary files to a
*						Visual FoxPro database with Stonefield Database Toolkit
*						extensions
* Author:			Doug Hennig
* Copyright:		(c) 1996 Stonefield Systems Group Inc.
* Last Revision:	01/25/99
* Parameters:		none
* Environment in:	SDT.VCX and DBCXMGR.VCX must be in the VFP path
* Environment out:	the database chosen by the user has been updated, meta data
*						tables were created or updated, and the tables have
*						attached to the DBC
*==============================================================================

#define ccCR chr(13)

* Create objects of our Migrate class (which is based on the SDDtoDBC class
* in SDD2DBC.PRG). Setup the environment the way we want it.

local lcCurrClassLib, ;
	lcCurrProcedures, ;
	oMigrate, ;
	lcPath, ;
	oMeta, ;
	lcProgram, ;
	lcDirectory
lcCurrClassLib   = set('CLASSLIB')
lcCurrProcedures = set('PROCEDURE')
set classlib to DBCXMGR additive
set procedure to SDD2DBC additive
oMigrate = createobject('Migrate')
oMigrate.SetEnv()

* If we can open the Stonefield Data Dictionary files and the user chose a
* database, instantiate DBCXMgr in "auto-create" mode.

if oMigrate.OpenSDD() and oMigrate.GetDBC()
	lcPath = left(dbc(), rat('\', dbc()))
	oMeta  = createobject('DBCXMgr', .T., lcPath, .T.)
	if type('oMeta') <> 'O' or isnull(oMeta)
		return .F.
	endif type('oMeta') <> 'O' ...

* If the SDT Manager isn't registered, do it now.

	if not oMeta.IsManagerRegistered('oSDTMgr')
		lcProgram   = left(sys(16), rat('\', sys(16)))
		lcDirectory = fullpath('..\SOURCE\', lcProgram)
		oMeta.RegisterManager('Stonefield Database Toolkit', lcDirectory, ;
			'SDT.VCX', 'SDTMgr')
	endif not oMeta.IsManagerRegistered('oSDTMgr')

* Tell DBCXMgr which database we're using and turn on "show status" mode, then
* validate the database.

	oMeta.SetDatabase(dbc())
	oMeta.lShowStatus = .T.
	oMeta.Validate()

* Convert tables and relations.

	oMigrate.ConvertTables(oMeta)
	oMigrate.ConvertRelations()
endif oMigrate.OpenSDD() ...
release oMigrate, oMeta
set procedure to &lcCurrProcedures
set classlib  to &lcCurrClassLib

********************************
define class Migrate as SDDtoDBC
********************************

	**********************
	function ConvertTables
	**********************

* Get a list of tables already in the database.

		lparameters oMeta
		local laTables[1], ;
			lnTables, ;
			lnI, ;
			lcAlias, ;
			lcField, ;
			lcType, ;
			lcIndex
		external array laQry_Array
		select FILEMAST
		lnTables = adbobjects(laTables, 'Table')
		for lnI = 1 to lnTables
			laTables[lnI] = padr(laTables[lnI], len(FILE))
		next lnI

* Process all tables in FILEMAST except the DD tables themselves.

		scan for not inlist(FILE, 'FILEMAST', 'INDXMAST', 'DATADICT', ;
			'RELATION', 'LISTMAST', 'ALSMAST', 'DDVIEWS')

* Add each table listed in FILEMAST to the database as long as it's not
* already there.

			if ascan(laTables, FILE) = 0
				This.ConvertOneTable()
				select FILEMAST
			else
				wait window 'Processing ' + trim(FILE) + '...' nowait
			endif ascan(laTables, FILE) = 0

* Validate the table.

			lcAlias = trim(ALIAS)
			oMeta.Validate(lcAlias, 'Table')

* Add the extended properties stored in the DD.

			oMeta.DBCXSetProp(lcAlias, 'Table', 'Caption', trim(DESCRIP))
			oMeta.DBCXSetProp('Filter',    REPORT)
			oMeta.DBCXSetProp('CanUpdate', not SYSTEM)
			oMeta.DBCXSetProp('AutoOpen',  AUTO_OPEN)
			oMeta.DBCXSetProp('NoUpdate',  NOUPDATE)

* For each field in the table, add the extended properties stored in the DD.

			select DATADICT
			seek FILEMAST.FILE
			scan while FILE = FILEMAST.FILE
				lcField = lcAlias + '.' + trim(FIELD_NAME)
				if empty(CALC_EXPR)
					lcType = 'Field'
				else
					oMeta.AddRow(lcField, 'User')
					oMeta.DBCXSetProp(lcField, 'User', 'Expression', CALC_EXPR)
					lcType = 'User'
				endif empty(CALC_EXPR)
				oMeta.DBCXSetProp(lcField, lcType, 'Filter', ;
					iif(type('FILTER') = 'U', REPORT, FILTER))
			endscan while FILE = FILEMAST.FILE

* For each tag for the table, add the extended properties stored in the DD.

			select INDXMAST
			seek FILEMAST.FILE
			scan while FILE = FILEMAST.FILE
				lcIndex = lcAlias + '.' + trim(TAG)
				oMeta.DBCXSetProp(lcIndex, 'Index', 'Caption', trim(DESCRIP))
				oMeta.DBCXSetProp('Select', SELECT)
			endscan while FILE = FILEMAST.FILE
		endscan for not inlist(FILE, ...
	endproc
enddefine
