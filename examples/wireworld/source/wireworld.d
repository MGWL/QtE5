module wireworld;

private
{
	import qte5;
}

// элементы мира WireWorld
final enum Element : byte 
{
	Empty,        // пустое поле
	Head,         // голова электрона
	Tail,         // хвост электрона
	Conductor     // проводник
}

// мир WireWorld
class WireWorld(size_t WORLD_WIDTH, size_t WORLD_HEIGHT)
{
	private
	{
		// мир
		byte[WORLD_HEIGHT][WORLD_WIDTH] world;
		// копия мира
		byte[WORLD_HEIGHT][WORLD_WIDTH] reserved;

		// резервное копирование мира
		void backupWorld()
		{
			for (int i = 0; i < WORLD_WIDTH; i++)
			{
				for (int j = 0; j < WORLD_HEIGHT; j++)
				{
					reserved[i][j] = world[i][j];
				}
			}
		}
	}

	this()
	{
		
	}

	// извлечение элемента
	auto opIndex(size_t i, size_t j)
	{
		return world[i][j];
	}

	// присвоение элемента
	void opIndexAssign(Element element, size_t i, size_t j)
	{
		world[i][j] = element;
	}

	// одно поколение клеточного автомата
	auto execute()
	{
		// скопировать мир
		backupWorld;

		// трансформация ячейки с проводником
		void transformConductorCell(int i, int j)
		{
			auto up = ((j + 1) >= WORLD_HEIGHT) ? WORLD_HEIGHT - 1 : j + 1;
			auto down = ((j - 1) < 0) ? 0 : j - 1;
			auto right = ((i + 1) >= WORLD_WIDTH) ?  WORLD_WIDTH - 1 : i + 1;
			auto left = ((i - 1) < 0) ? 0 : i - 1;

			auto counter = 0;

			if (reserved[i][up] == Element.Head)
			{
				counter++;
			}

			if (reserved[i][down] == Element.Head)
			{
				counter++;
			}

			if (reserved[left][j] == Element.Head)
			{
				counter++;
			}

			if (reserved[right][j] == Element.Head)
			{
				counter++;
			}

			if (reserved[left][up] == Element.Head)
			{
				counter++;
			}

			if (reserved[left][down] == Element.Head)
			{
				counter++;
			}

			if (reserved[right][up] == Element.Head)
			{
				counter++;
			}

			if (reserved[right][down] == Element.Head)
			{
				counter++;
			}

			if ((counter == 1) || (counter == 2))
			{
				world[i][j] = Element.Head;
			}
			else
			{
				world[i][j] = Element.Conductor;
			}
		}

		for (int i = 0; i < WORLD_WIDTH; i++)
		{
			for (int j = 0; j < WORLD_HEIGHT; j++)
			{
				auto currentCell = reserved[i][j];
				
				final switch (currentCell) with (Element)
				{
					case Empty:
						world[i][j] = Empty;
						break;
					case Head:
						world[i][j] = Tail;
						break;
					case Tail:
						world[i][j] = Conductor;
						break;
					case Conductor:
						transformConductorCell(i, j);
						break;
				}
			}
		}
	}

	// очистка всего мира
	void clearWorld()
	{
		world = typeof(world).init;
	}

	// нарисовать мир с помощью QtE5
	void drawWorld(QPainter painter, int cellWidth, int cellHeight)
	{

	    QColor BLACK = new QColor;
	    QColor BLUE = new QColor;
	    QColor RED = new QColor;
	    QColor YELLOW = new QColor;
	    QColor GRAY = new QColor;

	    BLACK.setRgb(0, 0, 0, 230);
		BLUE.setRgb(0, 0, 255, 230);
		RED.setRgb(255, 0, 0, 230);
		YELLOW.setRgb(255, 255, 0, 230);
		GRAY.setRgb(133, 133, 133, 230);

		QPen pen = new QPen;
		pen.setColor(GRAY);

	    for (int i = 0; i < WORLD_WIDTH; i++)
		{
			for (int j = 0; j < WORLD_HEIGHT; j++)
			{
				auto currentCell = world[i][j];

				// рисование прямоугольника
				QRect rect = new QRect;
	    		rect.setRect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);

				final switch (currentCell) with (Element)
				{
					case Empty:
						painter.fillRect(rect, BLACK);			
						break;
					case Head:
						painter.fillRect(rect, BLUE);
						break;
					case Tail:
						painter.fillRect(rect, RED);
						break;
					case Conductor:
						painter.fillRect(rect, YELLOW);
						break;
				}

				painter.setPen(pen);
				painter.drawRect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
			}
		}
	}
}