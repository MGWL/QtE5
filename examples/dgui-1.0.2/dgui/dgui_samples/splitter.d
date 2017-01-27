/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module splitter;

import std.string;
import dgui.all;
import dgui.layout.splitpanel;

class MainForm: Form
{
	private SplitPanel _spVPanel;
	private SplitPanel _spHPanel;
	private RichTextBox _rtbText;
	private RichTextBox _rtbText2;
	private TreeView _tvwTree;

	public this()
	{
		this.text = "DGui SplitPanel Example";
		this.size = Size(500, 500);
		this.startPosition = FormStartPosition.centerScreen;

		this._spVPanel = new SplitPanel();
		this._spVPanel.dock = DockStyle.fill;
		this._spVPanel.splitPosition = 200;
		this._spVPanel.splitOrientation = SplitOrientation.vertical; // Split Window vertically (this is the default option)
		this._spVPanel.parent = this;

		// Add another Splitter Panel in Panel1 of the Vertical Splitter Panel (aka. Right Panel)
		this._spHPanel = new SplitPanel();
		this._spHPanel.dock = DockStyle.fill;
		this._spHPanel.splitPosition = 300;
		this._spHPanel.splitOrientation = SplitOrientation.horizontal; // Split Window horizontally (this is the default option)
		this._spHPanel.parent = this._spVPanel.panel2;	// The parent of the Horizontal Splitter Panel is the left panel of the Vertical Splitter Panel

		// Add a TreeView in Panel1 of the Vertical Splitter Panel (aka. Left Panel)
		this._tvwTree = new TreeView();
		this._tvwTree.dock = DockStyle.fill;
		this._tvwTree.parent = this._spVPanel.panel1;

		for(int i = 0; i < 4; i++)
		{
			TreeNode node1 = this._tvwTree.addNode(format("Node %d", i));

			for(int j = 0; j < 5; j++)
			{
				node1.addNode(format("Node %d -> %d", i, j));
			}
		}

		// Add a RichTextBox in Panel1 of the Horizontal Splitter Panel (aka. Top Panel)
		this._rtbText = new RichTextBox();
		this._rtbText.dock = DockStyle.fill;
		this._rtbText.readOnly = true;
		this._rtbText.text = "This is a RichTextBox inside a Horizontal Splitter Panel (Top Panel)!";
		this._rtbText.parent = this._spHPanel.panel1; // The parent of the RichTextBox is the Top Panel of the Horizontal Splitter Panel

		// Add a RichTextBox in Panel2 of the Horizontal (aka. Bottom Panel)
		this._rtbText = new RichTextBox();
		this._rtbText.dock = DockStyle.fill;
		this._rtbText.readOnly = true;
		this._rtbText.text = "This is a RichTextBox inside a Horizontal Splitter Panel (Bottom Panel)!";
		this._rtbText.parent = this._spHPanel.panel2; // The parent of the RichTextBox is the Bottom Panel of the Horizontal Splitter Panel

	}
}

int main(string[] args)
{
	return Application.run(new MainForm());
}
