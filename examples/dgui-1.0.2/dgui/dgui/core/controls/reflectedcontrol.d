/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.controls.reflectedcontrol;

public import dgui.core.controls.control;

abstract class ReflectedControl: Control
{
	private void reflectMessageToChild(ref Message m)
	{
		HWND hFrom = void; //Inizializzata sotto

		switch(m.msg)
		{
			case WM_NOTIFY:
				NMHDR* pNotify = cast(NMHDR*)m.lParam;
				hFrom = pNotify.hwndFrom;
				break;

			case WM_MEASUREITEM:
			{
				MEASUREITEMSTRUCT* pMeasureItem = cast(MEASUREITEMSTRUCT*)m.lParam;

				switch(pMeasureItem.CtlType)
				{
					case ODT_COMBOBOX:
						hFrom = GetParent(cast(HWND)pMeasureItem.CtlID);
						break;

					case ODT_MENU:
						hFrom = this._handle; // Set the owner of the menu (this window)
						break;

					default:
						hFrom = cast(HWND)pMeasureItem.CtlID;
						break;
				}
			}
			break;

			case WM_DRAWITEM:
			{
				DRAWITEMSTRUCT* pDrawItem = cast(DRAWITEMSTRUCT*)m.lParam;

				switch(pDrawItem.CtlType)
				{
					case ODT_COMBOBOX:
						hFrom = GetParent(pDrawItem.hwndItem);
						break;

					case ODT_MENU:
						hFrom = this._handle; // Set the owner of the menu (this window)
						break;

					default:
						hFrom = cast(HWND)pDrawItem.hwndItem;
						break;
				}
			}
			break;

			default: // WM_COMMAND
				hFrom = cast(HWND)m.lParam;
				break;
		}

		/* If 'hFrom' is this window, the notification is sent by menus */
		Control c = winCast!(Control)(GetWindowLongW(hFrom, GWL_USERDATA));

		if(c)
		{
			c.sendMessage(DGUI_REFLECTMESSAGE, cast(WPARAM)&m, 0);
		}
	}

	protected override void wndProc(ref Message m)
	{
		switch(m.msg)
		{
			case WM_NOTIFY, WM_COMMAND, WM_MEASUREITEM, WM_DRAWITEM, WM_CTLCOLOREDIT, WM_CTLCOLORBTN:
			{
				this.originalWndProc(m); //Components like: ComboBoxEx need this one!

				if(ReflectedControl.hasBit(this._cBits, ControlBits.canNotify)) //Avoid fake notification messages caused by component's properties (like text(), checked(), ...)
				{
					this.reflectMessageToChild(m);
				}
			}
			break;

			default:
				super.wndProc(m);
				break;
		}
	}
}
