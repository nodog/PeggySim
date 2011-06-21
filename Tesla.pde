float teslaRadians;
float teslaRadStep;
color teslaArray[];
static int nPhases = 3;
color phaseTapColors[] = new color[ nPhases ];
int phaseLefts[] = { 17, 9, 1 };
color phaseTap1, phaseTap2, phaseTap3;

static int teslaWidth = 24;
static int powerTop = 21;
static int phaseTop = 17;
static int phaseHeight = 4;
static int poleBy2Top = phaseTop - phaseHeight;
static int poleBy4Top = poleBy2Top - phaseHeight;
static int poleBy8Top = poleBy4Top - phaseHeight;
static int rotorBottom = 3;
static int rotorTop = 0;

//Tesla expects nXLeds = 0 to 24;



void setupTesla( Peggy peggy )
{
  teslaRadians = 0.0;
  teslaRadStep = 0.2;
  teslaArray = new color[ peggy.nXLeds*peggy.nYLeds ];
  for( int iY=0; iY<peggy.nYLeds; iY++ )
  {
    for( int iX=0; iX<peggy.nXLeds; iX++ )
    {
      float baseDotColor = 0.0;
      teslaArray[ peggy.iGray( iX, iY ) ] = color( baseDotColor );
    }
  }
}

void updateTesla( Peggy peggy )
{
  teslaRadians = ( teslaRadians + teslaRadStep )%( 2.0*PI );

  // generate phaseTaps
  for( int iTap = 0; iTap < nPhases; iTap++ )
  {
    phaseTapColors[ iTap ] = teslaArray[ peggy.iGray( phaseLefts[ iTap ] + 3, powerTop ) ];
  }

  peggy.canvas.loadPixels();
  
  for( int iY=0; iY<peggy.nYLeds; iY++ )
  {
    for( int iX=1; iX<peggy.nXLeds; iX++ )
    {
      
      //draw incoming power
      if ( iY >= powerTop )
      { 
        float powerColColor = 0.5*sin( ( 2.0*PI*iX )/( 1.0*peggy.nXLeds ) + teslaRadians ) + 0.5;
        teslaArray[ peggy.iGray( iX, iY ) ] = color( powerColColor );
      }

      // draw phases (right side)
      else if ( iY >= phaseTop )
      {      
         // draw phase1 (right side)
         if ( iX >= phaseLefts[ 0 ] )
         {
           teslaArray[ peggy.iGray( iX, iY ) ] = phaseTapColors[ 0 ];
         }
         else if ( iX >= phaseLefts[ 1 ] )
         {
           teslaArray[ peggy.iGray( iX, iY ) ] = phaseTapColors[ 1 ];
         }
         else
         {
           teslaArray[ peggy.iGray( iX, iY ) ] = phaseTapColors[ 2 ];
         }
         
      }
      else if ( iY >= poleBy2Top )
      {
        teslaArray[ peggy.iGray( iX, iY ) ] = phaseTapColors[ ( ( teslaWidth - iX )/4 )%3 ];
      }
      else if ( iY >= poleBy4Top )
      {
        teslaArray[ peggy.iGray( iX, iY ) ] = phaseTapColors[ ( ( teslaWidth - iX )/2 )%3 ];
      }
      else if ( iY >= poleBy8Top )
      {
        teslaArray[ peggy.iGray( iX, iY ) ] = phaseTapColors[ ( teslaWidth - iX )%3 ];
      }
      else if ( ( iY == rotorBottom ) || ( iY == rotorTop ) )
      {
        color maxMagn = max( phaseTapColors );
        teslaArray[ peggy.iGray( iX, iY ) ] = maxMagn;
      }
      else if ( ( iY < rotorBottom ) && ( iY > rotorTop ) )
      {
        //if( iX%3  )
        //{ 
        //   color maxMagn = max( phaseTapColors );
        //   teslaArray[ peggy.iGray( iX, iY ) ] = maxMagn;
        //}
      }
      
    }
  }
  
  arrayCopy( teslaArray, peggy.canvas.pixels );
  peggy.canvas.updatePixels();
}
