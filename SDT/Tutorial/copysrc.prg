lparameters lcDir
if empty(lcDir)
	lcDir = ''
else
	lcDir = addbs(lcDir)
endif empty(lcDir)
close databases all
lnFiles = adir(laFiles, 'datasrc\*.*')
for lnI = 1 to lnFiles
	copy file ('datasrc\' + laFiles[lnI, 1]) to (lcDir + laFiles[lnI, 1])
next lnI
