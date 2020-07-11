/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.listview;

import std.utf: toUTF8;
public import dgui.core.controls.ownerdrawcontrol;
import dgui.core.utils;
import dgui.imagelist;

enum ColumnTextAlign: int
{
	left = LVCFMT_LEFT,
	center = LVCFMT_CENTER,
	right = LVCFMT_RIGHT,
}

enum ViewStyle: uint
{
	list = LVS_LIST,
	report = LVS_REPORT,
	largeIcon = LVS_ICON,
	smallIcon = LVS_SMALLICON,
}

enum ListViewBits: ubyte
{
	none 			   = 0,
	gridLines  	   = 1,
	fullRowSelect    = 2,
	checkBoxes 	   = 4,
}

class ListViewItem
{
	private Collection!(ListViewItem) _subItems;
	private bool _checked = false;
	private ListViewItem _parentItem;
	private ListView _owner;
	private string _text;
	private int _imgIdx;

	mixin tagProperty;

	package this(ListView owner, string txt, int imgIdx, bool check)
	{
		this._checked = check;
		this._imgIdx = imgIdx;
		this._owner = owner;
		this._text = txt;
	}

	package this(ListView owner, ListViewItem parentItem, string txt, int imgIdx, bool check)
	{
		this._parentItem = parentItem;
		this(owner, txt, imgIdx, check);
	}

	@property public final int index()
	{
		if(this._owner)
		{
			foreach(int i, ListViewItem lvi; this._owner.items)
			{
				if(lvi is (this._parentItem ? this._parentItem : this))
				{
					return i;
				}
			}
		}

		return -1;
	}

	@property public final int imageIndex()
	{
		return this._imgIdx;
	}

	@property public final void imageIndex(int imgIdx)
	{
		if(this._parentItem)
		{
			return;
		}

		this._imgIdx = imgIdx;

		if(this._owner && this._owner.created)
		{
			LVITEMW lvi;

			lvi.mask = LVIF_IMAGE;
			lvi.iItem = this.index;
			lvi.iSubItem = 0;
			lvi.iImage = imgIdx;

			this._owner.sendMessage(LVM_SETITEMW, 0, cast(LPARAM)&lvi);
		}
	}

	@property public final string text()
	{
		return this._text;
	}

	@property public final void text(string s)
	{
		this._text = s;

		if(this._owner && this._owner.created)
		{
			LVITEMW lvi;

			lvi.mask = LVIF_TEXT;
			lvi.iItem = this.index;
			lvi.iSubItem = !this._parentItem ? 0 : this.subitemIndex;
			lvi.pszText = toUTFz!(wchar*)(s);

			this._owner.sendMessage(LVM_SETITEMW, 0, cast(LPARAM)&lvi);
		}
	}

	@property package bool internalChecked()
	{
		return this._checked;
	}

	@property public final bool checked()
	{
		if(this._owner && this._owner.created)
		{
			return cast(bool)((this._owner.sendMessage(LVM_GETITEMSTATE, this.index, LVIS_STATEIMAGEMASK) >> 12) - 1);
		}

		return this._checked;
	}

	@property public final void checked(bool b)
	{
		if(this._parentItem)
		{
			return;
		}

		this._checked = b;

		if(this._owner && this._owner.created)
		{
			LVITEMW lvi;

			lvi.mask = LVIF_STATE;
			lvi.stateMask = LVIS_STATEIMAGEMASK;
			lvi.state = cast(LPARAM)(b ? 2 : 1) << 12; //Checked State

			this._owner.sendMessage(LVM_SETITEMSTATE, this.index, cast(LPARAM)&lvi);
		}
	}

	public final void addSubItem(string txt)
	{
		if(this._parentItem) //E' un subitem, non fare niente.
		{
			return;
		}

		if(!this._subItems)
		{
			this._subItems = new Collection!(ListViewItem)();
		}

		ListViewItem lvi = new ListViewItem(this._owner, this, txt, -1, false);
		this._subItems.add(lvi);

		if(this._owner && this._owner.created)
		{
			ListView.insertItem(lvi, true);
		}
	}

	@property public final ListViewItem[] subItems()
	{
		if(this._subItems)
		{
			return this._subItems.get();
		}

		return null;
	}

