/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.treeview;

import std.utf: toUTFz;
import dgui.core.utils;
import dgui.core.controls.subclassedcontrol;
import dgui.imagelist;

enum NodeInsertMode
{
	head = TVI_FIRST,
	tail = TVI_LAST,
}

class TreeNode: Handle!(HTREEITEM)//, IDisposable
{
	private Collection!(TreeNode) _nodes;
	private TreeView _owner;
	private TreeNode _parent;
	private NodeInsertMode _nim;
	private bool _lazyNode;
	private bool _childNodesCreated;
	private string _text;
	private int _imgIndex;
	private int _selImgIndex;

	mixin tagProperty;

	package this(TreeView owner, string txt, int imgIndex, int selImgIndex, NodeInsertMode nim)
	{
		this._childNodesCreated = false;
		this._owner = owner;
		this._text = txt;
		this._imgIndex = imgIndex;
		this._selImgIndex = selImgIndex;
		this._nim = nim;
	}

	package this(TreeView owner, TreeNode parent, string txt, int imgIndex, int selImgIndex, NodeInsertMode nim)
	{
		this._parent = parent;
		this(owner, txt, imgIndex, selImgIndex, nim);
	}

	/*
	public ~this()
	{
		this.dispose();
	}

	public void dispose()
	{
		if(this._nodes)
		{
			this._nodes.clear();
		}

		this._owner = null;
		this._handle = null;
		this._parent = null;
	}
	*/

	public final TreeNode addNode(string txt, int imgIndex = -1, int selImgIndex = -1, NodeInsertMode nim = NodeInsertMode.tail)
	{
		if(!this._nodes)
		{
			this._nodes = new Collection!(TreeNode)();
		}

		TreeNode tn = new TreeNode(this._owner, this, txt, imgIndex, selImgIndex == -1 ? imgIndex : selImgIndex, nim);
		this._nodes.add(tn);

		if(this._owner && this._owner.created)
		{
			TreeView.createTreeNode(tn);
		}

		return tn;
	}

	public final TreeNode addNode(string txt, int imgIndex, NodeInsertMode nim)
	{
		return this.addNode(txt, imgIndex, imgIndex, nim);
	}

	public final TreeNode addNode(string txt, NodeInsertMode nim)
	{
		return this.addNode(txt, -1, -1, nim);
	}

	public final void removeNode(TreeNode node)
	{
		if(this.created)
		{
			TreeView.removeTreeNode(node);
		}

		if(this._nodes)
		{
			this._nodes.remove(node);
		}
	}

	public final void removeNode(int idx)
	{
		TreeNode node = null;

		if(this._nodes)
		{
			node = this._nodes[idx];
		}

		if(node)
		{
			TreeView.removeTreeNode(node);
		}
	}

	public final void remove()
	{
		TreeView.removeTreeNode(this);
	}

	@property package NodeInsertMode insertMode()
	{
		return this._nim;
	}

	@property public final TreeView treeView()
	{
		return this._owner;
	}

	@property public final TreeNode parent()
	{
		return this._parent;
	}

	@property public final bool selected()
	{
		if(this._owner && this._owner.created)
		{
			TVITEMW tvi = void;

			tvi.mask = TVIF_STATE | TVIF_HANDLE;
			tvi.hItem = this._handle;
			tvi.stateMask = TVIS_SELECTED;

			this._owner.sendMessage(TVM_GETITEMW, 0, cast(LPARAM)&tvi);
			return (tvi.state & TVIS_SELECTED) ? true : false;
		}

		return false;
	}

	@property public final bool lazyNode()
	{
		return this._lazyNode;
	}

	@property public final void lazyNode(bool b)
	{
		this._lazyNode = b;
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
			TVITEMW tvi = void;

			tvi.mask = TVIF_TEXT | TVIF_HANDLE;
			tvi.hItem = this._handle;
			tvi.pszText = toUTFz!(wchar*)(txt);
			this._owner.sendMessage(TVM_SETITEMW, 0, cast(LPARAM)&tvi);
		}
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
			TVITEMW tvi = void;

