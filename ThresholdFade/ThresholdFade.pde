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
color[] colors = new color[] {
  yellow,
  green
};

// Which pixels do we care about?
int minDepth =  60;
int maxDepth = 860;

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
}

void draw() {
  
  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      age[i] = 0;
      depthImg.pixels[i] = pink;
    } else {
      age[i]++;
      
      if (age[i] > 50) {
        depthImg.pixels[i] = blue;
      } else {
         depthImg.pixels[i] = colors[(age[i]/5) % colors.length];
      }
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  image(depthImg, 0, 0);

  fill(0);
  text("TILT: " + angle, 10, 20);
  text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
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