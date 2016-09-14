void display_drop(VerletParticle2D p, color c){
  int speed = int(p.getVelocity().magnitude());
  int size = 10;
  noStroke();
  fill(c);
  ellipse(p.x,p.y, size, size);
  triangle(p.x-size/2,p.y,
             p.x,p.y-speed*4,
             p.x + size/2, p.y);

}