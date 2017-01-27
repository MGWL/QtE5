/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module gradient_rect;

import dgui.all;

class MainForm: Form
{
	public this()
	{
		this.text = "GDI: Gradient Fill Rect";
		this.size = Size(400, 200);
		this.startPosition = FormStartPosition.centerScreen;
	}

	protected override void onPaint(PaintEventArgs e)
	{
		Canvas c = e.canvas;

		c.fillRectGradient(Rect(nullPoint, this.size), SystemColors.blue, SystemColors.green, GradientFillRectMode.vertical);
		super.onPaint(e);
	}
}

int main(string[] args)
{
	return Application.run(new MainForm()); // Start the application
}