	@property public final ListView listView()
	{
		return this._owner;
	}

	@property package ListViewItem parentItem()
	{
		return this._parentItem;
	}

	package void removeSubItem(int idx)
	{
		this._subItems.removeAt(idx);
	}

	@property package int subitemIndex()
	{
		if(this._parentItem is this)
		{
			return 0; //Se è l'item principale ritorna 0.
		}
		else if(!this._parentItem.subItems)
		{
			return 1; //E' il primo subitem
		}
		else if(this._owner && this._parentItem)
		{
			int i = 0;

			foreach(ListViewItem lvi; this._parentItem.subItems)
			{
				if(lvi is this)
				{
					return i + 1;
				}

				i++;
			}
		}

		return -1; //Non dovrebbe mai restituire -1
	}
}

class ListViewColumn
{
	private ColumnTextAlign _cta;
	private ListView _owner;
	private string _text;
	private int _width;

	package this(ListView owner, string txt, int w, ColumnTextAlign cta)
	{
		this._owner = owner;
		this._text = txt;
		this._width = w;
		this._cta = cta;
	}

	@property public int index()
	{
		if(this._owner)
		{
			int i = 0;

			foreach(ListViewColumn lvc; this._owner.columns)
			{
				if(lvc is this)
				{
					return i;
				}

				i++;
			}
		}

		return -1;
	}

	@property public string text()
	{
		return this._text;
	}

	@property public int width()
	{
		return this._width;
	}

	@property public ColumnTextAlign textAlign()
	{
		return this._cta;
	}

	@property public ListView listView()
	{
		return this._owner;
	}
}

public alias ItemEventArgs!(ListViewItem) ListViewItemCheckedEventArgs;

class ListView: OwnerDrawControl
{
	public Event!(Control, EventArgs) itemChanged;
	public Event!(Control, ListViewItemCheckedEventArgs) itemChecked;

	private Collection!(ListViewColumn) _columns;
	private Collection!(ListViewItem) _items;
	private ListViewBits _lBits = ListViewBits.none;
	private ListViewItem _selectedItem;
	private ImageList _imgList;

	@property public final ImageList imageList()
	{
		return this._imgList;
	}

	@property public final void imageList(ImageList imgList)
	{
		 this._imgList = imgList;

		if(this.created)
		{
			this.sendMessage(LVM_SETIMAGELIST, LVSIL_NORMAL, cast(LPARAM)imgList.handle);
			this.sendMessage(LVM_SETIMAGELIST, LVSIL_SMALL, cast(LPARAM)imgList.handle);
		}
	}

	@property public final ViewStyle viewStyle()
	{
		if(this.getStyle() & ViewStyle.largeIcon)
		{
			return ViewStyle.largeIcon;
		}
		else if(this.getStyle() & ViewStyle.smallIcon)
		{
			return ViewStyle.smallIcon;
		}
		else if(this.getStyle() & ViewStyle.list)
		{
			return ViewStyle.list;
		}
		else if(this.getStyle() & ViewStyle.report)
		{
			return ViewStyle.report;
		}

		assert(false, "Unknwown ListView Style");
	}

	@property public final void viewStyle(ViewStyle vs)
	{
		/* Remove flickering in Report Mode */
		ListView.setBit(this._cBits, ControlBits.doubleBuffered, vs is ViewStyle.report);

		this.setStyle(vs, true);
	}

	@property public final bool fullRowSelect()
	{
		return cast(bool)(this._lBits & ListViewBits.fullRowSelect);
	}

	@property public final void fullRowSelect(bool b)
	{
		this._lBits |= ListViewBits.fullRowSelect;

		if(this.created)
		{
			this.sendMessage(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_FULLROWSELECT, b ? LVS_EX_FULLROWSELECT : 0);
		}
	}

	@property public final bool gridLines()
	{
		return cast(bool)(this._lBits & ListViewBits.gridLines);
	}

	@property public final void gridLines(bool b)
	{
		this._lBits |= ListViewBits.gridLines;

		if(this.created)
		{
			this.sendMessage(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_GRIDLINES, b ? LVS_EX_GRIDLINES : 0);
		}
	}

	@property public final bool checkBoxes()
	{
		return cast(bool)(this._lBits & ListViewBits.checkBoxes);
	}

