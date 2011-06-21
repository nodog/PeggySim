int branches = 3;  //Number of branches per line
int depth = 3; // Recursive depth
float MIN_ANGLE = 20.0; //Minimum angle for new branch
float MAX_ANGLE = 60.0; //Maximum angle for new branch
float MIN_LENGTH = 0.5; //Minimum length of new branch, as a pct of current length
float MAX_LENGTH = 1.5; //Maximum length of new branch, as a pct of current length

int frameCounter = 0;

Vector seed = new Vector(13,24, 5,-90); 

ArrayList<Vector> buffer = new ArrayList<Vector>();

// Implements a Vector
class Vector {
  int x,y;
  float r, theta;
  
  Vector (int _x, int _y, float _r, float _theta) {
    x = _x;  //Origin x
    y = _y;  //Origin y
    r = _r;  //Length
    theta = _theta;  // Angle
  }
  
  int getEndPointX() { 
    return int(x + r*cos(theta/57.3));
  }
  
  int getEndPointY() {
    return int(y + r*sin(theta/57.3));
  }
  
}

//Recursive function that creates a fractal "plant" 
void fractal(Vector v, int N) {
  if (N > 0) {
     int dir = 1;  //control alternating direction of the branch     
     buffer.add(v);
     for (int i = 0; i < branches; i++) {  
        //Create a random vector based on the current one
        Vector r = new Vector (v.x, v.y, v.r, v.theta);  //New random vector that will branch off the current line
        r.r = random(v.r*MIN_LENGTH, v.r*MAX_LENGTH);  //Select a random length
        r.x = r.getEndPointX();  //shift the x-origin
        r.y = r.getEndPointY();  //shift the y-origin
        r.theta += dir*random(MIN_ANGLE,MAX_ANGLE);  // shift the angle a bit
        dir = dir * -1;  //Alternate branch direction
        fractal(r, N-1);  //Recurse
      }
   }
}

void setupHorticulture( Peggy peg )
{
  colorMode( HSB, 1.0 );
  //frameRate( 30 );
  peg.canvas.stroke(1);
  peg.canvas.background( 0 );
  fractal (seed, depth);
}


void updateHorticulture( Peggy peg)
{
  if(frameCounter == buffer.size() )
  {
   peg.canvas.background(0);
   branches = int( random(2,4) );
   depth = (int)random(2,4);
   seed.r = (int)random(4,12);
   seed.theta = (int)random(-135, -45);
   
   buffer.clear();
   frameCounter = 0;
   fractal (seed, depth);
  }
  Vector v = buffer.get(frameCounter);
   peg.canvas.line( v.x, v.y, v.getEndPointX(), v.getEndPointY() );  //Draw the current vector
   frameCounter++;
}

