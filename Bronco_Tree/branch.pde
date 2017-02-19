// Coding Rainbow
// Daniel Shiffman
// http://patreon.com/codingtrain
// Code for: https://youtu.be/kKT0v3qhIQY

float TEXTURE_STEP = 20;
int SIDES = 10;

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
  float fin_len = 5;
  int num_children = 0; // keep track of the number of children per branch segment
  float radius = 0;
  float offsetLength = 0;
  
  float texture_index = 0;
  
  float MAGNITUDE_RANDOMNESS = 0.1; // higher values make values differ by more
  float length_offset = 0; // offsets for perlin noise
  
  float angle = TWO_PI / SIDES;

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
    length_offset = p.length_offset + MAGNITUDE_RANDOMNESS;
  }

  void reset() {
    // Resets the branch to it's original state (may be shifted during the algorithm)
    count = 0;
    dir = saveDir.copy();
  }
  
  void show() {
    // stroke(BRANCH_BROWN);
    noStroke();
    fill(255, 0, 0);
    
    // strokeWeight((float)Math.pow(b.radius, 1/(EXP_RATE + 0.5)) * 2.0);
    // strokeWeight(b.radius * 2);
    // line(b.pos.x, b.pos.y, b.parent.pos.x, b.parent.pos.y);
    pushMatrix();
    // translate(b.pos.x + (b.dir.x * b.len * 0.5), b.pos.y + (b.dir.y * b.len * 0.5));
    // translate(0.5*pos.x + 0.5*parent.pos.x, 0.5*pos.y + 0.5*parent.pos.y);
    translate(pos.x, pos.y);
    rotate(saveDir.heading() + PI/2);
    // rect(0, 0, radius * 2, len);
    // radius *= noise(length_offset) + 0.5;
    
    beginShape();
    texture(branch_img);
    vertex(-radius, 0, 0, texture_index);
    vertex( radius, 0, branch_img.width, texture_index);
    vertex( radius, len, branch_img.width, texture_index + TEXTURE_STEP);
    vertex(-radius, len, 0, texture_index + TEXTURE_STEP);
    endShape();
    popMatrix();
  }
  
  void show3D_() {
    stroke(0, 255, 0);
    fill(BRANCH_BROWN);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(25);
    popMatrix();
  }
  
  void show3D() {
    //pushMatrix();
    offset_3D();
    //stroke(255);
    
    //tube.setTexture(branch_img);
    //tube.setTexture( branch_img, Tube.BOTH_CAP );
    
    
    //PVector diff = PVector.sub(saveDir, parent.saveDir).mult(parent.radius);
    //PVector normal = saveDir.cross(parent.saveDir);
    //PVector offset = diff.cross(normal);
    //if (offset.dot(saveDir) > 0)
      //offset.mult(-1);
    
    //tube.setSize(radius, radius, parent.radius, parent.radius, len + offset.mag());
    //tube.setWorldPos(pos, PVector.add(parent.pos, offset));
    
    PVector newPos = this.pos.copy();
    PVector newParentPos = this.parent.pos.copy();
    if( parent != null ) {
      //newPos = PVector.add( this.pos, PVector.sub( parent.dir, this.dir ) );
      PVector tmp = saveDir.copy(); tmp.normalize();
      PVector tmpP = parent.saveDir.copy(); tmpP.normalize();
      PVector diff = PVector.sub(tmp, tmpP);
      PVector normal = saveDir.cross(tmpP);
      PVector offset = diff.cross(normal);
      //offset = saveDir.copy();
      //offset.normalize();
      //stroke(255, 0, 0);
      //strokeWeight(1);
      //pushMatrix();
      //translate(this.pos.x + rad.x, this.pos.y + rad.y, this.pos.z + rad.z);
      //line(0, 0, 0, offset.x * 10, offset.y * 10, offset.z * 10);
      //popMatrix();
        offset.normalize();
        if (PVector.angleBetween(offset, parent.saveDir) < HALF_PI)
          offset.mult(-1);
        offset.mult(-offsetLength);
        newPos = PVector.sub( this.pos, offset );
        newParentPos = PVector.add( parent.pos, offset );
      
      tube.setSize( this.radius, this.radius, parent.radius, parent.radius);
      tube.setWorldPos( newPos, newParentPos ); // MULT BY LEN/MAX_LEN
    } else {
      tube.setSize( this.radius, this.radius, this.radius, this.radius);
      tube.setWorldPos( this.pos, PVector.sub(this.pos, new PVector(0, this.len, 0)));//newPos);
    }
     
    //tube.setSize(TOP_RAD, BOT_RAD)
    //tube.setWorldPos(END POS, START POS (bottom))
     
    //tube.setSize(radius, radius, parent.radius, parent.radius, len);
    //tube.setWorldPos(pos, parent.pos);
    
    tube.draw();
    
    //pushMatrix();
    //translate(pos.x, pos.y, pos.z);
    //rotateY(-atan2(pos.z, pos.x));
    ////rotateZ(asin(pos.y));
    
    //// top
    //beginShape();
    //for (int i = 0; i < SIDES; i++) {
    //  float x = 20 * cos( i * angle );
    //  float y = 20 * sin( i * angle );
    //  vertex(x, y, 0);
    //}
    //endShape(CLOSE);
    
    ////bottom
    //beginShape();
    //for (int i = 0; i < SIDES; i++) {
    //  float x = 20 * cos( i * angle );
    //  float y = 20 * sin( i * angle );
    //  vertex(x, y, len);
    //}
    //endShape(CLOSE);
    
    //// body
    //beginShape(TRIANGLE_STRIP);
    //for (int i = 0; i < SIDES + 1; i++) {
    //  float x1 =        20 * cos( i * angle );
    //  float y1 =        20 * sin( i * angle );
    //  float x2 = 20 * cos( i * angle );
    //  float y2 = 20 * sin( i * angle );
    //  vertex(x1, y1, 0);
    //  vertex(x2, y2, len);
    //}
    //endShape(CLOSE);
    //popMatrix();
  }
  
  void offset_3D() {
    angle = ( parent.saveDir.heading()) - ( this.saveDir.heading());
    if ( this.parent != null ) {
       //if ( angle > PI/2 ) {
       //    offsetLength = atan( angle ) * this.radius - ( parent.radius * atan( angle ) );
       //} 
       //if ( angle < PI/2 ) {
           // offsetLength = tan( angle ) * this.radius;
           // law of cosines
           offsetLength = pow(2 * pow(parent.radius, 2) * (1 - cos(angle)), 0.5);
       //} 
    } else {
       offsetLength = 0; 
    }
    // offsetLength += this.radius;
  }

  PVector next() {
    // Returns a vector pointing to the "endpoint" of the branch
    PVector v = PVector.mult(dir, len);
    PVector next = PVector.add(pos, v);
    return next;
  }
  
  void grow() {
    len += 0.2;
  }
}