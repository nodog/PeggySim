import ddf.minim.*;
import ddf.minim.ugens.*;
    
Minim minim = new Minim( this );

class ArraySounder
{
  int spectrumSize;
  int arraySize;
  Oscil osc;
  Array2Spect array2Spect;
  
  ArraySounder( int nRows, int nCols )
  {
    spectrumSize = 4096;
    int nOverlap = 4;
    this.arraySize = arraySize;
    AudioOutput out = minim.getLineOut( Minim.MONO, 2048 );    

    osc = new Oscil( 349.23, 0.8 );
    
    array2Spect = new Array2Spect( spectrumSize, nOverlap, nRows, nCols );
    
    //imageSounder = new ImageSonuder( arraySize, 1 );
    
    //osc.patch( out );
    array2Spect.patch( out );
    
  }
  
  void setFreq( float freq )
  {
    osc.setFrequency( freq );
  }
  
  void setSpectrum( float[] array )
  {
    //osc.setFrequency( array[ 0 ]* 500 + 150 );
    array2Spect.updateSpectrum( array );
  }

}