			tvi.mask = TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_HANDLE;
			tvi.hItem = this._handle;
			this._owner.sendMessage(TVM_GETITEMW, 0, cast(LPARAM)&tvi);

			if(tvi.iSelectedImage == tvi.iImage) //Non e' mai stata assegnata veramente, quindi SelectedImage = Image.
			{
				tvi.iSelectedImage = idx;
			}

			tvi.iImage = idx;
			this._owner.sendMessage(TVM_SETITEMW, 0, cast(LPARAM)&tvi);
		}
	}

	@property public final int selectedImageIndex()
	{
		return this._selImgIndex;
	}

	@property public final void selectedImageIndex(int idx)
	{
		this._selImgIndex = idx;

		if(this._owner && this._owner.created)
		{
			TVITEMW tvi = void;

			tvi.mask = TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_HANDLE;
			tvi.hItem = this._handle;
			this._owner.sendMessage(TVM_GETITEMW, 0, cast(LPARAM)&tvi);

			idx == -1 ? (tvi.iSelectedImage = tvi.iImage) : (tvi.iSelectedImage = idx);
			this._owner.sendMessage(TVM_SETITEMW, 0, cast(LPARAM)&tvi);
		}
	}

	@property public final TreeNode[] nodes()
	{
		if(this._nodes)
		{
			return this._nodes.get();
		}

		return null;
	}

	public final void collapse()
	{
		if(this._owner && this._owner.createCanvas() && this.created)
		{
			this._owner.sendMessage(TVM_EXPAND, TVE_COLLAPSE, cast(LPARAM)this._handle);
		}
	}

	public final void expand()
	{
		if(this._owner && this._owner.createCanvas() && this.created)
		{
			this._owner.sendMessage(TVM_EXPAND, TVE_EXPAND, cast(LPARAM)this._handle);
		}
	}

	@property public final bool hasNodes()
	{
		return (this._nodes ? true : false);
	}

	@property public final int index()
	{
		if(this._parent && this._parent.hasNodes)
		{
			int i = 0;

			foreach(TreeNode node; this._parent.nodes)
			{
				if(node is this)
				{
					return i;
				}

				i++;
			}
		}

		return -1;
	}

	@property public override HTREEITEM handle()
	{
		return super.handle();
	}

	@property package void handle(HTREEITEM hTreeNode)
	{
		this._handle = hTreeNode;
	}

	package void doChildNodes()
	{
		if(this._nodes && !this._childNodesCreated)
		{
			foreach(TreeNode tn; this._nodes)
			{
				if(!tn.created)
				{
					TreeView.createTreeNode(tn);
				}
			}

			this._childNodesCreated = true;
		}
	}
}

public alias ItemChangedEventArgs!(TreeNode) TreeNodeChangedEventArgs;
public alias ItemEventArgs!(TreeNode) TreeNodeEventArgs;
public alias CancelEventArgs!(TreeNode) CancelTreeNodeEventArgs;

class TreeView: SubclassedControl
{
	public Event!(Control, CancelTreeNodeEventArgs) selectedNodeChanging;
	public Event!(Control, TreeNodeChangedEventArgs) selectedNodeChanged;
	public Event!(Control, CancelTreeNodeEventArgs) treeNodeExpanding;
	public Event!(Control, TreeNodeEventArgs) treeNodeExpanded;
	public Event!(Control, TreeNodeEventArgs) treeNodeCollapsed;

	private Collection!(TreeNode) _nodes;
	private ImageList _imgList;
	private TreeNode _selectedNode;

	public final void clear()
	{
		this.sendMessage(TVM_DELETEITEM, 0, cast(LPARAM)TVI_ROOT);

		if(this._nodes)
		{
			this._nodes.clear();
		}
	}

	public final TreeNode addNode(string txt, int imgIndex = -1, int selImgIndex = -1, NodeInsertMode nim = NodeInsertMode.tail)
	{
		if(!this._nodes)
		{
			this._nodes = new Collection!(TreeNode)();
		}

		TreeNode tn = new TreeNode(this, txt, imgIndex, selImgIndex == -1 ? imgIndex : selImgIndex, nim);
		this._nodes.add(tn);

		if(this.created)
		{
			TreeView.createTreeNode(tn);
		}

		return tn;
	}

