*==============================================================================
* Function:			TextMerge
* Purpose:			Performs a text merge on the specified string, expanding
*						all expressions between the left and right expression
*						delimiters
* Author:			Doug Hennig
* Copyright:		(c) 2000 Stonefield Systems Group Inc.
* Last revision:	02/27/2001
* Parameters:		tcString  - the string to text merge
*					tlRecurse - .T. to text merge the string as many times as
* 						necessary, which handles nested expressions
*					tcLeft    - the left expression delimiter (optional: if it
*						isn't specified, the default is used
*					tcRight   - the right expression delimiter (optional: if it
*						isn't specified, the default is used
* Returns:			the text merged string
* Environment in:	none
* Environment out:	none
* Notes:			This code uses EXECSCRIPT() to process some code that does
*						the text merge. The reason for doing it this way rather
*						than just text merging the string to a file is because
*						the text merge commands (\ and \\) aren't recursive, so
*						they can't evaluate the expressions inside the string
*						we would text merge
*==============================================================================

lparameters tcString, ;
	tlRecurse, ;
	tcLeft, ;
	tcRight
local lcDelimiters, ;
	lnDelimiters, ;
	lcDefaultLeft, ;
	lcDefaultRight, ;
	lcLeft, ;
	lcRight, ;
	lcString, ;
	lcTempFile, ;
	lcCode

* Ensure the parameters were passed correctly.

assert vartype(tcString) = 'C' ;
	message 'TextMerge: invalid tcString parameter'
assert vartype(tlRecurse) = 'L' ;
	message 'TextMerge: invalid tlRecurse parameter'
assert pcount() < 3 or (vartype(tcLeft) = 'C' and not empty(tcLeft)) ;
	message 'TextMerge: invalid tcLeft parameter'
assert pcount() < 4 or (vartype(tcRight) = 'C' and not empty(tcRight)) ;
	message 'TextMerge: invalid tcRight parameter'

* If the left and right delimiters weren't specified, use the defaults.

lcDelimiters   = set('textmerge', 1)
lnDelimiters   = len(lcDelimiters)/2
lcDefaultLeft  = left(lcDelimiters, lnDelimiters)
lcDefaultRight = right(lcDelimiters, lnDelimiters)
lcLeft         = iif(pcount() > 2, tcLeft,  lcDefaultLeft)
lcRight        = iif(pcount() > 2, tcRight, lcDefaultRight)

* If the specified string contains the expression delimiters, let's process it.
* First, create a temporary filename, then set the textmerge delimiters to the
* desired values.

lcString = tcString
if lcLeft $ lcString
	lcTempFile = addbs(sys(2023)) + sys(2015) + '.txt'
	set textmerge delimiters to lcLeft, lcRight

* As long as the delimiters exist in the string, create some code that performs
* the text merge, execute it, then read the file back into the string.

	do while lcLeft $ lcString
		lcCode = 'set textmerge on to ' + lcTempFile + ' noshow' + chr(13) + ;
			'\\' + lcString + chr(13) + ;
			'set textmerge to' + chr(13)
		execscript(lcCode)
		lcString = filetostr(lcTempFile)

* If we're not supposed to recurse, we're done.

		if not tlRecurse
			exit
		endif not tlRecurse
	enddo while lcLeft $ lcString

* Erase the temporary file and restore the delimiters.

	erase (lcTempFile)
	set textmerge delimiters to lcDefaultLeft, lcDefaultRight
endif lcLeft $ lcString
return lcString
