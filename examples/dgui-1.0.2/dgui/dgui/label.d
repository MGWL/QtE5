/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.label;

import std.string;
import dgui.core.controls.control;

enum LabelDrawMode: ubyte
{
	normal = 0,
	ownerDraw = 1,
}

class Label: Control
{
	private LabelDrawMode _drawMode = LabelDrawMode.normal;
	private TextAlignment _textAlign = TextAlignment.middle | TextAlignment.left;

	alias @property Control.text text;
	private bool _multiLine = false;

	@property public override void text(string s)
	{
		super.text = s;

		this._multiLine = false;

		foreach(char ch; s)
		{
			if(ch == '\n' || ch == '\r')
			{
				this._multiLine = true;
				break;
			}
		}

		if(this.created)
		{
			this.invalidate();
		}
	}

	@property public final LabelDrawMode drawMode()
	{
		return this._drawMode;
	}

	@property public final void drawMode(LabelDrawMode ldm)
	{
		this._drawMode = ldm;
	}

	@property public final TextAlignment alignment()
	{
		return this._textAlign;
	}

	@property public final void alignment(TextAlignment ta)
	{
		this._textAlign = ta;

		if(this.created)
		{
			this.invalidate();
		}
	}

	protected override void createControlParams(ref CreateControlParams ccp)
	{
		ccp.className = WC_DLABEL;
		ccp.classStyle = ClassStyles.hRedraw | ClassStyles.vRedraw;

		super.createControlParams(ccp);
	}

	protected override void onPaint(PaintEventArgs e)
	{
		super.onPaint(e);

		if(this._drawMode is LabelDrawMode.normal)
		{
			Canvas c = e.canvas;
			Rect r = Rect(nullPoint, this.clientSize);

			scope TextFormat tf = new TextFormat(this._multiLine ? TextFormatFlags.wordBreak : TextFormatFlags.singleLine);
			tf.alignment = this._textAlign;

			scope SolidBrush sb = new SolidBrush(this.backColor);
			c.fillRectangle(sb, r);
			c.drawText(this.text, r, this.foreColor, this.font, tf);
		}
	}
}
