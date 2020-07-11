/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.dialogs.dialogresult;

private import dgui.core.winapi;

enum DialogResult: int
{
	none,
	ok = IDOK,
	yes = IDYES,
	no = IDNO,
	cancel = IDCANCEL,
	retry = IDRETRY,
	abort = IDABORT,
	ignore = IDIGNORE,
	close = cancel, //Same as 'cancel'
}
