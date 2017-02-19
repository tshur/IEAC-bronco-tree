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

Tree tree;
float min_dist = 40; // when a leaf is within this distance it is popped
float max_dist = 300; // leaves outside this distance are ignored
PImage blossom; // image for blossom
PImage branch_img;
float y_rot = 0;

color BRANCH_BROWN = color(50,39,25);

void setup() {
  // Function: setup
  // Description: setup() runs one time when the sketch is initialized

  size(600, 600, P3D); // creates the canvas to be width=600px by height=600px
  cam = new PeasyCam(this, width/2, height/2 - 50, 0, width);
  cam.setActive(false);
  
  background(200);
  tree = new Tree();
  
  //blossom = loadImage("http://www.emoji.co.uk/files/twitter-emojis/animals-nature-twitter/10730-cherry-blossom.png");
  // blossom = loadImage("cherry-blossom2.png");
  
  // branch_img = loadImage("http://2.bp.blogspot.com/-cgMIsh6MNho/UOsCYA7Xq1I/AAAAAAAAAp0/d7ZVbXA6XHU/s1600/Oak_Bark.jpg");
  //branch_img = loadImage("http://us.123rf.com/450wm/dollapoom/dollapoom1505/dollapoom150500099/40326226-dark-tree-bark-texture.jpg?ver=6");
  // branch_img = loadImage("dark_bark_texture.jpg");
  
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
  background(200);
  surface.setTitle(int(frameRate) + " fps");

  float rot_rate = radians(0.5);
  cam.rotateY(rot_rate);
  y_rot = (y_rot + rot_rate) % TWO_PI;
  //background(230); // Draw a gray (RGB: 230 230 230) background (overwrites sketch)
  
  tree.show();
  tree.grow();
  
  //tube.setSize(TOP_RAD, BOT_RAD)
  //tube.setSize(5, 5, 8, 8);
  //tube.setWorldPos(END POS, START POS (bottom))
  //tube.setWorldPos( new PVector(0,-15,0), new PVector(0,0,0) );
  //tube.draw();
  
  stroke(255,0,0); //red, x-axis
  line(0,0,0,500,0,0);
  stroke(0,255,0); //green, y-axis
  line(0,0,0,0,500,0);
  stroke(0,0,255); //blue, z-axis
  line(0,0,0,0,0,500);
  
  
}

int distance = 60; //default 40
void mousePressed() {
  // Function: mousePressed
  // Description: mousePressed() runs when the mouse button is clicked down. Note:
  //              if the mouse is clicked and held, but not necessarily released, 
  //              this function will have run only once.
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  //pushMatrix();
  //translate(cam.getLookAt()[0], cam.getLookAt()[1], cam.getLookAt()[2]);
  //rotateY(y_rot);
  
  //translate(mouseX - width / 2 + randomX, mouseY - height / 2 + randomY, 0);
  float x = cam.getLookAt()[0] + cos(-y_rot)*(mouseX + randomX - width/2);
  float y = cam.getLookAt()[1] + mouseY + randomY - height/2;
  float z = cam.getLookAt()[2] + sin(-y_rot)*(mouseX + randomX - width/2);
  tree.newLeaf(new PVector(x, y, z)); // adds a new leaf to the tree with current mouse position  
}

void mouseDragged() {
  int timeframe = 4; // default 5
  // Function: mouseDragged
  // Description: mouseDragged() loops while the mouse is held down and moving. Holding
  //              the mouse button down in one place will not loop this function.
  //int randomX = (int) ( Math.random() * distance ) - distance/2;
  //int randomY = (int) ( Math.random() * distance ) - distance/2;
  
  //if( (int)( Math.random() * timeframe ) == 0 ) {
    //mouseClicked();
    //tree.newLeaf(new PVector(mouseX + randomX, mouseY + randomY, 0));
  //}
  if( (int)( Math.random() * timeframe ) == 0 ) {
    int randomX = (int) ( Math.random() * distance ) - distance/2;
    int randomY = (int) ( Math.random() * distance ) - distance/2;
    float x = cam.getLookAt()[0] + cos(-y_rot)*(mouseX + randomX - width/2);
    float y = cam.getLookAt()[1] + mouseY + randomY - height/2;
    float z = cam.getLookAt()[2] + sin(-y_rot)*(mouseX + randomX - width/2);
    tree.newLeaf(new PVector(x, y, z));
  }
}