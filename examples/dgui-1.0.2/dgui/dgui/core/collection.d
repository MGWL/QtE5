/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.collection;

class Collection(T)
{
	private T[] _t;

	public final int add(T t)
	{
		this._t ~= t;
		return this._t.length - 1;
	}

	public final void clear()
	{
		this._t.length = 0;
	}

	public final T[] get()
	{
		return this._t;
	}

	@property public final int length()
	{
		return this._t.length;
	}

	public final void remove(T t)
	{
		this.removeAt(this.find(t));
	}

	public final void removeAt(int idx)
	{
		int x = 0;
		T[] newT = new T[this._t.length - 1];

		foreach(int i, T t; this._t)
		{
			if(i != idx)
			{
				newT[x] = t;
				x++;
			}
		}

		this._t = newT;
	}

	public final int find(T t)
	{
		foreach(int i, T ft; this._t)
		{
			if(ft is t)
			{
				return i;
			}
		}

		return -1;
	}

	public T opIndex(int i) nothrow
	{
		if(i >= 0 && i < this._t.length)
		{
			return this._t[i];
		}

		assert(false, "Index out of range");
	}

	public int opApply(int delegate(ref T) dg)
	{
		int res = 0;

		if(this._t.length)
		{
			for(int i = 0; i < this._t.length; i++)
			{
				res = dg(this._t[i]);

				if(res)
				{
					break;
				}
			}
		}

		return res;
	}

	public int opApply(int delegate(ref int, ref T) dg)
	{
		int res = 0;

		if(this._t.length)
		{
			for(int i = 0; i < this._t.length; i++)
			{
				res = dg(i, this._t[i]);

				if(res)
				{
					break;
				}
			}
		}

		return res;
	}
}
