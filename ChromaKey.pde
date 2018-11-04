
PImage chromakey(Movie m, color keyColours) {
  PImage frame = createImage(m.width, m.height, ARGB);
  frame.set(0,0,m);
  frame.loadPixels();
  for (int i=0; i<frame.pixels.length; i+=1)
  {
      if (similar(frame.pixels[i], keyColours ))
      {
        frame.pixels[i] = color (123,100,200,0);
      }
   }
  frame.updatePixels();
  return frame;
}

color getFirstPixel(Movie m)
{  // This is asuuming the imposed image first pixel is the colour of the screen to be removed
  color colour = color(0,0,0);
  m.loadPixels();
  colour=m.pixels[0];
  return colour;
}


Boolean similar(color c1, color c2) { 
    return dist(red(c1), green(c1), blue(c1),red(c2), green(c2), blue(c2)) <= 120;
}