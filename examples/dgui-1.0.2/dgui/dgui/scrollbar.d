/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.scrollbar;

import dgui.core.controls.control; //?? Control ??
import dgui.core.winapi;

enum ScrollBarType
{
	vertical = SB_VERT,
	horizontal = SB_HORZ,
	separate = SB_CTL,
}

class ScrollBar: Control
{
	private ScrollBarType _sbt;

	public this()
	{
		this._sbt = ScrollBarType.separate;
	}

	private this(Control c, ScrollBarType sbt)
	{
		this._handle = c.handle;
		this._sbt = sbt;
	}

	private void setInfo(uint mask, SCROLLINFO* si)
	{
		si.cbSize = SCROLLINFO.sizeof;
		si.fMask = mask | SIF_DISABLENOSCROLL;

		SetScrollInfo(this._handle, this._sbt, si, true);
	}

	private void getInfo(uint mask, SCROLLINFO* si)
	{
		si.cbSize = SCROLLINFO.sizeof;
		si.fMask = mask;

		GetScrollInfo(this._handle, this._sbt, si);
	}

	public void setRange(uint min, uint max)
	{
		if(this.created)
		{
			SCROLLINFO si;
			si.nMin = min;
			si.nMax = max;

			this.setInfo(SIF_RANGE, &si);
		}
	}

	public void increment(int amount = 1)
	{
		this.position = this.position + amount;
	}

	public void decrement(int amount = 1)
	{
		this.position = this.position - amount;
	}

	@property public uint minRange()
	{
		if(this.created)
		{
			SCROLLINFO si;

			this.getInfo(SIF_RANGE, &si);
			return si.nMin;
		}

		return -1;
	}

	@property public uint maxRange()
	{
		if(this.created)
		{
			SCROLLINFO si;

			this.getInfo(SIF_RANGE, &si);
			return si.nMax;
		}

		return -1;
	}

	@property public uint position()
	{
		if(this.created)
		{
			SCROLLINFO si;

			this.getInfo(SIF_POS, &si);
			return si.nPos;
		}

		return -1;
	}

	@property public void position(uint p)
	{
		if(this.created)
		{
			SCROLLINFO si;
			si.nPos = p;

			this.setInfo(SIF_POS, &si);
		}
	}

	@property public uint page()
	{
		if(this.created)
		{
			SCROLLINFO si;

			this.getInfo(SIF_PAGE, &si);
			return si.nPage;
		}

		return -1;
	}

	@property public void page(uint p)
	{
		if(this.created)
		{
			SCROLLINFO si;
			si.nPage = p;

			this.setInfo(SIF_PAGE, &si);
		}
	}

	public static ScrollBar fromControl(Control c, ScrollBarType sbt)
	{
		assert(sbt !is ScrollBarType.separate, "ScrollBarType.separate not allowed here");
		return new ScrollBar(c, sbt);
	}
}
