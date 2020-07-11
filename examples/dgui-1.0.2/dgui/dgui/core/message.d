/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.message;

import dgui.core.winapi;

/* DGui Custom Messages in order to overcome WinAPI's limitation */
enum
{
	DGUI_BASE					= WM_APP + 1,	 // DGui's internal message start
	DGUI_ADDCHILDCONTROL	 	= DGUI_BASE, 	 // void DGUI_ADDCHILDCONTROL(Control childControl, NULL)
	DGUI_DOLAYOUT				= DGUI_BASE + 1, // void DGUI_DOLAYOUT(NULL, NULL)
	DGUI_SETDIALOGRESULT		= DGUI_BASE + 2, // void DGUI_SETDIALOGRESULT(DialogResult result, NULL)
	DGUI_REFLECTMESSAGE			= DGUI_BASE + 3, // void DGUI_REFLECTMESSAGE(Message m, NULL)
	DGUI_CHILDCONTROLCREATED	= DGUI_BASE + 4, // void DGUI_CHILDCONTROLCREATED(Control childControl, NULL)
	DGUI_CREATEONLY				= DGUI_BASE + 5, // void DGUI_CREATEONLY(NULL, NULL)
}

struct Message
{
	HWND hWnd;
	uint msg;
	WPARAM wParam;
	LPARAM lParam;
	LRESULT result;

	public static Message opCall(HWND h, uint msg, WPARAM wp, LPARAM lp)
	{
		Message m;

		m.hWnd = h;
		m.msg = msg;
		m.wParam = wp;
		m.lParam = lp;

		return m;
	}
}
