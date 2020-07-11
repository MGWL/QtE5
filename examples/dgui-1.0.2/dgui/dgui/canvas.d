/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.canvas;

import std.conv : to;
import std.path;
import std.string;
import core.memory;
import dgui.core.interfaces.idisposable;
import dgui.core.charset;
import dgui.core.winapi;
import dgui.core.exception;
import dgui.core.handle;
import dgui.core.utils;
public import dgui.core.geometry;

/**
  Enum that contain the font style of a Font Object.
  */
enum FontStyle: ubyte
{
	normal = 0,		/// Normal Font Style
	bold = 1,		/// Bold Font Style
	italic = 2,		/// Italic Font Style
	underline = 4,	/// Underline Font Style
	strikeout = 8,	/// Strikeout Font Style
}

/**
  Enum that contain the image type (useful in order to identify a Image object).
  */

enum ImageType
{
	bitmap 		   = 0,	/// Bitmap Image
	iconOrCursor = 1,	/// Icon or Cursor
}

/**
  Enum that specify the fill mode of a gradient.
  */
enum GradientFillRectMode
{
	horizontal = 0,	/// Horizontal Fill
	vertical   = 1,	/// Vertical Fill
}

/**
  Enum that specify the border type (used in a Canvas.drawEdge() call).
  */
enum EdgeType: uint
{
	raisedOuter = BDR_RAISEDOUTER,	/// Raised Outer Edge
	raisedInner = BDR_RAISEDINNER, /// Raised Innter Edge

	sunkenOuter = BDR_SUNKENOUTER,	/// Sunken Outer Edge
	sunkenInner = BDR_SUNKENINNER, /// Sunken Inner Edge

	bump = EDGE_BUMP,				/// Bump Edge
	etched = EDGE_ETCHED,			/// Etched Edge
	raised = EDGE_RAISED,		/// Edge Raised Edge
	sunken = EDGE_SUNKEN,			/// Sunken Edge
}

enum FrameType: uint
{
	button		= DFC_BUTTON,
	caption		= DFC_CAPTION,
	menu 		= DFC_MENU,
	popupMenu	= DFC_POPUPMENU,
	scroll		= DFC_SCROLL,
}

enum FrameMode: uint
{
	button3state				= DFCS_BUTTON3STATE,
	buttonCheck				= DFCS_BUTTONCHECK,
	buttonPush					= DFCS_BUTTONPUSH,
	buttonRadio				= DFCS_BUTTONRADIO,
	buttonRadioImage			= DFCS_BUTTONRADIOIMAGE,
	buttonRadioMask			= DFCS_BUTTONRADIOMASK,

	captionClose				= DFCS_CAPTIONCLOSE,
	captionHelp				= DFCS_CAPTIONHELP,
	captionMax					= DFCS_CAPTIONMAX,
	captionMin					= DFCS_CAPTIONMIN,
	captionRestore 			= DFCS_CAPTIONRESTORE,

	menuArrow					= DFCS_MENUARROW,
	menuArrowRight 			= DFCS_MENUARROWRIGHT,
	menuBullet					= DFCS_MENUBULLET,
	menuCheck					= DFCS_MENUCHECK,

	scrollComboBox				= DFCS_SCROLLCOMBOBOX,
	scrollDown					= DFCS_SCROLLDOWN,
	scrollLeft					= DFCS_SCROLLLEFT,
	scrollRight				= DFCS_SCROLLRIGHT,
	scrollSizeGrip				= DFCS_SCROLLSIZEGRIP,
	scrollSizeGripRight		= DFCS_SCROLLSIZEGRIPRIGHT,
	scrollUp					= DFCS_SCROLLUP,

	checked						= DFCS_CHECKED,
	flat						= DFCS_FLAT,
	hot							= DFCS_HOT,
	inactive					= DFCS_INACTIVE,
	mono						= DFCS_MONO,
	pushed						= DFCS_PUSHED,
	transparent					= DFCS_TRANSPARENT,
}

/**
  Enum that specify the draw border mode  (used in a Canvas.drawEdge() call).
  */
enum EdgeMode: uint
{
	adjust	 = BF_ADJUST,		/// Shrink the rectangle in order to exlude the edges that were drawn.
	diagonal = BF_DIAGONAL,		/// Diagonal Border.
	flat	 = BF_FLAT,			/// Flat Border.
	left	 = BF_LEFT,			/// Left Border Only.
	top		 = BF_TOP,			/// Top Border Only.
	right    = BF_RIGHT,		/// Right Border Only.
	bottom 	 = BF_BOTTOM,		/// Bottom Border Only.
	internal = BF_MIDDLE,		/// Internal Border will be filled.
	mono 	 = BF_MONO,			/// One Dimensional Border.
	rect 	 = BF_RECT,			/// Fills the entire border of the rectangle.
	//SOFT 	 = BF_SOFT,
}

/**
  Enum that specify the style of a Hatch Brush object
  */
enum HatchStyle: int
{
	horizontal 		   = HS_HORIZONTAL,		/// The brush has horizontal stripes.
	vertical 		   = HS_VERTICAL,		/// The brush has vertical stripes.
	degree45Upward   = HS_BDIAGONAL, 		/// The brush has 45° degree rising stripes.
	degree45Downward = HS_FDIAGONAL,		/// The brush has 45° degree falling stripes.
	cross			   = HS_CROSS,			/// The brush has crossed stripes.
	diagonalCross	   = HS_DIAGCROSS,		/// The brush has diagonal crossed stripes.
}


/**
  Enum that specify the style of a Pen object.
  */
enum PenStyle: uint
{
	solid		 = PS_SOLID,		/// Solid Pen (Standard).
	dash		 = PS_DASH,			/// Dashed Pen.
	dot  		 = PS_DOT,			/// Dotted Pen.
	dashDot	 = PS_DASHDOT,		/// Dash-Dotted Pen.
	dashDotDot = PS_DASHDOTDOT,	/// Dashed-Dotted-Dotted Pen.
	null_		 = PS_NULL,			/// Invisible Pen.
	insideFrame = PS_INSIDEFRAME,	/// Solid Pen (line are drown inside the border of a closed shape).
}

/**
  Enum that specify the style of a text in a drawText() call
  */
enum TextFormatFlags: uint
{
	noPrefix				= DT_NOPREFIX,		/// Turn of processing of prefix characters (like '&', character that it will be not displayed underline).
	wordBreak			    = DT_WORDBREAK,		/// Break the line if a carriage return is found or the selected rectangle is too small.
	singleLine				= DT_SINGLELINE,	/// The text is draw in one single line.
	lineLimit 				= DT_EDITCONTROL,	/// Duplicate the text displaying of a multiline control.
	noClip 				= DT_NOCLIP,		/// The text is not clipped.
	//DIRECTION_RIGHT_TO_LEFT = DT_RTLREADING,
}

/**
  Enum that specify the style of a text alignment in a drawText() call
  */
enum TextAlignment: uint
{
	left   = DT_LEFT,		/// Text is left aligned.
	right  = DT_RIGHT,		/// Text is right aligned.
	center = DT_CENTER,		/// Text is centred horizontally.

	top    = DT_TOP,		/// Text is top aligned.
	bottom = DT_BOTTOM,		/// Text is bottom aligned.
	middle = DT_VCENTER,	/// Text is centred vertically.
}

/**
  Enum that specify the trimming of a text alignment in a drawText() call
  */
