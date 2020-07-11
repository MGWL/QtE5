/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.contextmenu;

private import dgui.core.geometry;
public import dgui.core.menu.abstractmenu;

class ContextMenu: RootMenu
{
	public void popupMenu(HWND hWnd, Point pt)
	{
		if(!this.created)
		{
			this.create();
		}

		TrackPopupMenu(this._handle, TPM_LEFTALIGN, pt.x, pt.y, 0, hWnd, null);
	}

	public override void create()
	{
		this._handle = CreatePopupMenu();
		super.create();
	}
}
