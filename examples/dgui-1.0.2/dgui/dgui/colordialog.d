/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.colordialog;

public import dgui.core.dialogs.commondialog;

class ColorDialog: CommonDialog!(CHOOSECOLORW, Color)
{
	public override bool showDialog()
	{
		static COLORREF[16] custColors;
		custColors[] = RGB(255, 255, 255);

		this._dlgStruct.lStructSize = CHOOSECOLORW.sizeof;
		this._dlgStruct.lpCustColors = custColors.ptr; // Must be defined !!!
		this._dlgStruct.hwndOwner = GetActiveWindow();

		if(ChooseColorW(&this._dlgStruct))
		{
			this._dlgRes = Color.fromCOLORREF(this._dlgStruct.rgbResult);
			return true;
		}

		return false;
	}
}
