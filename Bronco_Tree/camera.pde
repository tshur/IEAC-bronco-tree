Capture getCam(){
  // Reads camera information to the console, searches for the highest resolutuion camera, and returns it
  String[] cameras = Capture.list();
   int camWidth = 0;
   int camHeight = 0;
   
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
    return new Capture(this, 0, 0);
  } 
  else {
    println("Available cameras:");
    // Search for the best camera
    for (int i = cameras.length - 1; i >= 0; i--) {
      // Search where the fps number is
      int p = cameras[i].indexOf("fps=");
      // Search where the width begins
      int q = cameras[i].indexOf("size=");
      // Search where the width ends and height begins
      int r = cameras[i].indexOf("x");
      // Search where the height ends
      int s = cameras[i].indexOf(",fps");
   
      //println("fps= " + cameras[i].substring(p+4));
      // transforms the numeral string into an int
      int fps = Integer.parseInt(cameras[i].substring(p+4));
   
      //println("width= " + cameras[i].substring(q+5, r));
      //println("height= " + cameras[i].substring(r+1, s));

      // test the fps... I'm not overly picky.
      if ( fps > 20) {
        // if the fps is faster than 20, select it as camera height&width!
        camWidth = Integer.parseInt(cameras[i].substring(q+5, r));
        camHeight = Integer.parseInt(cameras[i].substring(r+1, s));
        if (camWidth == width)
          break;
      }
      println(cameras[i]);
    }
    println("Camera initialized at " + camWidth + "x" + camHeight);
    Capture cam = new Capture(this, camWidth , camHeight);
    return cam;
  }
}