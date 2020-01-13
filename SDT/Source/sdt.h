#include DBCXMGR.H
#include SDTENGLISH.H

* Product names.

#define ccFULL_PRODUCT_NAME     'Stonefield Database Toolkit'

* Control characters.

#define ccFIELD_TERMINATOR      chr(13)
#define ccCRLF                  chr(13) + chr(10)
#define ccCR                    chr(13)
#define ccNULL                  chr(0)
#define ccTAB                   chr(9)

* SDT Preferences Registry Keys.

#define ccPREF_LISTACTION       'ListAction'
#define ccPREF_DBCXREG_SAME_DIR 'DBCXREG Same Directory As DBC'
	* for backward compatibility only -- not used anymore
#define ccPREF_DBCXREG_SPEC_DIR 'DBCXREG Specific Directory'
#define ccPREF_ASK_FOR_DBCXREG  'Ask for DBCXREG Location'
#define ccPREF_SHOW_INTL        'Show International'
#define ccPREF_NAMING_CONV      'Codebook naming convention'
#define ccPREF_DBC_SELECTION    'Database Selection'
#define ccPREF_DBC_SPEC_DIR     'Database Specific Directory'
#define ccPREF_USE_CURRENT_DBC  'Use current database'
#define ccPREF_ALWAYS_ASK_DBC   'Always ask for database'
#define ccPREF_ASK_IF_MANY      'Ask if more than one open'
#define ccPREF_OPEN_DBC_IN_DIR  'Open database in specific directory:'
#define ccPREF_FIELD_REP_DIR    'Field Repository Directory'
#define ccPREF_VIEW_INHERITANCE 'View field property inheritance'
#define ccPREF_AUTO_EXPAND      'Auto-expand tree'
#define ccPREF_AUTO_LOADTREE    'Auto-load tree'
#define ccPREF_FIELD_TEMPLATE   'Fields template'
#define ccPREF_TABLE_TEMPLATE   'Tables template'
#define ccPREF_INDEX_TEMPLATE   'Indexes template'
#define ccPREF_VIEW_TEMPLATE    'Views template'
#define ccPREF_SUMMARY_TEMPLATE 'Summary template'
#define ccPREF_FONTNAME         'Font Name'
#define ccPREF_FONTSIZE         'Font Size'
#define ccPREF_DBCXSEARCH       'DBCXREG Search Path'
#define ccPREF_USE_FIELDREP     'Use Field Repository'

* Miscellaneous constants.

#define cnBORDER                 4
	* the number of pixels added to the width of a 3-D textbox
	* (2 pixels left + 2 pixels right)
#define cn3DBORDER               0
	* the value of SpecialEffect for a 3-D border
#define cnSPNWIDTH              31
	* extra space needed around spinners
#define ccMETA_TABLE            'meta table'
#define ccLIBRARY_TABLE         '_LIBRARY'
#define ccREG_KEY               'Software\Stonefield Systems Group Inc.\SDT\6.0\Properties'
	* Windows registry key for preferences
#define ccREG_KEY_META_PATHS    'Software\Stonefield Systems Group Inc.\SDT\6.0\Meta Paths'
	* Windows registry key for meta data paths
#define ccREG_KEY_FORMER        'Software\Stonefield Systems Group Inc.\SDT\5.0\Properties'
	* Windows registry key for preferences
#define ccREG_KEY_SDT51        'Software\Stonefield Systems Group Inc.\SDT\5.1\Properties'
	* Windows registry key for preferences
#define ccCOMMDLG_CANCEL_MSG    'Cancel was selected'
	* The error message when cancel is chosen in the CommonDialog control
#define ccDIRECTIVE_NOFILTER    '*:SFQUERY NOFILTER'
#define ccSDT_MENU_PAD          '_MSM_TOOLS'
	* The menu pad under which SDT appears
#define ccSDT_FORM              'SDT'
#define clVFP7ORLATER           type('version(5)') <> 'U' and evaluate('version(5)') >= 700

* VFP index types.

#define ccPRIMARY               'Primary'
#define ccREGULAR               'Regular'
#define ccCANDIDATE             'Candidate'
#define ccUNIQUE                'Unique'
#define ccBINARY                'Binary'

* VFP base classes for Intellidrop.

#define cnBASE_CLASSES          10
#define ccDEFAULT_CLASS         '<Default>'
#define ccCHECKBOX              'Checkbox'
#define ccCOMBOBOX              'Combobox'
#define ccEDITBOX               'Editbox'
#define ccGRID                  'Grid'
#define ccLISTBOX               'Listbox'
#define ccOLEBOUNDCONTROL       'OLEBoundControl'
#define ccOPTIONGROUP           'OptionGroup'
#define ccSPINNER               'Spinner'
#define ccTEXTBOX               'Textbox'

* LLFF error numbers.

