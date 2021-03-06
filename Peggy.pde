

class Peggy
{
  int nXLeds, nYLeds;
  float nXLedSize, nYLedSize;
  int nLevels;
  int whiteLedArray[];
  float grayValueArray[];
  float gray9ValueArray[];
  float grayRateArray[];
  int boardWidth, boardHeight;
  float nearlyZero;
  PGraphics canvas;
  
  
  byte [] peggyHeader = new byte[] 
      { (byte)0xde, (byte)0xad, (byte)0xbe,(byte)0xef,1,0 };
  byte [] peggyFrame = new byte[13*25];

  boolean SerialEnabled;      // Set to "false" until we have a successful connection.

  PeggyMode currentMode;
  
  Peggy( int boardWidth, int boardHeight )
  {
    nXLeds = 25;
    nYLeds = 25;
    nLevels = 16;
    this.boardWidth = boardWidth;
    this.boardHeight = boardHeight;
    nXLedSize = boardWidth/nXLeds;
    nYLedSize = boardHeight/nYLeds;
    whiteLedArray = new int[ nXLeds*nYLeds ];
    grayValueArray = new float[ nXLeds*nYLeds ];
    grayRateArray = new float[ nXLeds*nYLeds ];
    gray9ValueArray = new float[ nXLeds*nYLeds ];
    nearlyZero = 0.0001;
    

    //currentMode = PeggyMode.BouncingBalls;
    //currentMode = PeggyMode.Fireworks;
    //currentMode = PeggyMode.Cancer;
    //currentMode = PeggyMode.Squares;
    //currentMode = PeggyMode.Wavez;
    //currentMode = PeggyMode.randomMode();
    //currentMode = PeggyMode.Tesla;
    currentMode = PeggyMode.Spinning;
    
    backgroundTint = 0.f;
    canvas = createGraphics( nXLeds, nYLeds );
    canvas.colorMode( HSB, 1.0 );
    canvas.ellipseMode(CENTER);
    canvas.smooth();
    
    setup();
    //setupBouncingBalls( this );
    //setupFireworks( this );
    //setupCancer( this );
        
    for( int iY=0; iY<nYLeds; iY++ )
    {
      for( int iX=0; iX<nXLeds; iX++ )
      {
        whiteLedArray[ iGray( iX, iY ) ] = 0;
        grayValueArray[ iGray( iX, iY ) ] = 0.5;
        grayRateArray[ iGray( iX, iY ) ] = ( iX + 1 )*0.002 + ( iY + 1 )*0.004;
      }
    }
  }
  
  void setup()
  {
    setupSpore( this );
    setupBouncingBalls( this );
    setupFireworks( this );
    setupCancer( this );   
    setupSquares( this ); 
    //setupBugTwo( this );
    setupPrimes( this );
    setupHorticulture( this );
    setupTesla( this );
    setupWavez( this );
    setupSpinning( this );
  }
  
  // render a PImage to the Peggy by transmitting it serially.  
  // If it is not already sized to 25x25, this method will 
  // create a downsized version to send...
  void renderToPeggy() 
  {
    int idx = 0;
   // iterate over the image, pull out pixels and 
    // build an array to serialize to the peggy
    for ( int iY = 0; iY < nYLeds; iY++ )
    {
      byte val = 0;
      for ( int iX=0; iX < 25; iX++ )
      {
        int br = ((int)whiteLedArray[ iGray( iX, iY ) ] );
        if (iX % 2 ==0)
        {
          val = (byte)br;
        }
        else
        {
          val = (byte) ((br<<4)|val);
          peggyFrame[idx++]= val;
        }
      }
      peggyFrame[idx++]= val;  // write that one last leftover half-byte
    }
   
    peggyPort.write(peggyHeader);
    peggyPort.write(peggyFrame); 
  }
 
  void update()
  {
    switch( currentMode )
    {
      case Wavez:
          updateWavez( this );
          break;
          
      case BouncingBalls:
          updateBouncingBalls( this );
          break;
      
      case Fireworks:
          updateFireworks( this );
          break;
          
      case Cancer:
          updateCancer( this );
          break;
          
      case Squares:
          updateSquares( this );
          break;
          
      case Spore:
          updateSpore( this );
          break;
          
      case Primes:
          updatePrimes( this );
          break;
          
      case Horticulture:
          updateHorticulture( this );
          break;
          
      case Tesla:
          updateTesla( this );
          
      case Spinning:
          updateSpinning( this );
          break;
    }
    
    // transfer the pixels from the graphics surface to peggy
    canvas.loadPixels();
    
    for( int iY=0; iY<nYLeds; iY++ )
    {
      for( int iX=0; iX<nXLeds; iX++ )
      {
        int index = iGray( iX, iY );
        grayValueArray[index] = brightness(canvas.pixels[index]);
        //grayValueArray[ iGray( iX, iY ) ] 
        //    = ( grayValueArray[ iGray( iX, iY ) ] + grayRateArray[ iGray( iX, iY ) ] )%1.0;
         
      }
    }
    
    float maxGray9 = 0.0; 
    float minGray9 = 1.0;
    for( int iY = 0; iY < nYLeds; iY++ )
    {
      for( int iX = 0; iX < nXLeds; iX++ )
      {
        float thisGray = avg9( iX, iY );
        gray9ValueArray[ iGray( iX, iY ) ] = thisGray;
        
        /*
        if ( thisGray > maxGray9 )
        {
          maxGray9 = thisGray;
        }
        
        if ( thisGray < minGray9 )
        {
          minGray9 = thisGray;
        } 
        */
        
      }
    }
 
    maxGray9 = 0.35;
    minGray9 = 0.1;

    for( int iY=0; iY<nYLeds; iY++ )
    {
      for( int iX=0; iX<nXLeds; iX++ )
      {
        gray9ValueArray[ iGray( iX, iY ) ] 
            = ( gray9ValueArray[ iGray( iX, iY ) ] - minGray9 )/( maxGray9 - minGray9 );
         
      }
    }
  }
 
  void draw()
  {
    
    
    for( int iY = 0; iY<nYLeds; iY++ )
    {
      for( int iX = 0; iX<nXLeds; iX++ )
      {
        //whiteLedArray[ iGray( iX, iY ) ] 
        //    = int( grayValueArray[ iGray( iX, iY ) ]*( nLevels - nearlyZero ) );     
        whiteLedArray[ iGray( iX, iY ) ] 
           // = int( gray9ValueArray[ iGray( iX, iY ) ]*( nLevels - nearlyZero ) );     
            = int( grayValueArray[ iGray( iX, iY ) ]*( nLevels - nearlyZero ) );     
        
        fill( whiteLedArray[ iGray( iX, iY ) ]/15.0 );
        stroke( 0.0 );
        ellipse( nXLedSize*( 0.5 + iX ), nYLedSize*( 0.5 +iY ), 
              nXLedSize, nYLedSize );
      }
    }
    
   
   
   // not right now
   renderToPeggy();
    
        
  } // end main loop 
  
  int iGray( int iX, int iY )
  {
    return iY*nYLeds + iX;
  }
  
  float avg9( int iX, int iY )
  {
    float sum = 0.0;
    
    for( int iiY = iY - 1; iiY < iY + 1; iiY ++ )
    {
      for( int iiX = iX - 1; iiX < iX + 1; iiX ++ )
      {
        float val = 0.5;
        if ( ( iiX >= 0 ) && ( iiY >= 0 ) && ( iiX < nXLeds ) && ( iiY < nYLeds ) )
        {
           val = grayValueArray[ iGray( iiX, iiY ) ];
        }
        sum += val;
      }
    }
    return sum/9.0;
  }

}
