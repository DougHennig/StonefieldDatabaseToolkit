* Set up the environment and create an error handler.

#include ..\SOURCE\SDT.H
close all
clear all
oError = createobject('ErrorObject')
on error oError.ErrorHandler(error(), message(), lineno())

* Open the database.

open database DEV\TESTDATA

* Set up DBCXMgr.

set classlib to DBCXMGR
oMeta = createobject('DBCXMgr', .F., 'DEV')
oMeta.SetDatabase(dbc())

* Try to open all tables.

oMeta.oSDTMgr.lQuiet = .T.
oMeta.oSDTMgr.OpenAllTables()
on error
set

**********************************
define class ErrorObject as custom
**********************************

	procedure ErrorHandler
		parameters tnError, tcMessage, tnLineno
		do case

* If an index error occurred (5 = record out of range, 19 = index doesn't match
* DBF, 20 = record not in index, 23 = index expression too big, 26 = table
* isn't ordered, 112 = invalid key length, 114 = index file doesn't match DBF,
* 1124 = key too big, 1683 = tag not found, 1707 = structural CDX not found,
* 1567 = primary key invalid), reindex the table.

			case inlist(tnError, 5, 19, 20, 23, 26, 112, 114, 1124, 1683, ;
				1707, 1567) and not empty(oMeta.oSDTMgr.cAlias)
				oMeta.oSDTMgr.Reindex(oMeta.oSDTMgr.cAlias)
				return ccMSG_RETRY

* If the table or memo is corrupted (15 = not a table, 41 = memo missing or
* invalid, 2091 = table has become corrupted), repair it.

			case inlist(tnError, 15, 41, 2091) and ;
				not empty(oMeta.oSDTMgr.cAlias)
				oMeta.oSDTMgr.Repair(oMeta.oSDTMgr.cAlias)
				return ccMSG_RETRY
		endcase
	endproc
enddefine
