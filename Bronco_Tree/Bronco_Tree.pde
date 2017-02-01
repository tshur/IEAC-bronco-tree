// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

Tree tree;
float min_dist = 10; // when a leaf is within this distance it is popped
float max_dist = 30; // leaves outside this distance are ignored

void setup() {
  // Function: setup
  // Description: setup() runs one time when the sketch is initialized

  size(600, 600); // creates the canvas to be width=600px by height=600px
  tree = new Tree();
}

void draw() {
  // Function: draw
  // Description: draw() runs one time every frame

  background(51); // Draw a gray (RGB: 51 51 51) background (overwrites sketch)
  tree.show();
  tree.grow();
}
