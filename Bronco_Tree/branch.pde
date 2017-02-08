//
// File: branch.pde
// Created by: Tim Shur, Julian Callin, and Isaac Sornborger
//
// IMPLEMENTS: The Branch class
// Description: A branch has a point position and a reference to a parent branch. New
// branches are drawn from the point position to the parent's position. While the branch
// is drawn with thickness, all calculations are done with reference to the point position.
//

float TEXTURE_STEP = 20; // step to extend a texture across multiple branch segments

class Branch {
  Branch parent;
  PVector pos;
  PVector dir;
  PVector saveDir;
  int closest_count = 0;
  int num_children = 0; // keep track of the number of children per branch segment
  float len = 4;
  float radius = 0;
  
  float texture_index = 0;

  Branch(PVector position, PVector direction) {
    // CONSTRUCTOR: Creates the root branch
    // Postcondition: A new root branch has been created
    
    parent = null;
    pos = position.copy(); // copy() is necessary to avoid having pos and v be pointers to the
		    // same vector object. Otherwise, changing v would change pos.
    dir = direction.copy();
    saveDir = dir.copy();
  }

  Branch(Branch parent_) {
    // CONSTRUCTOR: Creates a new branch; pass in parent branch as an argument
    // Postcondition: A new branch has been created from a parent branch
    
    parent = parent_;
    parent_.num_children++;
    pos = parent.next();
    dir = parent.dir.copy();
    saveDir = dir.copy();
    texture_index = (parent_.texture_index + TEXTURE_STEP) % 1000;
  }

  void reset() {
    // Function: reset()
    // Postcondition: The branch direction (dir) has been reset to its original state,
    // as it may be changed to create new branches. closest_count is reset to 0.
    
    closest_count = 0;
    dir = saveDir.copy();
  }
  
  void show() {
    // Function: show()
    // Postcondition: The branch has been drawn onto the sketch.
    
    noStroke();
    pushMatrix(); // saves the current translation and rotation
    translate(pos.x, pos.y); // shifts the coordinate axes
    rotate(saveDir.heading() + PI/2); // rotates the coordinate axes
    
    beginShape(); // build a shape vertex by vertex
    texture(branch_img);
    vertex(-radius, 0, 0, 1000 - texture_index);
    vertex( radius, 0, branch_img.width, 1000 - texture_index);
    vertex( radius, len, branch_img.width, 1000 - texture_index - TEXTURE_STEP);
    vertex(-radius, len, 0, 1000 - texture_index - TEXTURE_STEP);
    endShape();
    
    popMatrix(); // returns to previous translation and rotation
  }

  PVector next() {
    // Function: next()
    // Postcondition: A vector pointing to the position of the next branch has been returned.
    
    PVector v = PVector.mult(dir, len);
    PVector next = PVector.add(pos, v);
    return next;
  }
}