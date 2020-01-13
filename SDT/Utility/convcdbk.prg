lparameter tcDirectory
if type('tcDirectory') <> 'C'
	wait window 'Please specify a directory name.'
	return
endif type('tcDirectory') <> 'C'
lcDirectory = tcDirectory + iif(right(tcDirectory, 1) $ ':\', '', '\')
if not file(lcDirectory + 'CDBKMETA.DBF')
	wait window 'Please specify a directory where the meta data tables are located.'
	return
endif not file(lcDirectory + 'CDBKMETA.DBF')

* Open the tables.

close tables all
use (lcDirectory + 'CDBKMETA') in 0
use (lcDirectory + 'SDTMETA')  in 0 exclusive
use (lcDirectory + 'SDTUSER')  in 0
cursorsetprop('Buffering', 1, 'SDTUSER')
cursorsetprop('Buffering', 1, 'SDTMETA')

* Add the custom properties to SDTUSER.

if type('SDTMETA.CSCXPROMPT') = 'U'
	insert into SDTUSER values ;
		('CBcSCXPrompt', ;
		'F', ;
		'CSCXPROMPT', ;
		'C', ;
		30, ;
		0)
	insert into SDTUSER values ;
		('CBcDLGPrompt', ;
		'F', ;
		'CDLGPROMPT', ;
		'C', ;
		30, ;
		0)
	insert into SDTUSER values ;
		('CBcLSTPrompt', ;
		'F', ;
		'CLSTPROMPT', ;
		'C', ;
		30, ;
		0)
	insert into SDTUSER values ;
		('CBcFRXCol1', ;
		'F', ;
		'CFRXCOL1', ;
		'C', ;
		30, ;
		0)
	insert into SDTUSER values ;
		('CBcFRXCol2', ;
		'F', ;
		'CFRXCOL2', ;
		'C', ;
		30, ;
		0)
	insert into SDTUSER values ;
		('CBmOutFormat', ;
		'F', ;
		'MOUTFORMAT', ;
		'M', ;
		4, ;
		0)
	insert into SDTUSER values ;
		('CBmMessage', ;
		'F', ;
		'MMESSAGE', ;
		'M', ;
		4, ;
		0)
	insert into SDTUSER values ;
		('CBmToolTip', ;
		'F', ;
		'MTOOLTIP', ;
		'M', ;
		4, ;
		0)
	insert into SDTUSER values ;
		('CBmRangeLo', ;
		'F', ;
		'MRANGELO', ;
		'M', ;
		4, ;
		0)
	insert into SDTUSER values ;
		('CBmRangeHi', ;
		'F', ;
		'MRANGEHI', ;
		'M', ;
		4, ;
		0)
	insert into SDTUSER values ;
		('CBmHelpText', ;
		'F', ;
		'MHELPTEXT', ;
		'M', ;
		4, ;
		0)

* Add the new fields to SDTMETA.

	alter table SDTMETA ;
		add column cSCXPrompt C(30) ;
		add column cDLGPrompt C(30) ;
		add column cLSTPrompt C(30) ;
		add column cFRXCOL1   C(30) ;
		add column cFRXCOL2   C(30) ;
		add column mOutFormat M ;
		add column mMessage   M ;
		add column mToolTip   M ;
		add column mRangeLo   M ;
		add column mRangeHi   M ;
		add column mHelpText  M
endif type('SDTMETA.CSCXPROMPT') = 'U'

* Add the value of each property in CDBKMETA to the corresponding record in
* SDTMETA

select CDBKMETA
scan for cRecType = 'F'
	lcKey = upper(padr(cDBCName, len(SDTMETA.DBCName)) + 'F' + ;
		padr(trim(cCursor) + '.' + cField, len(SDTMETA.ObjectName)))
	if seek(lcKey, 'SDTMETA', 'OBJECTNAME')
		replace cSCXPrompt with CDBKMETA.cSCXPrompt, ;
			cDLGPrompt with CDBKMETA.cDLGPrompt, ;
			cLSTPrompt with CDBKMETA.cLSTPrompt, ;
			cFRXCol1 with CDBKMETA.cFRXCol1, ;
			cFRXCol2 with CDBKMETA.cFRXCol2, ;
			mOutFormat with CDBKMETA.mOutFormat, ;
			mMessage with CDBKMETA.mMessage, ;
			mToolTip with CDBKMETA.mToolTip, ;
			mRangeLo with CDBKMETA.mRangeLo, ;
			mRangeHi with CDBKMETA.mRangeHi, ;
			mHelpText with CDBKMETA.mHelpText ;
			in SDTMETA
	endif seek(lcKey, 'SDTMETA', 'OBJECTNAME')
endscan for cRecType = 'F'
close tables all
