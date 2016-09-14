import gab.opencv.*;
import processing.video.*;
 
Capture video;
OpenCV opencv;
 
ArrayList<Contour> contours;
 
void setup() {
  size(640, 480);
  video = new Capture(this, 320, 240);
  opencv = new OpenCV(this, 320, 240);
 
  video.start();
}
 
 
void draw() {
  scale(2);
  background(255);
 
  opencv.loadImage(video);
 
  opencv.findCannyEdges(30, 95);
 // opencv.invert();
 
  //scaled output
  //image(opencv.getOutput(), 0, 0 );
 
  contours = opencv.findContours(); //finding contours to the canny filtered one
 
  noFill();
  for (Contour contour : contours) {  
    stroke(255, 0, 0);
    beginShape();
    for (PVector point : contour.getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
  }
}
 
void captureEvent(Capture c) {
  c.read();
}