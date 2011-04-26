int nBalls;  // total balls on the screen

PVector[] ballPositions; 
PVector[] ballVelocities;
float[] ballRadii;
float[] ballRadiiVelocities;
float[] ballColors;

PVector oneEnd, otherEnd;
PVector oneEndDir, otherEndDir;
float backgroundTint;

float minRadius, maxRadius;

int speedCount, speedCountLimit;
float speedFactor;

void setupBouncingBalls( Peggy peg )
{
    nBalls = (int)random( 30, 269 );
    //nBalls = 1;
    ballPositions = new PVector[ nBalls ];
    ballVelocities = new PVector[ nBalls ];
    ballRadii = new float[ nBalls ];
    ballRadiiVelocities = new float[ nBalls ];
    ballColors = new float[ nBalls ];
    float speed = 2.f;
    minRadius = 0.3;
    maxRadius = random( 5.0 );
    for( int i = 0; i < nBalls; i++ )
    {
      ballPositions[ i ] = new PVector( (int)( random( peg.nXLeds - 2 ) + 1 ), (int)( random( peg.nYLeds - 1 ) + 1 ) );
      ballVelocities[ i ] = new PVector( random( -speed, speed ), random( -speed, speed ) );
      ballRadii[ i ] = random( minRadius, maxRadius );
      ballRadiiVelocities[ i ] = random( -speed/50.0, speed/50.0 );
      ballColors[ i ] = random( 0.05, 1.0 );
    }

    speedCount = 0;
    speedCountLimit = 10;
    speedFactor = 1.0;
}

void moveEnd( PVector p, PVector dir )
{
  p.add( dir );
  
  if ( p.x <= 0 || p.x >= ( peggy.nXLeds - 1 ) )
  {
    dir.x *= -1.f;
  }
  
  if ( p.y <= 0 || p.y >= ( peggy.nYLeds -1 ) )
  {
    dir.y *= -1.f;
  }
}

void moveRadius( float rad, float radVelocity )
{
  rad += radVelocity;
  
  if ( rad <= minRadius || rad >= maxRadius )
  {
    radVelocity *= -1.f;
  }
}

void updateBouncingBalls( Peggy peg )
{
    if (backgroundTint > 0.f )
    {
      backgroundTint -= 0.2f;
    }
    
    speedCount += 1;
    if ( speedCountLimit == speedCount )
    {
      speedCount = 0;
      speedFactor = random( 0.01, random( 0.01, 2.0 ) );
      speedCountLimit = int( random( 10, 50 ) );

      for( int i = 0; i < nBalls; i++ )
      {
        ballVelocities[ i ].normalize();
        ballVelocities[ i ]. mult( speedFactor );
      }
    }
    
    peg.canvas.noStroke();
    peg.canvas.fill( backgroundTint, 0.35 );
    peg.canvas.rect( 0, 0, 25, 25 );
    //peg.canvas.background(backgroundTint);
    peg.canvas.stroke( 1.0 );
    peg.canvas.fill( 255.0 );
    for( int i = 0; i < nBalls; i++ )
    {
      moveEnd( ballPositions[ i ], ballVelocities[ i ] );
      ballRadii[ i ] += ballRadiiVelocities[ i ];
  
      if ( ballRadii[ i ] <= minRadius || ballRadii[ i ] >= maxRadius )
      {
        ballRadiiVelocities[ i ] *= -1.f;
      }
      moveRadius( ballRadii[ i ], ballRadiiVelocities[ i ] );
      peg.canvas.fill( ballColors[ i ] );
      peg.canvas.stroke( ballColors[ i ] );

      peg.canvas.ellipse( ballPositions[ i ].x, ballPositions[ i ].y, ballRadii[ i ], ballRadii[ i ] );
    }
    //println( " radius 0 = " + ballRadii[ 0 ] );  
}
