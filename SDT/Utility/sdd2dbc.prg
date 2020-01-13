*===========================================================================
* Program:			SDD2DBC
* Purpose:			Convert a set of Stonefield Data Dictionary files to a
*						Visual FoxPro database
* Author:			Doug Hennig
* Copyright:		(c) 1995 Stonefield Systems Group Inc.
* Last Revision:	01/25/99
* Parameters:		none
* Environment in:	the database to update must exist
* Environment out:	the database chosen by the user has been updated
* Routines used:	none
*===========================================================================

* Create an object of our SDDtoDBC class and set up the environment.

local oSDD2DBC
oSDD2DBC = createobject('SDDtoDBC')
oSDD2DBC.SetEnv()

* If we can open the Stonefield files and the user chose a database, convert
* the tables (plus their fields and indexes), then the relationships between
* them.

if oSDD2DBC.OpenSDD() and oSDD2DBC.GetDBC()
	oSDD2DBC.ConvertTables()
	oSDD2DBC.ConvertRelations()
endif oSDD2DBC.OpenSDD() ...

*******************************
define class SDDtoDBC as Custom
*******************************

	protected cCurrTalk, ;
		cCurrDelete, ;
		cCurrExact, ;
		cCurrSafety, ;
		lSuppressError, ;
		lErrorOccurred, ;
		aCodePage[20, 3]
	aCodePage[ 1, 1] = 'U.S. MS-DOS (437)'
	aCodePage[ 1, 2] = 437
	aCodePage[ 1, 3] = 1
	aCodePage[ 2, 1] = 'International MS-DOS (850)'
	aCodePage[ 2, 2] = 850
	aCodePage[ 2, 3] = 2
	aCodePage[ 3, 1] = 'Windows ANSI (1252)'
	aCodePage[ 3, 2] = 1252
	aCodePage[ 3, 3] = 3
	aCodePage[ 4, 1] = 'Standard Macintosh (10000)'
	aCodePage[ 4, 2] = 10000
	aCodePage[ 4, 3] = 4
	aCodePage[ 5, 1] = 'Eastern European MS-DOS (852)'
	aCodePage[ 5, 2] = 852
	aCodePage[ 5, 3] = 100
	aCodePage[ 6, 1] = 'Russian MS-DOS (866)'
	aCodePage[ 6, 2] = 866
	aCodePage[ 6, 3] = 101
	aCodePage[ 7, 1] = 'Nordic MS-DOS (865)'
	aCodePage[ 7, 2] = 865
	aCodePage[ 7, 3] = 102
	aCodePage[ 8, 1] = 'Icelandic MS-DOS (861)'
	aCodePage[ 8, 2] = 861
	aCodePage[ 8, 3] = 103
	aCodePage[ 9, 1] = 'Kamenicky (Czech) MS-DOS (895)'
	aCodePage[ 9, 2] = 895
	aCodePage[ 9, 3] = 104
	aCodePage[10, 1] = 'Mazovia (Polish) MS-DOS (620)'
	aCodePage[10, 2] = 620
	aCodePage[10, 3] = 105
	aCodePage[11, 1] = 'Greek MS-DOS (737)'
	aCodePage[11, 2] = 737
	aCodePage[11, 3] = 106
	aCodePage[12, 1] = 'Turkish MS-DOS (857)'
	aCodePage[12, 2] = 857
	aCodePage[12, 3] = 107
	aCodePage[13, 1] = 'Russian Macintosh (10007)'
	aCodePage[13, 2] = 10007
	aCodePage[13, 3] = 150
	aCodePage[14, 1] = 'Macintosh EE (10029)'
	aCodePage[14, 2] = 10029
	aCodePage[14, 3] = 151
	aCodePage[15, 1] = 'Greek Macintosh (10006)'
	aCodePage[15, 2] = 10006
	aCodePage[15, 3] = 152
	aCodePage[16, 1] = 'Eastern European Windows (1250)'
	aCodePage[16, 2] = 1250
	aCodePage[16, 3] = 200
	aCodePage[17, 1] = 'Russian Windows (1251)'
	aCodePage[17, 2] = 1251
	aCodePage[17, 3] = 201
	aCodePage[18, 1] = 'Greek Windows (1253)'
	aCodePage[18, 2] = 1253
	aCodePage[18, 3] = 203
	aCodePage[19, 1] = 'Turkish Windows (1254)'
	aCodePage[19, 2] = 1254
	aCodePage[19, 3] = 202
	aCodePage[20, 1] = 'No Code Page (0)'
	aCodePage[20, 2] = 0
	aCodePage[20, 3] = 0

	*************
	function Init
	*************

