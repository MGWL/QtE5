/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.timer;

import dgui.core.interfaces.idisposable;
import dgui.core.winapi;
import dgui.core.events.event;
import dgui.core.events.eventargs;
import dgui.core.exception;

final class Timer: IDisposable
{
	private alias Timer[uint] timerMap;

	public Event!(Timer, EventArgs) tick;

	private static timerMap _timers;
	private uint _timerId = 0;
	private uint _time = 0;

	public ~this()
	{
		this.dispose();
	}

	extern(Windows) private static void timerProc(HWND hwnd, uint msg, uint idEvent, uint t)
	{
		if(idEvent in _timers)
		{
			_timers[idEvent].onTick(EventArgs.empty);
		}
		else
		{
			throwException!(Win32Exception)("Unknown Timer: '%08X'", idEvent);
		}
	}

	public void dispose()
	{
		if(this._timerId)
		{
			if(!KillTimer(null, this._timerId))
			{
				throwException!(Win32Exception)("Cannot Dispose Timer");
			}

			_timers.remove(this._timerId);
			this._timerId = 0;
		}
	}

	@property public uint time()
	{
		return this._time;
	}

	@property public void time(uint t)
	{
		this._time = t >= 0 ? t : t * (-1); //Take the absolute value.
	}

	public void start()
	{
		if(!this._timerId)
		{
			this._timerId = SetTimer(null, 0, this._time, cast(TIMERPROC) /*FIXME may throw*/ &Timer.timerProc);

			if(!this._timerId)
			{
				throwException!(Win32Exception)("Cannot Start Timer");
			}

			this._timers[this._timerId] = this;
		}
	}

	public void stop()
	{
		this.dispose();
	}

	private void onTick(EventArgs e)
	{
		this.tick(this, e);
	}
}