enum TextTrimming: uint
{
	none 		  = 0,					/// No Trimming.
	ellipsis	  = DT_END_ELLIPSIS,	/// If the text is too long, it will be replaced with end ellipsis (like: ellips...).
	ellipsisPath = DT_PATH_ELLIPSIS,   /// If the text is too long, it will be replaces with middle ellipsis (like: texttr...ing).
}

/**
  Specify the copy mode of a Bitmap
  */
enum BitmapCopyMode
{
	normal 	= SRCCOPY,		/// Standard Copy.
	invert	= SRCINVERT,	/// Copy Inverted.
	and   	= SRCAND,		/// Copy using _AND operator (Source _AND Destination).
	or      = SRCPAINT,		/// Copy using _OR operator (Source _OR Destination).
}

/**
  It rappresentes a color of a bitmap.
  */
struct BitmapBit
{
	union
	{
		ubyte rgbBlue;
		ubyte blue;			/// Blue color.
	}

	union
	{
		ubyte rgbGreen;
		ubyte green;	    /// Green color.
	}

	union
	{
		ubyte rgbRed;
		ubyte red;			/// Red color.
	}

	union
	{
		ubyte rgbReserved;
		ubyte alpha; 		/// Alpha channel (if available).
	}
}

/**
  This structure allows direct modification of a bitmap
  */
struct BitmapData
{
	BITMAPINFO* info;	/// BITMAPINFO structure (usually, it is used internally).
	uint imageSize;		/// The size of the _Bitmap.
	uint bitsCount;		/// Number of BitmapBits structure of the _Bitmap (is the _Bits field length).
	BitmapBit* bits;	/// Pointer to the _Bitmap's bits (it allows direct modification of the colors)
}

/**
  A _Color in ARGB format (compatible with COLORREF win32 type)
  */
struct Color
{
	private bool _valid = false; // Check if it was assigned a value

	public union
	{
		align(1) struct
		{
			ubyte red   = 0x00;
			ubyte green = 0x00;
			ubyte blue  = 0x00;
			ubyte alpha = 0x00; //0x00: Transparent (or Don't Care), 0xFF: Opaque
		}

		COLORREF colorref;	/// Compatibility with COLORREF type
	}

	/// Checks if the color information is _valid.
	@property public final bool valid()
	{
		return this._valid;
	}

	public static Color opCall(ubyte r, ubyte g, ubyte b)
	{
		return Color(0x00, r, g, b);
	}

	public static Color opCall(ubyte a, ubyte r, ubyte g, ubyte b)
	{
		Color color = void; //Inializzata sotto;

		color._valid = true;

		color.alpha = a;
		color.red = r;
		color.green = g;
		color.blue = b;

		return color;
	}

	/// Returns an invalid color
	public static Color invalid()
	{
		static Color color;
		//color._valid = false; //Set valid to false (false = default value)
		return color;
	}

	/// Given a COLORREF, it returns a _Color object
	public static Color fromCOLORREF(COLORREF cref)
	{
		Color color = void;

		color._valid = true;
		color.colorref = cref;
		return color;
	}
}

struct FontMetrics
{
	int height;
	int ascent;
	int descent;
	int internalLeading;
	int externalLeading;
	int averageCharWidth;
	int maxCharWidth;
}

/**
 The _Canvas object is the DGui's rappresentation of a Device Context (Screen DC, Memory DC and Printer DC)
 $(DDOC_BLANKLINE)
 $(B Note): Printer DC is not implemented
 */
class Canvas: Handle!(HDC), IDisposable
{
	private alias extern(Windows) BOOL function(HDC, int, int, int, int, HDC, int, int, int, int, UINT) GdiTransparentBltProc;
	private alias extern(Windows) BOOL function(HDC, int, int, int, int, HDC, int, int, int, int, BLENDFUNCTION) GdiAlphaBlendProc;
	private alias extern(Windows) BOOL function(HDC, TRIVERTEX*, ULONG, void*, ULONG, ULONG) GdiGradientFillProc;

	private static GdiTransparentBltProc _gdiTransparentBlt = null;
	private static GdiAlphaBlendProc _gdiAlphaBlend = null;
	private static GdiGradientFillProc _gdiGradientFill = null;

	private enum CanvasType: ubyte
	{
		normal = 0,
		fromControl = 1,
		inMemory = 2,
	}

	private CanvasType _canvasType = CanvasType.normal;
	private HBITMAP _hBitmap;
	private bool _owned;

	protected this(HDC hdc, bool owned, CanvasType type)
	{
		this._handle = hdc;
		this._owned = owned;
		this._canvasType = type;
	}

	public ~this()
	{
		this.dispose();
	}

	public void copyTo(Canvas c, BitmapCopyMode bcm, Rect destRect, Point posSrc)
	{
		BITMAP bmp;

		if(!destRect.width && destRect.height)
		{
			GetObjectW(GetCurrentObject(this._handle, OBJ_BITMAP), BITMAP.sizeof, &bmp);
		}

		BitBlt(c.handle, destRect.x, destRect.y,
			   destRect.width ? destRect.width : bmp.bmWidth,
			   destRect.height ? destRect.height : bmp.bmHeight,
			   this._handle, posSrc.x, posSrc.y, bcm);
	}

	public void copyTo(Canvas c, Rect destRect, Point posSrc)
	{
		this.copyTo(c, BitmapCopyMode.normal, destRect, posSrc);
	}

	public void copyTo(Canvas c, BitmapCopyMode bcm, Rect destRect)
	{
		this.copyTo(c, bcm, destRect, nullPoint);
	}

	public void copyTo(Canvas c, BitmapCopyMode bcm)
	{
		this.copyTo(c, bcm, nullRect, nullPoint);
	}

	public void copyTo(Canvas c)
	{
		this.copyTo(c, BitmapCopyMode.normal);
	}

	public void copyTransparent(Canvas c, Color transpColor)
	{
		this.copyTransparent(c, transpColor, nullRect);
	}

	public void copyTransparent(Canvas c, Color transpColor, Rect r)
	{
		if(!_gdiTransparentBlt)
		{
			_gdiTransparentBlt = cast(GdiTransparentBltProc)GetProcAddress(getModuleHandle("gdi32.dll"), toStringz("GdiTransparentBlt"));
		}

		BITMAP bmp;
		HBITMAP hBitmap = GetCurrentObject(this._handle, OBJ_BITMAP);
		GetObjectW(hBitmap, BITMAP.sizeof, &bmp);

		if(r.empty)
		{
			r = Rect(0, 0, bmp.bmWidth, bmp.bmHeight);
		}

		_gdiTransparentBlt(c.handle, r.x, r.y, r.width, r.height, this._handle, 0, 0, bmp.bmWidth, bmp.bmHeight, transpColor.colorref);
	}

	public void dispose()
	{
		if(this._handle && this._owned)
		{
			switch(this._canvasType)
			{
				case CanvasType.fromControl:
					ReleaseDC(WindowFromDC(this._handle), this._handle);
					break;

				case CanvasType.inMemory:
					DeleteObject(this._hBitmap);
					DeleteDC(this._handle);
					break;

				default:
					break;
			}

			this._handle = null;
		}
	}

	public static Size measureString(string s, Canvas c, Font f)
	{
		Size sz;

		HFONT hOldFont = f ? SelectObject(c.handle, f.handle) : null;
		GetTextExtentPoint32W(c.handle, toUTFz!(wchar*)(s), s.length, &sz.size);

		if(f)
		{
			SelectObject(c.handle, hOldFont);
		}

		return sz;
	}