	@property public final void checkBoxes(bool b)
	{
		this._lBits |= ListViewBits.checkBoxes;

		if(this.created)
		{
			this.sendMessage(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_CHECKBOXES, b ? LVS_EX_CHECKBOXES : 0);
		}
	}

	@property public final ListViewItem selectedItem()
	{
		return this._selectedItem;
	}

	public final ListViewColumn addColumn(string txt, int w, ColumnTextAlign cta = ColumnTextAlign.left)
	{
		if(!this._columns)
		{
			this._columns = new Collection!(ListViewColumn)();
		}

		ListViewColumn lvc = new ListViewColumn(this, txt, w, cta);
		this._columns.add(lvc);

		if(this.created)
		{
			ListView.insertColumn(lvc);
		}

		return lvc;
	}

	public final void removeColumn(int idx)
	{
		this._columns.removeAt(idx);

		/*
		 * Rimuovo tutti gli items nella colonna rimossa
		 */

		if(this._items)
		{
			if(idx)
			{
				foreach(ListViewItem lvi; this._items)
				{
					lvi.removeSubItem(idx - 1); //Subitems iniziano da 0 nelle DGui e da 1 su Windows.
				}
			}
			else
			{
				//TODO: Gestire caso "Rimozione colonna 0".
			}
		}

		if(this.created)
		{
			this.sendMessage(LVM_DELETECOLUMN, idx, 0);
		}
	}

	public final ListViewItem addItem(string txt, int imgIdx = -1, bool checked = false)
	{
		if(!this._items)
		{
			this._items = new Collection!(ListViewItem)();
		}

		ListViewItem lvi = new ListViewItem(this, txt, imgIdx, checked);
		this._items.add(lvi);

		if(this.created)
		{
			ListView.insertItem(lvi);
		}

		return lvi;
	}

	public final void removeItem(int idx)
	{
		if(this._items)
		{
			this._items.removeAt(idx);
		}

		if(this.created)
		{
			this.sendMessage(LVM_DELETEITEM, idx, 0);
		}
	}

	public final void clear()
	{
		if(this._items)
		{
			this._items.clear();
		}

		if(this.created)
		{
			this.sendMessage(LVM_DELETEALLITEMS, 0, 0);
		}
	}

	@property public final Collection!(ListViewItem) items()
	{
		return this._items;
	}

	@property public final Collection!(ListViewColumn) columns()
	{
		return this._columns;
	}

	package static void insertItem(ListViewItem item, bool subitem = false)
	{
		/*
		 * Item: Item (or SubItem) to insert.
		 * Subitem = Is a SubItem?
		 */

		int idx = item.index;
		LVITEMW lvi;

		lvi.mask = LVIF_TEXT | (!subitem ? (LVIF_IMAGE | LVIF_STATE | LVIF_PARAM) : 0);
		lvi.iImage = !subitem ? item.imageIndex : -1;
		lvi.iItem = !subitem ? idx : item.parentItem.index;
		lvi.iSubItem = !subitem ? 0 : item.subitemIndex; //ListView's subitem starts from 1 (0 is the main item).
		lvi.pszText = toUTFz!(wchar*)(item.text);
		lvi.lParam = winCast!(LPARAM)(item);

		item.listView.sendMessage(!subitem ? LVM_INSERTITEMW : LVM_SETITEMW, 0, cast(LPARAM)&lvi);

		if(!subitem)
		{
			if(item.listView.checkBoxes) //LVM_INSERTITEM doesn't handle CheckBoxes, use LVM_SETITEMSTATE
			{
				//Recycle the variable 'lvi'

				lvi.mask = LVIF_STATE;
				lvi.stateMask = LVIS_STATEIMAGEMASK;
				lvi.state = cast(LPARAM)(item.internalChecked ? 2 : 1) << 12; //Checked State
				item.listView.sendMessage(LVM_SETITEMSTATE, idx, cast(LPARAM)&lvi);
			}

			ListViewItem[] subItems = item.subItems;

			if(subItems)
			{
				foreach(ListViewItem slvi; subItems)
				{
					ListView.insertItem(slvi, true);
				}
			}
		}
	}

