class ImageContours {
  
  ArrayList<Contour> contours;
  ArrayList<FPoly> polys = new ArrayList<FPoly>();
  
  OpenCV opencv;
  FWorld world;
   
  ImageContours(OpenCV opencv,  FWorld world) {
    this.opencv = opencv;
    this.world = world;
  }
  
  ArrayList<Contour> fromImage(PImage image) {
    opencv.loadImage(image);
    opencv.gray();
    opencv.blur(15);
   // opencv.flip(1);
    opencv.threshold(100);
   //image(opencv.getSnapshot(), 0, 0);
     
  ArrayList<Contour> axprox = new ArrayList<Contour>();
   for (Contour contour : opencv.findContours()) { 
     contour.setPolygonApproximationFactor(1);
      axprox.add(contour.getPolygonApproximation());
   } 
   return  axprox;
  }
  
  void updateShapes(PImage image) {
    
    for (FPoly poly : polys) {
      world.remove(poly);
    }
    polys.clear();
          
    for (Contour contour : ic.fromImage(image)) { 
      FPoly l = new FPoly();
      
      points = contour.getPoints();
      for (PVector p : points) {
         l.vertex(p.x, p.y);
      }
      l.setFill(174, 252, 0);
      l.setFriction(.2);
      l.setStatic(true);
      l.setNoStroke();
      polys.add(l);
      world.add(l);
    }
  }
}