	public static Size measureString(string s, Canvas c)
	{
		return Canvas.measureString(s, c, null);
	}

	public static Size measureString(string s, Font f)
	{
		scope Canvas c = Screen.canvas;
		return Canvas.measureString(s, c, f);
	}

	public static Size measureString(string s)
	{
		scope Canvas c = Screen.canvas;
		return Canvas.measureString(s, c, SystemFonts.windowsFont);
	}

	public final void fillRectGradient(Rect r, Color startColor, Color endColor, GradientFillRectMode gfrm)
	{
		if(!_gdiGradientFill)
		{
			_gdiGradientFill = cast(GdiGradientFillProc)GetProcAddress(getModuleHandle("gdi32.dll"), toStringz("GdiGradientFill"));
		}

		TRIVERTEX[2] tv;
		static GRADIENT_RECT gr = {UpperLeft: 0, LowerRight: 1};

		tv[0].x = r.left;
		tv[0].y = r.top;
		tv[0].Red = startColor.red << 8;
		tv[0].Green = startColor.green << 8;
		tv[0].Blue = startColor.blue << 8;
		tv[0].Alpha = startColor.alpha << 8;

		tv[1].x = r.right;
		tv[1].y = r.bottom;
		tv[1].Red = endColor.red << 8;
		tv[1].Green = endColor.green  << 8;
		tv[1].Blue =  endColor.blue << 8;
		tv[1].Alpha = endColor.alpha << 8;

		_gdiGradientFill(this._handle, tv.ptr, 2, &gr, 1, gfrm);
	}

	public final void fillTriangleGradient(int x1, int y1, int x2, int y2, int x3, int y3, Color color1, Color color2, Color color3)
	{
		this.fillTriangleGradient(Point(x1, y1), Point(x2, y2), Point(x3, y3), color1, color2, color3);
	}

	public final void fillTriangleGradient(Point pt1, Point pt2, Point pt3, Color color1, Color color2, Color color3)
	{
		if(!_gdiGradientFill)
		{
			_gdiGradientFill = cast(GdiGradientFillProc)GetProcAddress(getModuleHandle("gdi32.dll"), toStringz("GdiGradientFill"));
		}

		TRIVERTEX[3] tv;
		static GRADIENT_TRIANGLE gt = {Vertex1: 0, Vertex2: 1, Vertex3: 2};

		tv[0].x = pt1.x;
		tv[0].y = pt1.y;
		tv[0].Red = color1.red << 8;
		tv[0].Green = color1.green << 8;
		tv[0].Blue = color1.blue << 8;
		tv[0].Alpha = color1.alpha << 8;

		tv[1].x = pt2.x;
		tv[1].y = pt2.y;
		tv[1].Red = color2.red << 8;
		tv[1].Green = color2.green  << 8;
		tv[1].Blue = color2.blue << 8;
		tv[1].Alpha = color2.alpha << 8;

		tv[2].x = pt3.x;
		tv[2].y = pt3.y;
		tv[2].Red = color3.red << 8;
		tv[2].Green = color3.green  << 8;
		tv[2].Blue = color3.blue << 8;
		tv[2].Alpha = color3.alpha << 8;

		_gdiGradientFill(this._handle, tv.ptr, 3, &gt, 1, 2 /* GRADIENT_FILL_TRIANGLE */);
	}

	public final void drawImage(Image img, Point upLeft, Point upRight, Point lowLeft)
	{
		this.drawImage(img, 0, 0, upLeft, upRight, lowLeft);
	}
	public final void drawImage(Image img, int x, int y, Point upLeft, Point upRight, Point lowLeft)
	{
		POINT[3] pts;

		pts[0] = upLeft.point;
		pts[1] = upRight.point;
		pts[2] = lowLeft.point;

		Size sz = img.size;
		HDC hdc = CreateCompatibleDC(this._handle);
		HBITMAP hOldBitmap = SelectObject(hdc, img.handle);

		PlgBlt(this._handle, pts.ptr, hdc, x, y, sz.width, sz.height, null, 0, 0);

		SelectObject(hdc, hOldBitmap);
		DeleteDC(hdc);
	}

	public final void drawImage(Image img, int x, int y)
	{
		Size sz = img.size;

		switch(img.type)
		{
			case ImageType.bitmap:
				HDC hdc = CreateCompatibleDC(this._handle);
				HBITMAP hOldBitmap = SelectObject(hdc, img.handle);
				BitBlt(this._handle, x, y, sz.width, sz.height, hdc, 0, 0, SRCCOPY);
				SelectObject(hdc, hOldBitmap);
				DeleteDC(hdc);
				break;

			case ImageType.iconOrCursor:
				DrawIconEx(this._handle, x, y, img.handle, sz.width, sz.height, 0, null, DI_NORMAL);
				break;

			default:
				break;
		}
	}

	public final void drawImage(Image img, Rect r)
	{
		Size sz = img.size;

		switch(img.type)
		{
			case ImageType.bitmap:
				HDC hdc = CreateCompatibleDC(this._handle);
				HBITMAP hOldBitmap = SelectObject(hdc, img.handle);
				StretchBlt(this._handle, r.x, r.y, r.width, r.height, hdc, 0, 0, sz.width, sz.height, SRCCOPY);
				SelectObject(hdc, hOldBitmap);
				DeleteDC(hdc);
				break;

			case ImageType.iconOrCursor:
				DrawIconEx(this._handle, r.x, r.y, img.handle, r.width, r.height, 0, null, DI_NORMAL);
				break;

			default:
				break;
		}
	}

	public final void drawFrameControl(Rect r, FrameType frameType, FrameMode frameMode)
	{
		DrawFrameControl(this._handle, &r.rect, frameType, frameMode);
	}

	public final void drawEdge(Rect r, EdgeType edgeType, EdgeMode edgeMode)
	{
		DrawEdge(this._handle, &r.rect, edgeType, edgeMode);
	}

	public final void drawText(string text, Rect r, Color foreColor, Font font, TextFormat textFormat)
	{
		DRAWTEXTPARAMS dtp;

		dtp.cbSize = DRAWTEXTPARAMS.sizeof;
		dtp.iLeftMargin = textFormat.leftMargin;
		dtp.iRightMargin = textFormat.rightMargin;
		dtp.iTabLength = textFormat.tabLength;

		HFONT hOldFont = SelectObject(this._handle, font.handle);
		COLORREF oldColorRef = SetTextColor(this._handle, foreColor.colorref);
		int oldBkMode = SetBkMode(this._handle, TRANSPARENT);

		drawTextEx(this._handle, text, &r.rect,
				   DT_EXPANDTABS | DT_TABSTOP | textFormat.formatFlags | textFormat.alignment | textFormat.trimming,
				   &dtp);

		SetBkMode(this._handle, oldBkMode);
		SetTextColor(this._handle, oldColorRef);
		SelectObject(this._handle, hOldFont);
	}

	public final void drawText(string text, Rect r, Color foreColor, Font font)
	{
		scope TextFormat tf = new TextFormat(TextFormatFlags.noPrefix | TextFormatFlags.wordBreak |
											 TextFormatFlags.noClip | TextFormatFlags.lineLimit);

		tf.trimming = TextTrimming.none;

		this.drawText(text, r, foreColor, font, tf);
	}

