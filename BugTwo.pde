int MAX_ITER;
double ZOOM;
  
  
void setupBugTwo( Peggy peg )
{
  MAX_ITER = 300;
  ZOOM = 1;
}


void updateBugTwo( Peggy peg)
{

  double zx, zy, cX, cY, tmp;
  
  ZOOM = 0.4 + ZOOM; 
  
  peg.canvas.loadPixels();  
  
  
  for( int iY=0; iY < peggy.nYLeds; iY++)
  {   
    for ( int iX=0; iX < peggy.nXLeds; iX++  )
     {     
  
       zx = zy = 0;
       cX = (iX - 4) / ZOOM;
       cY = (iY - 4) / ZOOM;
       int iter = MAX_ITER;
       while ((zx * zx + zy * zy < 4) && (iter > 0)) 
       {
         tmp = zx * zx - zy * zy + cX;
         zy = 2.0 * zx * zy + cY;
         zx = tmp;
         iter--;  
       }
     
    
      peggy.canvas.pixels[ peggy.iGray( iX, iY ) ] = color(float(iter) / MAX_ITER);
     
   } 
  }
  
  
  peg.canvas.updatePixels();
}

