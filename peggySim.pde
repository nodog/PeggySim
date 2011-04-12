float now = 0.0;
float stepSize = 0.01;

Peggy peggy;

void setup()
{
  size( 800, 800, JAVA2D);
  peggy = new Peggy( width, height );
  
  frameRate( 30 );
  
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
  peggy.setup();
}