	public final void drawText(string text, Rect r, Color foreColor)
	{
		scope Font f = Font.fromHFONT(GetCurrentObject(this._handle, OBJ_FONT), false);
		this.drawText(text, r, foreColor, f);
	}

	public final void drawText(string text, Rect r, Font f, TextFormat tf)
	{
		this.drawText(text, r, Color.fromCOLORREF(GetTextColor(this._handle)), f, tf);
	}

	public final void drawText(string text, Rect r, TextFormat tf)
	{
		scope Font f = Font.fromHFONT(GetCurrentObject(this._handle, OBJ_FONT), false);
		this.drawText(text, r, Color.fromCOLORREF(GetTextColor(this._handle)), f, tf);
	}

	public final void drawText(string text, Rect r, Font f)
	{
		this.drawText(text, r, Color.fromCOLORREF(GetTextColor(this._handle)), f);
	}

	public final void drawText(string text, Rect r)
	{
		scope Font f = Font.fromHFONT(GetCurrentObject(this._handle, OBJ_FONT), false);
		this.drawText(text, r, Color.fromCOLORREF(GetTextColor(this._handle)), f);
	}

	public final void drawLine(Pen p, int x1, int y1, int x2, int y2)
	{
		HPEN hOldPen = SelectObject(this._handle, p.handle);

		MoveToEx(this._handle, x1, y1, null);
		LineTo(this._handle, x2, y2);

		SelectObject(this._handle, hOldPen);
	}

	public final void drawEllipse(Pen pen, Brush fill, Rect r)
	{
		HPEN hOldPen;
		HBRUSH hOldBrush;

		if(pen)
		{
			hOldPen = SelectObject(this._handle, pen.handle);
		}

		if(fill)
		{
			hOldBrush = SelectObject(this._handle, fill.handle);
		}

		Ellipse(this._handle, r.left, r.top, r.right, r.bottom);

		if(hOldBrush)
		{
			SelectObject(this._handle, hOldBrush);
		}

		if(hOldPen)
		{
			SelectObject(this._handle, hOldPen);
		}
	}

	public final void drawEllipse(Pen pen, Rect r)
	{
		this.drawEllipse(pen, SystemBrushes.nullBrush, r);
	}

	public final void drawRectangle(Pen pen, Brush fill, Rect r)
	{
		HPEN hOldPen;
		HBRUSH hOldBrush;

		if(pen)
		{
			hOldPen = SelectObject(this._handle, pen.handle);
		}

		if(fill)
		{
			hOldBrush = SelectObject(this._handle, fill.handle);
		}

		Rectangle(this._handle, r.left, r.top, r.right, r.bottom);

		if(hOldBrush)
		{
			SelectObject(this._handle, hOldBrush);
		}

		if(hOldPen)
		{
			SelectObject(this._handle, hOldPen);
		}
	}

	public final void drawRectangle(Pen pen, Rect r)
	{
		this.drawRectangle(pen, SystemBrushes.nullBrush, r);
	}

	public final void fillRectangle(Brush b, Rect r)
	{
		FillRect(this._handle, &r.rect, b.handle);
	}

	public final void fillEllipse(Brush b, Rect r)
	{
		this.drawEllipse(SystemPens.nullPen, b, r);
	}

	public final Canvas createInMemory(Bitmap b)
	{
		HDC hdc = CreateCompatibleDC(this._handle);
		Canvas c = new Canvas(hdc, true, CanvasType.inMemory);

		if(!b)
		{
			Rect r;
			HWND hWnd = WindowFromDC(this._handle);

			if(hWnd)
			{
				GetClientRect(hWnd, &r.rect);
			}
			else // Try with bitmap's size
			{
				BITMAP bmp;
				HBITMAP hOrgBitmap = GetCurrentObject(this._handle, OBJ_BITMAP);
				GetObjectW(hOrgBitmap, BITMAP.sizeof, &bmp);

				assert(bmp.bmWidth > 0 && bmp.bmHeight > 0, "Bitmap zero size");
				r = Rect(0, 0, bmp.bmWidth, bmp.bmHeight);
			}

			HBITMAP hBitmap = CreateCompatibleBitmap(this._handle, r.width, r.height);
			c._hBitmap = hBitmap;
			SelectObject(hdc, hBitmap);  // Destroyed by Mem Canvas Object
		}
		else
		{
			SelectObject(hdc, b.handle); // This bitmap is not destroyed because the Bitmap object own his HBITMAP
		}

		return c;
	}

	public final Canvas createInMemory()
	{
		return this.createInMemory(null);
	}

	public static Canvas fromHDC(HDC hdc, bool owned = true)
	{
		return new Canvas(hdc, owned, CanvasType.fromControl);
	}
}

abstract class GraphicObject: Handle!(HGDIOBJ), IDisposable
{
	protected bool _owned;

	protected this()
	{

	}

	protected this(HGDIOBJ hGdiObj, bool owned)
	{
		this._handle = hGdiObj;
		this._owned = owned;
	}

	public ~this()
	{
		this.dispose();
	}

	protected static int getInfo(T)(HGDIOBJ hGdiObj, ref T t)
	{
		return GetObjectW(hGdiObj, T.sizeof, &t);
	}

	public void dispose()
	{
		if(this._handle && this._owned)
		{
			DeleteObject(this._handle);
			this._handle = null;
		}
	}
}

abstract class Image: GraphicObject
{
	protected this()
	{

	}

	@property public abstract Size size();
	@property public abstract ImageType type();

	protected this(HGDIOBJ hGdiObj, bool owned)
	{
		super(hGdiObj, owned);
	}
}

class Bitmap: Image
{
	public this(Size sz)
	{
		HBITMAP hBitmap = this.createBitmap(sz.width, sz.height, RGB(0xFF, 0xFF, 0xFF));
		super(hBitmap, true);
	}

	public this(Size sz, Color bc)
	{
		HBITMAP hBitmap = this.createBitmap(sz.width, sz.height, bc.colorref);
		super(hBitmap, true);
	}

	public this(int w, int h)
	{
		HBITMAP hBitmap = this.createBitmap(w, h, RGB(0xFF, 0xFF, 0xFF));
		super(hBitmap, true);
	}

	public this(int w, int h, Color bc)
	{
		HBITMAP hBitmap = this.createBitmap(w, h, bc.colorref);
		super(hBitmap, true);
	}

	protected this(HBITMAP hBitmap, bool owned)
	{
		super(hBitmap, owned);
	}

	protected this(string fileName)
	{
		HBITMAP hBitmap = loadImage(null, fileName, IMAGE_BITMAP, 0, 0, LR_DEFAULTCOLOR | LR_DEFAULTSIZE | LR_LOADFROMFILE);

		if(!hBitmap)
		{
			throwException!(Win32Exception)("Cannot load Bitmap From File: '%s'", fileName);
		}

		super(hBitmap, true);
	}

	private static HBITMAP createBitmap(int w, int h, COLORREF backColor)
	{
		Rect r = Rect(0, 0, w, h);

		HDC hdc = GetWindowDC(null);
		HDC hcdc = CreateCompatibleDC(hdc);
		HBITMAP hBitmap = CreateCompatibleBitmap(hdc, w, h);
		HBITMAP hOldBitmap = SelectObject(hcdc, hBitmap);

		HBRUSH hBrush = CreateSolidBrush(backColor);
		FillRect(hcdc, &r.rect, hBrush);
		DeleteObject(hBrush);

		SelectObject(hcdc, hOldBitmap);
		DeleteDC(hcdc);
		ReleaseDC(null, hdc);

		return hBitmap;
	}

