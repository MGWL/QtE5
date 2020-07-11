/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.events.eventargs;

class EventArgs
{
	private static EventArgs _empty;

	protected this()
	{

	}

	@property public static EventArgs empty()
	{
		if(!this._empty)
		{
			_empty = new EventArgs();
		}

		return _empty;
	}
}

class CancelEventArgs(T): EventArgs
{
	private bool _cancel = false;
	private T _t;

	public this(T t)
	{
		this._t = t;
	}

	@property public final bool cancel()
	{
		return this._cancel;
	}

	@property public final void cancel(bool b)
	{
		this._cancel = b;
	}

	@property public final T item()
	{
		return this._t;
	}
}

class ItemEventArgs(T): EventArgs
{
	private T _checkedItem;

	public this(T item)
	{
		this._checkedItem = item;
	}

	@property public T item()
	{
		return this._checkedItem;
	}
}

class ItemChangedEventArgs(T): EventArgs
{
	private T _oldItem;
	private T _newItem;

	public this(T oItem, T nItem)
	{
		this._oldItem = oItem;
		this._newItem = nItem;
	}

	@property public T oldItem()
	{
		return this._oldItem;
	}

	@property public T newItem()
	{
		return this._newItem;
	}
}
