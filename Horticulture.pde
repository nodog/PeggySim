int BRANCHES = 4;  //Number of branches per line
int DEPTH = 3; // Recursive depth
float MIN_ANGLE = 30.0; //Minimum angle for new branch
float MAX_ANGLE = 60.0; //Maximum angle for new branch
float MIN_LENGTH = 0.20; //Minimum length of new branch, as a pct of current length
float MAX_LENGTH = 0.70; //Maximum length of new branch, as a pct of current length

int frameCounter = 0;

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
void fractal(Vector v, int N, Peggy peg) {
  if (N > 0) {
     int dir = 1;  //control alternating direction of the branch
     stroke(#FFFFFF);
     strokeWeight(2);
     peg.canvas.line(v.x,v.y,v.getEndPointX(),v.getEndPointY());  //Draw the current vector
     for (int i = 0; i < BRANCHES; i++) {  
        //Create a random vector based on the current one
        Vector r = new Vector (v.x, v.y,v.r,v.theta);  //New random vector that will branch off the current line
        r.r = random(v.r*MIN_LENGTH, v.r*MAX_LENGTH);  //Select a random length
        r.x = r.getEndPointX();  //shift the x-origin
        r.y = r.getEndPointY();  //shift the y-origin
        r.theta += dir*random(MIN_ANGLE,MAX_ANGLE);  // shift the angle a bit
        dir = dir * -1;  //Alternate branch direction
        fractal(r,N-1, peg);  //Recurse
      }
   }
}

void setupHorticulture( Peggy peg )
{
  colorMode( HSB, 1.0 );
  frameRate( 15 );
  
  
}


void updateHorticulture( Peggy peg)
{
   peg.canvas.background(0);

   Vector seed = new Vector(13,24,7,-90);
   
   
   fractal (seed, DEPTH, peg );
}