	public final TreeNode addNode(string txt, int imgIndex, NodeInsertMode nim)
	{
		return this.addNode(txt, imgIndex, imgIndex, nim);
	}

	public final TreeNode addNode(string txt, NodeInsertMode nim)
	{
		return this.addNode(txt, -1, -1, nim);
	}

	public final void removeNode(TreeNode node)
	{
		if(this.created)
		{
			TreeView.removeTreeNode(node);
		}

		if(this._nodes)
		{
			this._nodes.remove(node);
		}
	}

	public final void removeNode(int idx)
	{
		TreeNode node = null;

		if(this._nodes)
		{
			node = this._nodes[idx];
		}

		if(node)
		{
			this.removeTreeNode(node);
		}
	}

	@property public final Collection!(TreeNode) nodes()
	{
		return this._nodes;
	}

	@property public final ImageList imageList()
	{
		return this._imgList;
	}

	@property public final void imageList(ImageList imgList)
	{
		this._imgList = imgList;

		if(this.created)
		{
			this.sendMessage(TVM_SETIMAGELIST, TVSIL_NORMAL, cast(LPARAM)this._imgList.handle);
		}
	}

	@property public final TreeNode selectedNode()
	{
		return this._selectedNode;
	}

	@property public final void selectedNode(TreeNode node)
	{
		this._selectedNode = node;

		if(this.created)
		{
			this.sendMessage(TVM_SELECTITEM, TVGN_FIRSTVISIBLE, cast(LPARAM)node.handle);
		}
	}

	public final void collapse()
	{
		if(this.created)
		{
			this.sendMessage(TVM_EXPAND, TVE_COLLAPSE, cast(LPARAM)TVI_ROOT);
		}
	}

	public final void expand()
	{
		if(this.created)
		{
			this.sendMessage(TVM_EXPAND, TVE_EXPAND, cast(LPARAM)TVI_ROOT);
		}
	}

	package static void createTreeNode(TreeNode node)
	{
		TVINSERTSTRUCTW tvis;

		tvis.hParent = (node.parent ? node.parent.handle : cast(HTREEITEM)TVI_ROOT);
		tvis.hInsertAfter = cast(HTREEITEM)node.insertMode;
		tvis.item.mask = TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_CHILDREN | TVIF_TEXT | TVIF_PARAM;
		tvis.item.cChildren = I_CHILDRENCALLBACK;
		tvis.item.iImage = node.imageIndex;
		tvis.item.iSelectedImage = node.selectedImageIndex;
		tvis.item.pszText  = toUTFz!(wchar*)(node.text);
		tvis.item.lParam = winCast!(LPARAM)(node);

		TreeView tvw = node.treeView;
		node.handle = cast(HTREEITEM)tvw.sendMessage(TVM_INSERTITEMW, 0, cast(LPARAM)&tvis);

		/*
		  *  Performance Killer: simulate a virtual tree view instead
		  *
		if(node.hasNodes)
		{
			node.doChildNodes();
		}
		*/

		//tvw.redraw();
	}

	package static void removeTreeNode(TreeNode node)
	{
		node.treeView.sendMessage(TVM_DELETEITEM, 0, cast(LPARAM)node.handle);
		//node.dispose();
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		ccp.superclassName = WC_TREEVIEW;
		ccp.className = WC_DTREEVIEW;
		this.setStyle(TVS_LINESATROOT | TVS_HASLINES | TVS_HASBUTTONS, true);
		ccp.defaultBackColor = SystemColors.colorWindow;

		// Tree view is Double buffered in DGui
		TreeView.setBit(this._cBits, ControlBits.doubleBuffered, true);
		super.createControlParams(ccp);
	}

