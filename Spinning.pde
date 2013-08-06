
float spinSpeed = 4.f;
float spinStep  = 0.f;
int   numDots   = 6;
float spinRad   = 3.f;

float spinRadOsc = 2.f;
float spinRadOscAmt = 5.f;
float spinRadOscStep = 0.f;

float spinRadOscMod = 0.1f;
float spinRadOscModAmt = 15.f;
float spinRadOscModStep = 0.f;

float numDotsOsc = 1.5f;
float numDotsOscAmt = 6;
float numDotsOscStep = 0.f;

float spinSpeedOsc = 0.1f;
float spinSpeedOscAmt = 30.f;
float spinSpeedOscStep = 0.f;

void setupSpinning( Peggy peg )
{
}

void updateSpinning( Peggy peg )
{
  spinSpeedOscStep += spinSpeedOsc * ( 1.f / frameRate );
  if ( spinSpeedOscStep > TWO_PI )
  {
    spinSpeedOscStep -= TWO_PI;
  }
  float spinSpeedMod = sin( spinSpeedOscStep ) * spinSpeedOscAmt + spinSpeedOscAmt;
  
  spinStep += (spinSpeed+spinSpeedMod) * (1.f / frameRate);
  if ( spinStep > TWO_PI )
  {
    spinStep -= TWO_PI;
  }
  
  spinRadOscModStep += spinRadOscMod * ( 1.f / frameRate );
  if ( spinRadOscModStep > TWO_PI )
  {
    spinRadOscModStep -= TWO_PI;
  }
  
  float radOscMod = sin( spinRadOscModStep ) * spinRadOscModAmt + spinRadOscModAmt;
  
  spinRadOscStep += (spinRadOsc+radOscMod) * (1.f / frameRate );
  if ( spinRadOscStep > TWO_PI )
  {
    spinRadOscStep -= TWO_PI;
  }
  
  numDotsOscStep += numDotsOsc * ( 1.f / frameRate );
  if ( numDotsOscStep > TWO_PI )
  {
    numDotsOscStep -= TWO_PI;
  }
  
  float radMod = sin( spinRadOscStep ) * spinRadOscAmt + spinRadOscAmt;
  int   dots   = numDots + (int)(sin( numDotsOscStep ) * numDotsOscAmt + numDotsOscAmt);
  
  peg.canvas.fill( 0, 0.5 );
  peg.canvas.noStroke();
  peg.canvas.rect( 0, 0, 25, 25 );
  
  for( int i = 0; i < dots; ++i )
  {
    float x = 12 + (spinRad+radMod)*sin( spinStep + i*(TWO_PI/dots) );
    float y = 12 + (spinRad+radMod)*cos( spinStep + i*(TWO_PI/dots) );
    peg.canvas.set( (int)x, (int)y, color(1) );
  }
 
}
