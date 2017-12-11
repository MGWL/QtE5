module gui;

import qte5;

import wireworld;

// состояние мира
WireWorld!(200,85) wireWorld;

extern(C)
{
    void onTimerTick(MainForm* mainFormPointer) 
    {
        (*mainFormPointer).runTimer;
    }

     void onStartButton(MainForm* mainFormPointer) 
    {
        (*mainFormPointer).runStart;
    }

    void onStopButton(MainForm* mainFormPointer) 
    {
        (*mainFormPointer).runStop;
    }

    void onLoadButton(MainForm* mainFormPointer) 
    {
        (*mainFormPointer).runLoad;
    }
}

extern(C)
{
    void onDrawStep(QWireWorld* wireWorldPointer, void* eventPointer, void* painterPointer) 
    { 
        (*wireWorldPointer).runDraw(eventPointer, painterPointer);
    }
}

class QWireWorld : QWidget
{
    private
    {
        QWidget parent;
    }

    this(QWidget parent)
    {
        wireWorld = new WireWorld!(200,85);
        super(parent);
        this.parent = parent;
        setStyleSheet(`background : white`);
        setPaintEvent(&onDrawStep, aThis);
        
    }

    void runDraw(void* eventPointer, void* painterPointer)
    {
      
        QPainter painter = new QPainter('+', painterPointer);

        wireWorld.drawWorld(painter, 10, 10);
       
        painter.end;
    }
}
 
// псевдонимы под Qt'шные типы
alias WindowType = QtE.WindowType;

// основное окно
class MainForm : QWidget
{
    private
    {
        QVBoxLayout mainBox;
        QWireWorld box0;
        QPushButton button, button0, button1;
        QTimer timer;
        QAction action, action0, action1, action2;
    }

   
    this(QWidget parent, WindowType windowType) 
	{
		super(parent, windowType); 
		resize(700, 500);
		setWindowTitle("QWireWorld");

        mainBox = new QVBoxLayout(this);

        box0 = new QWireWorld(this);
        box0.saveThis(&box0);


       	button = new QPushButton("Load world", this);
        button0 = new QPushButton("Start", this);
        button1 = new QPushButton("Stop", this);
        
        timer = new QTimer(this);
        timer.setInterval(100); 

        action = new QAction(this, &onLoadButton, aThis);
        connects(button, "clicked()", action, "Slot()");

        action0 = new QAction(this, &onTimerTick, aThis);
        connects(timer, "timeout()", action0, "Slot()");

        action1 = new QAction(null, &onStartButton, aThis);
        action2 = new QAction(null, &onStopButton, aThis);
        
        connects(button0, "clicked()", action1, "Slot()");
        connects(button1, "clicked()", action2, "Slot()");
        connects(button0, "clicked()", timer, "start()");
        connects(button1, "clicked()", timer, "stop()");

        mainBox
            .addWidget(box0)
            .addWidget(button)
            .addWidget(button0)
            .addWidget(button1);

        setLayout(mainBox);
    }

    void runTimer()
    {
    	wireWorld.execute;
        box0.update;
    }

    void runStart()
    {
        button0.setEnabled(false);
        button1.setEnabled(true);
    }

    void runStop()
    {
        button0.setEnabled(true);
        button1.setEnabled(false);
    }

    void runLoad()
    {
    	import std.algorithm;
    	import std.file;
    	import std.range;
		import std.stdio;
		import std.string;

    	QFileDialog fileDialog = new QFileDialog('+', null);
        string filename = fileDialog.getOpenFileNameSt("Open WireWorld File", "", "*.csv *.txt");

        if (!filename.empty)
        {
        	
        	wireWorld.clearWorld;

        	auto formatCSVString(string s)
			{
				import std.algorithm;
				import std.string;

				string replaceByE(string s)
				{
					return (s == "") ? "e" : s;
				}

				return s
						.split(";")
						.map!(a => replaceByE(a))
						.join;
			}

        	auto content = (cast(string) std.file.read(filename))
        								.splitLines
        								.map!(a => formatCSVString(a))
        								.map!(a => toLower(a))
        								.array;



	        foreach (index, s; content)
	        {
	        	for (int i = 0; i < s.length; i++)
	        	{
	        		Element element;
	        		
	        		switch (s[i])
	        		{
	        			case 'e':
	        				element = Element.Empty;
	        				break;
	        			case 'h':
	        				element = Element.Head;
	        				break;
	        			case 't':
	        				element = Element.Tail;
	        				break;
	        			case 'c':
	        				element = Element.Conductor;
	        				break;
	        			default:
	        				break;
	        		}
	        		wireWorld[i, index] = element;
	        	}
	        }
        }
    }
}