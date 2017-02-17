float distSq(float x1, float y1, float z1, float x2, float y2, float z2){
  // Calculates the square of the distance between 2 3D points to save computation power using square root
  return pow((x2-x1), 2) + pow((y2-y1), 2) + pow((z2-z1), 2);
}

float distSq(float x1, float y1, float x2, float y2){
  // Calculates the square of the distance between 2 points to save computation power using square root
  return pow((x2-x1), 2) + pow((y2-y1), 2);
}