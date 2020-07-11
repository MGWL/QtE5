/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.events.scrolleventargs;

public import dgui.core.events.eventargs;
import dgui.core.winapi;

enum ScrollMode: uint
{
	bottom 		  = SB_BOTTOM,
	endScroll 	  = SB_ENDSCROLL,
	lineDown  	  = SB_LINEDOWN,
	lineUp 		  = SB_LINEUP,
	pageDown	  = SB_PAGEDOWN,
	pageUp 		  = SB_PAGEUP,
	thumbPosition = SB_THUMBPOSITION,
	thumbTrack 	  = SB_THUMBTRACK,
	top 		  = SB_TOP,
	left  		  = SB_LEFT,
	right 		  = SB_RIGHT,
	lineLeft      = SB_LINELEFT,
	lineRight 	  = SB_LINERIGHT,
	pageLeft 	  = SB_PAGELEFT,
	pageRight 	  = SB_PAGERIGHT,
}

enum ScrollWindowDirection: ubyte
{
	left  = 0,
	up    = 1,
	right = 2,
	down  = 4,
}

enum ScrollDirection: ubyte
{
	vertical,
	horizontal,
}

class ScrollEventArgs: EventArgs
{
	private ScrollDirection _dir;
	private ScrollMode _mode;

	public this(ScrollDirection sd, ScrollMode sm)
	{
		this._dir = sd;
		this._mode = sm;
	}

	@property public ScrollDirection direction()
	{
		return this._dir;
	}

	@property public ScrollMode mode()
	{
		return this._mode;
	}
}
