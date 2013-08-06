/**
 * Spore 1 
 * by Mike Davis. 
 * 
 * A short program for alife experiments. Click in the window to restart.
 * Each cell is represented by a pixel on the display as well as an entry in
 * the array 'cells'. Each cell has a run() method, which performs actions
 * based on the cell's surroundings.  Cells run one at a time (to avoid conflicts
 * like wanting to move to the same space) and in random order.
 */

World w;
int numcells = 0;
int maxcells = 12*12;
Cell[] cells = new Cell[maxcells];
int spore_color;
// set lower for smoother animation, higher for faster simulation
int runs_per_loop = 100;
int black = 0;
PGraphics peggyCanvas;
float sporeTimer;
  
void setupSpore( Peggy peg )
{
  peggyCanvas = peg.canvas;
  peggyCanvas.beginDraw();
  peggyCanvas.background( 0 );
  peggyCanvas.endDraw();
  maxcells = int( random( 10, 50 ) );
  cells = new Cell[maxcells];
  w = new World();
  spore_color = 255;
  numcells = 0;
  seed();
  sporeTimer = random( 0.5, 5 );
}

void seed() 
{
  // Add cells at random places
  for (int i = 0; i < maxcells; i++)
  {
    int cX = (int)random(peggyCanvas.width);
    int cY = (int)random(peggyCanvas.height);
    if (w.getpix(cX, cY) == black)
    {
      w.setpix(cX, cY, spore_color);
      cells[numcells] = new Cell(cX, cY);
      numcells++;
    }
  }
}

void updateSpore( Peggy peg )
{
  colorMode(RGB, 255);
  sporeTimer -= 1.f / frameRate;
  
  if ( sporeTimer < 0 )
  {
    setupSpore( peg );
  }
  
  // Run cells in random order
  for (int i = 0; i < runs_per_loop; i++) 
  {
    int selected = min((int)random(numcells), numcells - 1);
    //println( "numcells: " + numcells + " selected: " + selected );
    cells[selected].run();
  }
}

class Cell
{
  int x, y;
  int age;
  Cell(int xin, int yin)
  {
    x = xin;
    y = yin;
    age = 0;
  }

    // Perform action based on surroundings
  void run()
  {
    // Fix cell coordinates
    while(x < 0) 
    {
      x+=peggyCanvas.width;
    }
    while(x > peggyCanvas.width - 1) 
    {
      x-=peggyCanvas.width;
    }
    while(y < 0) 
    {
      y+=peggyCanvas.height;
    }
    while(y > peggyCanvas.height - 1) 
    {
      y-=peggyCanvas.height;
    }
    
    // Cell instructions
    if (w.getpix(x + 1, y) == black) 
    {
      move(0, 1);
    } 
    else if (w.getpix(x, y - 1) != black && w.getpix(x, y + 1) != black) 
    {
      move((int)random(9) - 4, (int)random(9) - 4);
    }
    
    ++age;
  }
  
  // Will move the cell (dx, dy) units if that space is empty
  void move(int dx, int dy) 
  {
    if (w.getpix(x + dx, y + dy) == black) 
    {
      w.setpix(x + dx, y + dy, w.getpix(x, y) * random(0.65f, 1.4) );
      w.setpix(x, y, 0);
      x += dx;
      y += dy;
    }
  }
}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
class World
{
  void setpix(int x, int y, float c) 
  {
    while(x < 0) x+=peggyCanvas.width;
    while(x > peggyCanvas.width - 1) x-=peggyCanvas.width;
    while(y < 0) y+=peggyCanvas.height;
    while(y > peggyCanvas.height - 1) y-=peggyCanvas.height;
    peggyCanvas.set(x, y, color(c,c,c) );
  }
  
  int getpix(int x, int y) 
  {
    while(x < 0) x+=peggyCanvas.width;
    while(x > peggyCanvas.width - 1) x-=peggyCanvas.width;
    while(y < 0) y+=peggyCanvas.height;
    while(y > peggyCanvas.height - 1) y-=peggyCanvas.height;
    return int(red(peggyCanvas.get(x, y)));
  }
}