	private static void insertColumn(ListViewColumn col)
	{
		LVCOLUMNW lvc;

		lvc.mask =  LVCF_TEXT | LVCF_WIDTH | LVCF_FMT;
		lvc.cx = col.width;
		lvc.fmt = col.textAlign;
		lvc.pszText = toUTFz!(wchar*)(col.text);

		col.listView.sendMessage(LVM_INSERTCOLUMNW, col.listView._columns.length, cast(LPARAM)&lvc);
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		this.setStyle(LVS_ALIGNLEFT | LVS_ALIGNTOP | LVS_AUTOARRANGE | LVS_SHAREIMAGELISTS, true);

		/* WS_CLIPSIBLINGS | WS_CLIPCHILDREN: There is a SysHeader Component inside a list view in Report Mode */
		if(this.getStyle() & ViewStyle.report)
		{
			this.setStyle(WS_CLIPSIBLINGS | WS_CLIPCHILDREN, true);
		}

		ccp.superclassName = WC_LISTVIEW;
		ccp.className = WC_DLISTVIEW;
		ccp.defaultBackColor = SystemColors.colorWindow;

		switch(this._drawMode)
		{
			case OwnerDrawMode.fixed:
				this.setStyle(LVS_OWNERDRAWFIXED, true);
				break;

			case OwnerDrawMode.variable:
				assert(false, "ListView: Owner Draw Variable Style not allowed");

			default:
				break;
		}

		//ListView.setBit(this._cBits, ControlBits.ORIGINAL_PAINT, true);
		super.createControlParams(ccp);
	}

	protected override void onReflectedMessage(ref Message m)
	{
		switch(m.msg)
		{
			case WM_NOTIFY:
			{
				NMLISTVIEW* pNotify = cast(NMLISTVIEW*)m.lParam;

				if(pNotify && pNotify.iItem != -1)
				{
					switch(pNotify.hdr.code)
					{
						case LVN_ITEMCHANGED:
						{
							if(pNotify.uChanged & LVIF_STATE)
							{
								uint changedState = pNotify.uNewState ^ pNotify.uOldState;

								if(pNotify.uNewState & LVIS_SELECTED)
								{
									this._selectedItem = this._items[pNotify.iItem];
									this.onSelectedItemChanged(EventArgs.empty);
								}

								if((changedState & 0x2000) || (changedState & 0x1000)) /* IF Checked || Unchecked THEN */
								{
									scope ListViewItemCheckedEventArgs e = new ListViewItemCheckedEventArgs(this._items[pNotify.iItem]);
									this.onItemChecked(e);
								}
							}
						}
						break;

						default:
							break;
					}
				}
			}
			break;

			default:
				break;
		}

		super.onReflectedMessage(m);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		if(this._lBits & ListViewBits.gridLines)
		{
			this.sendMessage(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_GRIDLINES, LVS_EX_GRIDLINES);
		}

		if(this._lBits & ListViewBits.fullRowSelect)
		{
			this.sendMessage(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_FULLROWSELECT, LVS_EX_FULLROWSELECT);
		}

		if(this._lBits & ListViewBits.checkBoxes)
		{
			this.sendMessage(LVM_SETEXTENDEDLISTVIEWSTYLE, LVS_EX_CHECKBOXES, LVS_EX_CHECKBOXES);
		}

		if(this._imgList)
		{
			this.sendMessage(LVM_SETIMAGELIST, LVSIL_NORMAL, cast(LPARAM)this._imgList.handle);
			this.sendMessage(LVM_SETIMAGELIST, LVSIL_SMALL, cast(LPARAM)this._imgList.handle);
		}

		if(this.getStyle() & ViewStyle.report)
		{
			if(this._columns)
			{
				foreach(ListViewColumn lvc; this._columns)
				{
					ListView.insertColumn(lvc);
				}
			}

			/* Remove flickering in Report Mode */
			ListView.setBit(this._cBits, ControlBits.doubleBuffered, true);
		}

		if(this._items)
		{
			foreach(ListViewItem lvi; this._items)
			{
				ListView.insertItem(lvi);
			}
		}

		super.onHandleCreated(e);
	}

	protected void onSelectedItemChanged(EventArgs e)
	{
		this.itemChanged(this, e);
	}

	protected void onItemChecked(ListViewItemCheckedEventArgs e)
	{
		this.itemChecked(this, e);
	}
}
