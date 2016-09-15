import fisica.*;
import gab.opencv.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

FWorld world;
OpenCV opencv;
Kinect kinect;

color pink = color(255, 34, 168);
color yellow = color(255, 255, 34);
color blue =  color(36, 236, 255);
color green = color(174, 252, 0);

ArrayList<PVector> points;
ImageContours ic;
Drops drops;
PImage image;

int minDepth =  60;
int maxDepth = 890;

void setup() {
  
  size(640, 480);
  smooth();
  
  kinect = new Kinect(this);
  kinect.initDepth();
  
  // Init physics
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 500);
  
  image = new PImage(kinect.width, kinect.height);
  opencv = new OpenCV(this, image.width, image.height);
  
  ic = new ImageContours(opencv, world);
  drops = new Drops(world);
}

void draw() {
  
  background(pink);
  
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    image.pixels[i] = 
      rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth ? color(255) : color(0);
  }
  image.updatePixels();
  ic.updateShapes(image);

  if (random(100) < 10) {
    drops.addDrop(int(random(width)), 10);
  }
  
  world.step();
  world.draw();
}

void contactStarted(FContact contact) {
   drops.replace(contact.getBody1());
   drops.replace(contact.getBody2());
 }
 