#define cnLLFF_ERR_NOT_FOUND    2
	* File not found
#define cnLLFF_ERR_TOO_MANY     4
	* Too many files open
#define cnLLFF_ERR_NO_ACCESS    5
	* Access denied
#define cnLLFF_ERR_OUT_MEMORY   8
	* Out of memory
#define cnLLFF_ERR_OTHER        31
	* Error opening file

* DBF and FPT header information.

#define cnDBF_CDX_BIT           28
#define cnDBF_CODE_PAGE         29
#define cnDBF_FIRST_FIELD       32
#define cnDBF_FIELD_DEFN_SIZE   32
#define cnDBF_FIELD_NAME_SIZE   10
#define cnDBF_SYSTEM_FIELD       5
#define cnDBF_HEADER_LENGTH      8
#define cnDBF_NUM_RECORDS        4
#define cnDBF_RESERVED_BYTES1   16
	* number of reserved bytes (first set) in the DBF header
#define cnDBF_RESERVED_BYTES2    2
	* number of reserved bytes (second set) in the DBF header
#define cnDBF_RESERVED_BYTES3    8
	* number of reserved bytes in a field definition
#define cnDBF_HAS_MEMO           2
	* the CDX/FPT flag byte value for a table with a memo file
#define ccDBF_NULL_FLAGS        '_NullFlags'
	* the name of the _NullFlags field
#define ccDBF_NULL_FLAGS_TYPE   '0'
	* the type of the _NullFlags field
#define cnDBF_FIELDFLAG_SYSTEM   1
	* the field flag setting for a system field
#define cnDBF_FIELDFLAG_NULL     2
	* the field flag setting for field that accept null values
#define cnDBF_FIELDFLAG_BINARY   4
	* the field flag setting for a binary field type
#define cnDBF_FIELDFLAG_AUTOINC  12
	* the field flag setting for an auto-inc field
#define cnDBF_NEXTVALUE_OFFSET   9
	* the offset from the end of the field name to the start of the auto-inc
	* next value
#define ccDBF_NEW_TYPES          'YTBI'
#define cnFPT_DEFAULT_BLOCK_SIZE 64
#define cnFPT_HEADER_SIZE        512
#define cnFPT_BLOCK_SIZE_DIVISOR 512

* DBC object types padded to the length of the OBJECTTYPE field and using the
* same case.

#define cnVF_OBJ_TYPESIZE       10
#define ccVF_OBJ_CONNECTION     'Connection'
#define ccVF_OBJ_DATABASE       'Database  '
#define ccVF_OBJ_FIELD          'Field     '
#define ccVF_OBJ_INDEX          'Index     '
#define ccVF_OBJ_RELATION       'Relation  '
#define ccVF_OBJ_TABLE          'Table     '
#define ccVF_OBJ_VIEW           'View      '
#define ccVF_OBJ_STOREDPROCSRC  'StoredProceduresSource'
#define cnVF_OBJID_DATABASE      1

* DBC property IDs.

#define cnVF_TABLE_FILEPATH      1
#define cnVF_OBJ_SUBTYPE         2
#define cnVF_RULE_EXPR           9
#define cnVF_RULE_TEXT          10
#define cnVF_DEFAULT            11
#define cnVF_REL_TAG            13
#define cnVF_INDEX_TAGTYPE      17
#define cnVF_REL_FKTABLE        18
#define cnVF_REL_FKTAG          19
#define cnVF_TABLE_PRIMARYTAG   20
#define cnVF_VIEW_SQL           42
#define cnVF_VIEW_TABLES        43
#define cnVF_VIEWFLD_UPDATENAME 35

* DBC property values.

#define ccVF_IND_REGULAR        chr(0)
#define ccVF_IND_CANDIDATE      chr(1)
#define ccVF_OBJ_LOCALTABLE     chr(1)
#define ccVF_OBJ_LOCALVIEW      chr(6)

* VFP limits.

#define cnVF_LONGNAME_LENGTH    128
	* the length of a long name
#define cnVF_BACKLINK_LENGTH    263
	* the length of the database backlink in the DBF header
#define cnVF_INDEX_MAXKEYLEN    240
	* the length of an index expression
#define cnVF_INDEX_MAXNAMELEN    10
	* the length of a tag name
#define cnVF_FIELD_MAXCOUNT     255
	* the maximum # of fields
#define cnVF_FIELD_MAXNAMELEN    10
	* the length of a "real" field name

* Other FoxPro constants.

#define cnVFP_LOCAL_VIEW        1
	* The value returned by DBGETPROP('SourceType') for local views.
#define ccVFP_TABLE_FOXPLUS     '131'
	* The value returned by SYS(2029) for a FoxPlus table
#define cnVFP_TABLE_FOXPLUS     131
	* The value returned by SYS(2029) for a FoxPlus table converted to numeric
