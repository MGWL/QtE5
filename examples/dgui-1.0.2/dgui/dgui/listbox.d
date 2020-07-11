/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.listbox;

import std.utf: toUTFz;
public import dgui.core.controls.ownerdrawcontrol;
import dgui.core.utils;

class ListBox: OwnerDrawControl
{
	private static class StringItem
	{
		private string _str;

		public this(string s)
		{
			this._str = s;
		}

		public override string toString()
		{
			return this._str;
		}
	}

	public Event!(Control, EventArgs) itemChanged;

	private Collection!(Object) _items;
	private Object _selectedItem;
	private int _selectedIndex;

	public final int addItem(string s)
	{
		return this.addItem(new StringItem(s));
	}

	public final int addItem(Object obj)
	{
		if(!this._items)
		{
			this._items = new Collection!(Object)();
		}

		this._items.add(obj);

		if(this.created)
		{
			return this.createItem(obj);
		}

		return this._items.length - 1;
	}

	public final void removeItem(int idx)
	{
		if(this.created)
		{
			this.sendMessage(LB_DELETESTRING, idx, 0);
		}

		this._items.removeAt(idx);
	}

	@property public final int selectedIndex()
	{
		if(this.created)
		{
			return this.sendMessage(LB_GETCURSEL, 0, 0);
		}

		return this._selectedIndex;
	}

	@property public final void selectedIndex(int i)
	{
		this._selectedIndex = i;

		if(this.created)
		{
			this.sendMessage(LB_SETCURSEL, i, 0);
		}
	}

	@property public final Object selectedItem()
	{
		int idx = this.selectedIndex;

		if(this._items)
		{
			return this._items[idx];
		}

		return null;
	}

	@property public final string selectedString()
	{
		Object obj = this.selectedItem;
		return (obj ? obj.toString() : null);
	}

	@property public final Object[] items()
	{
		if(this._items)
		{
			return this._items.get();
		}

		return null;
	}

	private int createItem(Object obj)
	{
		return this.sendMessage(LB_ADDSTRING, 0, cast(LPARAM)toUTFz!(wchar*)(obj.toString()));
	}

	protected void onItemChanged(EventArgs e)
	{
		this.itemChanged(this, e);
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		/* LBN_SELCHANGE: This notification code is sent only by a list box that has the LBS_NOTIFY style (by MSDN) */
		this.setStyle(LBS_NOINTEGRALHEIGHT | LBS_NOTIFY, true);
		this.setExStyle(WS_EX_CLIENTEDGE, true);

		ccp.superclassName = WC_LISTBOX;
		ccp.className = WC_DLISTBOX;
		ccp.defaultBackColor = SystemColors.colorWindow;

		switch(this._drawMode)
		{
			case OwnerDrawMode.fixed:
				this.setStyle(LBS_OWNERDRAWFIXED, true);
				break;

			case OwnerDrawMode.variable:
				this.setStyle(LBS_OWNERDRAWVARIABLE, true);
				break;

			default:
				break;
		}

		super.createControlParams(ccp);
	}

	protected override void onReflectedMessage(ref Message m)
	{
		if(m.msg == WM_COMMAND && HIWORD(m.wParam) == LBN_SELCHANGE)
		{
			this._selectedIndex = this.sendMessage(LB_GETCURSEL, 0, 0);
			this.onItemChanged(EventArgs.empty);
		}

		super.onReflectedMessage(m);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		if(this._items)
		{
			foreach(Object obj; this._items)
			{
				this.createItem(obj);
			}
		}

		super.onHandleCreated(e);
	}
}
