/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.imagelist;

import dgui.core.interfaces.idisposable;
import dgui.core.collection;
import dgui.core.charset;
import dgui.core.winapi;
import dgui.core.handle;
import dgui.canvas;

enum ColorDepth: uint
{
	depth4bit = ILC_COLOR4,
	depth8bit = ILC_COLOR8,
	depth16bit = ILC_COLOR16,
	depth24bit = ILC_COLOR24,
	depth32bit = ILC_COLOR32,
}

/*
 * Dynamic Binding (Uses The Latest Version Available)
 */

private alias extern(Windows) HIMAGELIST function(int, int, uint, int, int) ImageList_CreateProc;
private alias extern(Windows) HIMAGELIST function(HIMAGELIST) ImageList_DestroyProc;
private alias extern(Windows) BOOL function(HIMAGELIST, int) ImageList_RemoveProc;
private alias extern(Windows) int function(HIMAGELIST, HICON) ImageList_AddIconProc;
private alias extern(Windows) int function(HIMAGELIST, int, HDC, int, int, UINT) ImageList_DrawProc;
private alias extern(Windows) int function(HIMAGELIST, COLORREF) ImageList_SetBkColorProc;

class ImageList: Handle!(HIMAGELIST), IDisposable
{
	private static ImageList_CreateProc imageList_Create;
	private static ImageList_RemoveProc imageList_Remove;
	private static ImageList_AddIconProc imageList_AddIcon;
	private static ImageList_DestroyProc imageList_Destroy;
	private static ImageList_DrawProc imageList_Draw;
	private static ImageList_SetBkColorProc imageList_SetBkColor;

	private ColorDepth _depth = ColorDepth.depth32bit;
	private Size _size;
	private Collection!(Icon) _images;

	public this()
	{
		if(!imageList_Create)
		{
			HMODULE hModule = getModuleHandle("comctl32.dll");

			/*
			  * Static Library Issue: Use Dynamic Binding so Visual Styles are enabled (if supported)
			  */

			imageList_Create = cast(ImageList_CreateProc)GetProcAddress(hModule, "ImageList_Create");
			imageList_Remove = cast(ImageList_RemoveProc)GetProcAddress(hModule, "ImageList_Remove");
			imageList_AddIcon = cast(ImageList_AddIconProc)GetProcAddress(hModule, "ImageList_AddIcon");
			imageList_Destroy = cast(ImageList_DestroyProc)GetProcAddress(hModule, "ImageList_Destroy");
			imageList_Draw = cast(ImageList_DrawProc)GetProcAddress(hModule, "ImageList_Draw");
			imageList_SetBkColor = cast(ImageList_SetBkColorProc)GetProcAddress(hModule, "ImageList_SetBkColor");
		}
	}

	public ~this()
	{
		if(this.created)
		{
			this.dispose();
		}
	}

	public void dispose()
	{
		foreach(Icon i; this._images)
		{
			i.dispose(); //Dispose Icons before delete the ImageList.
		}

		imageList_Destroy(this._handle);
	}

	@property public override HIMAGELIST handle()
	{
		if(!this.created)
		{
			if(this._size == nullSize)
			{
				this._size.width = 16;
				this._size.height = 16;
			}

			this._handle = imageList_Create(this._size.width, this._size.height, this._depth | ILC_MASK, 0, 0);
			imageList_SetBkColor(this._handle, CLR_NONE);
		}

		return super.handle;
	}

	public final void drawIcon(int i, Canvas dest, Point pos)
	{
		imageList_Draw(this._handle, i, dest.handle, pos.x, pos.y, ILD_NORMAL);
	}

	public final int addImage(Icon ico)
	{
		if(!this._images)
		{
			this._images = new Collection!(Icon)();
		}

		this._images.add(ico);

		if(!this.created)
		{
			if(this._size == nullSize)
			{
				this._size.width = 16;
				this._size.height = 16;
			}

			this._handle = imageList_Create(this._size.width, this._size.height, this._depth | ILC_MASK, 0, 0);
			imageList_SetBkColor(this._handle, CLR_NONE);
		}

		return imageList_AddIcon(this._handle, ico.handle);
	}

	public final void removeImage(int index)
	{
		if(this._images)
		{
			this._images.removeAt(index);
		}

		if(this.created)
		{
			imageList_Remove(this._handle, index);
		}
	}

	public final void clear()
	{
		imageList_Remove(this._handle, -1);
	}

	@property public final Icon[] images()
	{
		if(this._images)
		{
			return this._images.get();
		}

		return null;
	}

	@property public final Size size()
	{
		return this._size;
	}

	@property public final void size(Size sz)
	{
		this._size = sz;
	}

	@property public final ColorDepth colorDepth()
	{
		return this._depth;
	}

	@property public final void colorDepth(ColorDepth depth)
	{
		this._depth = depth;
	}
}
