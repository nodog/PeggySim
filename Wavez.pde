float phi1;
float modPhi1;
float modPhiFreq1;
float modScale1;

float phi2;
float modPhi2;
float modPhiFreq2;
float modScale2;

void setupWavez( Peggy peg )
{
  peg.canvas.colorMode( HSB, 1.0 );
  peg.canvas.stroke( 1 );
  peg.canvas.fill(1);
  peg.canvas.strokeWeight(1);
  
  modScale1 = 40;
  modPhi1 = 0;
  modPhiFreq1 = 0.05 * 360;
  phi1 = 0;
  
  modScale2 = 50;
  modPhi2 = 0;
  modPhiFreq2 = 0.07 * 360;
  phi2 = 0;
}

void updateWavez( Peggy peg )
{
  peg.canvas.background( 0 );
  
  modPhi1 = modPhi1 + modPhiFreq1 / frameRate; 
  float myVal1 = sin(radians(modPhi1));
  phi1 += modScale1 * myVal1; 
  phi1 = phi1%360;
  
  modPhi2 = modPhi2 + modPhiFreq2 / frameRate; 
  float myVal2 = sin(radians(modPhi2));
  phi2 += modScale2 * myVal2; 
  phi2 = phi2%360;
  
  for (int x = 0; x < 25; x++ )
  {
    float theta1 = map(x, 0,24,  0, 360+(180*myVal1) );
    float theta2 = map(x+1, 0,24, 0, 360+(180*myVal1) );
    float y1 = 9 * sin(radians(theta1 + phi1 ));
    float y2 = 9 * sin(radians(theta2 + phi1 ));
    
    float theta3 = map(x, 0,24,  0, 360+(180*myVal2) );
    float theta4 = map(x+1, 0,24, 0, 360+(180*myVal2) );
    float y3 = 9 * sin(radians(theta3 + phi2 ));
    float y4 = 9 * sin(radians(theta4 + phi2 ));
    
    peg.canvas.line( x,(int)y1+12, x+1,(int)y2+12 );
    
    peg.canvas.line( x,(int)y3+12, x+1,(int)y4+12 );
  }
  
}
