class Drop{
  int centerX;
  int centerY;
  int fallingSpeed;
  boolean active = false;
  color dropColor;
  int size = 20; 
   
  void display(){
    if (active) {
      noStroke();
      fill(dropColor);
      ellipse(centerX,centerY, size, size);
      triangle(centerX-size/2,centerY,
                 centerX,centerY-fallingSpeed*4,
                 centerX + size/2, centerY);
    }
  }
  
  void reset(int x, int y, int s) {
    centerX = x;
    centerY = y;
    fallingSpeed = s;
    active = true;
  }
  
  void fall(){
    centerY +=fallingSpeed;
  } 
}