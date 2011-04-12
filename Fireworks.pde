class Work
{
  PVector pos;
  float   age;
  float   sz;
}

float maxWorkAge = 2.f;
float workSpeed = 15.f;

ArrayList<Work> works;

float timeUntilNextWork;

void setupFireworks( Peggy peg )
{
  works = new ArrayList<Work>();
  timeUntilNextWork = 0;
}

void drawWorkParticle( Peggy peg, Work w, float d, float th )
{
  th += random( -0.2, 0.2 );
  peg.canvas.ellipse( w.pos.x + cos(th)*d, w.pos.y + sin(th)*d, w.sz, w.sz );
}

void updateFireworks( Peggy peg )
{
  timeUntilNextWork -= 1.f / frameRate;
  if ( timeUntilNextWork <= 0 )
  {
    Work w = new Work();
    w.pos = new PVector( random( 4, 20 ), random( 3, 10 ) );
    w.age = 0.f;
    w.sz = random( 1, 2 );
    works.add( w );
    
    timeUntilNextWork = random( 0.25f, 1.25f );
  }
  
  peg.canvas.noStroke();
  peg.canvas.fill( backgroundTint, 0.2 );
  peg.canvas.rect( 0, 0, 25, 25 );
  
  for( int i = 0; i < works.size(); ++i )
  {
    Work w = works.get(i);
    float d = workSpeed * w.age;
    peg.canvas.fill( 0, 1, 1 );
    //peg.canvas.fill( 0, 1.f, 1.f - w.age / maxWorkAge );
    drawWorkParticle( peg, w, d, PI/5 );
    drawWorkParticle( peg, w, d, 2*PI/5 );
    drawWorkParticle( peg, w, d, 3*PI/5 );
    drawWorkParticle( peg, w, d, 4*PI/5 );
    drawWorkParticle( peg, w, d, 5*PI/5 );
    drawWorkParticle( peg, w, d, 6*PI/5 );
    drawWorkParticle( peg, w, d, 7*PI/5 );
    drawWorkParticle( peg, w, d, 8*PI/5 );
    drawWorkParticle( peg, w, d, 9*PI/5 );
    drawWorkParticle( peg, w, d, 10*PI/5);
    
    w.age += 1.f / frameRate;
    if ( w.age > maxWorkAge )
    {
      works.remove( w );
      --i;
    }
  }
}
