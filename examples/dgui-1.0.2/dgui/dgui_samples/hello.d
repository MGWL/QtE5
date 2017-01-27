/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module hello;

import dgui.all;

class MainForm: Form
{
	public this()
	{
		this.text = "DGui Form";
		this.size = Size(500, 400);
		this.startPosition = FormStartPosition.centerScreen; // Set Form Position
	}
}

int main(string[] args)
{
	return Application.run(new MainForm()); // Start the application
}