* Ensure TALK is off so we don't see a mess on the screen.

		if set('TALK') = 'ON'
			set talk off
			This.cCurrTalk = 'ON'
		else
			This.cCurrTalk = 'OFF'
		endif set('TALK') = 'ON'
	endproc

	***************
	function SetEnv
	***************

* Set up the environment the way we want it.

		This.cCurrDelete = set('DELETED')
		This.cCurrExact  = set('EXACT')
		This.cCurrSafety = set('SAFETY')
		set deleted on
		set exact off
		set safety off
		close databases all
	endproc

	****************
	function OpenSDD
	****************

* If we can't find FILEMAST, ask for the directory containing the DD files.

		local lcDirectory, ;
			llReturn
		lcDirectory = ''
		llReturn    = .T.
		do case
			case file('DBFS\FILEMAST.DBF')
				lcDirectory = 'DBFS\'
			case file('SOURCE\FILEMAST.DBF')
				lcDirectory = 'SOURCE\'
		endcase
		if not file(lcDirectory + 'FILEMAST.DBF')
			lcDirectory = getfile('DBF', '', 'Select', 0, 'Locate FILEMAST.DBF')
			llReturn    = not empty(lcDirectory)
			lcDirectory = left(lcDirectory, rat('\', lcDirectory))
		endif not file(lcDirectory + 'FILEMAST.DBF')

* Open the data dictionary tables.

		if llReturn
			This.lErrorOccurred = .F.			
			This.lSuppressError = .T.
			use (lcDirectory + 'FILEMAST') order OPEN_ORDER
			use (lcDirectory + 'DATADICT') order FILE in 0
			use (lcDirectory + 'RELATION')            in 0
			use (lcDirectory + 'INDXMAST') order FILE in 0
			This.lSuppressError = .F.
			llReturn = not This.lErrorOccurred
			if not llReturn
				= messagebox('A problem occurred opening the data ' + ;
					'dictionary files.', 16)
				This.lErrorOccurred = .F.
			endif not llReturn
		endif llReturn
		return llReturn

	***************
	function GetDBC
	***************

* Get the name of the database to use.

		local llReturn, ;
			lcData
		llReturn = .T.
*		lcData   = getfile('DBC', '', '', 0, 'Select Database')
		lcData = putfile('Database', '', 'DBC')
		do case
			case empty(lcData)
				llReturn = .F.
			case not file(lcData)
				This.lErrorOccurred = .F.			
				This.lSuppressError = .T.
				create database (lcData)
				open database (lcData) exclusive
				This.lSuppressError = .F.
				llReturn = not This.lErrorOccurred
				if not llReturn
					= messagebox('A problem occurred creating the database.', 16)
					This.lErrorOccurred = .F.
				endif not llReturn
			otherwise
				This.lErrorOccurred = .F.			
				This.lSuppressError = .T.
				open database (lcData) exclusive
				This.lSuppressError = .F.
				llReturn = not This.lErrorOccurred
				if not llReturn
					= messagebox('A problem occurred opening the database.', 16)
					This.lErrorOccurred = .F.
				endif not llReturn
		endcase
		return llReturn
	endproc

	**********************
	function ConvertTables
	**********************

* Get a list of tables already in the database.

		local laTables[1], ;
			lnTables, ;
			lnI
		select FILEMAST
		lnTables = adbobjects(laTables, 'Table')
		for lnI = 1 to lnTables
			laTables[lnI] = padr(laTables[lnI], len(FILE))
		next lnI

* Add each table listed in FILEMAST to the database as long as it's not
* already there.

		scan for not inlist(FILE, 'FILEMAST', 'INDXMAST', 'DATADICT', ;
			'RELATION', 'LISTMAST', 'ALSMAST', 'DDVIEWS') and ;
			ascan(laTables, FILE) = 0
			This.ConvertOneTable()
		endscan for not inlist(FILE, ...
	endproc

	************************
	function ConvertOneTable
	************************

* Add the current table to the database.

		local lcTemp, ;
			lcFile, ;
			lcDirectory, ;
			lcAlias, ;
			llExist, ;
			lcField, ;
			lcExpr, ;
			lcTag, ;
			lcAlter, ;
			lcRange, ;
			lcValid, ;
			lnHandle, ;
			lnCodePage

* Get the filename, directory, and alias for the table to convert. Display a
* message that we're converting this table.

		lcTemp      = sys(3)
		lcFile      = trim(FILE)
		lcDirectory = fullpath(trim(DIRECTORY), dbf())
		lcAlias     = trim(ALIAS)
		wait window 'Adding ' + lcFile + '...' nowait

* If the file exists, copy its records to another table because we'll need to
* alter its structure to VFP's format.

		llExist = file(lcDirectory + lcFile + '.DBF')
		if llExist
			select 0
			This.lErrorOccurred = .F.			
			This.lSuppressError = .T.
			use (lcDirectory + lcFile) alias (lcAlias) exclusive
			This.lSuppressError = .F.
			if This.lErrorOccurred
				= messagebox('A problem occurred opening ' + lcDirectory + ;
					lcFile + '.', 16)
				This.lErrorOccurred = .F.
				return .F.
			endif This.lErrorOccurred
			copy to (lcTemp)
		endif llExist

* Now recreate the table from the data dictionary definition.

		lcTable = FILEMAST.FILE
		select FIELD_NAME, ;
				FIELD_TYPE, ;
				FIELD_LEN, ;
				FIELD_DEC, ;
				.F., ;
				CPNOTRANS ;
			from DATADICT ;
			where FILE = lcTable and ;
				(type('CALC_EXPR') = 'U' or ;
				empty(CALC_EXPR)) ;
			into array laFields ;
			order by FIELD_NUM
*		select DATADICT
*		lcField = ''
*		scan for FILE = FILEMAST.FILE and (type('CALC_EXPR') = 'U' or ;
*			empty(CALC_EXPR))
*			lcField = iif(empty(lcField), '(', lcField + ',') + ;
*				trim(FIELD_NAME) + ' ' + FIELD_TYPE
*			if not FIELD_TYPE $ 'MGDL'
*				lcField = lcField + '(' + ltrim(str(FIELD_LEN)) + ;
*					iif(FIELD_DEC > 0, ',' + ltrim(str(FIELD_DEC)), '') + ')'
*			endif not FIELD_TYPE $ 'MGDL'
*			lcField = lcField + iif(type('CPNOTRANS') = 'L' and CPNOTRANS, ;
*				' nocptrans', '')
*		endscan for FILE = FILEMAST.FILE ...
*		lcField = lcField + ')'

* Create the table.

*		create table (lcDirectory + lcFile) name (lcAlias) &lcField
		create table (lcDirectory + lcFile) name (lcAlias) from array laFields

* Create an index for each tag defined in the data dictionary.

		select INDXMAST
		scan for FILE = FILEMAST.FILE and INDFILE = FILE and not empty(TAG)
			if type('COLLATE') = 'C'
				set collate to (trim(COLLATE))
			endif type('COLLATE') = 'C'
			lcExpr = EXPRESSION + iif(empty(FOREXPR), '', ' for ' + ;
				FOREXPR) + iif(DESCEND, ' descending', '') + ;
				iif(UNIQUE, ' unique', '') + iif(type('NO_DUP') = 'L' and ;
				NO_DUP and not PRIMARY, ' candidate', '')
			select (lcAlias)
			index on &lcExpr tag (trim(INDXMAST.TAG))
		endscan for FILE = FILEMAST.FILE ...

* Now update other things in the database.

		select DATADICT
		scan for FILE = FILEMAST.FILE and (type('CALC_EXPR') = 'U' or ;
			empty(CALC_EXPR))

* Create DEFAULT, CHECK, and ERROR conditions.

			lcAlter = ''
			if not empty(DEFAULT)
				lcAlter = ' set default ' + DEFAULT
			endif not empty(DEFAULT)
			do case
				case empty(RANGELO + RANGEHI)
					lcRange = ''
				case not empty(RANGELO) and not empty(RANGEHI)
					lcRange = 'between(' + trim(FIELD_NAME) + ', ' + ;
						RANGELO + ', ' + RANGEHI + ')'
				case empty(RANGELO)
					lcRange = trim(FIELD_NAME) + ' <= ' + RANGEHI
				otherwise
					lcRange = trim(FIELD_NAME) + ' >= ' + RANGELO
			endcase
			do case
				case empty(VALID)
					lcValid = ''
				case '.OR.' $ upper(VALID) or ' OR ' $ upper(VALID) or ;
					')OR ' $ upper(VALID) or ' OR(' $ upper(VALID) or ;
					')OR(' $ upper(VALID)
					lcValid = '(' + VALID + ')'
				otherwise
					lcValid = VALID
			endcase
			lcValid = iif('M.' $ upper(VALID), ;
				This.StripMAlias(lcValid, lcAlias), lcValid)
			if not empty(lcRange + lcValid) and upper(lcValid) <> 'LOOK_UP'
				lcAlter = lcAlter + ' set check ' + lcValid
				if not empty(lcRange)
					lcAlter = lcAlter + iif(empty(lcValid), '', ' or ') + ;
						lcRange
				endif not empty(lcRange)
				if not empty(ERROR)
					lcAlter = lcAlter + ' error ' + ERROR
				endif not empty(ERROR)
			endif not empty(lcRange ...
			if not empty(lcAlter)
				alter table (lcAlias) alter column (trim(FIELD_NAME)) ;
					&lcAlter novalidate
			endif not empty(lcAlter)

* Update certain properties only if they're filled in.

			lcField = lcAlias + '.' + trim(FIELD_NAME)
			if not empty(PICTURE)
				dbsetprop(lcField, 'Field', 'InputMask', PICTURE)
			endif not empty(PICTURE)
			if not empty(FIELD_DESC)
				dbsetprop(lcField, 'Field', 'Caption', trim(FIELD_DESC))
			endif not empty(FIELD_DESC)
			if not empty(COMMENTS)
				dbsetprop(lcField, 'Field', 'Comment', left(COMMENTS, 254))
			endif not empty(COMMENTS)
		endscan for FILE = FILEMAST.FILE ...

* Add the records back from the temporary table. If an error occurs, tell the
* user.

		if llExist
			select (lcAlias)
			This.lErrorOccurred = .F.
			This.lSuppressError = .T.
			append from (lcTemp)
			This.lSuppressError = .F.
			if This.lErrorOccurred
				= messagebox('A problem occurred in converting the ' + ;
					'structure of ' + lcAlias + '. The data for this ' + ;
					'table is now stored in ' + lcTemp + '.DBF.', 16)
				This.lErrorOccurred = .F.
			else
				erase (lcTemp + '.DBF')
				erase (lcTemp + '.FPT')
			endif This.lErrorOccurred
		endif llExist

* Update the table's comments.

		if not empty(FILEMAST.COMMENTS)
			dbsetprop(lcAlias, 'Table', 'Comment', ;
				left(FILEMAST.COMMENTS, 254))
		endif not empty(FILEMAST.COMMENTS)

* Define the primary key for the table.

		select INDXMAST
		locate for FILE = FILEMAST.FILE and PRIMARY
		if found()
			lcExpr = EXPRESSION
			lcTag  = trim(TAG)
			alter table (lcAlias) add primary key &lcExpr tag &lcTag novalidate
		endif found()

* Close the table and add the proper codepage.

		use in (lcAlias)
		lnHandle = fopen(lcDirectory + lcFile + '.DBF', 2)
		if lnHandle >= 0
			= fseek(lnHandle, 29)
			lnCodePage = ascan(This.aCodePage, FILEMAST.CODEPAGE)
			lnCodePage = iif(lnCodePage = 0, 0, ;
				This.aCodePage[asubscript(This.aCodePage, lnCodePage, 1), 3])
			= fwrite(lnHandle, chr(lnCodePage)) 
			= fclose(lnHandle)
		endif lnHandle >= 0
	endproc

	*************************
	function ConvertRelations
	*************************

* Get a list of relations already in the database.

		local laRELATIONS[1], ;
			lnRELATIONS, ;
			lnI, ;
			llGOT_REL
		select RELATION
		lnRELATIONS = adbobjects(laRELATIONS, 'Relation')
		for lnI = 1 to lnRELATIONS
			laRELATIONS[lnI, 1] = padr(laRELATIONS[lnI, 1], len(FILE1))
			laRELATIONS[lnI, 2] = padr(laRELATIONS[lnI, 2], len(FILE1))
		next lnI

* Add each relation listed in RELATION to the database as long as it's not
* already there.

		wait window 'Adding relations...' nowait
		use (dbc()) alias DBCTABLE order OBJECTNAME again in 0
		scan
			llGOT_REL = .F.
			for lnI = 1 to lnRELATIONS
				if laRELATIONS[lnI, 1] = FILE1 and laRELATIONS[lnI, 2] = FILE2
					llGOT_REL = .T.
					exit
				endif laRELATIONS[lnI, 1] = FILE1 ...
			next lnI
			if not llGOT_REL
				This.ConvertOneRelation()
			endif not llGOT_REL
		endscan
		use in DBCTABLE
	endproc

	***************************
	function ConvertOneRelation
	***************************

* Add the current relation to the database.

		local lcAlias1, ;
			lcAlias2, ;
			lcExpr, ;
			lcTag1, ;
			lcTag2, ;
			liParent

		if type('ALIAS1') = 'C'
			lcAlias1 = trim(ALIAS1)
			lcAlias2 = trim(ALIAS2)
		else
			select FILEMAST
			locate for FILE = RELATION.FILE1
			lcAlias1 = trim(ALIAS)
			locate for FILE = RELATION.FILE2
			lcAlias2 = trim(ALIAS)
		endif type('ALIAS1') = 'C'
		select INDXMAST
		seek RELATION.FILE1 + RELATION.INDEX1 + RELATION.TAG1
		lcExpr = EXPRESSION
		lcTag1 = trim(RELATION.TAG1)
		lcTag2 = trim(RELATION.TAG2)
		alter table (lcAlias1) add foreign key &lcExpr tag &lcTag1 ;
			references &lcAlias2 tag &lcTag2 novalidate
		select DBCTABLE
		seek str(1) + padr('Table', len(OBJECTTYPE)) + lower(lcAlias1)
		liParent = OBJECTID
		locate for PARENTID = liParent and OBJECTTYPE = 'Relation' and ;
			lower(lcTag2) $ PROPERTY and lower(lcAlias2) $ PROPERTY
		replace RIINFO with iif(inlist(trim(RELATION.UPD_RULES), 'Cascade', ;
			'Restrict'), left(RELATION.UPD_RULES, 1), 'I') + ;
			iif(inlist(trim(RELATION.DEL_RULES), 'Cascade', 'Restrict'), ;
			left(RELATION.DEL_RULES, 1), 'I') + 'R'
	endproc

	****************
	function Destroy
	****************

* Clean up as we exit.

		wait clear
		close database all
		if This.cCurrSafety = 'ON'
			set safety on
		endif This.cCurrSafety = 'ON'
		if This.cCurrDelete = 'OFF'
			set deleted off
		endif This.cCurrDelete = 'OFF'
		if This.cCurrExact = 'ON'
			set exact on
		endif This.cCurrExact = 'ON'
		if This.cCurrTalk = 'ON'
			set talk on
		endif This.cCurrTalk = 'ON'
	endproc

	********************
	function StripMAlias
	********************

* Strip M. aliases off an expression.

		lparameters tcInExpr, ;
			tcAlias
		local lcOutExpr, ;
			lnCurrSelect, ;
			lnI, ;
			lcName, ;
			lnJ, ;
			lnPos, ;
			lcChar1, ;
			lcChar2

* Check each field name to see if we have an exact match with the
* expression. If so, add the alias and exit.

		lcOutExpr = strtran(tcInExpr, '->', '.')
		lnCurrSelect = select()
		select (tcAlias)
		for lnI = 1 to fcount()
			lcName = 'M.' + field(lnI)
			if lcName == upper(lcOutExpr)
				lcOutExpr = field(lnI)
				exit
			endif lcName == upper(lcOutExpr)

* We didn't have an exact match, so check every occurrence of the field
* name in the expression. If it appears to be a valid field name in the
* expression, insert the alias in front of it.

			for lnJ = 1 to occurs(lcName, upper(lcOutExpr))
				lnPos   = atc(lcName, lcOutExpr, lnJ)
				lcChar1 = substr(upper(lcOutExpr), lnPos - 1, 1)
				lcChar2 = substr(upper(lcOutExpr), lnPos + len(lcName), 1)
				if not isalpha(lcChar1) and not isalpha(lcChar2) and ;
					not isdigit(lcChar1) and not isdigit(lcChar2) and ;
					lcChar1 <> '.' and lcChar2 <> '.' and lcChar1 <> '_' and ;
					lcChar2 <> '_' and lcChar2 <> '(' and lcChar2 <> '['
					lcOutExpr = stuff(lcOutExpr, lnPos, len(lcName), ;
						field(lnI))
				endif not isalpha(lcChar1) ...
			next lnJ
		next lnI
		select (lnCurrSelect)
		return lcOutExpr
	endproc

	**************
	function Error
	**************

* Handle errors by setting a flag and displaying a message if necessary.

		lparameters tnError, ;
			tcMethod, ;
			tnLine
		This.lErrorOccurred = .T.
		if not This.lSuppressError
			= messagebox('Error #' + ltrim(str(tnError)) + ' (' + message() + ;
				') occurred in line ' + ltrim(str(tnLine)) + ' of method ' + ;
				tcMethod + '.', 16)
		endif not This.lSuppressError
	endproc
enddefine