	/*
	 *  !!! Is this procedure useful? !!!
	 *
	public Bitmap alphaBlend(ubyte alpha)
	{
		if(!_gdiAlphaBlend)
		{
			_gdiAlphaBlend = cast(GdiAlphaBlendProc)GetProcAddress(getModuleHandle("gdi32.dll"), toStringz("GdiAlphaBlend"));
		}

		BITMAP b;
		getInfo!(BITMAP)(this._handle, b);

		HDC hdc = GetWindowDC(null);
		HDC hdc1 = CreateCompatibleDC(hdc);
		HDC hdc2 = CreateCompatibleDC(hdc);
		HBITMAP hBitmap = CreateCompatibleBitmap(hdc, b.bmWidth, b.bmHeight);
		HBITMAP hOldBitmap1 = SelectObject(hdc1, hBitmap);
		HBITMAP hOldBitmap2 = SelectObject(hdc2, this._handle);

		BLENDFUNCTION bf;
		bf.BlendOp = 0; // AC_SRC_OVER
		bf.SourceConstantAlpha = alpha;

		if(b.bmBitsPixel == 32) // Premultiply bits if Bitmap's bpp = 32bpp
		{
			BitmapData bd;
			Bitmap.getData(hBitmap, bd);

			for(int i = 0; i < bd.bitsCount; i++)
			{
				bd.bits[i].red = cast(ubyte)(bd.bits[i].red * (alpha / 0xFF));
				bd.bits[i].green = cast(ubyte)(bd.bits[i].green * (alpha / 0xFF));
				bd.bits[i].blue = cast(ubyte)(bd.bits[i].blue * (alpha / 0xFF));
			}

			Bitmap.setData(hBitmap, bd);

			bf.AlphaFormat = 1; // AC_SRC_ALPHA
		}

		_gdiAlphaBlend(hdc1, 0, 0, b.bmWidth, b.bmHeight, hdc2, 0, 0, b.bmWidth, b.bmHeight, bf);

		SelectObject(hdc2, hOldBitmap2);
		SelectObject(hdc1, hOldBitmap1);
		DeleteDC(hdc2);
		DeleteDC(hdc1);
		ReleaseDC(null, hdc);

		return Bitmap.fromHBITMAP(hBitmap);
	}
	*/

	public Bitmap clone()
	{
		BITMAP b;
		getInfo!(BITMAP)(this._handle, b);

		HDC hdc = GetDC(null);
		HDC hcdc1 = CreateCompatibleDC(hdc); // Contains this bitmap
		HDC hcdc2 = CreateCompatibleDC(hdc); // The Bitmap will be copied here
		HBITMAP hBitmap = CreateCompatibleBitmap(hdc, b.bmWidth, b.bmHeight); //Don't delete it, it will be deleted by the class Bitmap

		HBITMAP hOldBitmap1 = SelectObject(hcdc1, this._handle);
		HBITMAP hOldBitmap2 = SelectObject(hcdc2, hBitmap);

		BitBlt(hcdc2, 0, 0, b.bmWidth, b.bmHeight, hcdc1, 0, 0, SRCCOPY);
		SelectObject(hcdc2, hOldBitmap2);
		SelectObject(hcdc1, hOldBitmap1);

		DeleteDC(hcdc2);
		DeleteDC(hcdc1);
		ReleaseDC(null, hdc);

		Bitmap bmp = new Bitmap(hBitmap, true);
		return bmp;
	}

	public static void getData(HBITMAP hBitmap, ref BitmapData bd)
	{
		BITMAPINFO bi;
		bi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
		bi.bmiHeader.biBitCount = 0;

		HDC hdc = GetWindowDC(null);
		GetDIBits(hdc, hBitmap, 0, 0, null, &bi, DIB_RGB_COLORS); // Get Bitmap Info

		bd.imageSize = bi.bmiHeader.biSizeImage;
		bd.bitsCount = bi.bmiHeader.biSizeImage / RGBQUAD.sizeof;
		bd.bits = cast(BitmapBit*)GC.malloc(bi.bmiHeader.biSizeImage);

		switch(bi.bmiHeader.biBitCount) // Calculate color table size (if needed)
		{
			case 24:
				bd.info = cast(BITMAPINFO*)GC.malloc(bi.bmiHeader.biSize);
				break;

			case 16, 32:
				bd.info = cast(BITMAPINFO*)GC.malloc(bi.bmiHeader.biSize + uint.sizeof * 3); // Needs Investigation
				break;

			default:
				bd.info = cast(BITMAPINFO*)GC.malloc(bi.bmiHeader.biSize + RGBQUAD.sizeof * (1 << bi.bmiHeader.biBitCount));
				break;
		}

		bd.info.bmiHeader = bi.bmiHeader;
		GetDIBits(hdc, hBitmap, 0, bd.info.bmiHeader.biHeight, cast(RGBQUAD*)bd.bits, bd.info, DIB_RGB_COLORS);
		ReleaseDC(null, hdc);
	}


	public void getData(ref BitmapData bd)
	{
		return Bitmap.getData(this._handle, bd);
	}

	private static void setData(HBITMAP hBitmap, ref BitmapData bd)
	{
		HDC hdc = GetWindowDC(null);
		SetDIBits(hdc, hBitmap, 0, bd.info.bmiHeader.biHeight, cast(RGBQUAD*)bd.bits, bd.info, DIB_RGB_COLORS);

		ReleaseDC(null, hdc);
		Bitmap.freeData(bd);
	}

	public void setData(ref BitmapData bd)
	{
		Bitmap.setData(this._handle, bd);
	}

	public static void freeData(ref BitmapData bd)
	{
		GC.free(bd.bits);
		GC.free(bd.info);
	}

	@property public override Size size()
	{
		BITMAP bmp = void; //Inizializzata da getInfo()

		getInfo!(BITMAP)(this._handle, bmp);
		return Size(bmp.bmWidth, bmp.bmHeight);
	}

	@property public override ImageType type()
	{
		return ImageType.bitmap;
	}

	public static Bitmap fromHBITMAP(HBITMAP hBitmap, bool owned = true)
	{
		return new Bitmap(hBitmap, owned);
	}

	public static Bitmap fromFile(string fileName)
	{
		return new Bitmap(fileName);
	}
}

class Icon: Image
{
	protected this(HICON hIcon, bool owned)
	{
		super(hIcon, owned);
	}

	protected this(string fileName)
	{
		HICON hIcon;

		if(!icmp(std.path.extension(fileName), ".ico"))
		{
			hIcon = loadImage(null, fileName, IMAGE_ICON, 0, 0, LR_DEFAULTCOLOR | LR_DEFAULTSIZE | LR_LOADFROMFILE);
		}
		else
		{
			ushort dummy = 0;
			hIcon = extractAssociatedIcon(fileName, &dummy);
		}

		if(!hIcon)
		{
			throwException!(Win32Exception)("Cannot load Icon From File: '%s'", fileName);
		}

		super(hIcon, true);
	}

	public override void dispose()
	{
		if(this._handle && this._owned)
		{
			DestroyIcon(this._handle); // Use DestroyIcon() not DestroyObject()
		}
	}

