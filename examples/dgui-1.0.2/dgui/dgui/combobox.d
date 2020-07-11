/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.combobox;

import std.utf: toUTFz;
import dgui.core.controls.subclassedcontrol;
import dgui.core.utils;
public import dgui.imagelist;

enum DropDownStyles: uint
{
	none 		  = 0, // Internal Use
	simple 		  = CBS_SIMPLE,
	dropdown 	  = CBS_DROPDOWN,
	dropdownList = CBS_DROPDOWNLIST,
}

class ComboBoxItem
{
	private ComboBox _owner;
	private string _text;
	private int _imgIndex = -1;

	mixin tagProperty;

	package this(string txt, int idx = -1)
	{
		this._text = txt;
		this._imgIndex = idx;
	}

	@property public final int index()
	{
		if(this._owner.items)
		{
			foreach(int i, ComboBoxItem cbi; this._owner.items)
			{
				if(cbi is this)
				{
					return i;
				}
			}
		}

		return -1;
	}

	@property public final ComboBox comboBox()
	{
		return this._owner;
	}

	@property package void comboBox(ComboBox cbx)
	{
		this._owner = cbx;
	}

	@property public final int imageIndex()
	{
		return this._imgIndex;
	}

	@property public final void imageIndex(int idx)
	{
		this._imgIndex = idx;

		if(this._owner && this._owner.created)
		{
			COMBOBOXEXITEMW cbei;

			cbei.mask = CBEIF_IMAGE;
			cbei.iImage = idx;
			cbei.iItem = this.index;

			this._owner.sendMessage(CBEM_SETITEMW, 0, cast(LPARAM)&cbei);
		}
	}

	@property public final string text()
	{
		return this._text;
	}

	@property public final void text(string txt)
	{
		this._text = txt;

		if(this._owner && this._owner.created)
		{
			COMBOBOXEXITEMW cbei;

			cbei.mask = CBEIF_TEXT;
			cbei.pszText = toUTFz!(wchar*)(txt);
			cbei.iItem = this.index;

			this._owner.sendMessage(CBEM_SETITEMW, 0, cast(LPARAM)&cbei);
		}
	}
}

class ComboBox: SubclassedControl
{
	public Event!(Control, EventArgs) itemChanged;

	private Collection!(ComboBoxItem) _items;
	private DropDownStyles _oldDDStyle = DropDownStyles.none;
	private int _selectedIndex;
	private ImageList _imgList;

	public this()
	{
		this.setStyle(DropDownStyles.dropdown, true);
	}

	public final ComboBoxItem addItem(string s, int imgIndex = -1)
	{
		if(!this._items)
		{
			this._items = new Collection!(ComboBoxItem);
		}

		ComboBoxItem cbi = new ComboBoxItem(s, imgIndex);
		this._items.add(cbi);

		if(this.created)
		{
			return this.insertItem(cbi);
		}

		return cbi;
	}

	public final void removeItem(int idx)
	{
		if(this.created)
		{
			this.sendMessage(CB_DELETESTRING, idx, 0);
		}

		this._items.removeAt(idx);
	}

	@property public final int selectedIndex()
	{
		if(this.created)
		{
			return this.sendMessage(CB_GETCURSEL, 0, 0);
		}

		return this._selectedIndex;
	}

	@property public final void selectedIndex(int i)
	{
		this._selectedIndex = i;

		if(this.created)
		{
			this.sendMessage(CB_SETCURSEL, i, 0);
		}
	}

	public void clear()
	{
		if(this._items)
		{
			foreach(ComboBoxItem cbi; this._items)
			{
				this.sendMessage(CB_DELETESTRING, 0, 0);
			}

			this._items.clear();
		}

		this.selectedIndex = -1;
	}

	@property public final ComboBoxItem selectedItem()
	{
		if(this.created)
		{
			return this._items[this._selectedIndex];
		}
		else
		{
			int idx = this.selectedIndex;

			if(this._items)
			{
				return this._items[idx];
			}
		}

		return null;
	}

	@property public override bool focused()
	{
		if(this.created)
		{
			return GetFocus() == cast(HWND)this.sendMessage(CBEM_GETCOMBOCONTROL, 0, 0);
		}

		return false;
	}

	@property public final ImageList imageList()
	{
		return this._imgList;
	}

	@property public void imageList(ImageList imgList)
	{
		this._imgList = imgList;

		if(this.created)
		{
			this.sendMessage(CBEM_SETIMAGELIST, 0, cast(LPARAM)this._imgList.handle);
		}
	}

	@property public final void dropDownStyle(DropDownStyles dds)
	{
		if(dds !is this._oldDDStyle)
		{
			this.setStyle(this._oldDDStyle, false); //Rimuovo il vecchio
			this.setStyle(dds, true); //Aggiungo il nuovo

			this._oldDDStyle = dds;
		}
	}

	@property public final ComboBoxItem[] items()
	{
		if(this._items)
		{
			return this._items.get();
		}

		return null;
	}

	private ComboBoxItem insertItem(ComboBoxItem cbi)
	{
		COMBOBOXEXITEMW cbei;

		cbei.mask = CBEIF_TEXT | CBEIF_IMAGE | CBEIF_SELECTEDIMAGE | CBEIF_LPARAM;
		cbei.iItem = -1;
		cbei.iImage = cbi.imageIndex;
		cbei.iSelectedImage = cbi.imageIndex;
		cbei.pszText = toUTFz!(wchar*)(cbi.text);
		cbei.lParam = winCast!(LPARAM)(cbi);

		this.sendMessage(CBEM_INSERTITEMW, 0, cast(LPARAM)&cbei);
		cbi.comboBox = this;
		return cbi;
	}

	protected void onItemChanged(EventArgs e)
	{
		this.itemChanged(this, e);
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		// Use Original Paint Routine, the double buffered one causes some issues

		ccp.superclassName = WC_COMBOBOXEX;
		ccp.className = WC_DCOMBOBOX;

		this.setStyle(WS_CLIPCHILDREN | WS_CLIPSIBLINGS, true); //Clip child ComboBox
		//this.setStyle(CBS_NOINTEGRALHEIGHT, true);

		super.createControlParams(ccp);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		if(this._imgList)
		{
			this.sendMessage(CBEM_SETIMAGELIST, 0, cast(LPARAM)this._imgList.handle);
		}

		if(this._items)
		{
			foreach(ComboBoxItem cbi; this._items)
			{
				this.insertItem(cbi);
			}
		}

		if(this._selectedIndex != -1)
		{
			this.sendMessage(CB_SETCURSEL, this._selectedIndex, 0);
		}

		super.onHandleCreated(e);
	}

	protected override void onReflectedMessage(ref Message m)
	{
		if(m.msg == WM_COMMAND && HIWORD(m.wParam) == CBN_SELCHANGE)
		{
			this._selectedIndex = this.sendMessage(CB_GETCURSEL, 0, 0);
			this.onItemChanged(EventArgs.empty);
		}

		super.onReflectedMessage(m);
	}

	protected override void wndProc(ref Message m)
	{
		switch(m.msg)
		{
			case WM_COMMAND:
			{
				/* Retrieve focus notifications from child ComboBox  */
				if(HIWORD(m.wParam) == CBN_SETFOCUS || HIWORD(m.wParam) == CBN_KILLFOCUS)
				{
					this.onFocusChanged(EventArgs.empty);
				}

				super.wndProc(m);
			}
			break;

			case WM_SETFOCUS, WM_KILLFOCUS:
				this.originalWndProc(m); //Don't send focusChanged event here!
				break;

			default:
				super.wndProc(m);
				break;
		}
	}
}
