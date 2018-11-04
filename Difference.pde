 final float USER_SCALING = 0.2;

float [] rgb2Lab(float r, float g, float b) {
  float [] lab = new float[3];

  lab[0] = 0.3475 * r + 0.8231 * g + 0.5550 * b;
  lab[1] = 0.2162 * r + 0.4316 * g - 0.6411 * b;
  lab[2] = 0.1304 * r - 0.1033 * g - 0.0269 * b;

  return lab;
}

float [] lab2RGB(float l, float a, float b) {
  float [] rgb = new float[3];

  rgb[0] = 0.5773 * l + 0.2621 * a + 5.6947 * b;
  rgb[1] = 0.5774 * l + 0.6072 * a - 2.5444 * b;
  rgb[2] = 0.5832 * l - 1.0627 * a + 0.2073 * b;

  return rgb;
}


float [] getMeansFrom(PImage p) {
  float [] m = new float [3];
  int count = 0;

  p.loadPixels();

  for (int i = 0; i < p.pixels.length; i += 1) {
      if (color(p.pixels[i])!=keyColours) {
        float [] cp = rgb2Lab(red(p.pixels[i]), green(p.pixels[i]), blue(p.pixels[i]));

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



float [] getStandardDeviationsFrom(PImage p, Boolean backImage) {
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
        float [] cp = rgb2Lab(red(p.pixels[i]), green(p.pixels[i]), blue(p.pixels[i]));

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



void applyScalingsFromTo(PImage background, PImage front) {
  colorMode (RGB, 255);
  float [] s = new float[3];
 
  float [] sdRef = getStandardDeviationsFrom(background,true);
  float [] mTarget = getMeansFrom(front);
  float [] sdTarget = getStandardDeviationsFrom(front, false);

  for (int j = 0; j < s.length; j += 1) {
    s[j] = 1 - USER_SCALING + USER_SCALING * sdRef[j] / sdTarget[j];
  }

  front.loadPixels();

  for (int i = 0; i < front.pixels.length; i += 1) {
     if (color(front.pixels[i])!=keyColours) {
        float [] cp = rgb2Lab(red(front.pixels[i]), green(front.pixels[i]), blue(front.pixels[i]));

      for (int j = 0; j < cp.length; j += 1) {
          cp[j] = s[j] * (cp[j] - mTarget[j]) + mTarget[j];
    }

    float [] rgb = lab2RGB(cp[0], cp[1], cp[2]);
    front.pixels[i] = color(rgb[0], rgb[1], rgb[2]);
  }
  }
  front.updatePixels();
}