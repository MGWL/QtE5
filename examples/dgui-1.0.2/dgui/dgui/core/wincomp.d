/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/

/* Windows 2000/XP/Vista/7 Compatibility Module */

module dgui.core.wincomp;

import dgui.core.utils;
import dgui.core.winapi;
import dgui.core.charset;
import dgui.core.exception;

private const WIN_NOT_SUPPORTED_MSG = "This function cannot be used on Windows 2000/XP";

enum
{
	BPPF_ERASE = 0x0001,
}

align(1) struct BP_PAINTPARAMS
{
  DWORD cbSize;
  DWORD dwFlags;
  RECT* prcExclude;
  BLENDFUNCTION* pBlendFunction;
}

private alias HANDLE HPAINTBUFFER;
private alias uint BP_BUFFERFORMAT; //It's a enum but we need only one value from it, make it an alias of type uint.

private alias extern(Windows) HPAINTBUFFER function(HDC, RECT*, BP_BUFFERFORMAT, BP_PAINTPARAMS*, HDC*) BeginBufferedPaintProc;
private alias extern(Windows) HRESULT function(HPAINTBUFFER, RGBQUAD**, int*) GetBufferedPaintBitsProc;
private alias extern(Windows) HRESULT function(HPAINTBUFFER, BOOL) EndBufferedPaintProc;

private BeginBufferedPaintProc beginBufferedPaint;
private GetBufferedPaintBitsProc getBufferedPaintBits;
private EndBufferedPaintProc endBufferedPaint;

private void initBitmapInfo(ref BITMAPINFO bi, SIZE sz)
{
	bi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
	bi.bmiHeader.biPlanes = 1;
	bi.bmiHeader.biCompression = 0; //BI_RGB;
	bi.bmiHeader.biWidth = sz.cx;
	bi.bmiHeader.biHeight = sz.cy;
	bi.bmiHeader.biBitCount = 32;
}

private HBITMAP create32BitHBITMAP(HDC hdc, SIZE sz)
{
	BITMAPINFO bi;
	initBitmapInfo(bi, sz);

	return CreateDIBSection(hdc, &bi, DIB_RGB_COLORS, null, null, 0);
}

bool hasAlpha(ARGB* pArgb, SIZE szIco, int cxRow)
{
    ulong cxDelta = cxRow - szIco.cx;

    for(ulong y = szIco.cy; y; --y)
    {
        for(ulong x = szIco.cx; x; --x)
        {
            if(*pArgb++ & 0xFF000000)
            {
                return true;
            }
        }

        pArgb += cxDelta;
    }

    return false;
}

private void convertToPARGB32(HDC hdc, ARGB* pArgb, HBITMAP hBmpMask, SIZE sz, int cxRow)
{
	BITMAPINFO bi;
	initBitmapInfo(bi, sz);

	ubyte[] pBits = new ubyte[bi.bmiHeader.biWidth * 4 * bi.bmiHeader.biHeight];
	GetDIBits(hdc, hBmpMask, 0, bi.bmiHeader.biHeight, pBits.ptr, &bi, DIB_RGB_COLORS);

	ulong cxDelta = cxRow - bi.bmiHeader.biWidth;
	ARGB *pArgbMask = cast(ARGB*)pBits.ptr;

	for(ulong y = bi.bmiHeader.biHeight; y; --y)
	{
		for(ulong x = bi.bmiHeader.biWidth; x; --x)
		{
			if(*pArgbMask++)
			{
				// transparent pixel
				*pArgb++ = 0;
			}
			else
			{
				// opaque pixel
				*pArgb++ |= 0xFF000000;
			}
		}

		pArgb += cxDelta;
	}
}

private void convertBufferToPARGB32(HPAINTBUFFER hPaintBuffer, HDC hdc, HICON hIcon, SIZE szIco)
{
	int cxRow;
	RGBQUAD* pRgbQuad;

	getBufferedPaintBits(hPaintBuffer, &pRgbQuad, &cxRow);
	ARGB* pArgb = cast(ARGB*)pRgbQuad;

	if(!hasAlpha(pArgb, szIco, cxRow))
	{
		ICONINFO ii;
		GetIconInfo(hIcon, &ii);

		if(ii.hbmMask)
		{
			convertToPARGB32(hdc, pArgb, ii.hbmMask, szIco, cxRow);
		}

		DeleteObject(ii.hbmColor);
		DeleteObject(ii.hbmMask);
	}
}

public HBITMAP iconToBitmapPARGB32(HICON hIcon)
{
	static HMODULE hUxTheme;
	WindowsVersion ver = getWindowsVersion();

	SIZE szIco;
	szIco.cx = GetSystemMetrics(SM_CXSMICON);
	szIco.cy = GetSystemMetrics(SM_CYSMICON);

	RECT rIco;
	rIco.left = 0;
	rIco.top = 0;
	rIco.right = szIco.cx;
	rIco.bottom = szIco.cy;

	if(ver > WindowsVersion.windowsXP) //Is Vista or 7
	{
		if(!hUxTheme)
		{
			hUxTheme = getModuleHandle("UxTheme.dll");

			beginBufferedPaint = cast(BeginBufferedPaintProc)GetProcAddress(hUxTheme, "BeginBufferedPaint");
			getBufferedPaintBits = cast(GetBufferedPaintBitsProc)GetProcAddress(hUxTheme, "GetBufferedPaintBits");
			endBufferedPaint = cast(EndBufferedPaintProc)GetProcAddress(hUxTheme, "EndBufferedPaint");
		}

		HDC hdc = CreateCompatibleDC(null);
		HBITMAP hBitmap = create32BitHBITMAP(hdc, szIco);
		HBITMAP hOldBitmap = SelectObject(hdc, hBitmap);

		BLENDFUNCTION bf;
		bf.BlendOp = 0; // AC_SRC_OVER
		bf.SourceConstantAlpha = 255;
		bf.AlphaFormat = 1; // AC_SRC_ALPHA

		BP_PAINTPARAMS pp;
		pp.cbSize = BP_PAINTPARAMS.sizeof;
		pp.dwFlags = BPPF_ERASE;
		pp.pBlendFunction = &bf;

		HDC hdcBuffer;
		HPAINTBUFFER hPaintBuffer = beginBufferedPaint(hdc, &rIco, 1 /*BPBF_DIB*/, &pp, &hdcBuffer);
		DrawIconEx(hdcBuffer, 0, 0, hIcon, szIco.cx, szIco.cy, 0, null, DI_NORMAL);
		convertBufferToPARGB32(hPaintBuffer, hdc, hIcon, szIco);
		endBufferedPaint(hPaintBuffer, true);

		SelectObject(hdc, hOldBitmap);
		DeleteDC(hdc);

		return hBitmap;
	}

	throwException!(WindowsNotSupportedException)("Not supported in 2000/XP");
	return null;
}
