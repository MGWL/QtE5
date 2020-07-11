/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.form;

public import dgui.core.dialogs.dialogresult;
public import dgui.menubar;
private import dgui.core.utils;
import dgui.layout.layoutcontrol;
import dgui.core.events.eventargs;

alias CancelEventArgs!(Form) CancelFormEventArgs;

enum FormBits: ulong
{
	none 		 	= 0,
	modalCompleted = 1,
}

enum FormBorderStyle: ubyte
{
	none 				= 0,
	manual 				= 1, // Internal Use
	fixedSingle 		= 2,
	fixed3d 			= 4,
	fixedDialog		= 8,
	sizeable 			= 16,
	fixedToolWindow 	= 32,
	sizeableToolWindow = 64,
}

enum FormStartPosition: ubyte
{
	manual 			 = 0,
	centerParent	 = 1,
	centerScreen	 = 2,
	defaultLocation = 4,
}

class Form: LayoutControl
{
	private FormBits _fBits = FormBits.none;
	private FormStartPosition _startPosition = FormStartPosition.manual;
	private FormBorderStyle _formBorder = FormBorderStyle.sizeable;
	private DialogResult _dlgResult = DialogResult.cancel;
	private HWND _hActiveWnd;
	private Icon _formIcon;
	private MenuBar _menu;

	public Event!(Control, EventArgs) close;
	public Event!(Control, CancelFormEventArgs) closing;

	public this()
	{
		this.setStyle(WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX, true);
	}

	@property public final void formBorderStyle(FormBorderStyle fbs)
	{
		if(this.created)
		{
			uint style = 0, exStyle = 0;

			makeFormBorderStyle(this._formBorder, style, exStyle); // Vecchio Stile.
			this.setStyle(style, false);
			this.setExStyle(exStyle, false);

			style = 0;
			exStyle = 0;

			makeFormBorderStyle(fbs, style, exStyle); // Nuovo Stile.
			this.setStyle(style, true);
			this.setExStyle(exStyle, true);
		}

		this._formBorder = fbs;
	}

	@property public final void controlBox(bool b)
	{
		this.setStyle(WS_SYSMENU, b);
	}

	@property public final void maximizeBox(bool b)
	{
		this.setStyle(WS_MAXIMIZEBOX, b);
	}

	@property public final void minimizeBox(bool b)
	{
		this.setStyle(WS_MINIMIZEBOX, b);
	}

	@property public final void showInTaskbar(bool b)
	{
		this.setExStyle(WS_EX_APPWINDOW, b);
	}

	@property public final MenuBar menu()
	{
		return this._menu;
	}

	@property public final void menu(MenuBar mb)
	{
		if(this.created)
		{
			if(this._menu)
			{
				this._menu.dispose();
			}

			mb.create();
			SetMenu(this._handle, mb.handle);
		}

		this._menu = mb;
	}

	@property public final Icon icon()
	{
		return this._formIcon;
	}

	@property public final void icon(Icon ico)
	{
		if(this.created)
		{
			if(this._formIcon)
			{
				this._formIcon.dispose();
			}

			this.sendMessage(WM_SETICON, ICON_BIG, cast(LPARAM)ico.handle);
			this.sendMessage(WM_SETICON, ICON_SMALL, cast(LPARAM)ico.handle);
		}

		this._formIcon = ico;
	}

	@property public final void topMost(bool b)
	{
		this.setExStyle(WS_EX_TOPMOST, b);
	}

	@property public final void startPosition(FormStartPosition fsp)
	{
		this._startPosition = fsp;
	}

	private void doEvents()
	{
		MSG m = void;

		while(GetMessageW(&m, null, 0, 0))
		{
			if(Form.hasBit(this._cBits, ControlBits.modalControl) && Form.hasBit(this._fBits, FormBits.modalCompleted))
			{
				break;
			}
			else if(!IsDialogMessageW(this._handle, &m))
			{
				TranslateMessage(&m);
				DispatchMessageW(&m);
			}
		}
	}

	public override void show()
	{
		super.show();

		this.doEvents();
	}

	public final DialogResult showDialog()
	{
		Form.setBit(this._cBits, ControlBits.modalControl, true);
		this._hActiveWnd = GetActiveWindow();
		EnableWindow(this._hActiveWnd, false);

		this.show();
		return this._dlgResult;
	}

	private final void doFormStartPosition()
	{
		if((this._startPosition is FormStartPosition.centerParent && !this.parent) ||
			this._startPosition is FormStartPosition.centerScreen)
		{
			Rect wa = Screen.workArea;
			Rect b = this._bounds;

			this._bounds.position = Point((wa.width - b.width) / 2,
										  (wa.height - b.height) / 2);
		}
		else if(this._startPosition is FormStartPosition.centerParent)
		{
			Rect pr = this.parent.bounds;
			Rect b = this._bounds;

			this._bounds.position = Point(pr.left + (pr.width - b.width) / 2,
										  pr.top + (pr.height - b.height) / 2);
		}
		else if(this._startPosition is FormStartPosition.defaultLocation)
		{
			this._bounds.position = Point(CW_USEDEFAULT, CW_USEDEFAULT);
		}
	}

