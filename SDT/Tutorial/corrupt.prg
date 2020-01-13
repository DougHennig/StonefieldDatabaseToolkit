lparameters tcTable, ;
	tlMemoOnly
local lcTable
if type('tcTable') <> 'C' or empty(tcTable)
	wait window 'Please specify a table to corrupt.'
	return
endif type('tcTable') <> 'C' ...
lcTable = upper(tcTable)
do case
	case file(lcTable)
	case not empty(dbc())
		lcTable = substr(lcTable, rat('\', lcTable) + 1)
		lcTable = fullpath(dbgetprop(lcTable, 'Table', 'Path'), dbc())
	otherwise
		lcTable = lcTable + '.DBF'
endcase
if not file(lcTable)
	wait window tcTable + ' was not found.'
	return
endif not file(lcTable)
close tables all
lcMemo = left(lcTable, at('.', lcTable)) + 'FPT'
if tlMemoOnly and file(lcMemo)
	lcTable = lcMemo
endif tlMemoOnly ...
lnHandle = fopen(lcTable, 2)
if lnHandle < 0
	wait window 'Could not open table.'
	return
endif lnHandle < 0
= fwrite(lnHandle, replicate(chr(0), 10))
= fclose(lnHandle)
