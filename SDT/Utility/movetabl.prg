*==============================================================================
* Program:			MoveTabl
* Purpose:			Changes the location of a table in the DBC
* Author:			Doug Hennig
* Copyright:		(c) 1996-2001 Stonefield Systems Group Inc.
* Last Revision:	08/07/2001
* Parameters:		tcTable   - the alias (long name) of the table
*					tcNewPath - the complete new path for the table, including
*						the DBF name
* Returns:			.T. if the changes were made successfully
* Environment in:	the SDT and DBCX meta data tables are either in the same
*						directory as the database or are in the VFP path
*					the database containing the table is selected
* Environment out:	the DBC PATH property for the table and the DBF header have
*						been changed accordingly
*==============================================================================

#include '..\SOURCE\SDT.H'
lparameters tcTable, ;
	tcNewPath
local oMeta, ;
	lcDBC, ;
	llOK

* Error if no DBC is open.

if empty(set('DATABASE'))
	wait window 'Please select a database first.'
	return .F.
endif empty(set('DATABASE'))

* Instantiate the DBCX DBCXMgr class.

set classlib to DBCXMGR additive
oMeta = createobject('DBCXMgr')
if type('oMeta') <> 'O' or isnull(oMeta)
	wait window 'Could not instantiate DBCXMgr.'
	return .F.
endif type('oMeta') <> 'O' ...

* Try to open the DBC as a table. If we could open it, try to find the table
* in the DBC. If we found it, change its path to the new one and write the new
* backlink to the DBC in the table header.

use (dbc()) again shared
lcDBC = alias()
do case
	case empty(lcDBC)
		llOK = .F.
		wait window 'The database could not be opened as a table.'
	case not oMeta.oSDTMgr.DBCFindObject(tcTable, ccVF_OBJ_TABLE, lcDBC, 1)
		llOK = .F.
		wait window tcTable + ' was not found in the database.'
	otherwise
		oMeta.oSDTMgr.DBCSetProp(cnVF_TABLE_FILEPATH, ;
			sys(2014, tcNewPath, dbc()), lcDBC, 1)
		llOK = oMeta.oSDTMgr.WriteBackLink(tcNewPath, sys(2014, dbc(), ;
			tcNewPath)) >= 0
endcase

* Clean up.

if used(lcDBC)
	use in (lcDBC)
endif used(lcDBC)
return llOK
