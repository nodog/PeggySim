static int nHistory = 99;

float currentMode;
int currentCount;
int currentWriteFrame, currentReadFrameOffset; 
color cancerArray[][];
float brightArray[];
float xPos, yPos;
float xMaxGrow, yMaxGrow;

void setupCancer( Peggy peggy )
{
  colorMode( HSB, 1.0 );
  currentCount = 0; 
  currentWriteFrame = 0; 
  currentReadFrameOffset = 0;
  cancerArray = new color[ nHistory ][ peggy.nXLeds*peggy.nYLeds ];
  brightArray = new float[ peggy.nXLeds*peggy.nYLeds ];
  currentMode = random( 0.0, 1.0 );

  for( int jY=0; jY<peggy.nYLeds; jY++ )
  {
    for( int jX=0; jX<peggy.nXLeds; jX++ )
    {
      float baseDotColor = random( 0.2, 0.7 );
      for( int jF=0; jF<nHistory; jF++ )
      {
        cancerArray[ jF ][ peggy.iGray( jX, jY ) ] 
            //= color( ( 1.0*( jF+jX+jY )/( 1.0*( nHistory + peggy.nXLeds + peggy.nYLeds ) ) % 1.0 ) );
            = color( ( ( 1.0*( nHistory - 1 - jF ) )/( 1.0*nHistory ) + baseDotColor ) % 1.0 );
            //= color( 0.5 );
      }
    }
  }
  
  xPos = peggy.nXLeds/2.0;
  yPos = peggy.nYLeds/2.0;
 
  xMaxGrow = random( 0.05, 0.25 );
  yMaxGrow = random( 0.05, 0.25 );
}

void updateCancer( Peggy peggy )
{
  currentCount += 1;
  currentWriteFrame = currentCount%nHistory;
  //println( "currentWriteFrame = " + currentWriteFrame + " currentReadFrameOffset = " + currentReadFrameOffset );

  float smallColorChange = random( 0.0, 0.01 ); 
  for( int jX=0; jX<peggy.nXLeds; jX++ )
  {
    for( int jY=0; jY<peggy.nXLeds; jY++ )
    {
      xPos = ( xPos + random( -1.0*xMaxGrow, xMaxGrow ) + 1.0*peggy.nXLeds ) % ( 1.0*peggy.nXLeds);
      yPos = ( yPos + random( -1.0*yMaxGrow, yMaxGrow ) + 1.0*peggy.nYLeds ) % ( 1.0*peggy.nYLeds);
      cancerArray[ currentWriteFrame ][ peggy.iGray( int( xPos ), int( yPos ) ) ] = color( random( 0.0, 0.02 ) );
      color oldValue;
      if ( 0.5 > currentMode )
      {
        oldValue = cancerArray[ currentWriteFrame ][ peggy.iGray( jX, jY ) ];
      }
      else
      {
        oldValue = cancerArray[ ( currentWriteFrame + nHistory - 1 ) % nHistory ][ peggy.iGray( jX, jY ) ];
      }
      cancerArray[ currentWriteFrame ][ peggy.iGray( jX, jY ) ] = oldValue + color( smallColorChange );
 
 
    }
  }


  peggy.canvas.loadPixels();

  if( currentCount < nHistory )
  {
     currentReadFrameOffset = 0;
  }
     else if ( random( 0.0, 1.0 ) < 0.1 )
  {
     currentReadFrameOffset = int( random( 0, nHistory - 1 ) );
  }
  arrayCopy( cancerArray[ ( currentWriteFrame + currentReadFrameOffset )%nHistory ], peggy.canvas.pixels );
 
  for ( int i = 0; i < peggy.nXLeds*peggy.nYLeds; i++ )
  {
    brightArray[ i ] = brightness( peggy.canvas.pixels[ i ] );
  }

  //arraySounder.setSpectrum( brightArray );   

  //for( int iFrame = nHistory - 1; iFrame > 0; iFrame-- )
  //{
  //  arrayCopy( cancerArray[ iFrame - 1 ], cancerArray[ iFrame ] ); 
  //}
   
  peggy.canvas.updatePixels();
}
