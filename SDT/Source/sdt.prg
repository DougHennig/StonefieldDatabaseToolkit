*==============================================================================
* Program:			SDT
* Purpose:			Startup program for Stonefield Database Toolkit
* Author:			Doug Hennig
* Copyright:		(c) 1996-2003 Stonefield Systems Group Inc.
* Last revision:	03/12/2003
*==============================================================================

lparameters tcAction, ;
	tcPopup
local lcCurrTalk, ;
	lcCurrExact, ;
	lcAction
#include 'SDT.H'

* Save the current TALK and EXACT settings and set them both off.

if set('TALK') = 'ON'
	set talk off
	lcCurrTalk = 'ON'
else
	lcCurrTalk = 'OFF'
endif set('TALK') = 'ON'
lcCurrExact = set('EXACT')
set exact off

* Handle the action parameter.

lcAction = iif(vartype(tcAction) <> 'C', '', upper(tcAction))
do case

* If we weren't called with a parameter, this is an "install" call, so do the
* installation.

	case pcount() = 0
		do InstallSDT

* Run SDT.

	case lcAction = 'RUN'
		do RunSDT

* Handle Preferences.

	case lcAction = 'PREF'
		do SDTPref

* If we were called with "INSTALL" and a popup name, install in that popup.

	case lcAction = 'INSTALL' and pcount() = 2
		do InstallSDT with tcPopup
endcase

* Cleanup and return.

if lcCurrExact = 'ON'
	set exact on
endif lcCurrExact = 'ON'
if lcCurrTalk = 'ON'
	set talk on
endif lcCurrTalk = 'ON'
return
		
*==============================================================================
* Procedure:		RunSDT
* Purpose:			Bring up SDT
* Author:			Doug Hennig
* Copyright:		(c) 1996-2001 Stonefield Systems Group Inc.
* Last revision:	06/19/2001
* Parameters:		none
* Environment in:	none
* Environment out:	if one doesn't already exist, a SDTController object (in
*						MANAGERS.VCX) is added to _screen
*					the SDT main form is called
*==============================================================================

* Check to see if an SDTController object exists in _screen. If not, create
* one.

procedure RunSDT
set classlib to SDTManagers, SFRegistry additive
if type('_screen.SDTController.Name') <> 'C'
	_screen.AddObject('SDTController', 'SDTController')
endif type('_screen.SDTController.Name') <> 'C'

* Call the StartSDT method of the SDTController object to open an instance of
* the SDT main form.

_screen.SDTController.StartSDT()
return
		
*==============================================================================
* Procedure:		InstallSDT
* Purpose:			Install SDT in the system menu bar
* Author:			Doug Hennig
* Copyright:		(c) 1996-2003 Stonefield Systems Group Inc.
* Last revision:	03/12/2003
* Parameters:		tcPopup - the popup to install SDT into
* Environment in:	none
* Environment out:	SDT is installed in the system menu bar
*==============================================================================

procedure InstallSDT
lparameters tcPopup
local lcAppPath, ;
	lcAppName, ;
	lnBar, ;
	lcBar, ;
	llPopup, ;
	lcPad, ;
	lnI, ;
	lcLocate

* Save the application we're running into lcAppPath and lcAppName.

lcAppPath = sys(16)
lcAppPath = substr(lcAppPath, at(' ', lcAppPath, 2) + 1)
lcAppName = justfname(lcAppPath)

* Display the startup screen.

do form LOGO

* Install ourselves in the appropriate menu if necessary, then return.

lnBar   = 0
lcBar   = strtran(ccMENU_BAR_PROMPT_SDT, '\<')
llPopup = vartype(tcPopup) = 'C' and not empty(tcPopup)
lcPad   = iif(llPopup, upper(tcPopup), ccSDT_MENU_PAD)
lnPad   = 0
for lnI = 1 to cntpad('_msysmenu')
	if getpad('_msysmenu', lnI) = lcPad
		lnPad = lnI
		exit
	endif getpad('_msysmenu', lnI) = lcPad
