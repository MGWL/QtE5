/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.menubar;

public import dgui.core.menu.abstractmenu;

class MenuBar: RootMenu
{
	public override void create()
	{
		this._handle = CreateMenu();
		super.create();
	}
}
