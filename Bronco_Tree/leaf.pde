//
// File: leaf.pde
// Created by: Tim Shur, Julian Callin, and Isaac Sornborger
//
// IMPLEMENTS: The Leaf class
// Description: A leaf is defined by a position vector. A leaf has three states: its
// original state, its reached state, and its bloomed state. When a leaf hasn't been
// reached, it is considered in all tree-growing calculations and is part of the leaves
// array list. Once a leaf is reached, it is no longer a part of calculations; instead,
// the leaf is added to a new array list, blossoms, and begins to grow. A leaf is bloomed
// when it has been reached and has finished growing.
//

class Leaf {
  PVector pos;
  float rotation = random(0, HALF_PI); // rotation of the drawn flower
  float radius = 1;
  float BLOOM_RADIUS = random(6, 12);  // final radius of a bloomed flower
  
  long creationTime;                // NEW
  boolean shouldExpire = false;     // NEW
  
  boolean reached = false;
  boolean bloomed = false;
  boolean bad_leaf = (random(1) < 0.6); // bad_leaves do not grow after they are reached

  Leaf() {
    // CONSTRUCTOR: Creates a leaf with a random position
    // Postcondition: A leaf has been created within a random uniform disk.
    
    pos = PVector.random2D(); // creates a random 2D vector
    pos.mult( sqrt( random(width*width/4) ) ); // uniform disk
    pos.x += width/2;
    pos.y += 2.0/5*height;
    pos.y *= 0.9;
    creationTime = System.currentTimeMillis(); // NEW creation time
  }

  Leaf(PVector pos_) {
    // CONSTRUCTOR: Creates a leaf with given position
    // Postcondition: A leaf has been created
    
    pos = pos_;
    creationTime = System.currentTimeMillis(); // NEW creation time
  }

  void reached() {
    reached = true;
    grow();
    if (radius >= BLOOM_RADIUS)
      bloomed = true;
  }

  void show() {
    // Function: show()
    // Postcondition: The leaf has been drawn onto the sketch
  
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    image(blossom, 0, 0, radius * 2, radius * 2);
    popMatrix();
    
    if( System.currentTimeMillis() - creationTime >= 5000 ) {  // NEW check for expiration after show
       shouldExpire = true; 
    }
  }
  
  void grow() {
    // Function: grow()
    // Postcondition: The leaf has grown a small amount
    
    radius += BLOOM_RADIUS / 30.0;
  }
}