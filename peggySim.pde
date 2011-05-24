import processing.serial.*;

Serial peggyPort;

float now = 0.0;
float stepSize = 0.01;

Peggy peggy;
ArraySounder arraySounder;


void setup()
{
  size( 600, 600, JAVA2D);
  peggy = new Peggy( width, height );
  peggyPort = new Serial( this, "/dev/cu.usbserial-FTEST5ED", 115200 );    // CHANGE_HERE

  //arraySounder = new ArraySounder( peggy.nXLeds, peggy.nYLeds );
  
  frameRate( 20 );
  
  colorMode( RGB, 1.0 );
  background( 0.0, 0.0, 0.0 );
  smooth();
    
}

void draw()
{
  now = now + stepSize;
  peggy.update();
  peggy.draw(); 
}

void keyPressed()
{
  if ( key == '1' )
  {
    peggy.currentMode = PeggyMode.BouncingBalls;
  }
  else if ( key == '2' )
  {
    peggy.currentMode = PeggyMode.Fireworks;
  }
  else if ( key == '3' )
  {
    peggy.currentMode = PeggyMode.Cancer;
  }
  else if ( key == '4' )
  {
    peggy.currentMode = PeggyMode.Squares;
  }
  else if ( key == '5' )
  {
    peggy.currentMode = PeggyMode.BugTwo;
  }
  else if ( key == '6' )
  {
    peggy.currentMode = PeggyMode.Primes;
  }
  else if ( key == '7' )
  {
    peggy.currentMode = PeggyMode.Horticulture;
  }
  peggy.setup();
}
