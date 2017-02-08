//
// File: tree.pde
// Created by: Tim Shur, Julian Callin, and Isaac Sornborger
//
// IMPLEMENTS: The Tree class
// Description: This class manages all of the branches and leaves in the sketch. A
// tree controls the growing of all branches and leaves in the grow() function.
//

class Tree {
  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();

  Tree() {
    // CONSTRUCTOR: Creates a tree
    // Description: This creates a population of leaves and a root branch. Then,
    //              a trunk is extended from the bottom until it is within max_dist
    //              of any leaf.

    for (int i = 0; i < 1000; i++) {  // default value: 20000
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

  boolean closeEnough(Branch branch) {
    // Function: closeEnough(Branch branch)
    // Postcondition: Returns whether or not branch is within max_dist of any leaf

    for (Leaf leaf : leaves) {
      float distance_to_leaf = PVector.dist(branch.pos, leaf.pos);
      if (distance_to_leaf < max_dist) {
        return true;
      }
    }
    return false;
  }

  void grow() {
    // Function: grow()
    // Postcondition: The leaves have been updated and potentially removed from the list.
    // Leaves that have been reached have grown. A set of new branches has been created.
    // All branches and leaves are drawn on the canvas.
    
    // for each leaf, find the closest branch to that leaf
    for (int i = leaves.size() - 1; i >= 0; i--) {
      Leaf leaf = leaves.get(i);
      Branch closest = null;
      PVector closestDir = null;
      float record = -1;

      // look for the closest branch to the leaf
      for (Branch branch : branches) {
        PVector dir = PVector.sub(leaf.pos, branch.pos);
        float distance_to_leaf = dir.mag(); // d is the distance between the leaf and branch
        if (branch.num_children > 0) // segments with no children, i.e., terminal branches
          distance_to_leaf *= 1.05; // higher the value, the more likely the terminal branches will seek leaves
        if (distance_to_leaf < min_dist) {
          if (leaf.bad_leaf) // cull out a percentage of leaves
            leaves.remove(i);
          else
            leaf.reached();
          closest = null;
          break;
        } else if (distance_to_leaf > max_dist) { // disregard branches that are too far away

        } else if (closest == null || distance_to_leaf < record) {
          closest = branch;
          closestDir = dir;
          record = distance_to_leaf;
        }
      }
      if (closest != null) {
        // closest is the branch closest to the current leaf
        closestDir.normalize();
        closestDir.mult(random(0.8, 1.2)); // slightly randomize movement toward the leaf
        closest.dir.add(closestDir);
        closest.closest_count++;
      }
    }

    // check all leaves for expiration or blooming
    for (int i = leaves.size()-1; i >= 0; i--) {
      if (leaves.get(i).bloomed || leaves.get(i).shouldExpire ) {
        leaves.remove(i);
      }
    }

    // add a round of new branches from parents which are closest to some leaves
    for (int i = branches.size()-1; i >= 0; i--) {
      Branch branch = branches.get(i);
      if (branch.closest_count > 0) { // if this branch is closest to any leaves
        branch.dir.normalize();
        Branch newB = new Branch(branch);
        branches.add(newB);
        branch.reset();
      }
    }
  }

  void show() {
    // Function: show()
    // Postcondition: All leaves and branches have been drawn on the sketch
    
    for (Leaf leaf : leaves) { // display all leaves
      leaf.show();
    }
    
    updateBranchThickness(branches); // update the radius of each branch
    
    for (Branch branch : branches) { // display all branches
      if (branch.parent != null) {
        branch.show();
        branch.radius = 0; // reset branch radii to zero for next calculation
      }
    }
  }
  
  void updateBranchThickness(ArrayList<Branch> branches) {
    // Function: updateBranchThickness(ArrayList<Branch> branches)
    // Postcondition: All branches have new radii according to their children. Calculation
    // starts from the terminal branches with no children (tips). Calculation continues, adding
    // thickness every time two branches merge (in this case, the parent has two children).
    // Formula for radius of branch merges is parent^2 = child1^2 + child2^2.
    
    float TIP_RADIUS = 0.8; // radius of the terminal branches
    float GROW_RATE = 0.015; // growth rate as a single branch extends
    float EXP_RATE = 2.5;   // exponent for branch merge calculation (typically between 2-3)

    // loop backwards to ensure child branches come before parent branches
    for (int i = branches.size() - 1; i >= 0; i--) { // SLOW: calculate branch thicknesses
      Branch branch = branches.get(i);
      if (branch.parent != null) {
        // compute current branch radius
        if (branch.num_children == 0)
          branch.radius = TIP_RADIUS;
        else if (branch.num_children >= 2) // square root parent radius
          branch.radius = (float) Math.pow(branch.radius, 1/(EXP_RATE));
        
        // compute parent branch radius
        if (branch.parent.num_children >= 2) // signals a merge of two children
          branch.parent.radius += Math.pow(branch.radius, EXP_RATE); // add powers of children radii to parent
        else
          branch.parent.radius = branch.radius + GROW_RATE; // linear growth along a single branch
      }
    }
  }
  
  void newLeaf(PVector position) {
    // Function: newLeaf(PVector position)
    // Postcondition: A new leaf with given position has been added to the array.
    
    leaves.add(new Leaf(position));
  }
}