

PVector oneEnd, otherEnd;
PVector oneEndDir, otherEndDir;
float backgroundTint;
PVector tempOneEndDir, tempOtherEndDir;

int speedCount, speedCountLimit;
float speedFactor;

void setupBouncingBalls( Peggy peg )
{
    float speed = 2.f;
    oneEnd = new PVector( 2, 2 );
    oneEndDir = new PVector( random( -speed, speed ), random( -speed, speed ) );
    tempOneEndDir = new PVector();
    tempOneEndDir.set( oneEndDir );
    otherEnd = new PVector( 10, 12 );
    otherEndDir = new PVector( random( -speed, speed ), random( -speed, speed ) );
    tempOtherEndDir = new PVector();
    tempOtherEndDir.set( otherEndDir );
    
    speedCount = 0;
    speedCountLimit = 10;
    speedFactor = 1.0;
}

void moveEnd( PVector p, PVector dir )
{
  p.add( dir );
  
  if ( p.x <= 0 || p.x >= 24 )
  {
    dir.x *= -1.f;
    //backgroundTint = 0.5;
  }
  
  if ( p.y <= 0 || p.y >= 24 )
  {
    dir.y *= -1.f;
    //backgroundTint = 0.5;
  }
 
}

void updateBouncingBalls( Peggy peg )
{
    if (backgroundTint > 0.f )
    {
      backgroundTint -= 0.2f;
    }
    
    speedCount += 1;
    //println( "speedCount = " + speedCount + " speedFactor = " + speedFactor );
    if ( speedCountLimit == speedCount )
    {
      speedCount = 0;
      speedFactor = random( 0.01, 2.0 );
      speedCountLimit = int( random( 10, 50 ) );
      oneEndDir.normalize();
      oneEndDir.mult( speedFactor );
      otherEndDir.normalize();
      otherEndDir.mult( speedFactor );
    }
    
    moveEnd( oneEnd, oneEndDir );
    moveEnd( otherEnd, otherEndDir );
    
    peg.canvas.noStroke();
    peg.canvas.fill( backgroundTint, 0.2 );
    peg.canvas.rect( 0, 0, 25, 25 );
    //peg.canvas.background(backgroundTint);
    peg.canvas.stroke( 1.0 );
    peg.canvas.fill( 255.0 );
    //canvas.ellipse( (oneEnd.x + otherEnd.x)/2.f, (oneEnd.y + otherEnd.y)/2.f, abs(oneEnd.x-otherEnd.x), abs(oneEnd.y-otherEnd.y));
    peg.canvas.ellipse( oneEnd.x, oneEnd.y, 0.5, 0.5 );
    peg.canvas.ellipse( otherEnd.x, otherEnd.y, 0.7, 0.7 );
    // peg.canvas.line( oneEnd.x, oneEnd.y, otherEnd.x, otherEnd.y );
}
