// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

class Branch {
  // Class: Branch
  // Description: A branch has a point position and a reference to a parent branch. New
  //		  branches are drawn from the point position to the parent's position

  Branch parent;
  PVector pos;
  PVector dir;
  int count = 0;
  PVector saveDir;
  float len = 5;

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
    pos = parent.next();
    dir = parent.dir.copy();
    saveDir = dir.copy();
  }

  void reset() {
    // Resets the branch to it's original state (may be shifted during the algorithm)
    count = 0;
    dir = saveDir.copy();
  }

  PVector next() {
    // Returns a vector pointing to the "endpoint" of the branch
    PVector v = PVector.mult(dir, len);
    PVector next = PVector.add(pos, v);
    return next;
  }
}
