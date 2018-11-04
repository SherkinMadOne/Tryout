 final float SCALE = 0.5;
 
float [] meansFrom(PImage p) {
  float [] m = new float [3];
  int count = 0;

  p.loadPixels();

  for (int i = 0; i < p.pixels.length; i += 1) {
      if (color(p.pixels[i])!=keyColours) {
        float [] cp = rgb2Lab(hue(p.pixels[i]), saturation(p.pixels[i]), brightness(p.pixels[i]));

         for (int j = 0; j < m.length; j += 1) {
            m[j] += cp[j];
          }
        count += 1;
  }}
  for (int j = 0; j < m.length; j += 1) {
    m[j] /= count;
  }
  return m;
}



float [] standardDeviationsFrom(PImage p, Boolean backImage) {
  float [] m = getMeansFrom(p);
  float [] sd = new float [3];
  int count = 0;
  p.loadPixels();
  if (backImage==true){
    // This takes the background relative in size to the synthetic image
    PImage newImage = get (posX,posY, p.width/2, p.height/2);
    p=newImage;
  }
  for (int i = 0; i < p.pixels.length; i += 1) {
     if (color(p.pixels[i])!=keyColours) {
        float [] cp = rgb2Lab(hue(p.pixels[i]), saturation(p.pixels[i]), brightness(p.pixels[i]));

        for (int j = 0; j < sd.length; j += 1) {
          sd[j] += ((cp[j] - m[j]) * (cp[j] - m[j]));
        }
      count += 1;
  }}

  for (int j = 0; j < sd.length; j += 1) {
    sd[j] = sqrt(sd[j] / count);
  }
  return sd;
}



void HSB(PImage background, PImage front) {
 colorMode (HSB, 255);  
  float [] s = new float[3];
 
  float [] sdRef = standardDeviationsFrom(background,true);
  float [] mTarget = meansFrom(front);
  float [] sdTarget = standardDeviationsFrom(front, false);

  for (int j = 0; j < s.length; j += 1) {
    s[j] = 1 - SCALE + SCALE * sdRef[j] / sdTarget[j];
  }

  front.loadPixels();

  for (int i = 0; i < front.pixels.length; i += 1) {
     if (color(front.pixels[i])!=keyColours) {
        float [] cp = rgb2Lab(hue(front.pixels[i]), saturation(front.pixels[i]), brightness(front.pixels[i]));

      for (int j = 0; j < cp.length; j += 1) {
          cp[j] = s[j] * (cp[j] - mTarget[j]) + mTarget[j];
    }

    float [] rgb = lab2RGB(cp[0], cp[1], cp[2]);
    front.pixels[i] = color(rgb[0], rgb[1], rgb[2]);
  }
  }
  front.updatePixels();
}