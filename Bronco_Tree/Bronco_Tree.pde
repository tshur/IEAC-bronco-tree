// Adapted from:
// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY
import peasy.*;

import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

PeasyCam cam;
Tube tube;

// Used for webcam
import processing.video.*;

// Tree
Tree tree;
float min_dist = 40; // when a leaf is within this distance it is popped
float max_dist = 150; // leaves outside this distance are ignored
PImage blossom; // image for blossom
PImage branch_img;
float y_rot = 0;

color BRANCH_BROWN = color(50,39,25);

// Video
Capture video;
color trackColor;

// Computer vision
ArrayList<Blob> blobs = new ArrayList<Blob>();


void setup() {
  // Function: setup
  // Description: setup() runs one time when the sketch is initialized

  size(600, 600, P3D); // creates the canvas to be width=600px by height=600px
  cam = new PeasyCam(this, width/2, height/2 - 50, 0, width);
  cam.setActive(false);
  
  tree = new Tree();
  
  //blossom = loadImage("http://www.emoji.co.uk/files/twitter-emojis/animals-nature-twitter/10730-cherry-blossom.png");
  // blossom = loadImage("cherry-blossom2.png");
  
  // branch_img = loadImage("http://2.bp.blogspot.com/-cgMIsh6MNho/UOsCYA7Xq1I/AAAAAAAAAp0/d7ZVbXA6XHU/s1600/Oak_Bark.jpg");
  //branch_img = loadImage("http://us.123rf.com/450wm/dollapoom/dollapoom1505/dollapoom150500099/40326226-dark-tree-bark-texture.jpg?ver=6");
  // branch_img = loadImage("dark_bark_texture.jpg");
  
  // Video set up
  video = getCam();
  video.start();
  trackColor = color(150, 35, 82);
  
  imageMode(CENTER); // images are drawn from the center
  rectMode(CENTER);
  
  tube = new Tube(this, 1, 8);
  tube.setSize(25, 25, 25, 25);
  tube.fill(BRANCH_BROWN);
  tube.fill(BRANCH_BROWN, Tube.BOTH_CAP);
}

void draw() {
  // Function: draw
  // Description: draw() runs one time every frame
  surface.setTitle(int(frameRate) + " fps");
  lights();

  // Draw tree-related stuff
  background(230); // Draw a gray (RGB: 230 230 230) background (overwrites sketch)
  
  
  // Draw video/CV related stuff
  imageMode(CORNER);
  video.loadPixels();
  //tint(255, 20);
  image(video, 0, 0);
  imageMode(CENTER);
  renderBlobs();
  addBlobLeaves();
  
  // Camera view setup
  float ROTATION_RATE = radians(0.5);
  cam.rotateY(ROTATION_RATE);
  y_rot = (y_rot + ROTATION_RATE) % TWO_PI;
  
  tree.show();
  tree.grow();
  
  stroke(255,0,0); //red, x-axis
  line(0,0,0,500,0,0);
  stroke(0,255,0); //green, y-axis
  line(0,0,0,0,500,0);
  stroke(0,0,255); //blue, z-axis
  line(0,0,0,0,0,500);
}

void renderBlobs(){
    blobs.clear();
    int colorThreshold = 20;
    // Loop through every pixel, seeing if it is within the color range to be detected
    for(int x = 0; x < video.width; x++){
      for(int y = 0; y < video.height; y++){
        int loc = x + y * video.width;
        // Get current color
        color currentColor = video.pixels[loc];
        float r1 = red(currentColor);
        float g1 = green(currentColor);
        float b1 = blue(currentColor);
        float r2 = red(trackColor);
        float g2 = green(trackColor);
        float b2 = blue(trackColor);
        
        // Determine how close in color the current pixel is to the threshold
        float d = distSq(r1, g1, b1, r2, g2, b2);
        
        // If the color is within the threshold, try and find a nearby blob to add the pixel to
        if (d < colorThreshold * colorThreshold){
          boolean found = false;
          for(Blob b : blobs){
            if (b.isNear(x, y)){
              b.add(x, y);
              found = true;
              break;
            }
          }
          
          // If no blob is found, make a new blob with that pixel
          if(!found){
            Blob b = new Blob(x, y);
            blobs.add(b);
          }
        } 
      }
    } 
    // Render all blob rectangles
    for(Blob b : blobs){
      //if(b.size() > 150){
        //b.show();
      //}
    }
}

void captureEvent(Capture video){
    video.read();
}

int distance = 30; //default 40
void mousePressed() {
  // Function: keyPressed
  // Description: keyPressed() runs when the mouse button is clicked down. Note:
  //              if the mouse is clicked and held, but not necessarily released, 
  //              this function will have run only once.

  if(mouseButton == RIGHT){
    // Mouse functionality for blob color selection
    int loc = mouseX + mouseY*video.width;
    trackColor = video.pixels[loc];
    print(red(trackColor) + " " + green(trackColor) + " " + blue(trackColor) + " ");
  }
  if(mouseButton == LEFT){
    // Mouse functionality for tree drawing
    float x = cam.getLookAt()[0] + cos(-y_rot)*(mouseX + randomX - width/2);
    float y = cam.getLookAt()[1] + mouseY + randomY - height/2;
    float z = cam.getLookAt()[2] + sin(-y_rot)*(mouseX + randomX - width/2);
    tree.newLeaf(new PVector(x, y, z)); // adds a new leaf to the tree with current mouse position  
  }
}

void mouseDragged() {
  int timeframe = 8; // default 5
  // Function: mouseDragged
  // Description: mouseDragged() loops while the mouse is held down and moving. Holding
  //              the mouse button down in one place will not loop this function.

  if( (int)( Math.random() * timeframe ) == 0 ) {
    int randomX = (int) ( Math.random() * distance ) - distance/2;
    int randomY = (int) ( Math.random() * distance ) - distance/2;
    float x = cam.getLookAt()[0] + cos(-y_rot)*(mouseX + randomX - width/2);
    float y = cam.getLookAt()[1] + mouseY + randomY - height/2;
    float z = cam.getLookAt()[2] + sin(-y_rot)*(mouseX + randomX - width/2);
    tree.newLeaf(new PVector(x, y, z));
  }
}

void addBlobLeaves() {
  int timeframe = 2;
  
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  
  if( (int)( Math.random() * timeframe ) == 0 ) {
    for (Blob b : blobs) {
      if (b.size() > 30)
      tree.newLeaf(new PVector(b.get_center_x() + randomX, b.get_center_y() + randomY));
    }
  }
}