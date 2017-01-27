import dgui.all;
import dgui.layout.panel;
import std.stdio;
import core.sys.windows.windows; 
import dgui.core.events.keyeventargs;

class MyTextBox: TextBox {
	/*
	protected override void onTextChanged(EventArgs e)	{
		writeln("onTextChanged e = ", e);
		this.textChanged(this, e);
	}
	protected override void onClick(EventArgs e)	{
		writeln("onClick e = ", e);
		this.click(this, e);
	}

	protected override void onKeyDown(KeyEventArgs e)	{
		writeln("onKeyDown e = ", e);
		this.keyDown(this, e);
	}
	*/
	protected override void onKeyUp(KeyEventArgs e)	{
		if(e.keyCode == Keys.enter) {
			(cast(MainForm)parent).setTextStatusBar(text);
		}
	}
	protected override void onKeyChar(KeyCharEventArgs e)	{
		this.keyChar(this, e);
	}


}

class MainForm: Form {
		RichTextBox _rtfText;
		Label _lblHead;
		Label _lblInfo;
		Button _btnIgnore;
		Button _btnQuit;
		Panel  pnlKn, pnlKn2, pnlKn3;
		StatusBar sb;
		MyTextBox		tb;

		public this()	{
			this.text = "Пример моего приложения ...";
			this.size = Size(700, 520);
			// this.controlBox = false;
			this.startPosition = FormStartPosition.centerParent;
			// this.formBorderStyle = FormBorderStyle.fixedDialog;

			this._lblHead = new Label();
			this._lblHead.alignment = TextAlignment.middle | TextAlignment.left;
			this._lblHead.foreColor = Color(0xB4, 0x00, 0x00);
			this._lblHead.backColor = Color(0x00, 0xB4, 0x00);
			this._lblHead.dock = DockStyle.top;
			this._lblHead.height = 50;
			this._lblHead.text = "Привет мужики!";
			this._lblHead.font = new Font("Batang", 12);
			writeln(this._lblHead.font.height);
			// this._lblHead.font
			this._lblHead.parent = this;

			this._lblInfo = new Label();
			this._lblInfo.alignment = TextAlignment.middle | TextAlignment.left;
			this._lblInfo.dock = DockStyle.top;
			this._lblInfo.backColor = Color(0x00, 114, 0x00);
			this._lblInfo.height = 20;
			this._lblInfo.text = "info";
			this._lblInfo.parent = this;

			this._rtfText = new RichTextBox();
			// this._rtfText.backColor = Color(0xCB, 0xB9, 0x43);
			this._rtfText.borderStyle = BorderStyle.fixed3d;
			this._rtfText.dock = DockStyle.height;
			this._rtfText.height = 0;
			// this._rtfText.backColor = SystemColors.colorButtonFace;
			this._rtfText.scrollBars = true;
			// this._rtfText.readOnly = true;
			this._rtfText.text = "Пробная строка";
			this._rtfText.parent = this;
			
			
			sb = new StatusBar();
			this.sb.height = 10;
			this.sb.dock = DockStyle.bottom;
			this.sb.parent = this;
			this.sb.text("Привет");
			
			pnlKn3 = new Panel();
			this.pnlKn3.height = 10;
			this.pnlKn3.dock = DockStyle.bottom;
			this.pnlKn3.parent = this;

			pnlKn2 = new Panel();
			this.pnlKn2.height = 24;
			this.pnlKn2.dock = DockStyle.bottom;
			this.pnlKn2.parent = this;
			
			this._btnQuit = new Button();
			// this._btnQuit.bounds = Rect(310, 164, 80, 23);
			this._btnQuit.dock = DockStyle.right;
			this._btnQuit.height = 20;
			this._btnQuit.width = 100;
			// this._btnQuit.margin = 10;
			// this._btnQuit.width = 20;
			// this._btnQuit.dialogResult = DialogResult.abort;
			this._btnQuit.text = "Quit";
			this._btnQuit.parent = pnlKn2;

			this._btnIgnore = new Button();
			// this._btnIgnore.bounds = Rect(225, 164, 80, 23);
			// this._btnIgnore.dialogResult = DialogResult.ignore;
			this._btnIgnore.height = 30;
			this._btnIgnore.width = 150;
			// this._btnIgnore.margin = 10;
			this._btnIgnore.dock = DockStyle.right;
			this._btnIgnore.text = "Проверка действия";
			this._btnIgnore.click.attach(&onBtnOkClick); //Attach the click event with the selected procedure
			this._btnIgnore.parent = pnlKn2;
			
			pnlKn = new Panel();
			this.pnlKn.height = 10;
			this.pnlKn.dock = DockStyle.bottom;
			this.pnlKn.parent = this;
			// ___________ LineEdit _________________________
			tb = new MyTextBox();
			tb.dock = DockStyle.bottom;
			tb.height = 12;
			tb.parent = this;
			// ______________________________________________
		}
	public void setTextStatusBar(string s) {
		sb.text = s;
	}
	protected override void onClosing(CancelFormEventArgs e)	{
		// MessageBoxA(null, "--3--", null, MB_OK); 
		// e.cancel(true);
		writeln("e.cancel = ", e.cancel);
		writeln("e.empty = ", e.empty);
		super.onClosing(e);
		// this.closing(this, e);
	}
	protected override void onClose(EventArgs e) {
		// MessageBoxA(null, "--4--", null, MB_OK); 
	//	MsgBox.show("Заголовок...", "Текст в окне\nПример!", MsgBoxIcons.information);
		super.onClose(e);
	}
	private void onBtnOkClick(Control sender, EventArgs e)	{
		// MsgBox.show("OnClick", "Button.onClick()");
		_rtfText.font = new Font("Batang", 12);
		sb.backColor = Color(0xCB, 0xB9, 0x43);
		sb.text("Ещё одна проверка ...");
	}
	protected override void onKeyDown(KeyEventArgs e)	{
		writeln("MainForm -- onKeyDown e = ", e);
		this.keyDown(this, e);
	}
	protected override void onKeyUp(KeyEventArgs e)	{
		writeln("MainForm -- onKeyUp e = ", e);
		this.keyDown(this, e);
	}

}


void main() {
	int app = Application.run(new MainForm());
}

        // MessageBoxA(null, "CHello.~this()", null, MB_OK); 
