/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.events.mouseeventargs;

public import dgui.core.events.eventargs;
import dgui.core.geometry;
import dgui.core.winapi;

enum MouseWheel: ubyte
{
	up,
	down,
}

enum MouseKeys: uint
{
	none   = 0, // No mouse buttons specified.

	// Standard mouse keys
	left   = MK_LBUTTON,
	right  = MK_RBUTTON,
	middle = MK_MBUTTON,

	// Windows 2000+
	//XBUTTON1 = 0x0800000,
	//XBUTTON2 = 0x1000000,
}

class MouseEventArgs: EventArgs
{
	private MouseKeys _mKeys;
	private Point _cursorPos;

	public this(Point cursorPos, MouseKeys mk)
	{
		this._cursorPos = cursorPos;
		this._mKeys = mk;
	}

	@property public Point location()
	{
		return this._cursorPos;
	}

	@property public MouseKeys keys()
	{
		return this._mKeys;
	}
}

class MouseWheelEventArgs: MouseEventArgs
{
	private MouseWheel _mw;

	public this(Point cursorPos, MouseKeys mk, MouseWheel mw)
	{
		this._mw = mw;

		super(cursorPos, mk);
	}

	@property public MouseWheel wheel()
	{
		return this._mw;
	}
}
