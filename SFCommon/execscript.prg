lparameters tcCode, ;
	tuParm1, ;
	tuParm2, ;
	tuParm3
local loUtility, ;
	luReturn
if type('oUtility.Name') = 'C'
	loUtility = oUtility
else
	loUtility = MakeObject('SFUtility', 'SFUtility.vcx')
endif type('oUtility.Name') = 'C'
do case
	case pcount() = 4
		luReturn = loUtility.RunCode(tcCode, set('DATASESSION'), tuParm1, ;
			tuParm2, tuParm3)
	case pcount() = 3
		luReturn = loUtility.RunCode(tcCode, set('DATASESSION'), tuParm1, ;
			tuParm2)
	case pcount() = 2
		luReturn = loUtility.RunCode(tcCode, set('DATASESSION'), tuParm1)
	otherwise
		luReturn = loUtility.RunCode(tcCode, set('DATASESSION'))
endcase
return luReturn
