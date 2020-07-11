/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.trackbar;

import dgui.core.controls.subclassedcontrol;

class TrackBar: SubclassedControl
{
	public Event!(Control, EventArgs) valueChanged;

	private int _minRange = 0;
	private int _maxRange = 100;
	private int _value = 0;
	private int _lastValue = 0;

	@property public uint minRange()
	{
		return this._minRange;
	}

	@property public void minRange(uint mr)
	{
		this._minRange = mr;

		if(this.created)
		{
			this.sendMessage(TBM_SETRANGE, true, MAKELPARAM(this._minRange, this._maxRange));
		}
	}

	@property public uint maxRange()
	{
		return this._maxRange;
	}

	@property public void maxRange(uint mr)
	{
		this._maxRange = mr;

		if(this.created)
		{
			this.sendMessage(TBM_SETRANGE, true, MAKELPARAM(this._minRange, this._maxRange));
		}
	}

	@property public int value()
	{
		if(this.created)
		{
			return this.sendMessage(TBM_GETPOS, 0, 0);
		}

		return this._value;
	}

	@property public void value(int p)
	{
		this._value = p;

		if(this.created)
		{
			this.sendMessage(TBM_SETPOS, true, p);
		}
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		ccp.superclassName = WC_TRACKBAR;
		ccp.className = WC_DTRACKBAR;
		this.setStyle(TBS_AUTOTICKS, true);

		assert(this._dock is DockStyle.fill, "TrackBar: Invalid Dock Style");

		if(this._dock is DockStyle.top || this._dock is DockStyle.bottom || (this._dock is DockStyle.none && this._bounds.width >= this._bounds.height))
		{
			this.setStyle(TBS_HORZ, true);
		}
		else if(this._dock is DockStyle.left || this._dock is DockStyle.right || (this._dock is DockStyle.none && this._bounds.height < this._bounds.width))
		{
			this.setStyle(TBS_VERT, true);
		}

		super.createControlParams(ccp);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		this.sendMessage(TBM_SETRANGE, true, MAKELPARAM(this._minRange, this._maxRange));
		this.sendMessage(TBM_SETTIC, 20, 0);
		this.sendMessage(TBM_SETPOS, true, this._value);

		super.onHandleCreated(e);
	}

	protected override void wndProc(ref Message m)
	{
		if(m.msg == WM_MOUSEMOVE && (cast(MouseKeys)m.wParam) is MouseKeys.left ||
		   m.msg == WM_KEYDOWN && ((cast(Keys)m.wParam) is Keys.left ||
		   (cast(Keys)m.wParam) is Keys.up ||
		   (cast(Keys)m.wParam) is Keys.right ||
		   (cast(Keys)m.wParam) is Keys.down))
		{
			int val = this.value;

			if(this._lastValue != val)
			{
				this._lastValue = val; //Save last position.
				this.onValueChanged(EventArgs.empty);
			}
		}

		super.wndProc(m);
	}

	private void onValueChanged(EventArgs e)
	{
		this.valueChanged(this, e);
	}
}
