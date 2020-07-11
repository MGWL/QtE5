/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/


module dgui.layout.splitpanel;

import dgui.core.events.event;
import dgui.core.events.eventargs;
import dgui.layout.layoutcontrol;
import dgui.layout.panel;

enum SplitOrientation
{
	vertical   = 1,
	horizontal = 2,
}

class SplitPanel: LayoutControl
{
	private enum int splitterSize = 8;

	private SplitOrientation _splitOrientation = SplitOrientation.vertical;
	private bool _downing = false;
	private int _splitPos = 0;
	private Panel _panel1;
	private Panel _panel2;

	public this()
	{
		this._panel1 = new Panel();
		this._panel1.parent = this;

		this._panel2 = new Panel();
		this._panel2.parent = this;
	}

	@property public void splitPosition(int sp)
	{
		this._splitPos = sp;

		if(this.created)
		{
			this.updateLayout();
		}
	}

	@property public Panel panel1()
	{
		return this._panel1;
	}

	@property public Panel panel2()
	{
		return this._panel2;
	}

	@property SplitOrientation splitOrientation()
	{
		return this._splitOrientation;
	}

	@property void splitOrientation(SplitOrientation so)
	{
		this._splitOrientation = so;
	}

	public override void updateLayout()
	{
		scope ResizeManager rm = new ResizeManager(2); //Fixed Panel

		bool changed = false;

		switch(this._splitOrientation)
		{
			case SplitOrientation.vertical:
			{
				if(this._splitPos >= 0 && (this._splitPos + splitterSize) < this.width)
				{
					rm.setSize(this._panel1, this._splitPos, this.height);
					rm.resizeControl(this._panel2, this._splitPos + splitterSize, 0, this.width - (this._splitPos + splitterSize), this.height);
					changed = true;
				}
			}
			break;

			default: // SplitOrientation.horizontal
			{
				if(this._splitPos >= 0 && (this._splitPos + splitterSize) < this.height)
				{
					rm.setSize(this._panel1, this.width, this._splitPos);
					rm.resizeControl(this._panel2, 0, this._splitPos + splitterSize, this.width, this.height - (this._splitPos + splitterSize));
					changed = true;
				}
			}
			break;
		}

		if(changed)
		{
			this.invalidate();
		}
	}

	protected override void onMouseKeyDown(MouseEventArgs e)
	{
		if(e.keys == MouseKeys.left)
		{
			this._downing = true;
			SetCapture(this._handle);
		}

		super.onMouseKeyDown(e);
	}

	protected override void onMouseKeyUp(MouseEventArgs e)
	{
		if(this._downing)
		{
			this._downing = false;
			ReleaseCapture();
		}

		super.onMouseKeyUp(e);
	}

	protected override void onMouseMove(MouseEventArgs e)
	{
		if(this._downing)
		{
			Point pt = Cursor.position;
			convertPoint(pt, null, this);

			switch(this._splitOrientation)
			{
				case SplitOrientation.vertical:
					this._splitPos = pt.x;
					break;

				default: // SplitOrientation.horizontal
					this._splitPos = pt.y;
					break;
			}

			this.updateLayout();
		}

		super.onMouseMove(e);
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		ccp.className = WC_DSPLITPANEL;

		switch(this._splitOrientation)
		{
			case SplitOrientation.vertical:
				ccp.defaultCursor = SystemCursors.sizeWE;
				break;

			default: // SplitOrientation.horizontal
				ccp.defaultCursor = SystemCursors.sizeNS;
				break;
		}

		if(!this._splitPos)
		{
			switch(this._splitOrientation)
			{
				case SplitOrientation.vertical:
					this._splitPos = this.width / 3;
					break;

				default: // SplitOrientation.horizontal
					this._splitPos = this.height - (this.height / 3);
					break;
			}
		}

		super.createControlParams(ccp);
	}

	protected override void onDGuiMessage(ref Message m)
	{
		switch(m.msg)
		{
			case DGUI_ADDCHILDCONTROL:
			{
				Control c = winCast!(Control)(m.wParam);

				if(c is this._panel1 || c is this._panel2)
				{
					super.onDGuiMessage(m);
				}
				else
				{
					throwException!(DGuiException)("SplitPanel doesn't accept child controls");
				}
			}
			break;

			default:
				super.onDGuiMessage(m);
				break;
		}
	}

	protected override void onHandleCreated(EventArgs e)
	{
		switch(this._splitOrientation)
		{
			case SplitOrientation.vertical:
				this.cursor = SystemCursors.sizeWE;
				break;

			default: // SplitOrientation.horizontal
				this.cursor = SystemCursors.sizeNS;
				break;
		}

		super.onHandleCreated(e);
	}

	protected override void onPaint(PaintEventArgs e)
	{
		Canvas c = e.canvas;
		Rect cr = e.clipRectangle;
		int mid = this._splitPos + (splitterSize / 2);
		scope Pen dp = new Pen(SystemColors.color3DDarkShadow, 2, PenStyle.dot);
		scope Pen lp = new Pen(SystemColors.colorButtonFace, 2, PenStyle.dot);

		switch(this._splitOrientation)
		{
			case SplitOrientation.vertical:
			{
				c.drawEdge(Rect(this._splitPos, cr.top, splitterSize, cr.bottom), EdgeType.raised, EdgeMode.left | EdgeMode.right);

				for(int p = (this.height / 2) - 15, i = 0; i < 8; i++, p += 5)
				{
					c.drawLine(dp, mid, p, mid, p + 1);
					c.drawLine(lp, mid - 1, p - 1, mid - 1, p);
				}
			}
			break;

			default: // SplitOrientation.horizontal
			{
				c.drawEdge(Rect(cr.left, this._splitPos, cr.right, splitterSize), EdgeType.raised, EdgeMode.top | EdgeMode.bottom);

				for(int p = (this.width / 2) - 15, i = 0; i < 8; i++, p += 5)
				{
					c.drawLine(dp, p, mid, p + 1, mid);
					c.drawLine(lp, p - 1, mid + 1, p - 1, mid);
				}
			}
			break;
		}

		super.onPaint(e);
	}

	protected override void wndProc(ref Message m)
	{
		if(m.msg == WM_WINDOWPOSCHANGING)
		{
			WINDOWPOS* pWndPos = cast(WINDOWPOS*)m.lParam;

			if(!(pWndPos.flags & SWP_NOSIZE))
			{
				switch(this._splitOrientation)
				{
					case SplitOrientation.vertical:
					{
						if(this.width) // Avoid division by 0
							this._splitPos = MulDiv(pWndPos.cx, this._splitPos, this.width);
					}
					break;

					default: // SplitOrientation.horizontal
					{
						if(this.height) // Avoid division by 0
							this._splitPos = MulDiv(pWndPos.cy, this._splitPos, this.height);
					}
					break;
				}
			}
		}

		super.wndProc(m);
	}
}
