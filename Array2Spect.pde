import ddf.minim.analysis.FFT;

public class Array2Spect extends UGen
{
  // the window size we use for analysis
  private int          m_windowSize;

  // how many samples should pass between the beginning of each window
  private int          m_windowSpacing;

  // the current spectrum data
  private float[]      m_spectrumReal;
  private float[]      m_spectrumImag;

  // our output
  private float[]      m_outputSamples;

  // where we are in our sampling arrays
  private int          m_index;
  // where we are in our output array
  private int          m_outputIndex;
  // sample counter for triggering the next window
  private int          m_triggerCount;
  // the float array we use for constructing our analysis window
  private float[]      m_analysisSamples;
  private float        m_outputScale;
  // used to analyze the audio input
  private FFT          m_audioFFT;
  
  // used to setup the analysis
  private int          m_nRows;
  private int          m_nCols;
  private float[]      m_imageArray;

  private int          m_rowIndex;
  private int          m_interpDivisor;

  public Array2Spect( int windowSize, int windowCount, int nRows, int nCols )
  {
    float overlapPercent = 1.f;
    m_outputScale = 1.f;
    if ( windowCount > 1 )
    {
      overlapPercent = 1.f / (float)windowCount;
      m_outputScale = overlapPercent / 8.f;
    }
    m_windowSize = windowSize;
    m_windowSpacing = (int)( windowSize * overlapPercent );
    int bufferSize = m_windowSize * 2 - m_windowSpacing;
    m_outputSamples = new float[bufferSize];
    m_analysisSamples = new float[windowSize];
    m_index = 0;
    m_outputIndex = 0;
    m_triggerCount = m_windowSize;
    m_spectrumReal = new float[ m_windowSize ];
    m_spectrumImag = new float[ m_windowSize ];
    for ( int i = 0; i < m_windowSize; i++ )
    {
      m_spectrumReal[ i ] = 0.01;
      m_spectrumImag[ i ] = 0.01;
    }
    // need to defer creation of the FFT objects until we know our samplerate.
    m_spectrumReal[ 24 ] = 0.5;
    m_spectrumReal[ 48 ] = 0.5;
    
    m_nRows = nRows;
    m_nCols = nCols;
    m_imageArray = new float[ nRows * nCols ];
    m_rowIndex = 0;
    
    m_interpDivisor = 64;
 
  }

  protected void sampleRateChanged()
  {
    m_audioFFT = new FFT( m_windowSize, sampleRate() );
  }
  
  public void updateSpectrum( float[] imageArray )
  {
    arrayCopy( imageArray, m_imageArray );
    
    //for ( int i = 0; i < m_windowSize; i++ )
    //{
    //  m_spectrumReal[ i ] = spectrum[ i / 3 ];
    //  float freqScale = float( i )/float( m_windowSize );
    //  m_spectrumReal[ i ] *= ( 100.0 / m_outputScale ) * freqScale * freqScale * freqScale;
    //  if ( i < 170 )
    //  {
    //    m_spectrumReal[ i ] *= 0.01 ;
    //  }
    //  m_spectrumImag[ i ] = m_spectrumImag[ i ] + random( 0.001, 0.01 );
    //  //m_spectrumImag[ i ] = random( 3 ) * freqScale * freqScale * freqScale;
    //}
    // //println( "spectrum updated = " + m_spectrumReal[ 3 ] );
  }

  protected void interpFill( float[] smallArray, float[] bigArray, int divisor )
  {
    int bigArrayLimit = bigArray.length/divisor;
    bigArray[ 0 ] = smallArray[ 0 ];
    bigArray[ bigArrayLimit - 1 ] = smallArray[ smallArray.length - 1 ];
    for ( int i = 1; i < ( bigArrayLimit - 1 ); i++ )
    {
      float freqScale = ( (float)i / (float)bigArrayLimit );
      float fndexSmall = ( (float)i )/( (float)bigArrayLimit )*(float)( smallArray.length - 1 );
      int lodexSmall = (int)Math.floor( fndexSmall );
      //println( lodexSmall );
      bigArray[ i ] = ( (int)fndexSmall + 1 - fndexSmall )*smallArray[ lodexSmall ]
          + ( fndexSmall - (int)fndexSmall )*smallArray[ lodexSmall + 1 ];
      bigArray[ i ] *= divisor*m_windowSize*freqScale;
      bigArray[ bigArrayLimit + i ] = bigArray[ i ]/3.0;
      bigArray[ 2*bigArrayLimit + i ] = bigArray[ i ]/5.0;
      
    }
    for ( int i = 3*bigArrayLimit; i < bigArray.length; i ++ )
    {
      bigArray[ i ] = 0.01;
    }
    bigArray = reverse( bigArray );
  }

  protected void uGenerate(float[] out)
  {
    --m_triggerCount; 
    
    // we reached the end of our window. analyze and synthesize!
    if ( m_triggerCount == 0 )
    {
      //for ( int i = 0; i < m_audioFFT.specSize(); ++i )
      //{
      //    m_audioFFT.setBand( i, m_spectrumReal[ i ] );
      //}
     
      // copy one row into a small spectral array 
      float[] rowSpectrum = new float[ m_nCols ];
      arrayCopy( m_imageArray, m_rowIndex*m_nCols, rowSpectrum, 0, m_nCols );
      m_rowIndex = ( m_rowIndex + 1 ) % m_nRows; 
      
      // fill out the windowSize array with the small spectral array
      float[] arraySpectrum = new float[ m_windowSize ];
      interpFill( rowSpectrum, arraySpectrum, m_interpDivisor );
      //for ( int i = 0; i < arraySpectrum.length; i++ )
      //{
      //  arraySpectrum[ i ] = 0.0001;
      //}
      //arrayCopy( rowSpectrum, 0, arraySpectrum, 0, rowSpectrum.length );
      //for ( int i = 0; i < arraySpectrum.length; i++ )
      //{
      //  arraySpectrum[ i ] *= 2800.0;
      //}
      arrayCopy( arraySpectrum, m_spectrumReal );
      
      for( int i = 0; i < m_windowSize; i++ )
      {
        m_spectrumImag[ i ] = ( m_spectrumImag[ i ] + random( 0.1 ) ) % 4.3;
      }

      // synthesize
      m_audioFFT.inverse( m_spectrumReal, m_spectrumImag, m_analysisSamples );

      // window
      FFT.HAMMING.apply( m_analysisSamples );

      // accumulate
      for ( int a = 0; a < m_windowSize; ++a )
      {
        int outIndex = m_outputIndex + a;
        if ( outIndex >= m_outputSamples.length )
        {
          outIndex -= m_outputSamples.length;
        }
        m_outputSamples[ outIndex ] += m_analysisSamples[ a ] * m_outputScale;
      }
      
      m_triggerCount = m_windowSpacing;
    }
    
    for ( int i = 0; i < out.length; ++i )
    {
      out[i] = m_outputSamples[ m_outputIndex ];
    }
    
    // eat it.
    m_outputSamples[ m_outputIndex ] = 0.f;
    // next!
    ++m_outputIndex;
    if ( m_outputIndex == m_outputSamples.length )
    {
      m_outputIndex = 0;
    }
  }
}
 


