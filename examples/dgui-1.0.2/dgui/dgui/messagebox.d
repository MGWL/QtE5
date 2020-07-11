/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.messagebox;

import std.utf: toUTFz;
private import dgui.core.winapi;
public import dgui.core.dialogs.dialogresult;

enum MsgBoxButtons: uint
{
	ok = MB_OK,
	yesNo = MB_YESNO,
	okCancel = MB_OKCANCEL,
	retryCancel = MB_RETRYCANCEL,
	yesNoCancel = MB_YESNOCANCEL,
	abortRetryIgnore = MB_ABORTRETRYIGNORE,
}

enum MsgBoxIcons: uint
{
	none = 0,
	warning = MB_ICONWARNING,
	information = MB_ICONINFORMATION,
	question = MB_ICONQUESTION,
	error = MB_ICONERROR,
}

final class MsgBox
{
	private this()
	{

	}

	public static DialogResult show(string title, string text, MsgBoxButtons button, MsgBoxIcons icon)
	{
		return cast(DialogResult)MessageBoxW(GetActiveWindow(), toUTFz!(wchar*)(text), toUTFz!(wchar*)(title), button | icon);
	}

	public static DialogResult show(string title, string text, MsgBoxButtons button)
	{
		return MsgBox.show(title, text, button, MsgBoxIcons.none);
	}

	public static DialogResult show(string title, string text, MsgBoxIcons icon)
	{
		return MsgBox.show(title, text, MsgBoxButtons.ok, icon);
	}

	public static DialogResult show(string title, string text)
	{
		return MsgBox.show(title, text, MsgBoxButtons.ok, MsgBoxIcons.none);
	}
}
