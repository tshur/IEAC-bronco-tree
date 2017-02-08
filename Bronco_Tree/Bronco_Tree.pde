// Adapted from:
// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

Tree tree;
float min_dist = 10; // default: 10 when a leaf is within this distance it is popped
float max_dist = 50; // default: 50 leaves outside this distance are ignored
PImage blossom; // image for blossom
PImage branch_img;

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
  //branch_img = loadImage("http://us.123rf.com/450wm/dollapoom/dollapoom1505/dollapoom150500099/40326226-dark-tree-bark-texture.jpg?ver=6");
  // branch_img = loadImage("dark_bark_texture.jpg");
  branch_img = loadImage("http://previews.123rf.com/images/skif55/skif551302/skif55130200023/17724932-Dies-ist-eine-typische-gl-nzende-Rinde-Textur-von-einem-Kirschbaum-trunk-Lizenzfreie-Bilder.jpg");
  
  imageMode(CENTER); // images are drawn from the center
  rectMode(CENTER);
}

void draw() {
  // Function: draw
  // Description: draw() runs one time every frame

  surface.setTitle(int(frameRate) + " fps");

  //background(230); // Draw a gray (RGB: 230 230 230) background (overwrites sketch)
  tree.show();
  tree.grow();
}

int distance = 40; // default 40; radius around mouse inside which leaves randomly appear
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
  int timeframe = 5; // default 5; controls the rate at which new leaves are created
  // Function: mouseDragged
  // Description: mouseDragged() loops while the mouse is held down and moving. Holding
  //              the mouse button down in one place will not loop this function.
  int randomX = (int) ( Math.random() * distance ) - distance/2;
  int randomY = (int) ( Math.random() * distance ) - distance/2;
  
  if( (int)( Math.random() * timeframe ) == 0 ) {
    tree.newLeaf(new PVector(mouseX + randomX, mouseY + randomY));
  }
}