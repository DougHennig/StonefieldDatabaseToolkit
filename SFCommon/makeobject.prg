*==============================================================================
* Program:			MakeObject
* Purpose:			Create an object from a specified class and library
* Author:			Doug Hennig
* Copyright:		(c) 1997-2005 Stonefield Systems Group Inc.
* Last revision:	01/24/2005
* Parameters:		tcClass   - the name of the class to instantiate
*					tcLibrary - the name of the class library containing
*						the class
*					tcInApp   - the name of the application the class is in
*					tuParm1   - an optional parameter to pass to the new
*						object's Init method
*					tuParm2   - an optional parameter to pass to the new
*						object's Init method
*					tuParm3   - an optional parameter to pass to the new
*						object's Init method
*					tuParm4   - an optional parameter to pass to the new
*						object's Init method
*					tuParm5   - an optional parameter to pass to the new
*						object's Init method
*					tuParm6   - an optional parameter to pass to the new
*						object's Init method
* Returns:			the return value from NEWOBJECT() (usually an object
*						reference but it could also be .NULL. if the object
*						failed to instantiate)
* Environment in:	if tcLibrary isn't specified, it must already be opened
*						with SET CLASSLIB (for a VCX) or SET LIBRARY or SET
*						PROCEDURE (for a PRG)
* Environment out:	the object may have been instantiated
* Note:				This routine should be used rather than NEWOBJECT()
*						because that function needs to find the VCX file even
*						if it's already in SET CLASSLIB
*==============================================================================

lparameters tcClass, ;
	tcLibrary, ;
	tcInApp, ;
	tuParm1, ;
	tuParm2, ;
	tuParm3, ;
	tuParm4, ;
	tuParm5, ;
	tuParm6
local lcLibrary, ;
	llLibrary, ;
	lnParms, ;
	loObject
lcLibrary = iif(empty(tcLibrary) or '\' + upper(tcLibrary) $ set('CLASSLIB') or ;
	upper(tcLibrary) $ set('PROCEDURE'), '', tcLibrary)
llLibrary = empty(lcLibrary) or file(tcLibrary) or ;
	file(tcLibrary + '.VCX') or file(tcLibrary + '.PRG') or ;
	file(tcLibrary + '.FXP')
lnParms   = pcount()
do case
	case lnParms = 1
		loObject = createobject(tcClass)
	case not llLibrary
		loObject = .NULL.
	case lnParms = 2
		loObject  = newobject(tcClass, lcLibrary)
	case lnParms = 3
		loObject  = newobject(tcClass, lcLibrary, tcInApp)
	case lnParms = 4
		loObject  = newobject(tcClass, lcLibrary, tcInApp, @tuParm1)
	case lnParms = 5
		loObject  = newobject(tcClass, lcLibrary, tcInApp, @tuParm1, ;
			@tuParm2)
	case lnParms = 6
		loObject  = newobject(tcClass, lcLibrary, tcInApp, @tuParm1, ;
			@tuParm2, @tuParm3)
	case lnParms = 7
		loObject  = newobject(tcClass, lcLibrary, tcInApp, @tuParm1, ;
			@tuParm2, @tuParm3, @tuParm4)
	case lnParms = 8
		loObject  = newobject(tcClass, lcLibrary, tcInApp, @tuParm1, ;
			@tuParm2, @tuParm3, @tuParm4, @tuParm5)
	case lnParms = 9
		loObject  = newobject(tcClass, lcLibrary, tcInApp, @tuParm1, ;
			@tuParm2, @tuParm3, @tuParm4, @tuParm5, @tuParm6)
endcase
return loObject
