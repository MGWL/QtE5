/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.layout.layoutcontrol;

import dgui.core.interfaces.ilayoutcontrol;
public import dgui.core.controls.containercontrol;

class ResizeManager: Handle!(HDWP), IDisposable
{
	public this(int c)
	{
		if(c > 1)
		{
			this._handle = BeginDeferWindowPos(c);
		}
	}

	public ~this()
	{
		this.dispose();
	}

	public void dispose()
	{
		if(this._handle)
		{
			EndDeferWindowPos(this._handle);
		}
	}

	public void setPosition(Control ctrl, Point pt)
	{
		this.setPosition(ctrl, pt.x, pt.y);
	}

	public void setPosition(Control ctrl, int x, int y)
	{
		this.resizeControl(ctrl, x, y, 0, 0, PositionSpecified.position);
	}

	public void setSize(Control ctrl, Size sz)
	{
		this.setSize(ctrl, sz.width, sz.height);
	}

	public void setSize(Control ctrl, int w, int h)
	{
		this.resizeControl(ctrl, 0, 0, w, h, PositionSpecified.size);
	}

	public void resizeControl(Control ctrl, Rect r, PositionSpecified ps = PositionSpecified.all)
	{
		this.resizeControl(ctrl, r.x, r.y, r.width, r.height, ps);
	}

	public void resizeControl(Control ctrl, int x, int y, int w, int h, PositionSpecified ps = PositionSpecified.all)
	{
		uint wpf = SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE;

		if(ps !is PositionSpecified.all)
		{
			if(ps is PositionSpecified.position)
			{
				wpf &= ~SWP_NOMOVE;
			}
			else //if(ps is PositionSpecified.size)
			{
				wpf &= ~SWP_NOSIZE;
			}
		}
		else
		{
			wpf &= ~(SWP_NOMOVE | SWP_NOSIZE);
		}

		if(this._handle)
		{
			this._handle = DeferWindowPos(this._handle, ctrl.handle, null, x, y, w, h, wpf);
		}
		else
		{
			SetWindowPos(ctrl.handle, null, x, y, w, h, wpf); //Bounds updated in WM_WINDOWPOSCHANGED
		}
	}
}

abstract class LayoutControl: ContainerControl, ILayoutControl
{
	public override void show()
	{
		super.show();
		this.updateLayout();
	}

	public void updateLayout()
	{
	
		// MGW
		import std.stdio: writeln;
		
		
		if(this._childControls && this.created && this.visible)
		{
			scope ResizeManager rm = new ResizeManager(this._childControls.length);
			Rect da = Rect(nullPoint, this.clientSize);
			// writeln("---> da = ", da);
			// writeln("---> da.top = ", da.top);
			// Считаем высоту и ширину всех элементов
			int allH, allW; 
			foreach(Control c; this._childControls) {
				if(c.dock == DockStyle.top  ||  c.dock == DockStyle.bottom  ||  c.dock == DockStyle.height) allH += c.height;
				if(c.dock == DockStyle.left ||  c.dock == DockStyle.right   ||  c.dock == DockStyle.width)  allW += c.width;
			}

			foreach(Control c; this._childControls)
			{
				if(da.empty)
				{
					rm.dispose();
					break;
				}

				if(c.dock !is DockStyle.none && c.visible && c.created)
				{
					Rect da2 = Rect(nullPoint, this.clientSize);
					switch(c.dock)
					{
						// Добавлено два новых стиля height и width. В наборен элементов может быть
						// только один элемент этих стилей
						case DockStyle.height:
							allH -= c.height; c.height = da2.height - allH;
							rm.resizeControl(c, da.left, da.top, da.width, c.height);
							break;

						case DockStyle.width:
							allW -= c.width; c.width = da2.width - allW;
							rm.resizeControl(c, da.left, da.top, c.width, da.height);
							break;

						case DockStyle.left:
							//c.bounds = Rect(da.left, da.top, c.width, da.height);
							rm.resizeControl(c, da.left, da.top, c.width, da.height);
							da.left += c.width;
							break;

						case DockStyle.top:
							//c.bounds = Rect(da.left, da.top, da.width, c.height);
							rm.resizeControl(c, da.left, da.top, da.width, c.height);
							da.top += c.height;
							break;

						case DockStyle.right:
							//c.bounds = Rect(da.right - c.width, da.top, c.width, da.height);
							rm.resizeControl(c, da.right - c.width, da.top, c.width, da.height);
							da.right -= c.width;
							break;

						case DockStyle.bottom:
							//c.bounds = Rect(c, da.left, da.bottom - c.height, da.width, c.height);
							rm.resizeControl(c, da.left, da.bottom - c.height, da.width, c.height);
							da.bottom -= c.height;
							break;

						case DockStyle.fill:
							//c.bounds = da;
							rm.resizeControl(c, da);
							da.size = nullSize;
							break;

						default:
							rm.dispose();
							assert(false, "Unknown DockStyle");
							//break;
					}
				}
			}
		}
	}

	protected override void onDGuiMessage(ref Message m)
	{
		switch(m.msg)
		{
			case DGUI_DOLAYOUT:
				this.updateLayout();
				break;

			case DGUI_CHILDCONTROLCREATED:
			{
				Control c = winCast!(Control)(m.wParam);

				if(c.dock !is DockStyle.none && c.visible)
				{
					this.updateLayout();
				}
			}
			break;

			default:
				break;
		}

		super.onDGuiMessage(m);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		super.onHandleCreated(e);

		this.updateLayout();
	}

	protected override void onResize(EventArgs e)
	{
		this.updateLayout();

		InvalidateRect(this._handle, null, true);
		UpdateWindow(this._handle);
		super.onResize(e);
	}
}
