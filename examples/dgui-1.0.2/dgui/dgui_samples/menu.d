/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module menu;

import dgui.all;

class MainForm: Form
{
	private MenuBar _mainMenu;

	public this()
	{
		this.text = "DGui Menu Test";
		this.size = Size(500, 400);
		this.startPosition = FormStartPosition.centerScreen; // Set Form Position

		this._mainMenu = new MenuBar();
		MenuItem m1 = this._mainMenu.addItem("Menu 1"); //Menu 1
		MenuItem m2 = this._mainMenu.addItem("Menu 2"); //Menu 2
		MenuItem m3 = this._mainMenu.addItem("Menu 3"); //Menu 3

		MenuItem m1_1 = m1.addItem("Menu 1.1"); //Add new menu item in Menu 1
		MenuItem m1_2 = m1.addItem("Menu 1.2"); //Add new menu item in Menu 1
		MenuItem m1_3 = m1.addItem("Menu 1.3"); //Add new menu item in Menu 1

		/* Menu 2 Creation */
		m2.addItem("Menu 2.1");
		m2.addItem("Menu 2.2", false); // Disable this menu item
		m2.addSeparator(); //Add a separator
		m2.addItem("Menu 2.3");

		/* Creazione Menu 3 */
		m3.addItem("Menu 3.1");
		m3.addItem("Menu 3.2");
		m3.addSeparator(); //Add a separator
		m3.addItem("Menu 3.3", false); // Disable this menu item

		m1_1.click.attach(&this.onMenu1_1Click); // Link the click event
		m1_2.click.attach(&this.onMenu1_2Click); // Link the click event
		m1_3.click.attach(&this.onMenu1_3Click); // Link the click event

		this.menu = this._mainMenu; // Associate the menu previously created with the form
	}

	private void onMenu1_1Click(MenuItem sender, EventArgs e)
	{
		MsgBox.show("Menu 1 -> 1.1 Click", "Menu 1 -> 1");
	}

	private void onMenu1_2Click(MenuItem sender, EventArgs e)
	{
		MsgBox.show("Menu 1 -> 1.2 Click", "Menu 1 -> 1");
	}

	private void onMenu1_3Click(MenuItem sender, EventArgs e)
	{
		MsgBox.show("Menu 1 -> 1.3 Click", "Menu 1 -> 1");
	}
}

int main(string[] args)
{
	return Application.run(new MainForm()); // Start the application
}
