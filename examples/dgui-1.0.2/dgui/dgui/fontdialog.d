/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.fontdialog;

public import dgui.core.dialogs.commondialog;

class FontDialog: CommonDialog!(CHOOSEFONTW, Font)
{
	public override bool showDialog()
	{
		LOGFONTW lf = void;

		this._dlgStruct.lStructSize = CHOOSEFONTW.sizeof;
		this._dlgStruct.hwndOwner = GetActiveWindow();
		this._dlgStruct.Flags = CF_INITTOLOGFONTSTRUCT | CF_EFFECTS | CF_SCREENFONTS;
		this._dlgStruct.lpLogFont = &lf;

		if(ChooseFontW(&this._dlgStruct))
		{
			this._dlgRes = Font.fromHFONT(createFontIndirect(&lf));
			return true;
		}

		return false;
	}
}