	protected override void onHandleCreated(EventArgs e)
	{
		if(this._imgList)
		{
			this.sendMessage(TVM_SETIMAGELIST, TVSIL_NORMAL, cast(LPARAM)this._imgList.handle);
		}

		if(this._nodes)
		{
			foreach(TreeNode tn; this._nodes)
			{
				TreeView.createTreeNode(tn);
			}
		}

		super.onHandleCreated(e);
	}

	protected override void onReflectedMessage(ref Message m)
	{
		if(m.msg == WM_NOTIFY)
		{
			NMTREEVIEWW* pNotifyTreeView = cast(NMTREEVIEWW*)m.lParam;

			switch(pNotifyTreeView.hdr.code)
			{
				case TVN_GETDISPINFOW:
				{
					NMTVDISPINFOW* pTvDispInfo = cast(NMTVDISPINFOW*)m.lParam;
					TreeNode node = winCast!(TreeNode)(pTvDispInfo.item.lParam);

					if(node.lazyNode || node.nodes) //Is a Lazy Node, or has childNodes sooner or later a child node will be added
					{
						pTvDispInfo.item.cChildren = node.nodes ? node.nodes.length : 1;
					}
					else
					{
						pTvDispInfo.item.cChildren = 0;
					}
				}
				break;

				case TVN_ITEMEXPANDINGW:
				{
					TreeNode node = winCast!(TreeNode)(pNotifyTreeView.itemNew.lParam);
					scope CancelTreeNodeEventArgs e = new CancelTreeNodeEventArgs(node);

					this.onTreeNodeExpanding(e); //Allow the user to add nodes if e.cancel is 'false'

					if(!e.cancel && pNotifyTreeView.action & TVE_EXPAND)
					{
						node.doChildNodes();
					}

					m.result = e.cancel;
				}
				break;

				case TVN_ITEMEXPANDEDW:
				{
					TreeNode node = winCast!(TreeNode)(pNotifyTreeView.itemNew.lParam);
					scope TreeNodeEventArgs e = new TreeNodeEventArgs(node);

					if(pNotifyTreeView.action & TVE_EXPAND)
					{
						this.onTreeNodeExpanded(e);
					}
					else if(pNotifyTreeView.action & TVE_COLLAPSE)
					{
						this.onTreeNodeCollapsed(e);
					}
				}
				break;

				case TVN_SELCHANGINGW:
				{
					TreeNode node = winCast!(TreeNode)(pNotifyTreeView.itemNew.lParam);
					scope CancelTreeNodeEventArgs e = new CancelTreeNodeEventArgs(node);
					this.onSelectedNodeChanging(e);
					m.result = e.cancel;
				}
				break;

				case TVN_SELCHANGEDW:
				{
					TreeNode oldNode = winCast!(TreeNode)(pNotifyTreeView.itemOld.lParam);
					TreeNode newNode = winCast!(TreeNode)(pNotifyTreeView.itemNew.lParam);

					this._selectedNode = newNode;
					scope TreeNodeChangedEventArgs e = new TreeNodeChangedEventArgs(oldNode, newNode);
					this.onSelectedNodeChanged(e);
				}
				break;

				case NM_RCLICK: //Trigger a WM_CONTEXMENU Message (Fixes the double click/context menu bug, probably it's a windows bug).
					Message sm = Message(this._handle, WM_CONTEXTMENU, 0, 0);
					this.wndProc(sm);
					m.result = sm.result;
					break;

				default:
					super.onReflectedMessage(m);
					break;
			}
		}
	}

	protected void onTreeNodeExpanding(CancelTreeNodeEventArgs e)
	{
		this.treeNodeExpanding(this, e);
	}

	protected void onTreeNodeExpanded(TreeNodeEventArgs e)
	{
		this.treeNodeExpanded(this, e);
	}

	protected void onTreeNodeCollapsed(TreeNodeEventArgs e)
	{
		this.treeNodeCollapsed(this, e);
	}

	protected void onSelectedNodeChanging(CancelTreeNodeEventArgs e)
	{
		this.selectedNodeChanging(this, e);
	}

	protected void onSelectedNodeChanged(TreeNodeChangedEventArgs e)
	{
		this.selectedNodeChanged(this, e);
	}
}
