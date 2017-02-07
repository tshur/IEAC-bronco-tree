// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

float TEXTURE_STEP = 20;

class Branch {
  // Class: Branch
  // Description: A branch has a point position and a reference to a parent branch. New
  //		  branches are drawn from the point position to the parent's position

  Branch parent;
  PVector pos;
  PVector dir;
  int count = 0;
  PVector saveDir;
  float len = 4;
  int num_children = 0; // keep track of the number of children per branch segment
  float radius = 0;
  float offset = 0;
  
  float texture_index = 0;

  Branch(PVector v, PVector d) {
    // Constructor for the root branch
    parent = null;
    pos = v.copy(); // copy() is necessary to avoid having pos and v be pointers to the
		    // same vector object. Otherwise, changing v would change pos.
    dir = d.copy();
    saveDir = dir.copy();
  }

  Branch(Branch p) {
    // Constructor for new branches; pass in parent branch as an argument
    parent = p;
    p.num_children++;
    pos = parent.next();
    dir = parent.dir.copy();
    saveDir = dir.copy();
    texture_index = (p.texture_index + TEXTURE_STEP) % 290;
  }

  void reset() {
    // Resets the branch to it's original state (may be shifted during the algorithm)
    count = 0;
    dir = saveDir.copy();
  }
  
  void show() {
    //PVector offsetPos = pos;
    computeOffset();
    // stroke(BRANCH_BROWN);
    noStroke();
    fill(BRANCH_BROWN);
    
    // strokeWeight((float)Math.pow(b.radius, 1/(EXP_RATE + 0.5)) * 2.0);
    // strokeWeight(b.radius * 2);
    // line(b.pos.x, b.pos.y, b.parent.pos.x, b.parent.pos.y);
    pushMatrix();
    // translate(b.pos.x + (b.dir.x * b.len * 0.5), b.pos.y + (b.dir.y * b.len * 0.5));
    // translate(0.5*pos.x + 0.5*parent.pos.x, 0.5*pos.y + 0.5*parent.pos.y);
    //translate(offsetPos.x, offsetPos.y);
    translate(pos.x, pos.y-offset);
    rotate(saveDir.heading() + PI/2);
    // rect(0, 0, radius * 2, len);
    beginShape();
    texture(branch_img);
    vertex(-radius, 0, 0, texture_index);
    vertex( radius, 0, branch_img.width, texture_index);
    vertex( radius, len+offset, branch_img.width, texture_index + TEXTURE_STEP);
    vertex(-radius, len+offset, 0, texture_index + TEXTURE_STEP);
    endShape();
    popMatrix();
  }
  
  void computeOffset() {
    float angle = ( parent.saveDir.heading() + PI/2 ) - ( this.saveDir.heading() + PI/2 );
    if ( this.parent != null ) {
       if ( angle > PI/2 ) {
           offset = atan( angle ) * this.radius - ( parent.radius * atan( angle ) );
       } 
       if ( angle < PI/2 ) {
           offset = atan( angle ) * this.radius;
       } 
    }
    offset += radius;
  }

  PVector next() {
    // Returns a vector pointing to the "endpoint" of the branch
    PVector v = PVector.mult(dir, len);
    PVector next = PVector.add(pos, v);
    return next;
  }
}