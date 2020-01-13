*** START OF SDT DBC EVENTS CODE: DON'T REMOVE THIS LINE!
#define ccMETADATA_PATH    '<METADATA_PATH>'
#define ccDBCXMGR_PATH     '<DBCXMGR_PATH>'
#define ccSDTDBUTILS_PATH  '<SDTDBUTILS_PATH>'

procedure DBC_AfterAddRelation(tcRelationID, tcTableName, tcTableTag, ;
	tcRelatedTable, tcRelatedTag)
ValidateMetaData(dbc() + '!' + tcTableName + '.' + tcTableTag + ',' + ;
	tcRelatedTable + '.' + tcRelatedTag, 'Relation')

procedure DBC_AfterAddTable(tcTableName, tcLongTableName)
ValidateMetaData(dbc() + '!' + tcLongTableName, 'Table')

procedure DBC_AfterCreateConnection(tcConnectionName, tcDataSourceName, ;
	tcUserID, tcPassword, tcConnectionString)
ValidateMetaData(dbc() + '!' + tcConnectionName, 'Connection')

procedure DBC_AfterCreateTable(tcTableName, tcLongTableName)
local lcLongTableName
lcLongTableName = cursorgetprop('SourceName')
ValidateMetaData(dbc() + '!' + lcLongTableName, 'Table')

procedure DBC_AfterCreateView(tcViewName, tlRemote)
ValidateMetaData(dbc() + '!' + tcViewName, 'View')

procedure DBC_AfterDeleteConnection(tcConnectionName)
RemoveMetaData(dbc() + '!' + tcConnectionName, 'Connection')

procedure DBC_AfterDropRelation(tcRelationID, tcTableName, tcTableTag, ;
	tcRelatedTable, tcRelatedTag)
RemoveMetaData(dbc() + '!' + tcTableName + '.' + tcTableTag + ',' + ;
	tcRelatedTable + '.' + tcRelatedTag, 'Relation')

procedure DBC_AfterDropTable(tcTableName, tlRecycle)
RemoveMetaData(dbc() + '!' + tcTableName, 'Table')

procedure DBC_AfterDropView(tcViewName)
RemoveMetaData(dbc() + '!' + tcViewName, 'View')

procedure DBC_AfterModifyConnection(tcConnectionName, tlChanged)
if tlChanged
	ValidateMetaData(dbc() + '!' + tcConnectionName, 'Connection')
endif tlChanged

procedure DBC_AfterModifyTable(tcTableName, tlChanged)
local lcTableName, ;
	loUtil
if tlChanged and type('_screen.SDTController.Name') <> 'C' and ;
	version(2) <> 0 and not CalledFromSDTMethod()
	lcTableName = cursorgetprop('SourceName')
	ValidateMetaData(dbc() + '!' + lcTableName, 'Table')
	loUtil = newobject('SDTDBUtilities', locfile(ccSDTDBUTILS_PATH, 'vcx'))
	if vartype(loUtil) = 'O'
		loUtil.RedefineAllViews(tcTableName, oMeta, .T., .T.)
	endif vartype(loUtil) = 'O'
endif tlChanged ...

procedure DBC_AfterModifyView(tcViewName, tlCancelled)
if not tlCancelled
	ValidateMetaData(dbc() + '!' + tcViewName, 'View')
endif not tlCancelled

procedure DBC_AfterRemoveTable(tcTableName, tlDelete, tlRecycle)
RemoveMetaData(dbc() + '!' + tcTableName, 'Table')

procedure DBC_AfterRenameConnection(tcPreviousName, tcNewName)
RenameMetaData(dbc() + '!' + tcPreviousName, tcNewName, 'Connection')

procedure DBC_AfterRenameTable(tcPreviousName, tcNewName)
RenameMetaData(dbc() + '!' + tcPreviousName, tcNewName, 'Table')

procedure DBC_AfterRenameView(tcPreviousName, tcNewName)
RenameMetaData(dbc() + '!' + tcPreviousName, tcNewName, 'View')

