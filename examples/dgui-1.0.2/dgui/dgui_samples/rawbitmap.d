/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module events;

import dgui.all;

class MainForm: Form
{
	private PictureBox _pict;
	private Bitmap _orgBmp;
	private Bitmap _bmp;

	public this()
	{
		this._orgBmp = Bitmap.fromFile("image.bmp"); //Load the bitmap from file (this is the original)
		this._bmp = Bitmap.fromFile("image.bmp"); //Load the bitmap from file (this one will be modified)

		this.text = "DGui Events";
		this.size = Size(300, 250);
		this.startPosition = FormStartPosition.centerScreen; // Set Form Position

		this._pict = new PictureBox();
		this._pict.sizeMode = SizeMode.autoSize; // Stretch the image
		this._pict.dock = DockStyle.fill; // Fill the whole form area
		this._pict.image = this._bmp;
		this._pict.parent = this;

		this.menu = new MenuBar();
		MenuItem mi = this.menu.addItem("Bitmap");

		MenuItem mOrgColors = mi.addItem("Original Colors");
		MenuItem mInvColors = mi.addItem("Invert Colors");
		MenuItem mGsColors = mi.addItem("Gray Scale");

		mOrgColors.click.attach(&this.onMenuOrgColorsClick);
		mInvColors.click.attach(&this.onMenuInvColorsClick);
		mGsColors.click.attach(&this.onMenuGsColorsClick);
	}

	private void onMenuOrgColorsClick(MenuItem sender, EventArgs e)
	{
		BitmapData bd;
		this._orgBmp.getData(bd); //Get the original data
		this._bmp.setData(bd); //Set the original bitmap data
		this._pict.invalidate(); // Tell at the PictureBox to redraw itself
	}

	private void onMenuInvColorsClick(MenuItem sender, EventArgs e)
	{
		BitmapData bd;
		this._bmp.getData(bd); //Get the original data

		for(int i = 0; i < bd.BitsCount; i++) // Invert Colors!
		{
			bd.bits[i].rgbRed = ~bd.bits[i].rgbRed;
			bd.bits[i].rgbGreen = ~bd.bits[i].rgbGreen;
			bd.bits[i].rgbBlue = ~bd.bits[i].rgbBlue;
		}

		this._bmp.setData(bd); //Set the original bitmap data
		this._pict.invalidate(); // Tell at the PictureBox to redraw itself
	}

	private void onMenuGsColorsClick(MenuItem sender, EventArgs e)
	{
		BitmapData bd;
		this._bmp.getData(bd); //Get the original data

		for(int i = 0; i < bd.BitsCount; i++) // Gray Scale!
		{
			ubyte mid = cast(ubyte)((bd.bits[i].rgbRed + bd.bits[i].rgbGreen + bd.bits[i].rgbBlue) / 3);

			bd.bits[i].rgbRed = mid;
			bd.bits[i].rgbGreen = mid;
			bd.bits[i].rgbBlue = mid;
		}

		this._bmp.setData(bd); //Set the original bitmap data
		this._pict.invalidate(); // Tell at the PictureBox to redraw itself
	}
}

int main(string[] args)
{
	return Application.run(new MainForm()); // Start the application
}
