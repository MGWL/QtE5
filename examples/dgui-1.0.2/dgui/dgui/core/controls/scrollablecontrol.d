/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.controls.scrollablecontrol;

public import dgui.core.controls.reflectedcontrol;
public import dgui.core.events.mouseeventargs;
public import dgui.core.events.scrolleventargs;

abstract class ScrollableControl: ReflectedControl
{
	public Event!(Control, ScrollEventArgs) scroll;
	public Event!(Control, MouseWheelEventArgs) mouseWheel;

	protected final void scrollWindow(ScrollWindowDirection swd, int amount)
	{
		this.scrollWindow(swd, amount, nullRect);
	}

	protected final void scrollWindow(ScrollWindowDirection swd, int amount, Rect rectScroll)
	{
		if(this.created)
		{
			switch(swd)
			{
				case ScrollWindowDirection.left:
					ScrollWindowEx(this._handle, amount, 0, null, rectScroll == nullRect ? null : &rectScroll.rect, null, null, SW_INVALIDATE);
					break;

				case ScrollWindowDirection.up:
					ScrollWindowEx(this._handle, 0, amount, null, rectScroll == nullRect ? null : &rectScroll.rect, null, null, SW_INVALIDATE);
					break;

				case ScrollWindowDirection.right:
					ScrollWindowEx(this._handle, -amount, 0, null, rectScroll == nullRect ? null : &rectScroll.rect, null, null, SW_INVALIDATE);
					break;

				case ScrollWindowDirection.down:
					ScrollWindowEx(this._handle, 0, -amount, null, rectScroll == nullRect ? null : &rectScroll.rect, null, null, SW_INVALIDATE);
					break;

				default:
					break;
			}
		}
	}

	protected void onMouseWheel(MouseWheelEventArgs e)
	{
		this.mouseWheel(this, e);
	}

	protected void onScroll(ScrollEventArgs e)
	{
		this.scroll(this, e);
	}

	protected override void wndProc(ref Message m)
	{
		switch(m.msg)
		{
			case WM_MOUSEWHEEL:
			{
				short delta = GetWheelDelta(m.wParam);
				scope MouseWheelEventArgs e = new MouseWheelEventArgs(Point(LOWORD(m.lParam), HIWORD(m.lParam)),
																      cast(MouseKeys)m.wParam, delta > 0 ? MouseWheel.up : MouseWheel.down);
				this.onMouseWheel(e);
				this.originalWndProc(m);
			}
			break;

			case WM_VSCROLL, WM_HSCROLL:
			{
				ScrollDirection sd = m.msg == WM_VSCROLL ? ScrollDirection.vertical : ScrollDirection.horizontal;
				ScrollMode sm = cast(ScrollMode)m.wParam;

				scope ScrollEventArgs e = new ScrollEventArgs(sd, sm);
				this.onScroll(e);

				this.originalWndProc(m);
			}
			break;

			default:
				break;
		}

		super.wndProc(m);
	}
}