next lnI
if lnPad > 0
	for lnI = cntbar(lcPad) to 1 step -1
		if prmbar(lcPad, getbar(lcPad, lnI)) = lcBar
			lnBar = lnI
			exit
		endif prmbar(lcPad ...
	next lnI
	if lnBar = 0
		lnBar = cntbar(lcPad) + 1
		define bar lnBar     of &lcPad after _mlast prompt '\-'
		define bar lnBar + 1 of &lcPad  after _mlast ;
			prompt ccMENU_BAR_PROMPT_SDT
		define bar lnBar + 2 of &lcPad after _mlast ;
			prompt ccMENU_BAR_PROMPT_PREF
	else
		lnBar = lnBar - 1
	endif lnBar = 0
	lcLocate = "'" + strtran(ccMSG_LOCATE, ccMSG_INSERT1, lcAppName) + "'"
	on selection bar lnBar + 1 of &lcPad ;
		do locfile('&lcAppPath', 'APP', &lcLocate, '&lcAppName') with 'Run'
	on selection bar lnBar + 2 of &lcPad ;
		do locfile('&lcAppPath', 'APP', &lcLocate, '&lcAppName') with 'Pref'
	if not llPopup
		set sysmenu save
	endif not llPopup
else
	do RunSDT
endif lnPad > 0
return

*==============================================================================
* Procedure:		SDTPref
* Purpose:			Bring up the SDT Preferences form
* Author:			Doug Hennig
* Copyright:		(c) 1996-2003 Stonefield Systems Group Inc.
* Last revision:	01/17/2003
* Parameters:		none
* Environment in:	none
* Environment out:	none
*==============================================================================

procedure SDTPref
local lcHelp, ;
	lcHelpFile, ;
	loUtility, ;
	lcHelpDir

* Save the current help setting and file.

lcHelp     = set('HELP')
lcHelpFile = set('HELP', 1)

* Set up our help file.

loUtility = newobject('SFUtility', 'SFUtility')
lcHelpDir = loUtility.GetAppDirectory(sys(16))
if file(lcHelpDir + 'SDT.CHM')
	set help on
	set help to (lcHelpDir + 'SDT.CHM')
endif file(lcHelpDir + 'SDT.CHM')

* Display the preferences form.

do form SDTPREF

* Clean up.

set topic id to
if not empty(lcHelpFile) and file(lcHelpFile)
	set help to (lcHelpFile)
endif not empty(lcHelpFile) ...
if lcHelp = 'OFF'
	set help off
endif lcHelp = 'OFF'
return
		
*==============================================================================
* Class:			SFTreeView
* Purpose:			Subclass of TreeView control
* Author:			Doug Hennig
* Copyright:		(c) 1998 Stonefield Systems Group Inc.
* Last revision:	07/31/98
*==============================================================================

define class SFTreeList as OLEControl
	OLEClass = 'COMCTL.TreeCtrl'
	Name     = 'SFTreeList'

	procedure Collapse
		lparameters toNode
		Thisform.TreeCollapse(toNode)
	endproc

	procedure Expand
		lparameters toNode
		Thisform.TreeExpand(toNode)
	endproc

	procedure NodeClick
		lparameters toNode
		Thisform.TreeNodeClick(toNode)
	endproc

	procedure KeyDown
		lparameters tnKeycode, tnShift
		Thisform.TreeKeyPress(tnKeycode, tnShift)
	endproc

	procedure MouseDown
		lparameters tnButton, tnShift, tnX, tnY
		Thisform.TreeMouseDown(tnButton, tnShift, tnX, tnY)
	endproc

	procedure MouseMove
		lparameters tnButton, tnShift, tnX, tnY
		Thisform.TreeMouseMove(tnButton, tnShift, tnX, tnY)
	endproc

	procedure DblClick
		Thisform.TreeDblClick()
	endproc

	procedure DragDrop
		lparameters toSource, tnXCoord, tnYCoord
		Thisform.TreeDragDrop(toSource, tnXCoord - This.Left, ;
			tnYCoord - This.Top)
	endproc

	procedure DragOver
		lparameters toSource, tnXCoord, tnYCoord, tnState
		Thisform.TreeDragOver(toSource, tnXCoord - This.Left, ;
			tnYCoord - This.Top, tnState)
	endproc
enddefine
