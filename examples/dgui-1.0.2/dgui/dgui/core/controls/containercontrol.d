/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.controls.containercontrol;

public import dgui.core.controls.reflectedcontrol;

abstract class ContainerControl: ReflectedControl
{
	protected Collection!(Control) _childControls;

	@property public final bool rtlLayout()
	{
		return cast(bool)(this.getExStyle() & WS_EX_LAYOUTRTL);
	}

	@property public final void rtlLayout(bool b)
	{
		this.setExStyle(WS_EX_LAYOUTRTL, b);
	}

	@property public final Control[] controls()
	{
		if(this._childControls)
		{
			return this._childControls.get();
		}

		return null;
	}

	private void addChildControl(Control c)
	{
		if(!this._childControls)
		{
			this._childControls = new Collection!(Control);
		}

		this._childControls.add(c);

		if(this.created)
		{
			c.show();
		}
	}

	protected void doChildControls()
	{
		if(this._childControls)
		{
			foreach(Control c; this._childControls)
			{
				if(!c.created) //Extra Check: Avoid creating duplicate components (added at runtime)
				{
					c.show();
				}
			}
		}
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		this.setStyle(WS_CLIPCHILDREN, true);
		this.setExStyle(WS_EX_CONTROLPARENT, true);

		super.createControlParams(ccp);
	}

	protected override void onDGuiMessage(ref Message m)
	{
		switch(m.msg)
		{
			case DGUI_ADDCHILDCONTROL:
				this.addChildControl(winCast!(Control)(m.wParam));
				break;

			default:
				break;
		}

		super.onDGuiMessage(m);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		this.doChildControls();
		super.onHandleCreated(e);
	}
}