procedure DBC_Deactivate(tcDatabaseName)

* When this database isn't the current one, nuke the DBCXMgr object since
* another DBC may have its meta data in a different directory.

if program(program(-1) - 1) <> 'DBCXMGR.'
	release oMeta
endif program(program(-1) - 1) <> 'DBCXMGR.'

procedure DBC_Activate(tcDatabaseName)

* When this database becomes the current one, instantiate a DBCXMgr object.

if program(program(-1) - 1) <> 'DBCXMGR.' and ;
	not upper(dbc()) == upper(tcDatabaseName)
	CreateDBCXMgr(tcDatabaseName)
endif program(program(-1) - 1) <> 'DBCXMGR.' ...

procedure ValidateMetaData(tcObjectName, tcObjectType)
local llReturn
do case
	case type('_screen.SDTController.Name') = 'C' or version(2) = 0 or ;
		CalledFromSDTMethod()
		llReturn = .T.
	case type('oMeta.Name') <> 'C' and not CreateDBCXMgr()
		llReturn = .F.
	otherwise
		llReturn = oMeta.Validate(tcObjectName, tcObjectType)
endcase
return llReturn

procedure RemoveMetaData(tcObjectName, tcObjectType)
local llReturn
do case
	case type('_screen.SDTController.Name') = 'C' or version(2) = 0 or ;
		CalledFromSDTMethod()
		llReturn = .T.
	case type('oMeta.Name') <> 'C' and not CreateDBCXMgr()
		llReturn = .F.
	otherwise
		llReturn = oMeta.DBCXDeleteRow(tcObjectName, tcObjectType)
endcase
return llReturn

procedure RenameMetaData(tcPreviousName, tcNewName, tcObjectType)
local llReturn
do case
	case type('_screen.SDTController.Name') = 'C' or version(2) = 0 or ;
		CalledFromSDTMethod()
		llReturn = .T.
	case type('oMeta.Name') <> 'C' and not CreateDBCXMgr()
		llReturn = .F.
	otherwise
		llReturn = oMeta.DBCXRenameObject(tcPreviousName, tcObjectType, ;
			tcNewName)
endcase
return llReturn

function CreateDBCXMgr(tcDBC)
local llReturn, ;
	lcDBC

* Do nothing if the SDT Database Explorer is open.

if type('_screen.SDTController.Name') = 'C' or version(2) = 0 or ;
	CalledFromSDTMethod()
	llReturn = .F.

* Instantiate DBCXMgr into a public variable called oMeta.

else
	release oMeta
	public oMeta
	oMeta = newobject('DBCXMgr', locfile(ccDBCXMGR_PATH, 'vcx'), '', .F., ;
		ccMETADATA_PATH, .T.)
	llReturn = vartype(oMeta) = 'O'
	if llReturn

* Tell DBCXMgr which database we're using and turn on the "show status" flag
* so we'll see the progress of validation.

		lcDBC = iif(pcount() = 1, tcDBC, dbc())
		oMeta.SetDatabase(lcDBC)
		oMeta.lShowStatus = .T.

* If we don't have a value for the "last modified" property for the database,
* the meta data tables were just created, so let's create meta data for the
* database and all its members.

		if isnull(oMeta.DBCXGetProp(juststem(lcDBC), 'Database', ;
			'LastModified'))
			oMeta.Validate(lcDBC)
		endif isnull(oMeta.DBCXGetProp( ...
	endif llReturn
endif type('_screen.SDTController.Name') = 'C' ...
return llReturn

function CalledFromSDTMethod
#if version(5) >= 700
local laStack[1]
astackinfo(laStack)
return ascan(laStack, 'SDTMGR', -1, -1, 3, 5) > 0 or ;
	ascan(laStack, 'DBCXMGR', -1, -1, 3, 5) > 0
#endif
*** END OF SDT DBC EVENTS CODE: DON'T REMOVE THIS LINE!
