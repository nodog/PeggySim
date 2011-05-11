// how many steps each row ticks after
int steps[]      = { 
  1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89
};
String pitches[] = { 
  "A1", "C2", "E2", "G2", "B2", "D3", "F#3", "Bb3", "Db4", "F4", "Ab4", "C5", "Eb5", "Bb5", "D6", "F6", "Ab6", "B6", "Eb7", "Gb7", "Bb7", "D8", "F#8", "A8", "C#9"
};
// represents one row
class Row
{
  // column that is lit in this row
  int position;
  // counter so we know when to increment our position
  int counter;
}

Row rows[];

// how long is one step
float stepLength = 0.1f;
// keep track of time so we can move to the next step
float stepCount;
float stepChangeTimer;

void setupPrimes( Peggy peg )
{
  stepCount = 0.f;
  stepChangeTimer = random( 1.f, 5.f );
  // reset everything
  rows = new Row[ peg.nXLeds ];
  for ( int i = 0; i < rows.length; ++i )
  {
    rows[i] = new Row();
    rows[i].position = 0;
    rows[i].counter = 0;
  }
}

void updatePrimes( Peggy peg )
{
  float dt =  1.f / frameRate;
  stepCount += dt;
  if ( stepCount >= stepLength )
  {
    // increment counters, possibly increment position
    for (int i = 0; i < rows.length; ++i )
    {
      rows[i].counter++;
      if ( rows[i].counter == steps[i] )
      {
        rows[i].position++;
        if ( rows[i].position == peg.nXLeds )
        {
          rows[i].position = 0;
        }
        out.playNote( 0.f, stepLength * steps[i] * 0.5f, new PegTone( pitches[ rows[i].position ] ) );
        rows[i].counter = 0;
      }
    }
    stepCount %= stepLength;
  }

  stepChangeTimer -= dt;
  if ( stepChangeTimer < 0 )
  {
    if ( random( 1.f ) < 0.5f )
    {
      stepLength = random( 0.001f, 0.01f );
    }
    else
    {
      stepLength = random( 0.1f, 0.5f );
    }
    stepChangeTimer = random( 1.f, 5.f );
    println( "new stepLegnth " + stepLength + " for " + stepChangeTimer );
  }

  // render our state
  //peg.canvas.background( 0 );
  peg.canvas.fill( 0.0, 0.2 );
  peg.canvas.rect( -1, -1, 26, 26 );

  peg.canvas.loadPixels();
  for ( int i = 0; i < rows.length; ++i )
  {
    float rad = map( rows[i].counter, 0, steps[i], 0, steps[i] + 1 );
    int pos = rows[i].position;
    for ( float p = pos - rad; p < pos + rad; ++p )
    {
      if ( p >= 0 && p < 25 )
      {
        float step = norm( p, pos - rad, pos + rad );
        peg.canvas.pixels[ i*rows.length+(int)p ] = color( sin( step * PI ) );
      }
    }
  }
  peg.canvas.updatePixels();
}

float lowFreq = Frequency.ofPitch( pitches[0] ).asHz();
float hiFreq  = Frequency.ofPitch( pitches[24] ).asHz();

class PegTone implements Instrument
{
  Oscil wave;
  Oscil mod;
  Line  env;
  Line  hz;
  Line  modFreq;
  float amp;
  float freq;

  PegTone( String pitch )
  {
    freq = Frequency.ofPitch(pitch).asHz();
    amp = map( freq, lowFreq, hiFreq, 0.2f, 0.01f );
    //println( amp );
    wave = new Oscil( freq, amp, Waves.SINE );
    mod  = new Oscil( 0.f, amp, Waves.SINE );
    mod.phase.setLastValue( random( 0, 1 ) );
    mod.patch( wave.amplitude );
    env = new Line();
    env.patch( mod.amplitude );
    hz = new Line();
    hz.patch( wave.frequency );
    modFreq = new Line();
    modFreq.patch( mod.frequency );
  }

  void noteOn( float dur )
  {
    env.activate( dur, amp, 0.f );
    hz.activate( dur, freq, freq*random(0.25f, 4.f) );
    modFreq.activate( dur, 0.1f, 50.f );
    wave.patch( out );
  }

  void noteOff()
  {
    wave.unpatch( out );
  }
}


