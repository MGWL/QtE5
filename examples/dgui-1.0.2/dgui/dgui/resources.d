/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.resources;

import dgui.core.charset;
import dgui.core.winapi;
import dgui.core.geometry;
import dgui.core.utils;
import dgui.core.exception;
import dgui.canvas;

final class Resources
{
	private static Resources _rsrc;

	private this()
	{

	}

	public Icon getIcon(ushort id)
	{
		return getIcon(id, nullSize);
	}

	public Icon getIcon(ushort id, Size sz)
	{
		HICON hIcon = loadImage(getHInstance(), cast(wchar*)id, IMAGE_ICON, sz.width, sz.height, LR_LOADTRANSPARENT | (sz == nullSize ? LR_DEFAULTSIZE : 0));

		if(!hIcon)
		{
			throwException!(GDIException)("Cannot load Icon: '%d'", id);
		}

		return Icon.fromHICON(hIcon);
	}

	public Bitmap getBitmap(ushort id)
	{
		HBITMAP hBitmap = loadImage(getHInstance(), cast(wchar*)id, IMAGE_BITMAP, 0, 0, LR_LOADTRANSPARENT | LR_DEFAULTSIZE);

		if(!hBitmap)
		{
			throwException!(GDIException)("Cannot load Bitmap: '%d'", id);
		}

		return Bitmap.fromHBITMAP(hBitmap);
	}

	public T* getRaw(T)(ushort id, char* rt)
	{
		HRSRC hRsrc = FindResourceW(null, MAKEINTRESOURCEW(id), rt);

		if(!hRsrc)
		{
			throwException!(GDIException)("Cannot load Custom Resource: '%d'", id);
		}

		return cast(T*)LockResource(LoadResource(null, hRsrc));
	}

	@property public static Resources instance()
	{
		if(!_rsrc)
		{
			_rsrc = new Resources();
		}

		return _rsrc;
	}
}