	@property public override Size size()
	{
		ICONINFO ii = void; //Inizializzata da GetIconInfo()
		BITMAP bmp = void; //Inizializzata da getInfo()
		Size sz = void; //Inizializzata sotto.

		if(!GetIconInfo(this._handle, &ii))
		{
			throwException!(Win32Exception)("Unable to get information from Icon");
		}

		if(ii.hbmColor) //Exists: Icon Color Bitmap
		{
			if(!getInfo!(BITMAP)(ii.hbmColor, bmp))
			{
				throwException!(Win32Exception)("Unable to get Icon Color Bitmap");
			}

			sz.width = bmp.bmWidth;
			sz.height = bmp.bmHeight;
			DeleteObject(ii.hbmColor);
		}
		else
		{
			if(!getInfo!(BITMAP)(ii.hbmMask, bmp))
			{
				throwException!(Win32Exception)("Unable to get Icon Mask");
			}

			sz.width = bmp.bmWidth;
			sz.height = bmp.bmHeight / 2;
		}

		DeleteObject(ii.hbmMask);
		return sz;
	}

	@property public override ImageType type()
	{
		return ImageType.iconOrCursor;
	}

	public Bitmap toBitmap(Size sz)
	{
		HDC hwdc = GetWindowDC(null);
		HDC hdc1 = CreateCompatibleDC(hwdc);

		HBITMAP hBitmap = CreateCompatibleBitmap(hwdc, sz.width, sz.height);
		HBITMAP hOldBitmap = SelectObject(hdc1, hBitmap);

		Rect r = Rect(nullPoint, sz);
		HBRUSH hBrush = CreateSolidBrush(RGB(255, 255, 255));
		FillRect(hdc1, &r.rect, hBrush);
		DeleteObject(hBrush);

		DrawIconEx(hdc1, 0, 0, this._handle, sz.width, sz.height, 0, null, DI_NORMAL);
		SelectObject(hdc1, hOldBitmap);
		DeleteDC(hdc1);
		ReleaseDC(null, hwdc);

		return Bitmap.fromHBITMAP(hBitmap);
	}

	public Bitmap toBitmap()
	{
		Size sz = this.size;
		return this.toBitmap(sz);
	}

	public static Icon fromHICON(HICON hIcon, bool owned = true)
	{
		return new Icon(hIcon, owned);
	}

	public static Icon fromFile(string fileName)
	{
		return new Icon(fileName);
	}
}

final class Cursor: Icon
{
	protected this(HCURSOR hCursor, bool owned)
	{
		super(hCursor, owned);
	}

	public override void dispose()
	{
		if(this._handle && this._owned)
		{
			DestroyCursor(this._handle); // Use DestroyCursor() not DestroyObject()
		}
	}

	@property public static Point position()
	{
		Point pt;

		GetCursorPos(&pt.point);
		return pt;
	}

	public static Cursor fromHCURSOR(HCURSOR hCursor, bool owned = true)
	{
		return new Cursor(hCursor, owned);
	}
}

final class Font: GraphicObject
{
	private static int _logPixelSY = 0;

	private bool _metricsDone = false;
	private FontMetrics _metrics;

	private this(HFONT hFont, bool owned)
	{
		super(hFont, owned);
	}

	private static void initLogPixelSY()
	{
		if(!_logPixelSY)
		{
			HDC hdc = GetWindowDC(null);
			_logPixelSY = GetDeviceCaps(hdc, LOGPIXELSY);
			ReleaseDC(null, hdc);
		}
	}

	public this(string name, int h, FontStyle style = FontStyle.normal)
	{
		Font.initLogPixelSY();

		LOGFONTW lf;
		lf.lfHeight = -MulDiv(h, _logPixelSY, 72);

		doStyle(style, lf);
		this._handle = createFontIndirect(name, &lf);
	}

	public this(Font f, FontStyle fs)
	{
		LOGFONTW lf;

		getInfo!(LOGFONTW)(f.handle, lf);
		doStyle(fs, lf);
		this._handle = createFontIndirect(&lf);
	}

	@property public string name()
	{
		LOGFONTW lf;

		getInfo!(LOGFONTW)(this._handle, lf);
		int idx = indexOf(lf.lfFaceName, '\0');
		return to!(string)(lf.lfFaceName[0..idx]);
	}

	@property public int height()
	{
		LOGFONTW lf;

		Font.initLogPixelSY();

		getInfo!(LOGFONTW)(this._handle, lf);
		return -MulDiv(72, lf.lfHeight, _logPixelSY);
	}

	@property public FontMetrics metrics()
	{
		if(!this._metricsDone)
		{
			TEXTMETRICW tm;

			HDC hdc = CreateCompatibleDC(null);
			HFONT hOldFont = SelectObject(hdc, this._handle);
			GetTextMetricsW(hdc, &tm);
			SelectObject(hdc, hOldFont);
			DeleteDC(hdc);

			this._metrics.height = tm.tmHeight;
			this._metrics.ascent = tm.tmAscent;
			this._metrics.descent = tm.tmDescent;
			this._metrics.internalLeading = tm.tmInternalLeading;
			this._metrics.externalLeading = tm.tmExternalLeading;
			this._metrics.averageCharWidth = tm.tmAveCharWidth;
			this._metrics.maxCharWidth = tm.tmMaxCharWidth;

			this._metricsDone = true;
		}

		return this._metrics;
	}

	private static void doStyle(FontStyle style, ref LOGFONTW lf)
	{
		lf.lfCharSet = DEFAULT_CHARSET;
		lf.lfWeight = FW_NORMAL;
		//lf.lfItalic = FALSE;    Inizializzata dal compilatore
		//lf.lfStrikeOut = FALSE; Inizializzata dal compilatore
		//lf.lfUnderline = FALSE; Inizializzata dal compilatore

		if(style & FontStyle.bold)
		{
			lf.lfWeight = FW_BOLD;
		}

		if(style & FontStyle.italic)
		{
			lf.lfItalic = 1;
		}

		if(style & FontStyle.strikeout)
		{
			lf.lfStrikeOut = 1;
		}

		if(style & FontStyle.underline)
		{
			lf.lfUnderline = 1;
		}
	}

	public static Font fromHFONT(HFONT hFont, bool owned = true)
	{
		return new Font(hFont, owned);
	}
}

abstract class Brush: GraphicObject
{
	protected this(HBRUSH hBrush, bool owned)
	{
		super(hBrush, owned);
	}
}

class SolidBrush: Brush
{
	private Color _color;

	protected this(HBRUSH hBrush, bool owned)
	{
		super(hBrush, owned);
	}

	public this(Color color)
	{
		this._color = color;
		super(CreateSolidBrush(color.colorref), true);
	}

	@property public final Color color()
	{
		return this._color;
	}

	public static SolidBrush fromHBRUSH(HBRUSH hBrush, bool owned = true)
	{
		return new SolidBrush(hBrush, owned);
	}
}

class HatchBrush: Brush
{
	private Color _color;
	private HatchStyle _style;

	protected this(HBRUSH hBrush, bool owned)
	{
		super(hBrush, owned);
	}

	public this(Color color, HatchStyle style)
	{
		this._color = color;
		this._style = style;

		super(CreateHatchBrush(style, color.colorref), true);
	}

	@property public final Color color()
	{
		return this._color;
	}

	@property public final HatchStyle style()
	{
		return this._style;
	}

	public static HatchBrush fromHBRUSH(HBRUSH hBrush, bool owned = true)
	{
		return new HatchBrush(hBrush, owned);
	}
}

class PatternBrush: Brush
{
	private Bitmap _bmp;

