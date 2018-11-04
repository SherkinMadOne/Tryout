import processing.video.*;

PImage screen;

//String backgroundFile= "running-720p.mp4";
///String backgroundFile= "motocross-720p.mp4";
String  backgroundFile  = "skateboarder-720p.mp4";
//String  movieFilename  = "TRex-01-720p.mp4";
String  movieFilename  = "Aliens-720p.mp4";
PImage displayVideo;
Movie frontMovie, backgroundMovie;
int posX, posY;
Boolean imageBackground = false;
color keyColours = color(2,16,207);


void setup() {
  // set the frame rate at - 
  size(1280, 720);
  frameRate(25);
  screen  = createImage(1280,720, RGB);
  backgroundMovie = new Movie(this,backgroundFile);
  frontMovie = new Movie(this,  movieFilename);
  backgroundMovie.loop();
  frontMovie.loop();
  frontMovie.read();
  posX=width/2;
  posY=height/2;
  keyColours = getFirstPixel(frontMovie);
  displaySynthetic(); 
}

PImage displaySynthetic(){
   frontMovie.read();   
   displayVideo = chromakey(frontMovie, keyColours); 
   applyScalingsFromTo(backgroundMovie,frontMovie);
   HSB(backgroundMovie,frontMovie);
   return displayVideo;
}
  

void draw() {
  println(frameRate);
 backgroundMovie.read();
 image(backgroundMovie, 0,0,width,height);
   if (frameCount%2==0){
        displaySynthetic(); }
  image(displayVideo, posX,posY, (frontMovie.width/2), (frontMovie.height/2)); 

}