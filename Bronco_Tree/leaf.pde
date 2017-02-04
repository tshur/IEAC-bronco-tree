// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

class Leaf {
  // Class: leaf
  // Description: A leaf is essentially a point; it is defined by a position vector
  PVector pos;
  boolean reached = false; // has this leaf been reached by a branch yet
  
  boolean shouldExpire = false;     // NEW
  long creationTime;                // NEW

  Leaf() {
    // Constructor creates a leaf with a random position
    pos = PVector.random2D(); // creates a random 2D vector
    pos.mult(random(width/2));
    pos.x += width/2;
    pos.y += 2.0/5*height;
    creationTime = System.currentTimeMillis(); // NEW creation time
    //pos = new PVector(random(10, width-10), random(10, height-40));
  }

  Leaf(PVector pos_) {
    // Constructor creates a leaf with given position
    pos = pos_;
    creationTime = System.currentTimeMillis(); // NEW creation time
  }

  void reached() {
    reached = true;
  }

  void show() {
    // Function: show
    // Description: Draws the leaf (point) onto the canvas

    fill(255); // Fills the point with a color (white: 255 255 255)
    noStroke(); // Stroke is the outline of a drawing
    ellipse(pos.x, pos.y, 4, 4); // draws an ellipse as (pos.x, pos.y) with "x-radius" 2
         // and "y-radius" 2
    if( System.currentTimeMillis() - creationTime >= 5000 ) {  // NEW check for expiration after show
       shouldExpire = true; 
    }
  }
}