	protected this(HBRUSH hBrush, bool owned)
	{
		super(hBrush, owned);
	}

	public this(Bitmap bmp)
	{
		this._bmp = bmp;
		super(CreatePatternBrush(bmp.handle), true);
	}

	@property public final Bitmap bitmap()
	{
		return this._bmp;
	}

	public static PatternBrush fromHBRUSH(HBRUSH hBrush, bool owned = true)
	{
		return new PatternBrush(hBrush, owned);
	}
}

final class Pen: GraphicObject
{
	private PenStyle _style;
	private Color _color;
	private int _width;

	protected this(HPEN hPen, bool owned)
	{
		super(hPen, owned);
	}

	public this(Color color, int width = 1, PenStyle style = PenStyle.solid)
	{
		this._color = color;
		this._width = width;
		this._style = style;

		this._handle = CreatePen(style, width, color.colorref);

		super(this._handle, true);
	}

	@property public PenStyle style()
	{
		return this._style;
	}

	@property public int width()
	{
		return this._width;
	}

	@property public Color color()
	{
		return this._color;
	}

	public static Pen fromHPEN(HPEN hPen, bool owned = true)
	{
		return new Pen(hPen, owned);
	}
}

final class SystemPens
{
	@property public static Pen nullPen()
	{
		return Pen.fromHPEN(GetStockObject(NULL_PEN), false);
	}

	@property public static Pen blackPen()
	{
		return Pen.fromHPEN(GetStockObject(BLACK_PEN), false);
	}

	@property public static Pen whitePen()
	{
		return Pen.fromHPEN(GetStockObject(WHITE_PEN), false);
	}
}

final class SystemIcons
{
	@property public static Icon application()
	{
		static Icon ico;

		if(!ico)
		{
			HICON hIco = loadImage(null, cast(wchar*)IDI_APPLICATION, IMAGE_ICON, 0, 0, LR_SHARED | LR_DEFAULTCOLOR | LR_DEFAULTSIZE);
			ico = Icon.fromHICON(hIco);
		}

		return ico;
	}

	@property public static Icon asterisk()
	{
		static Icon ico;

		if(!ico)
		{
			HICON hIco = loadImage(null, IDI_ASTERISK, IMAGE_ICON, 0, 0, LR_SHARED | LR_DEFAULTCOLOR | LR_DEFAULTSIZE);
			ico = Icon.fromHICON(hIco);
		}

		return ico;
	}

	@property public static Icon error()
	{
		static Icon ico;

		if(!ico)
		{
			HICON hIco = loadImage(null, IDI_ERROR, IMAGE_ICON, 0, 0, LR_SHARED | LR_DEFAULTCOLOR | LR_DEFAULTSIZE);
			ico = Icon.fromHICON(hIco);
		}

		return ico;
	}

	@property public static Icon question()
	{
		static Icon ico;

		if(!ico)
		{
			HICON hIco = loadImage(null, IDI_QUESTION, IMAGE_ICON, 0, 0, LR_SHARED | LR_DEFAULTCOLOR | LR_DEFAULTSIZE);
			ico = Icon.fromHICON(hIco);
		}

		return ico;
	}

	@property public static Icon warning()
	{
		static Icon ico;

		if(!ico)
		{
			HICON hIco = loadImage(null, IDI_WARNING, IMAGE_ICON, 0, 0, LR_SHARED | LR_DEFAULTCOLOR | LR_DEFAULTSIZE);
			ico = Icon.fromHICON(hIco);
		}

		return ico;
	}
}

final class SystemBrushes
{
	@property public static SolidBrush blackBrush()
	{
		return SolidBrush.fromHBRUSH(GetStockObject(BLACK_BRUSH), false);
	}

	@property public static SolidBrush darkGrayBrush()
	{
		return SolidBrush.fromHBRUSH(GetStockObject(DKGRAY_BRUSH), false);
	}

	@property public static SolidBrush grayBrush()
	{
		return SolidBrush.fromHBRUSH(GetStockObject(GRAY_BRUSH), false);
	}

	@property public static SolidBrush lightGrayBrush()
	{
		return SolidBrush.fromHBRUSH(GetStockObject(LTGRAY_BRUSH), false);
	}

	@property public static SolidBrush nullBrush()
	{
		return SolidBrush.fromHBRUSH(GetStockObject(NULL_BRUSH), false);
	}

	@property public static SolidBrush whiteBrush()
	{
		return SolidBrush.fromHBRUSH(GetStockObject(WHITE_BRUSH), false);
	}

	@property public static SolidBrush brush3DDarkShadow()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_3DDKSHADOW), false);
	}

	@property public static SolidBrush brush3DFace()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_3DFACE), false);
	}

	@property public static SolidBrush brushButtonFace()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_BTNFACE), false);
	}

	@property public static SolidBrush brush3DLight()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_3DLIGHT), false);
	}

	@property public static SolidBrush brush3DShadow()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_3DSHADOW), false);
	}

	@property public static SolidBrush brushActiveBorder()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_ACTIVEBORDER), false);
	}

	@property public static SolidBrush brushActiveCaption()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_3DLIGHT), false);
	}

	@property public static SolidBrush brushAppWorkspace()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_APPWORKSPACE), false);
	}

	@property public static SolidBrush brushBackground()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_BACKGROUND), false);
	}

	@property public static SolidBrush brushButtonText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_BTNTEXT), false);
	}

	@property public static SolidBrush brushCaptionText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_CAPTIONTEXT), false);
	}

	@property public static SolidBrush brushGrayText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_GRAYTEXT), false);
	}

	@property public static SolidBrush brushHighlight()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_HIGHLIGHT), false);
	}

	@property public static SolidBrush brushHighlightText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_HIGHLIGHTTEXT), false);
	}

	@property public static SolidBrush brushInactiveBorder()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_INACTIVEBORDER), false);
	}

	@property public static SolidBrush brushInactiveCaption()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_INACTIVECAPTION), false);
	}

	@property public static SolidBrush brushInactiveCaptionText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_INACTIVECAPTIONTEXT), false);
	}

	@property public static SolidBrush brushInfo()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_INFOBK), false);
	}

	@property public static SolidBrush brushInfoText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_INFOTEXT), false);
	}

	@property public static SolidBrush brushMenu()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_MENU), false);
	}

	@property public static SolidBrush brushMenuText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_MENUTEXT), false);
	}

	@property public static SolidBrush brushScrollBar()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_SCROLLBAR), false);
	}

	@property public static SolidBrush brushWindow()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_WINDOW), false);
	}

	@property public static SolidBrush brushWindowFrame()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_WINDOW), false);
	}

	@property public static SolidBrush brushWindowText()
	{
		return SolidBrush.fromHBRUSH(GetSysColorBrush(COLOR_WINDOWTEXT), false);
	}
}

final class SystemFonts
{
	@property public static Font windowsFont()
	{
		static Font f;

		if(!f)
		{
			NONCLIENTMETRICSW ncm = void; //La inizializza sotto.
			ncm.cbSize = NONCLIENTMETRICSW.sizeof;

			if(SystemParametersInfoW(SPI_GETNONCLIENTMETRICS, NONCLIENTMETRICSW.sizeof, &ncm, 0))
			{
				f = Font.fromHFONT(createFontIndirect(&ncm.lfMessageFont), false);
			}
			else
			{
				f = SystemFonts.ansiVarFont;
			}
		}

		return f;
	}

