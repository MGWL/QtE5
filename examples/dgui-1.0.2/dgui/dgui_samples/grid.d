/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module splitter;

import std.string;
import dgui.all;
import dgui.layout.gridpanel;

class MainForm: Form
{
	private GridPanel _gridPanel;
	private Collection!(Label) _labels;
	private Collection!(TextBox) _textboxes;
	private Collection!(Button) _buttons;

	public this()
	{
		this.text = "DGui SplitPanel Example";
		this.size = Size(400, 400);
		this.maximizeBox = false;
		this.minimizeBox = false;
		this.startPosition = FormStartPosition.centerScreen;
		this.formBorderStyle = FormBorderStyle.fixedDialog;

		this._gridPanel = new GridPanel();
		this._gridPanel.dock = DockStyle.fill;
		this._gridPanel.parent = this;

		this._labels = new Collection!(Label);
		this._textboxes = new Collection!(TextBox);
		this._buttons = new Collection!(Button);

		// Add 10 rows
		for(int i = 0; i < 10; i++)
		{
			RowPart row = this._gridPanel.addRow();
			row.marginTop = 4; // Set 4 pixel of empty space (top part) for this row
			row.height = 23; //If you don't set the row's height, it will be used the component's height (if set)

			string s = format("Row No. %d", i);

			/* COLUMN 1 */
			Label lbl = new Label();
			lbl.text = s;
			lbl.alignment = TextAlignment.middle | TextAlignment.left;

			ColumnPart col1 = row.addColumn(lbl); //Add the component in the column 1, this parameter can be 'null' if you want to add an empty space
			col1.width = 60; //If you don't set the column's width, it will be used the component's width (if set)
			col1.marginLeft = 4; // Set 4 pixel of empty space (left part) for column 1

			/* COLUMN 2 */
			TextBox tbx = new TextBox();
			tbx.text = s;

			ColumnPart col2 = row.addColumn(tbx); //Add the component in the column 2, this parameter can be 'null' if you want to add an empty space
			col2.width = 80; //If you don't set the column's width, it will be used the component's width (if set)
			col2.marginRight = 4; // Set 4 pixel of empty space (right part) for column 2

			/* COLUMN 3 */
			Button btn = new Button();
			btn.text = "Click Me!";
			btn.tag = tbx; // Save the TextBox (just for this sample, is not needed for GridPanel)
			btn.click.attach(&this.onBtnClick);

			ColumnPart col3 = row.addColumn(btn); //Add the component in the column 2, this parameter can be 'null' if you want to add an empty space
			col3.width = 60; //If you don't set the column's width, it will be used the component's width (if set)

			this._labels.add(lbl);
			this._textboxes.add(tbx);
			this._buttons.add(btn);
		}
	}

	private void onBtnClick(Control sender, EventArgs e)
	{
		TextBox tbx = sender.tag!(TextBox);
		MsgBox.show("Click Event", tbx.text);
	}
}

int main(string[] args)
{
	return Application.run(new MainForm());
}
