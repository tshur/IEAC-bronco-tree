// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

class Leaf {
  // Class: leaf
  // Description: A leaf is essentially a point; it is defined by a position vector
  PVector pos;
  boolean reached = false; // has this leaf been reached by a branch yet
  boolean bloomed = false;
  boolean bad_leaf = random(1) < 0.2; // bad_leaves do not grow after they are reached
  float radius = 2;
  float rotation = random(0, HALF_PI);
  float BLOOM_RADIUS = random(3, 5);
  color col = color(255, 183, 197);
  boolean shouldExpire = false;     // NEW
  long creationTime;                // NEW

  void changeCol(){
    if(random(1) < 0.3)
      col = color(255, 255, 255);
  }
  
  Leaf() {
    changeCol();
    // Constructor creates a leaf with a random position
    pos = PVector.random3D(); // creates a random 2D vector
    pos.mult( sqrt( random(width*width/4) ) ); // uniform disk
    pos.x += width/2;
    pos.y += 2.0/5*height;
    pos.y *= 0.9;
    creationTime = System.currentTimeMillis(); // NEW creation time
    //pos = new PVector(random(10, width-10), random(10, height-40));
  }

  Leaf(PVector pos_) {
    changeCol();
    // Constructor creates a leaf with given position
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
    // Function: show
    // Description: Draws the leaf (point) onto the canvas

      // fill(col); // Fills the point with a color (white: 255 255 255)
      // stroke(color(red(col)*0.8, green(col)*0.8, blue(col)*0.8)); // Stroke is the outline of a drawing
      // strokeWeight(1);
   
      // PETAL DRAWING
      pushMatrix(); // stores the current drawing frame
      translate(pos.x, pos.y);
      rotate(rotation);
      image(blossom, 0, 0, radius * 2, radius * 2);
      //ellipse(-radius, 0, radius * 2, radius); // left
      //ellipse( radius, 0, radius * 2, radius); // right
      //ellipse(0, -radius, radius, radius * 2); // top
      //ellipse(0,  radius, radius, radius * 2); // bot
      popMatrix(); // returns to last pushed drawing frame
    
      //fill(253, 240, 43);
      //noStroke();
      //ellipse(pos.x, pos.y, radius / 2, radius / 2);
    
    if( System.currentTimeMillis() - creationTime >= 5000 ) {  // NEW check for expiration after show
       shouldExpire = true; 
    }
  }
  
  void show3D() {
      // PETAL DRAWING
      fill(col);
      noStroke();
      //stroke(230, 170, 180);
      pushMatrix(); // stores the current drawing frame
      translate(pos.x, pos.y, pos.z);
      box(radius);
      popMatrix(); // returns to last pushed drawing frame
    
      //fill(253, 240, 43);
      //noStroke();
      //ellipse(pos.x, pos.y, radius / 2, radius / 2);
    
    if( System.currentTimeMillis() - creationTime >= 1000 ) {  // NEW check for expiration after show
       shouldExpire = true; 
    }
  }
  
  void grow() {
    radius += BLOOM_RADIUS / 30.0;
  }
}