	@property public static Font ansiFixedFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(ANSI_FIXED_FONT), false);
		}

		return f;
	}

	@property public static Font ansiVarFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(ANSI_VAR_FONT), false);
		}

		return f;
	}

	@property public static Font deviceDefaultFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(DEVICE_DEFAULT_FONT), false);
		}

		return f;
	}

	@property public static Font oemFixedFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(OEM_FIXED_FONT), false);
		}

		return f;
	}

	@property public static Font systemFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(SYSTEM_FONT), false);
		}

		return f;
	}

	@property public static Font systemFixedFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(SYSTEM_FIXED_FONT), false);
		}

		return f;
	}
}

final class SystemCursors
{
	@property public static Cursor appStarting()
	{
		static Cursor c;

		if(!c)
		{
			 c = Cursor.fromHCURSOR(loadImage(getHInstance(), IDC_APPSTARTING, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor arrow()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_ARROW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor cross()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, cast(wchar*)IDC_CROSS, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor iBeam()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_IBEAM, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor icon()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_ICON, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor no()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_NO, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor sizeAll()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_SIZEALL, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor sizeNESW()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_SIZENESW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor sizeNS()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_SIZENS, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor sizeNWSE()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_SIZENWSE, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor sizeWE()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_SIZEWE, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor upArrow()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_UPARROW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}

	@property public static Cursor wait()
	{
		static Cursor c;

		if(!c)
		{
			c = Cursor.fromHCURSOR(loadImage(null, IDC_WAIT, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), false);
		}

		return c;
	}
}

final class SystemColors
{
	@property public static Color red()
	{
		return Color(0xFF, 0x00, 0x00);
	}

	@property public static Color green()
	{
		return Color(0x00, 0xFF, 0x00);
	}

	@property public static Color blue()
	{
		return Color(0x00, 0x00, 0xFF);
	}

	@property public static Color black()
	{
		return Color(0x00, 0x00, 0x00);
	}

	@property public static Color white()
	{
		return Color(0xFF, 0xFF, 0xFF);
	}

	@property public static Color yellow()
	{
		return Color(0xFF, 0xFF, 0x00);
	}

	@property public static Color magenta()
	{
		return Color(0xFF, 0x00, 0xFF);
	}

	@property public static Color magicPink()
	{
		return SystemColors.magenta; //Is 'Magic Pink'
	}

	@property public static Color cyan()
	{
		return Color(0x00, 0xFF, 0xFF);
	}

	@property public static Color darkGray()
	{
		return Color(0xA9, 0xA9, 0xA9);
	}

	@property public static Color lightGray()
	{
		return Color(0xD3, 0xD3, 0xD3);
	}

	@property public static Color darkRed()
	{
		return Color(0x8B, 0x00, 0x00);
	}

	@property public static Color darkGreen()
	{
		return Color(0x00, 0x64, 0x00);
	}

	@property public static Color darkBlue()
	{
		return Color(0x00, 0x00, 0x8B);
	}

	@property public static Color darkYellow()
	{
		return Color(0x00, 0x80, 0x80);
	}

	@property public static Color darkMagenta()
	{
		return Color(0x80, 0x00, 0x80);
	}

	@property public static Color darkCyan()
	{
		return Color(0x80, 0x80, 0x00);
	}

	@property public static Color transparent()
	{
		return Color(0x00, 0x00, 0x00, 0x00);
	}

	@property public static Color color3DDarkShadow()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DDKSHADOW));
	}

	@property public static Color color3DFace()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DFACE));
	}

	@property public static Color colorButtonFace()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_BTNFACE));
	}

	@property public static Color color3DLight()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DLIGHT));
	}

	@property public static Color color3DShadow()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DSHADOW));
	}

	@property public static Color colorActiveBorder()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_ACTIVEBORDER));
	}

	@property public static Color colorActiveCaption()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DLIGHT));
	}

	@property public static Color colorAppWorkspace()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_APPWORKSPACE));
	}

	@property public static Color colorBackground()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_BACKGROUND));
	}

	@property public static Color colorButtonText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_BTNTEXT));
	}

	@property public static Color colorCaptionText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_CAPTIONTEXT));
	}

	@property public static Color colorGrayText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_GRAYTEXT));
	}

	@property public static Color colorHighlight()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_HIGHLIGHT));
	}

	@property public static Color colorHighlightText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_HIGHLIGHTTEXT));
	}

	@property public static Color colorInactiveBorder()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INACTIVEBORDER));
	}

	@property public static Color colorInactiveCaption()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INACTIVECAPTION));
	}

	@property public static Color colorInactiveCaptionText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INACTIVECAPTIONTEXT));
	}

	@property public static Color colorInfo()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INFOBK));
	}

	@property public static Color colorInfoText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INFOTEXT));
	}

	@property public static Color colorMenu()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_MENU));
	}

	@property public static Color colorMenuText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_MENUTEXT));
	}

	@property public static Color colorScrollBar()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_SCROLLBAR));
	}

	@property public static Color colorWindow()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_WINDOW));
	}

	@property public static Color colorWindowFrame()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_WINDOW));
	}

	@property public static Color colorWindowText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_WINDOWTEXT));
	}
}

final class TextFormat
{
	private TextTrimming _trim = TextTrimming.none; // TextTrimming.CHARACTER.
	private TextFormatFlags _flags = TextFormatFlags.noPrefix | TextFormatFlags.wordBreak;
	private TextAlignment _align = TextAlignment.left;
	private DRAWTEXTPARAMS _params = {DRAWTEXTPARAMS.sizeof, 8, 0, 0};

	public this()
	{

	}

	public this(TextFormat tf)
	{
		this._trim = tf._trim;
		this._flags = tf._flags;
		this._align = tf._align;
		this._params = tf._params;
	}

	public this(TextFormatFlags tff)
	{
		this._flags = tff;
	}

	@property public TextAlignment alignment()
	{
		return this._align;
	}

	@property public void alignment(TextAlignment ta)
	{
		this._align = ta;
	}

	@property public void formatFlags(TextFormatFlags tff)
	{
		this._flags = tff;
	}

	@property public TextFormatFlags formatFlags()
	{
		return this._flags;
	}

	@property public void trimming(TextTrimming tt)
	{
		this._trim = tt;
	}

	@property public TextTrimming trimming()
	{
		return this._trim;
	}

	@property public int tabLength()
	{
		return _params.iTabLength;
	}

	@property public void tabLength(int tablen)
	{
		this._params.iTabLength = tablen;
	}

	@property public int leftMargin()
	{
		return this._params.iLeftMargin;
	}

	@property public void leftMargin(int sz)
	{
		this._params.iLeftMargin = sz;
	}

	@property public int rightMargin()
	{
		return this._params.iRightMargin;
	}

	@property public void rightMargin(int sz)
	{
		this._params.iRightMargin = sz;
	}
}

final class Screen
{
	@property public static Size size()
	{
		Size sz = void; //Inizializzata sotto

		sz.width = GetSystemMetrics(SM_CXSCREEN);
		sz.height = GetSystemMetrics(SM_CYSCREEN);

		return sz;
	}

	@property public static Rect workArea()
	{
		Rect r = void; //Inizializzata sotto

		SystemParametersInfoW(SPI_GETWORKAREA, 0, &r.rect, 0);
		return r;
	}

	@property public static Canvas canvas()
	{
		return Canvas.fromHDC(GetWindowDC(null));
	}
}
