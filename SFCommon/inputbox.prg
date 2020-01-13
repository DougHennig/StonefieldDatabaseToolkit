lparameters tcPrompt, ;
	tcCaption, ;
	tcDefault
local lcReturn
do case
	case pcount() = 0
		error 1229
	case vartype(tcPrompt) <> 'C'
		error 11
endcase
set classlib to SFCtrls, SFButton additive
loForm = createobject('frmInputBox', tcPrompt, tcCaption, tcDefault)
loForm.Show()
if vartype(loForm) = 'O'
	lcReturn = loForm.cValue
else
	lcReturn = ''
endif vartype(loForm) = 'O'
return lcReturn

define class frmInputBox as SFModalDialog
	Height  = 89
	Width   = 380
	Caption = 'Enter Value'
	cValue  = ''
	Name    = 'frmInputBox'

	add object lblPrompt as SFLabel with ;
		Caption = 'Value', ;
		Left    = 10, ;
		Top     = 18, ;
		Name    = 'lblPrompt'

	add object txtValue as SFTextbox with ;
		Left  = 48, ;
		Top   = 15, ;
		Width = 322, ;
		Name  = 'txtValue'

	add object cmdOK as SFOKButton with ;
		Top     = 50, ;
		Left    = 103, ;
		Default = .T., ;
		Name    = 'cmdOK'

	add object cmdCancel as SFCancelButton with ;
		Top  = 50, ;
		Left = 193, ;
		Name = 'cmdCancel'

	procedure Init
		lparameters tcPrompt, ;
			tcCaption, ;
			tcDefault
		with This
			.lblPrompt.Caption = tcPrompt
			if vartype(tcCaption) = 'C'
				.Caption = tcCaption
			endif vartype(tcCaption) = 'C'
			if vartype(tcDefault) = 'C'
				.txtValue.Value = tcDefault
			endif vartype(tcDefault) = 'C'
		endwith
		dodefault()
	endproc

	procedure Activate
		with This
			.txtValue.Left  = .lblPrompt.Left + .lblPrompt.Width + 5
			.txtValue.Width = .Width - .txtValue.Left - 10
		endwith
		dodefault()
	endproc

	procedure Unload
		return This.cValue
	endproc

	procedure cmdOK.Click
		with Thisform
			.cValue = alltrim(.txtValue.Value)
			.Hide()
		endwith
	endproc
enddefine
