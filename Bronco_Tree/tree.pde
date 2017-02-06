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

    for (int i = 0; i < 100; i++) {  // should be 2000 for OG Tree
      leaves.add(new Leaf());
    }
    
    // Creating the root branch with dir pointing straight upwards
    Branch root = new Branch(new PVector(width/2, height + 5), new PVector(0, -1));
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
    for (int i = leaves.size() - 1; i >= 0; i--) {
      Leaf l = leaves.get(i);
      Branch closest = null; // closest branch to Leaf l
      PVector closestDir = null;
      float record = -1;

      for (Branch b : branches) {
        PVector dir = PVector.sub(l.pos, b.pos);
        float d = dir.mag(); // d is the distance between the leaf and branch
        if (b.num_children > 0) // segments inside branches less likely to link to leaves
          d *= 1.05; // higher the value, the more likely the terminal branches will seek leaves
        if (d < min_dist) { // a branch has reached the leaf
          if (l.bad_leaf)
            leaves.remove(i);
          else
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
        closestDir.mult(random(0.8, 1.2));
        closest.dir.add(closestDir); // add direction of leaf to branch dir
        closest.count++; // increment count (holds the number of closest leaves)
      }
    }

    // check all leaves
    for (int i = leaves.size()-1; i >= 0; i--) {
      // if a leaf is reached by a branch, remove it from further consideration
      if (leaves.get(i).bloomed || leaves.get(i).shouldExpire ) {  // added expiration to removal check
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
    float TIP_RADIUS = 0.2; // radius of the terminal branches
    float GROW_RATE = 0.015; // growth rate as a single branch extends
    float EXP_RATE = 2;   // exponent for branch merge calculation (typically between 2-3)
    
    // TO BE MOVED INTO A SEPARATE FUNCTION TO CALCULATE BRANCH RADII
    // loop backwards to ensure child branches come before parent branches
    for (int i = branches.size() - 1; i >= 0; i--) { // calculate branch thicknesses
      Branch b = branches.get(i);
      if (b.parent != null) {
        // slow method to compute so many squares and square roots
        if (b.num_children == 0) { // reset terminal branch radius
          b.radius = TIP_RADIUS;
        } else if (b.num_children >= 2) { // root parent radius to get desired radius
          b.radius = (float) Math.pow(b.radius, 1/EXP_RATE);
        }
        
        if (b.parent.num_children >= 2) { // signals a parent branch
          // b.parent.radius += b.radius * 0.9;
          b.parent.radius += Math.pow(b.radius, EXP_RATE); // add powers of children radii to parent
        } else {
          b.parent.radius = b.radius + GROW_RATE; // linear growth along a single branch
        }
        
        
        //stroke(255);
        //strokeWeight((float)Math.pow(b.radius, 1/2.4) * 2.0);
        //line(b.pos.x, b.pos.y, b.parent.pos.x, b.parent.pos.y);
      }
    }
    // stroke(50,39,25);
    noStroke();
    fill(50, 39, 25);
    // draw branches
    for (Branch b : branches) {
      if (b.parent != null) {
        // strokeWeight((float)Math.pow(b.radius, 1/(EXP_RATE + 0.5)) * 2.0);
        //strokeWeight(b.radius * 2);
        //line(b.pos.x, b.pos.y, b.parent.pos.x, b.parent.pos.y);
        rectMode(CENTER);
        pushMatrix();
        //translate(b.pos.x + (b.dir.x * b.len * 0.5), b.pos.y + (b.dir.y * b.len * 0.5));
        translate(b.pos.x, b.pos.y);
        rotate(b.saveDir.heading() - HALF_PI);
        rect(0, 0, b.radius * 2, b.len + b.radius);
        popMatrix();
        
        b.radius = 0; // reset branch radii to zero for next calculation
      }
    }
  }
  
  void newLeaf(PVector pos) {
    leaves.add(new Leaf(pos));
  }
}