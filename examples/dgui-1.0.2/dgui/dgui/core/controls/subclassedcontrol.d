/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.controls.subclassedcontrol;

public import dgui.core.controls.reflectedcontrol;

abstract class SubclassedControl: ReflectedControl
{
	private WNDPROC _oldWndProc; // Original Window Procedure

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		this._oldWndProc = WindowClass.superclass(ccp.superclassName, ccp.className, cast(WNDPROC) /*FIXME may throw*/ &Control.msgRouter);
	}

	protected override uint originalWndProc(ref Message m)
	{
		if(IsWindowUnicode(this._handle))
		{
			m.result = CallWindowProcW(this._oldWndProc, this._handle, m.msg, m.wParam, m.lParam);
		}
		else
		{
			m.result = CallWindowProcA(this._oldWndProc, this._handle, m.msg, m.wParam, m.lParam);
		}

		return m.result;
	}

	protected override void wndProc(ref Message m)
	{
		switch(m.msg)
		{
			case WM_ERASEBKGND:
			{
				if(SubclassedControl.hasBit(this._cBits, ControlBits.doubleBuffered))
				{
					Rect r = void;
					GetUpdateRect(this._handle, &r.rect, false);

					scope Canvas orgCanvas = Canvas.fromHDC(cast(HDC)m.wParam, false); //Don't delete it, it's a DC from WM_ERASEBKGND or WM_PAINT
					scope Canvas memCanvas = orgCanvas.createInMemory(); // Off Screen Canvas

					Message rm = m;

					rm.msg = WM_ERASEBKGND;
					rm.wParam = cast(WPARAM)memCanvas.handle;
					this.originalWndProc(rm);

					rm.msg = WM_PAINT;
					//rm.wParam = cast(WPARAM)memCanvas.handle;
					this.originalWndProc(rm);

					scope PaintEventArgs e = new PaintEventArgs(memCanvas, r);
					this.onPaint(e);

					memCanvas.copyTo(orgCanvas, r, r.position);
					SubclassedControl.setBit(this._cBits, ControlBits.erased, true);
					m.result = 0;
				}
				else
				{
					this.originalWndProc(m);
				}
			}
			break;

			case WM_PAINT:
			{
				if(SubclassedControl.hasBit(this._cBits, ControlBits.doubleBuffered) && SubclassedControl.hasBit(this._cBits, ControlBits.erased))
				{
					SubclassedControl.setBit(this._cBits, ControlBits.erased, false);
					m.result = 0;
				}
				else
				{
					/* *** Not double buffered *** */
					Rect r = void;
					GetUpdateRect(this._handle, &r.rect, false); //Keep drawing area
					this.originalWndProc(m);

					scope Canvas c = Canvas.fromHDC(m.wParam ? cast(HDC)m.wParam : GetDC(this._handle), m.wParam ? false : true);
					HRGN hRgn = CreateRectRgnIndirect(&r.rect);
					SelectClipRgn(c.handle, hRgn);
					DeleteObject(hRgn);

					SetBkColor(c.handle, this.backColor.colorref);
					SetTextColor(c.handle, this.foreColor.colorref);

					scope PaintEventArgs e = new PaintEventArgs(c, r);
					this.onPaint(e);
				}
			}
			break;

			case WM_CREATE:
				this.originalWndProc(m);
				super.wndProc(m);
				break;

			default:
				super.wndProc(m);
				break;
		}
	}
}
