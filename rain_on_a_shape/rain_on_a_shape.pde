import fisica.*;
import gab.opencv.*;

FWorld world;
OpenCV opencv;

color pink = color(255, 34, 168);
color yellow = color(255, 255, 34);
color blue =  color(36, 236, 255);
color green = color(174, 252, 0);

ArrayList<Contour> contours;
ArrayList<PVector> points;

void setup() {
  
  size(800, 800);
  smooth();
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 500);
  
  opencv = new OpenCV(this, loadImage("test1.png"));
  opencv.gray();
  opencv.invert();
  opencv.threshold(70);
  
  contours = opencv.findContours();
  for (Contour contour : contours) { 
    FPoly l = new FPoly();
    
    points = contour.getPolygonApproximation().getPoints();
    println(points.size());
    for (PVector p : points) {
       l.vertex(p.x, p.y);
       //ellipse(p.x,p.y, 10, 10);
    }
    l.setFill(174, 252, 0);
    l.setFriction(.2);
    l.setStatic(true);
    world.add(l);
  }
}

void draw() {
  
  background(pink);
    
  if (random(100) < 10) {
    //FBlob b = new FBlob();
    //b.setAsCircle(random(width), 0, 15, 3);
    
    int w = 10;
    
    FPoly tail = new FPoly();
    tail.vertex(-w/2, 0);
    tail.vertex(0, -2*w);
    tail.vertex(w/2, 0);
    tail.setNoStroke();
    tail.setFill(36, 236, 255);
   
    FCircle dot = new FCircle(w);
    dot.setNoStroke();
    dot.setFill(36, 236, 255);
    
   FCompound drop = new FCompound();
    drop.addBody(dot);
    drop.addBody(tail);
    drop.setPosition(random(width), 0);
    drop.setRestitution(.3);
    drop.setFriction(.1);
    drop.setVelocity(0, 100 + random(100));
    drop.adjustRotation(0.01 * random(1));
    drop.setName("drop");
    world.add(drop);
  }
  
  world.step();
  world.draw();
}

void contactStarted(FContact contact) {
   replace(contact.getBody1());
   replace(contact.getBody2());
 }
 
void replace(FBody b) {
  if("drop".equals(b.getName())) {
    world.remove(b);
    FBlob blob = new FBlob();
    blob.setAsCircle(b.getX(), b.getY(), 15, 10);
    blob.setVelocity(b.getVelocityX(), b.getVelocityY());
    blob.setNoStroke();
    blob.setVertexSize(1);
    blob.setFrequency(.2);
    blob.setDamping(1000);
    blob.setFill(36, 236, 255);
    world.add(blob);
  }
}