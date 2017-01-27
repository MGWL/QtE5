/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module gradient_triangle;

import dgui.all;

class MainForm: Form
{
	public this()
	{
		this.text = "GDI: Gradient Fill Triangle";
		this.size = Size(360, 190);
		this.startPosition = FormStartPosition.centerScreen;
		this.formBorderStyle = FormBorderStyle.fixedDialog;
		this.maximizeBox = false;
		this.minimizeBox = false;
	}

	protected override void onPaint(PaintEventArgs e)
	{
		Canvas c = e.canvas;

		c.fillTriangleGradient(10, 180, 180, 10, 350, 180, SystemColors.blue, SystemColors.green, SystemColors.red);
		super.onPaint(e);
	}
}

int main(string[] args)
{
	return Application.run(new MainForm()); // Start the application
}
