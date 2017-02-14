// Adapted from:
// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY
import processing.video.*;

Tree tree;
float min_dist = 10; // when a leaf is within this distance it is popped
float max_dist = 50; // leaves outside this distance are ignored
PImage blossom; // image for blossom
PImage branch_img;

Capture video;

color BRANCH_BROWN = color(50,39,25);

void setup() {
  // Function: setup
  // Description: setup() runs one time when the sketch is initialized

  size(600, 600, P2D); // creates the canvas to be width=600px by height=600px
  smooth(4); // smooth(level) is level-x anti-aliasing. Default for P2D is 2x. noSmooth() turns off
  
  background(255);
  tree = new Tree();
  
  blossom = loadImage("http://www.emoji.co.uk/files/twitter-emojis/animals-nature-twitter/10730-cherry-blossom.png");
  // blossom = loadImage("cherry-blossom2.png");
  
  // branch_img = loadImage("http://2.bp.blogspot.com/-cgMIsh6MNho/UOsCYA7Xq1I/AAAAAAAAAp0/d7ZVbXA6XHU/s1600/Oak_Bark.jpg");
  branch_img = loadImage("http://us.123rf.com/450wm/dollapoom/dollapoom1505/dollapoom150500099/40326226-dark-tree-bark-texture.jpg?ver=6");
  // branch_img = loadImage("dark_bark_texture.jpg");
  
  video = getCam();
  //video = new Capture(this, 2048, 1536, 30);
  video.start();
  
  imageMode(CENTER); // images are drawn from the center
  rectMode(CENTER);
}

Capture getCam(){
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
    for (int i = 0; i < cameras.length; i++) {
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
      }
      println(cameras[i]);
    }
    println("Camera initialized at " + camWidth + "x" + camHeight);
    Capture cam = new Capture(this, camWidth , camHeight);
    return cam;
  }
}

void draw() {
  if(video.available()){
    video.read();
  }
  // Function: draw
  // Description: draw() runs one time every frame

  surface.setTitle(int(frameRate) + " fps");

  // Draw tree-related stuff
  //background(230); // Draw a gray (RGB: 230 230 230) background (overwrites sketch)
  //tree.show();
  //tree.grow();
  
  // Draw video related stuff
  image(video, 0, 0);
}

int distance = 60; //default 40
void mousePressed() {
  // Function: mousePressed
  // Description: mousePressed() runs when the mouse button is clicked down. Note:
  //              if the mouse is clicked and held, but not necessarily released, 
  //              this function will have run only once.
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  tree.newLeaf(new PVector(mouseX + randomX, mouseY + randomY)); // adds a new leaf to the tree with current mouse position
}

void mouseDragged() {
  int timeframe = 4; // default 5
  // Function: mouseDragged
  // Description: mouseDragged() loops while the mouse is held down and moving. Holding
  //              the mouse button down in one place will not loop this function.
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  
  if( (int)( Math.random() * timeframe ) == 0 ) {
    tree.newLeaf(new PVector(mouseX + randomX, mouseY + randomY));
  }
}