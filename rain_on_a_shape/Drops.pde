class Drops {
  
  FWorld world;
  
  Drops(FWorld world) {
    this.world = world;
  }
  
  void addDrop(int x, int v) {
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
    drop.setPosition(x, 0);
    drop.setRestitution(.3);
    drop.setFriction(.1);
    drop.setVelocity(0, v);
    drop.adjustRotation(0.01 * random(1));
    drop.setName("drop");
    world.add(drop);
  }
  
  void replace(FBody b, FBody b2) {
    if("drop".equals(b.getName()) && !"drop".equals(b2.getName())) {
      world.remove(b);
      FBlob blob = new FBlob();
      blob.setAsCircle(b.getX(), b.getY(), 15, 10);
      blob.setVelocity(b.getVelocityX(), b.getVelocityY());
      blob.setNoStroke();
      blob.setVertexSize(1);
      blob.setFrequency(10000);
      blob.setDamping(1000);
      blob.setFill(36, 236, 255);
      world.add(blob);
    }
  }
}