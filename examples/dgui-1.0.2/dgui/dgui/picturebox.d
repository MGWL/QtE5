/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.picturebox;

import dgui.core.controls.control;
import dgui.canvas;

enum SizeMode
{
	normal = 0,
	autoSize = 1,
}

class PictureBox: Control
{
	private SizeMode _sm = SizeMode.normal;
	private Image _img;

	public override void dispose()
	{
		if(this._img)
		{
			this._img.dispose();
			this._img = null;
		}

		super.dispose();
	}

	alias @property Control.bounds bounds;

	@property public override void bounds(Rect r)
	{
		if(this._img && this._sm is SizeMode.autoSize)
		{
			// Ignora 'r.size' e usa la dimensione dell'immagine
			Size sz = r.size;
			super.bounds = Rect(r.x, r.y, sz.width, sz.height);

		}
		else
		{
			super.bounds = r;
		}
	}

	@property public final SizeMode sizeMode()
	{
		return this._sm;
	}

	@property public final void sizeMode(SizeMode sm)
	{
		this._sm = sm;

		if(this.created)
		{
			this.redraw();
		}
	}

	@property public final Image image()
	{
		return this._img;
	}

	@property public final void image(Image img)
	{
		if(this._img)
		{
			this._img.dispose(); // Destroy the previous image
		}

		this._img = img;

		if(this.created)
		{
			this.redraw();
		}
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		ccp.className  = WC_DPICTUREBOX;
		ccp.defaultCursor = SystemCursors.arrow;
		ccp.classStyle = ClassStyles.parentDC;

		super.createControlParams(ccp);
	}

	protected override void onPaint(PaintEventArgs e)
	{
		if(this._img)
		{
			Canvas c = e.canvas;

			switch(this._sm)
			{
				case SizeMode.autoSize:
					c.drawImage(this._img, Rect(nullPoint, this.size));
					break;

				default:
					c.drawImage(this._img, 0, 0);
					break;
			}
		}

		super.onPaint(e);
	}
}
