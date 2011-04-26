
boolean bEvens;

float   flipTimer;
float   flipLength;

float   rotation;
float   rotationRate;

float   changeTimer;
float   changeInterval;

int     rectSpacing;

float   backgroundPulse;
float   backgroundPulseRate;

void setupSquares( Peggy peg )
{
  bEvens = true;
  flipTimer = 0.f;
  flipLength = 0.1f;
  rotation = 0.f;
  rotationRate = PI/8;
  changeTimer = 0.f;
  changeInterval = 0.5f;
  rectSpacing = 4;
  backgroundPulse = 0.f;
  backgroundPulseRate = PI/4;
}

void updateSquares( Peggy peg )
{
  float dt = 1.f / frameRate;
  flipTimer += dt;
  rotation += dt * rotationRate;
  if ( rotation > TWO_PI )
  {
    rotation -= TWO_PI;
  }
  changeTimer += dt; 
  
  backgroundPulse += dt * backgroundPulseRate;
  if ( backgroundPulse > TWO_PI )
  {
    backgroundPulse -= TWO_PI;
  }
  
  peg.canvas.background( sin(backgroundPulse)*0.5 + 0.5f );
  //peg.canvas.noSmooth();
  peg.canvas.noFill();
  peg.canvas.stroke(1.0);
  peg.canvas.rectMode(RADIUS);
  peg.canvas.pushMatrix();
  peg.canvas.translate( 12.5f + sin(rotation) * 2.f, 12.5f + cos(rotation) * 2.f );
  peg.canvas.rotate( rotation );
  
  int i = bEvens ? 4 : 3;
  for( ; i <= peg.nXLeds; i+=rectSpacing )
  {
    peg.canvas.rect( 0, 0, i, i );
  }
  
  i = bEvens ? 4 : 3;
  peg.canvas.stroke(0);
  peg.canvas.rotate( -rotation * 2 );
  for( ; i <= peg.nXLeds; i+=rectSpacing )
  {
    peg.canvas.rect( 0, 0, i, i );
  }
  
  if ( flipTimer > flipLength )
  {
    bEvens = !bEvens;
    flipTimer = 0.f;
  }
  
  if ( changeTimer > changeInterval )
  {
    flipLength = random( 0.05f, 0.15f );
    rotationRate = random( PI, PI/4 );
    changeInterval = random( 0.2f, 0.5f );
    rectSpacing += 1;
    if ( rectSpacing > 8 )
    {
      rectSpacing = 4;
    }
    changeTimer = 0.f;
  }
  
  /*peggy.canvas.loadPixels();
  
  for ( int i2 = 0; i2 < peggy.nXLeds*peggy.nYLeds; i2++ )
  {
    brightArray[ i2 ] = brightness( peggy.canvas.pixels[ i2 ] );
  }
  */
  //arraySounder.setSpectrum( brightArray );
  
  peg.canvas.popMatrix();
}