	private static void makeFormBorderStyle(FormBorderStyle fbs, ref uint style, ref uint exStyle)
	{
		switch(fbs)
		{
			case FormBorderStyle.fixed3d:
				style &= ~(WS_BORDER | WS_THICKFRAME | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_STATICEDGE);

				style |= WS_CAPTION;
				exStyle |= WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;

			case FormBorderStyle.fixedDialog:
				style &= ~(WS_BORDER | WS_THICKFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);

				style |= WS_CAPTION | WS_DLGFRAME;
				exStyle |= WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE;
				break;

			case FormBorderStyle.fixedSingle:
				style &= ~(WS_THICKFRAME | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_STATICEDGE);

				style |= WS_CAPTION | WS_BORDER;
				exStyle |= WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;

			case FormBorderStyle.fixedToolWindow:
				style &= ~(WS_BORDER | WS_THICKFRAME | WS_DLGFRAME);
				exStyle &= ~(WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);

				style |= WS_CAPTION;
				exStyle |= WS_EX_TOOLWINDOW | WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;

			case FormBorderStyle.sizeable:
				style &= ~(WS_BORDER | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE);

				style |= WS_CAPTION | WS_THICKFRAME;
				exStyle |= WS_EX_WINDOWEDGE;
				break;

			case FormBorderStyle.sizeableToolWindow:
				style &= ~(WS_BORDER | WS_DLGFRAME);
				exStyle &= ~(WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE);

				style |= WS_THICKFRAME | WS_CAPTION;
				exStyle |= WS_EX_TOOLWINDOW | WS_EX_WINDOWEDGE;
				break;

			case FormBorderStyle.none:
				style &= ~(WS_BORDER | WS_THICKFRAME | WS_CAPTION | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);
				break;

			default:
				assert(0, "Unknown Form Border Style");
				//break;
		}
	}

	protected override void onDGuiMessage(ref Message m)
	{
		switch(m.msg)
		{
			case DGUI_SETDIALOGRESULT:
			{
				this._dlgResult = cast(DialogResult)m.wParam;

				Form.setBit(this._fBits, FormBits.modalCompleted, true);
				ShowWindow(this._handle, SW_HIDE); // Hide this window (it waits to be destroyed)
				EnableWindow(this._hActiveWnd, true);
				SetActiveWindow(this._hActiveWnd); // Restore the previous active window
			}
			break;

			default:
				break;
		}

		super.onDGuiMessage(m);
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		uint style = 0, exStyle = 0;
		makeFormBorderStyle(this._formBorder, style, exStyle);

		this.setStyle(style, true);
		this.setExStyle(exStyle, true);
		ccp.className = WC_FORM;
		ccp.defaultCursor = SystemCursors.arrow;

		this.doFormStartPosition();
		super.createControlParams(ccp);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		if(this._menu)
		{
			this._menu.create();
			SetMenu(this._handle, this._menu.handle);
			DrawMenuBar(this._handle);
		}

		if(this._formIcon)
		{
			Message m = Message(this._handle, WM_SETICON, ICON_BIG, cast(LPARAM)this._formIcon.handle);
			this.originalWndProc(m);

			m.msg = ICON_SMALL;
			this.originalWndProc(m);
		}

		super.onHandleCreated(e);
	}

	protected override void wndProc(ref Message m)
	{
		switch(m.msg)
		{
			case WM_CLOSE:
			{
				scope CancelFormEventArgs e = new CancelFormEventArgs(this);
				this.onClosing(e);

				if(!e.cancel)
				{
					this.onClose(EventArgs.empty);

					if(Form.hasBit(this._cBits, ControlBits.modalControl))
					{
						EnableWindow(this._hActiveWnd, true);
						SetActiveWindow(this._hActiveWnd);
					}

					super.wndProc(m);
				}

				m.result = 0;
			}
			break;

			case WM_CONTEXTMENU:
			{
				// Display default shortcut menu in case of click on window's caption.

				Rect r = void;
				GetClientRect(handle, &r.rect);

				auto pt = Point(LOWORD(m.lParam), HIWORD(m.lParam));
				convertPoint(pt, null, this);
				if(pt.inRect(r))
					goto default;

				originalWndProc(m);
			}
			break;

			default:
				super.wndProc(m);
				break;
		}
	}

	protected void onClosing(CancelFormEventArgs e)
	{
		this.closing(this, e);
	}

	protected void onClose(EventArgs e)
	{
		this.close(this, e);
	}
}
