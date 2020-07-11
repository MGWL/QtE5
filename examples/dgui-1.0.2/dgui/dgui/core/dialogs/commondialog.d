/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.dialogs.commondialog;

public import dgui.core.charset;
public import dgui.core.winapi;
public import dgui.canvas; // ???

class CommonDialog(T1, T2)
{
	protected T1 _dlgStruct;
	protected T2 _dlgRes;
	protected string _title;

	@property public string title()
	{
		return this._title;
	}

	@property public void title(string s)
	{
		this._title = s;
	}

	@property public T2 result()
	{
		return this._dlgRes;
	}

	public abstract bool showDialog();
}
