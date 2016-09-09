// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

color pink = color(255, 34, 168);
color yellow = color(255, 255, 34);
color blue =  color(36, 236, 255);
color green = color(174, 252, 0);


// Depth image
PImage depthImg;

int[] age;
int[] original_depth;

color[] colors = new color[] {
  yellow,
  green
};

// Which pixels do we care about?
int minDepth =  60;
int maxDepth = 890;

// What is the kinect's angle
float angle;

int tick = 0;

void setup() {
  size(640, 480);

  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();

  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);
  age = new int[kinect.width * kinect.height];  
  original_depth = new int[kinect.width * kinect.height];
  for (int i=0; i < original_depth.length; i++) {
    original_depth[i] = maxDepth;
  }
}

int trail_stripe_count = 5;
int trail_stripe_width = 5;

void draw() {
  
  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    
    age[i]++;
    
    if (
      rawDepth[i] >= minDepth &&
      rawDepth[i] <= maxDepth &&
      ((rawDepth[i] - 3) <= original_depth[i] || age[i] >= trail_stripe_count*trail_stripe_width)) {
      age[i] = 0;
      original_depth[i] = rawDepth[i];
    }
    
    if (age[i] < 2) { //&& rawDepth[i] < original_depth[i]) {
       depthImg.pixels[i] = pink;
    } else if (age[i] < trail_stripe_count*trail_stripe_width) {   
      depthImg.pixels[i] = colors[(age[i]/trail_stripe_width) % colors.length];
    } else {
      depthImg.pixels[i] = blue;
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, 0, 0);

  fill(0);
  //text("TILT: " + angle, 10, 20);
  //text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
}

// Adjust the angle and the depth threshold min and max
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
  }
}