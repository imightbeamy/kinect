import fisica.*;
import gab.opencv.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import themidibus.*;

FWorld world;
OpenCV opencv;
Kinect kinect;
MidiBus myBus;

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
boolean random_drops = false;

int pitch;
int max_pitch = 0;
int min_pitch = 1000;
float angle;

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
  myBus = new MidiBus(this, "Port 1", "Port 1");
  
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

  if (random_drops && random(100) < 10) {
    drops.addDrop(int(random(width)), 10);
  }
  
  world.step();
  world.draw();
}

void contactStarted(FContact contact) {
   drops.replace(contact.getBody1(), contact.getBody2());
   drops.replace(contact.getBody2(), contact.getBody1());
}

void noteOn(Note note) {
  println("Note On! " + "Pitch: "+ note.pitch() + "Velocity: " + note.velocity());
  
  pitch = note.pitch();
  max_pitch = max(max_pitch, pitch);
  min_pitch = min(min_pitch, pitch);
  drops.addDrop(normilize(min_pitch, max_pitch, note.pitch), 4 + note.velocity()/10);
}

int normilize(int min_val, int max_val, int val) {
  return int((val - min_val * 1.0)/(max_val - min_val)*width);
}
 
 void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  } else if (key == 'a') {
    minDepth = constrain(minDepth+10, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-10, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+10, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-10, minDepth, 2047);
  } else if (key == 'r') {
    random_drops = !random_drops; 
  } 
}