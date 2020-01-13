#include FOXPRO.H

* Strings to substitute in error and other messages.

#define ccMSG_INSERT1                '<Insert1>'
#define ccMSG_INSERT2                '<Insert2>'
#define ccMSG_INSERT3                '<Insert3>'

* Error messages.

#define ccERR_NO_PROPERTY_SPECIFIED  'No property name was specified.'
#define ccERR_NO_DBC_SPECIFIED       'No database was specified.'
#define ccERR_NO_OBJ_TYPE_SPECIFIED  'No object type was specified.'
#define ccERR_NO_OBJ_NAME_SPECIFIED  'No object name was specified.'
#define ccERR_INVALID_PROPERTY_NAME  '<Insert1> is not a valid property name.'
#define ccERR_INVALID_OBJECT_NAME    '<Insert1> is not a valid object name.'
#define ccERR_INVALID_OBJECT_TYPE    '<Insert1> is not a valid object type.'
#define ccERR_PROPERTY_EXISTS        'Property <Insert1> already exists.'
#define ccERR_NO_SYSTEM_RECORD       'Unable to locate the System Record.'
#define ccERR_CANT_LOCK_REGISTRY     'Unable to update the last used row ID.'
#define ccERR_CANT_REGISTER_COREMGR  'Unable to register core manager.'
#define ccERR_CANT_VALIDATE          'Unable to validate <Insert1>. Would you like to continue the validation process?'
#define ccERR_CANT_CREATE_FILE       'Unable to create <Insert1>.'
#define ccERR_CANT_OPEN_FILE         'Unable to open <Insert1>.'
#define ccERR_CANT_CREATE_PROPCURSOR 'Unable to create properties cursor.'
#define ccERR_CANT_CREATE_PROPERTY   'Unable to create property <Insert1>.'
#define ccERR_CANT_DELETE_PROPERTY   'Unable to delete property <Insert1>.'
#define ccERR_CANT_INSTANTIATE_MGR   'Unable to instantiate class <Insert1>.'
#define ccERR_FILE_NOT_EXIST         'File <Insert1> does not exist.'
#define ccERR_DB_NOT_OPEN            'The database <Insert1> is not open.'
#define ccERR_INVALID_PARAMETERS     'Invalid parameters.'
#define ccERR_INVALID_MANAGER        '<Insert1> is not a valid DBCX extension manager.'
#define ccERR_INVALID_DATA_TYPE      'The data type of the property <Insert1> does not match the specified value.'
#define ccERR_CANT_DELETE_RECORD     'Cannot delete object record.'
#define ccERR_INVALID_KEY            'That is not a valid DBCX ID.'
#define ccERR_NO_NEW_NAME_SPECIFIED  'The new object name was not specified.'
#define ccERR_CANT_RENAME_RECORD     'Cannot rename all object records.'

* Other messages.

#define ccMSG_VALIDATING_DATABASE    'Validating database...'
#define ccMSG_VALIDATING_TABLE       'Validating table <Insert1>...'
#define ccMSG_VALIDATING_VIEW        'Validating view <Insert1>...'
#define ccMSG_VALIDATING_RELATION    'Validating relation <Insert1>...'
#define ccMSG_VALIDATING_CONNECTION  'Validating connection <Insert1>...'
#define ccMSG_VALIDATING_OBJECT      'Validating <Insert1> <Insert2>...'
#define ccMSG_CONVERT_DBCXMETA       'The meta data tables need be converted to the latest structures. Would you like to do so now?'
#define ccMSG_DEBUGGER               'An error occurred. The VFP Debugger will be displayed and program execution suspended.'
#define ccMSG_WARNING                'Display the VFP Debugger and suspend program execution?'
#define ccMSG_CONVERTING             'Converting <Insert1>...'

* Other strings.

#define ccMSG_METHOD                 'Method:'
#define ccMSG_ERROR_NUM              'Error #:'
#define ccMSG_MESSAGE                'Message:'
#define ccMSG_LINE_NUM               'Line #:'
#define ccCAPTION_DBCXMGR            'DBCX Manager'

* Error resolution return values.

#define ccMSG_RETRY					 'Retry'
#define ccMSG_CONTINUE				 'Continue'
#define ccMSG_CLOSEFORM				 'Close Form'
#define ccMSG_QUIT					 'Quit'
#define ccMSG_CANCEL				 'Cancel'
#define ccMSG_DEBUG					 'Debug'

* VFP error numbers.

#define cnERR_FILE_NOT_FOUND		    1
	* File does not exist
#define cnERR_FILE_IN_USE               3
	* File in use
#define cnERR_ODBC                   1526
	* ODBC error
#define cnERR_BASE_FIELDS_CHANGED    1542
	* Base fields have changed
#define cnERR_FIELD_NOT_ACCEPT_NULL  1581
	* Fields does not accept null values
#define cnERR_ACCESS_DENIED			 1705
	* File access is denied
#define cnERR_SQL_COLUMN_NOT_FOUND   1806
	* SQL column not found