#define ccVFP_TABLE_VFP         '48'
	* The value returned by SYS(2029) for a VFP table
#define cnVFP_TABLE_VFP         48
	* The numeric value for a VFP table
#define cnVFP_TABLE_VFP_8       49
	* The byte in position 0 of a DBF header for a table with VFP 8 or later features (eg. auto-inc)
#define cnVFP_TABLE_VFP_9       50
	* The byte in position 0 of a DBF header for a table with VFP 9 or later features (eg. Varchar)

* Common Dialog constants.

#define ccFILEDLG_OVERWRITE     0x2
#define ccFILEDLG_HIDERO        0x4
#define ccFILEDLG_SHOWHELP      0x10
#define ccFILEDLG_MULTIPLE      0x200
#define ccFILEDLG_PATHEXIST     0x800
#define ccFILEDLG_FILEEXIST     0x1000
#define ccFILEDLG_PROMPTNEW     0x2000
#define ccFILEDLG_SHAREAWARE    0x4000

* Registry constants.

#define cnSUCCESS                    0
#define cnRESERVED                   0
#define cnREG_SZ                     1
	* the size of a data string
#define cnBUFFER_SIZE                256
	* the size of the buffer for the key value

* Registry key values.

#define cnHKEY_CLASSES_ROOT          -2147483648
#define cnHKEY_CURRENT_USER          -2147483647
#define cnHKEY_LOCAL_MACHINE         -2147483646
#define cnHKEY_USERS                 -2147483645

* AERROR() array dimensions, including added extensions:

#define cnAERR_NUMBER				 1
#define cnAERR_MESSAGE				 2
#define cnAERR_OBJECT				 3
#define cnAERR_WORKAREA				 4
#define cnAERR_TRIGGER				 5
#define cnAERR_EXTRA1				 6
#define cnAERR_EXTRA2				 7
#define cnAERR_METHOD				 8
#define cnAERR_LINE					 9
#define cnAERR_SOURCE				10
#define cnAERR_DATETIME				11
#define cnAERR_USER					12
#define cnAERR_MAX					cnAERR_USER

* DBC events constants:

#define ccSTART_SDT_EVENT_CODE      "*** START OF SDT DBC EVENTS CODE: DON'T REMOVE THIS LINE!"
#define ccEND_SDT_EVENT_CODE        "*** END OF SDT DBC EVENTS CODE: DON'T REMOVE THIS LINE!"

* VFP error numbers:

#define cnERR_ALIAS_NOTFOUND		  13
	* Alias is not found
#define cnERR_INDEX_FILE_TABLE        19
	* Index file doesn't match table
#define cnERR_INVALID_SUBSCRIPT		  31
	* Invalid subscrip reference
#define cnERR_TYPE_MISMATCH          107
	* Operator/operand type mismatch
#define cnERR_RECINUSE				 109
	* Record in use by another user
#define cnERR_INDEX_MATCH_TABLE      114
	* Index doesn't match table
#define cnERR_ARRAYDIM				 230
   * Array dimensions are invalid
#define cnERR_TOO_FEW_ARGS			1229
	* Too few arguments
#define cnERR_OLE_EXEC_FAIL         1426
	* OLE error: remote procedure call failed
#define cnERR_OLE_ERROR             1429
	* OLE error
#define cnERR_EXECUTION_CANCELED    1523
	* Execution was canceled by user
#define cnERR_BELONGANOTHER2        1537
	* Table belongs to another database
#define cnERR_TRIGGER_FAILED		1539
	* Trigger failed
#define cnERR_OBJECT_NOT_IN_DBC     1562
	* Object not found in database
#define cnERR_BELONGANOTHER         1565
	* Table belongs to another database
#define cnERR_PRIM_KEY_INVALID		1567
	* Primary key property invalid
#define cnERR_NONULLS				1581
	* Field does not accept null values
#define cnERR_FIELD_RULE_FAILED		1582
	* Field validation rule is violated
#define cnERR_TABLE_RULE_FAILED		1583
	* Record validation rule is violated
#define cnERR_RECMODIFIED			1585
	* Update conflict
#define cnERR_CDX_NOT_FOUND			1707
	* Structural CDX not found
#define cnERR_NO_CLASS_DEFN         1733
	* Class definition not found
#define cnERR_PROPERTY_READ_ONLY	1743
	* Property is read-only
#define cnERR_DUPLKEY				1884
	* Uniqueness of index is violated
#define cnERR_DE_UNLOADED			1967
	* Data environment is already unloaded
#define cnERR_TABLE_IN_USE			1995
	* Error loading the data environment: table is in use
#define cnERR_TABLE_MOVED			2004
	* The table has moved

* Include a file for user-defined constants.

#if file('SDTUSER.H')
#include SDTUSER.H
#endif
