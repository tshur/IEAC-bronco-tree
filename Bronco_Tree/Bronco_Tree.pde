//
// File: Bronco_Tree.pde
// Created by: Tim Shur, Julian Callin, and Isaac Sornborger
//
// Description: This is the main file to run the Bronco_Tree sketch.
//

Tree tree;
float min_dist = 10; // default: 10 when a leaf is within this distance it is popped
float max_dist = 50; // default: 50 leaves outside this distance are ignored
PImage blossom; // image for blossom
PImage branch_img;

void setup() {
  // Function: setup()
  // Description: setup() runs one time when the sketch is initialized
  // Postcondition: The canvas and rendered have been initialized and images pre-loaded.

  size(600, 600, P2D); // creates the canvas to be width=600px by height=600px
  smooth(4); // smooth(level) is level-x anti-aliasing. Default for P2D is 2x. noSmooth() turns off
  
  background(255);
  tree = new Tree();
  
  blossom = loadImage("http://www.emoji.co.uk/files/twitter-emojis/animals-nature-twitter/10730-cherry-blossom.png");
  branch_img = loadImage("http://previews.123rf.com/images/skif55/skif551302/skif55130200023/17724932-Dies-ist-eine-typische-gl-nzende-Rinde-Textur-von-einem-Kirschbaum-trunk-Lizenzfreie-Bilder.jpg");
  
  imageMode(CENTER); // images are drawn from the center
  rectMode(CENTER);
}

void draw() {
  // Function: draw()
  // Description: This function is called one time every frame
  // Postcondition: The tree has been shown and then updated.

  surface.setTitle(int(frameRate) + " fps");

  tree.show();
  tree.grow();
}

int distance = 40; // default 40; radius around mouse inside which leaves randomly appear
void mousePressed() {
  // Function: mousePressed()
  // Description: This function is called when the mouse button is clicked down. Note:
  //              if the mouse is clicked and held, but not necessarily released, 
  //              this function will have run only once.
  // Postcondition: A new leaf has been created randomly within distance of the mouse.
  
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  tree.newLeaf(new PVector(mouseX + randomX, mouseY + randomY));
}

void mouseDragged() {
  // Function: mouseDragged
  // Description: This function loops while the mouse is held down and moving. Holding
  //              the mouse button down in one place will not loop this function.
  // Postcondition: Randomly creates leaves within distance away from the mouse
  
  int timeframe = 5; // default 5; controls the rate at which new leaves are created
  
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  
  if( (int)( Math.random() * timeframe ) == 0 ) {
    tree.newLeaf(new PVector(mouseX + randomX, mouseY + randomY));
  }
}