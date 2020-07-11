/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.events.event;

struct Event(T1, T2)
{
	private alias void delegate(T1, T2) SlotDelegate;
	private alias void function(T1, T2) SlotFunction;

	private SlotDelegate[] _slotDg;
	private SlotFunction[] _slotFn;

	public alias opCall call;

	public void opCall(T1 t1, T2 t2)
	{
		synchronized
		{
			for(int i = 0; i < this._slotDg.length; i++)
			{
				this._slotDg[i](t1, t2);
			}

			for(int i = 0; i < this._slotFn.length; i++)
			{
				this._slotFn[i](t1, t2);
			}
		}
	}

	public void attach(SlotDelegate dg)
	{
		if(dg)
		{
			this._slotDg ~= dg;
		}
	}

	public void attach(SlotFunction fn)
	{
		if(fn)
		{
			this._slotFn ~= fn;
		}
	}
}
