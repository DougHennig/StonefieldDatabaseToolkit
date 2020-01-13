* Include other include files.

#include FOXPRO.H
#include SFERRORS.H
#include SFCTRLCHAR.H

* Flag if we have VFP 7 or later.

#define clVFP7ORLATER           (type('version(5)') <> 'U' and evaluate('version(5)') >= 700)

* Strings to substitute in error and other messages.

#define ccMSG_INSERT1           '<Insert1>'
#define ccMSG_INSERT2           '<Insert2>'
#define ccMSG_INSERT3           '<Insert3>'
