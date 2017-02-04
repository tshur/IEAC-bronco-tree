// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

class Tree {
  // Class: Tree
  // Description: The Tree class manages all of the branches and leaves in the sketch.
  //		  This is also where most of the algorithm is

  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();

  Tree() {
    // Constructor: Tree
    // Description: This creates a population of leaves and a root branch. Then,
    //              a trunk is extended from the bottom until it is within max_dist
    //              of any leaf (essentially, this moves within the vicinity of leaves)

    for (int i = 0; i < 2000; i++) {  // should be 2000 for OG Tree
      leaves.add(new Leaf());
    }
    
    // Creating the root branch with dir pointing straight upwards
    Branch root = new Branch(new PVector(width/2, height), new PVector(0, -1));
    branches.add(root);
    Branch current = new Branch(root);

    // Extends the root upwards until the current branch is within max_dist of a leaf
    while (!closeEnough(current)) { 
      Branch trunk = new Branch(current);
      branches.add(trunk);
      current = trunk;
    }
  }

  boolean closeEnough(Branch b) {
    // Function: closeEnough
    // Description: Returns whether or not Branch b is within max_dist of any leaf

    for (Leaf l : leaves) {
      float d = PVector.dist(b.pos, l.pos);
      if (d < max_dist) {
        return true;
      }
    }
    return false;
  }

  void grow() {
    // Function: grow
    // Description: This function is the heart of the algorithm. grow() looks at each
    // 		    leaf and
    for (Leaf l : leaves) {
      Branch closest = null; // closest branch to Leaf l
      PVector closestDir = null;
      float record = -1;

      for (Branch b : branches) {
        PVector dir = PVector.sub(l.pos, b.pos);
        float d = dir.mag(); // d is the distance between the leaf and branch
        if (d < min_dist) { // a branch has reached the leaf
          l.reached();
          closest = null;
          break;
        } else if (d > max_dist) { // disregard branches that are too far away

        } else if (closest == null || d < record) {
	  // saves the record-closest branch to each leaf and sets closestDir to the
	  // vector between the leaf and branch
          closest = b;
          closestDir = dir;
          record = d;
        }
      }
      if (closest != null) { // if a leaf has a closest branch
        closestDir.normalize(); // normal vector in direction of leaf
        closest.dir.add(closestDir); // add direction of leaf to branch dir
        closest.count++; // increment count (holds the number of closest leaves)
      }
    }

    // check all leaves
    for (int i = leaves.size()-1; i >= 0; i--) {
      // if a leaf is reached by a branch, remove it from further consideration
      if (leaves.get(i).reached || leaves.get(i).shouldExpire ) {  // added expiration to removal check
        leaves.remove(i);
      }
    }

    // check all branches
    for (int i = branches.size()-1; i >= 0; i--) {
      Branch b = branches.get(i);
      if (b.count > 0) { // if this branch is closest to any leaves
        b.dir.div(b.count);
        b.dir.normalize(); // normal vector in a weighted direction towards close leaves
        Branch newB = new Branch(b); // new branch in this direction
        branches.add(newB);
        b.reset(); // reset Branch b to its original direction and reset count
      }
    }
  }

  void show() {
    for (Leaf l : leaves) { // display all leaves
      l.show(); // LEAF VISIBILITY
    }
    for (Branch b : branches) { // display all branches
      if (b.parent != null) {
        stroke(255);
        strokeWeight(3);
        line(b.pos.x, b.pos.y, b.parent.pos.x, b.parent.pos.y);
      }
    }
  }
  
  void newLeaf(PVector pos) {
    leaves.add(new Leaf(pos));
  }
}