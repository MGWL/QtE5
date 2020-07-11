/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.geometry;

import dgui.core.winapi;

struct Rect
{
	public union
	{
		align(1)  struct
		{
			uint left = 0;
			uint top = 0;
			uint right = 0;
			uint bottom = 0;
		}

		RECT rect;
	}

	public static Rect opCall(Point pt, Size sz)
	{
		return opCall(pt.x, pt.y, sz.width, sz.height);
	}

	public static Rect opCall(uint l, uint t, uint w, uint h)
	{
		Rect r = void; //Viene inizializzata sotto.

		r.left = l;
		r.top = t;
		r.right = l + w;
		r.bottom = t + h;

		return r;
	}

	public const bool opEquals(ref const Rect r)
	{
		return this.left == r.left && this.top == r.top && this.right == r.right && this.bottom == r.bottom;
	}

	@property public int x()
	{
		return this.left;
	}

	@property public void x(int newX)
	{
		int w = this.width;

		this.left = newX;
		this.right = newX + w;
	}

	@property public int y()
	{
		return this.top;
	}

	@property public void y(int newY)
	{
		int h = this.height;

		this.top = newY;
		this.bottom = newY + h;
	}

	@property public int width()
	{
		if(this.right != CW_USEDEFAULT)
		{
			return this.right - this.left;
		}

		return CW_USEDEFAULT;
	}

	@property public void width(int w)
	{
		this.right = this.left + w;
	}

	@property public int height()
	{
		if(this.bottom != CW_USEDEFAULT)
		{
			return this.bottom - this.top;
		}

		return CW_USEDEFAULT;
	}

	@property public void height(int h)
	{
		this.bottom = this.top + h;
	}

	@property public Point position()
	{
		return Point(this.left, this.top);
	}

	@property public void position(Point pt)
	{
		Size sz = this.size; //Copia dimensioni

		this.left = pt.x;
		this.top = pt.y;
		this.right = this.left + sz.width;
		this.bottom = this.top + sz.height;
	}

	@property public Size size()
	{
		return Size(this.width, this.height);
	}

	@property public void size(Size sz)
	{
		this.right = this.left + sz.width;
		this.bottom = this.top + sz.height;
	}

	@property public bool empty()
	{
		return this.width <= 0 && this.height <= 0;
	}

	public static Rect fromRECT(RECT* pWinRect)
	{
		Rect r = void; //Inizializzata sotto

		r.rect = *pWinRect;
		return r;
	}
}

struct Point
{
	public union
	{
		align(1) struct
		{
			uint x = 0;
			uint y = 0;
		}

		POINT point;
	}

	public bool inRect(Rect r)
	{
		if(point.x < r.left || point.y < r.top || point.x > r.right || point.y > r.bottom)
		{
			return false;
		}

		return true;
	}

	public bool opEquals(ref const Point pt) const
	{
		return this.x == pt.x && this.y == pt.y;
	}

	public static Point opCall(int x, int y)
	{
		Point pt = void; //Viene inizializzata sotto.

		pt.x = x;
		pt.y = y;
		return pt;
	}
}

struct Size
{
	public union
	{
		align(1) struct
		{
			uint width = 0;
			uint height = 0;
		}

		SIZE size;
	}

	public bool opEquals(ref const Size sz) const
	{
		return this.width == sz.width && this.height == sz.height;
	}

	public static Size opCall(int w, int h)
	{
		Size sz = void;

		sz.width = w;
		sz.height = h;
		return sz;
	}
}

public const Rect nullRect; // = Rect.init;
public const Point nullPoint; // = Point.init;
public const Size nullSize; // = Size.init;
