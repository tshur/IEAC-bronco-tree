
class Blob{
  // Adjust this to set how sensitive a blob is to acquiring more blobs
  float DISTANCE_THRESHOLD = 75;
  float min_x, min_y, max_x, max_y;
  
  Blob(float x, float y){
    // Define the corners of the blob (blob is a rectangle)
    min_x = x;
    min_y = y;
    max_x = x;
    max_y = y;
  }
  
  void add(float x, float y){
    // Expand the blob's corners to accomodate the point we are adding
    min_x = min(min_x, x);
    min_y = min(min_y, y);
    max_x = max(max_x, x);
    max_y = max(max_y, y);
  }
  
  void show(){
    // Render the blob
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(min_x, min_y, max_x, max_y);
    rectMode(CENTER);
  }
  
  float size(){
    // Give the size of the blob rectangle
    return (max_x - min_x)*(max_y - min_y);
  }
  
  boolean isNear(float x, float y){
    // Determine if pixel is near center of blob
    float center_x = (min_x + max_x) / 2;
    float center_y = (min_y + max_y) / 2;
    
    // Calculate if the current pixel point is near a blob
    float distance_between = distSq(center_x, center_y, x, y);
    if(distance_between < DISTANCE_THRESHOLD * DISTANCE_THRESHOLD){
      return true;
    }else{
      return false;
    }
  }
  
  float get_center_x() {
    return (min_x + max_x) / 2;
  }
  
  float get_center_y() {
    return (min_y + max_y) / 2; 
  }
}