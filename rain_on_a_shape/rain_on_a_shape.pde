import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.constraints.*;

import gab.opencv.*;

VerletPhysics2D physics;

OpenCV opencv;

color pink = color(255, 34, 168);
color yellow = color(255, 255, 34);
color blue =  color(36, 236, 255);
color green = color(174, 252, 0);

ArrayList<Contour> contours;
ArrayList<PVector> points;

Circle circle;
CircularConstraint c;

void setup() {
  
  size(800, 800);

  physics = new VerletPhysics2D();
  physics.setDrag(0.01f);
  physics.setWorldBounds(new Rect(0, 0, width, height));
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f)));
  
  opencv = new OpenCV(this, loadImage("test.jpg"));
  opencv.gray();
  opencv.invert();
  opencv.threshold(70);
  
  circle = new Circle(width/2, height/2, 200);
  c = new CircularConstraint(circle);
}


void draw() {
  
  background(pink);
  
  fill(yellow);
  ellipse(circle.x, circle.y, circle.getRadius(), circle.getRadius()); 
 
  if (random(100) < 30) {
    VerletParticle2D p = 
      new VerletParticle2D(
        Vec2D.randomVector().scale(5).addSelf(random(width), 0));
    physics.addParticle(p);
    c.apply(p);
  }
  
  contours = opencv.findContours();
  noFill();
  strokeWeight(3);
  stroke(green);
  for (Contour contour : contours) {
    contour.draw();
    points = contour.getPoints();
  }
  
  physics.update();
  
  for (VerletParticle2D p : physics.particles) {
    display_drop(p, blue);
  }
 
}