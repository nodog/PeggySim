int MAX_ITER;
double ZOOM;
  
  
void setupBugTwo( Peggy peg )
{
  MAX_ITER = 200;
  ZOOM = 1;
}


void updateBugTwo( Peggy peg)
{

  double zX, zY, countX, countY, tmp;
  
  ZOOM = 0.3 + ZOOM; 
  
  peg.canvas.loadPixels();  
  
  
  for( int iY=0; iY < peggy.nYLeds; iY++)
  {   
    for ( int iX=0; iX < peggy.nXLeds; iX++  )
     {     
  
       zX = zY = 0; //reset things to zero
       
       countX = (iX - 4) / ZOOM;
       countY = (iY - 4) / ZOOM;
       int iter = MAX_ITER;
       
       while ( (zX * zX + zY * zY < 4) && (iter > 0) ) 
       {
         tmp = zX * zX - zY * zY + countX;
         zY =  zX * zY + countY;
         zX = tmp;
         iter--;  
       }
     
    
      peggy.canvas.pixels[ peggy.iGray( iX, iY ) ] = color(float(iter) / MAX_ITER);
     
   } 
  }
  
  
  peg.canvas.updatePixels();
}

