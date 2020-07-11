/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module toolbar_32_x_32;

import dgui.all;

class MainForm: Form
{
	private ImageList _imgList;
	private ToolBar _tbrToolbar;

	public this()
	{
		this.text = "ToolBar 32 x 32";
		this.size = Size(400, 200);
		this.startPosition = FormStartPosition.centerScreen;

		this._imgList = new ImageList();
		this._imgList.size = Size(32, 32); //The ImageList's size set the ToolBar's size.
		this._imgList.addImage(SystemIcons.question);
		this._imgList.addImage(SystemIcons.warning);

		this._tbrToolbar = new ToolBar();
		this._tbrToolbar.imageList = this._imgList;
		this._tbrToolbar.parent = this;

		this._tbrToolbar.addButton(0);
		this._tbrToolbar.addButton(1);
		this._tbrToolbar.addButton(0);
		this._tbrToolbar.addButton(1);
		this._tbrToolbar.addSeparator();
		this._tbrToolbar.addButton(0, false);
		this._tbrToolbar.addButton(1, false);
	}
}

int main(string[] args)
{
	return Application.run(new MainForm()); // Start the application
}
