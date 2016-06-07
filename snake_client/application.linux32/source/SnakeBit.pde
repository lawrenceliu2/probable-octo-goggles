public class SnakeBit {
  float x, y, z;
  float bitSize;
  color c;
  
  SnakeBit(float x, float y, float z, float bitSize, color c) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.bitSize = bitSize;
    this.c = c;
  }

  void move(float dx, float dy, float dz) {
    this.x += dx;
    this.y += dy;
    this.z += dz;
  }

  void display() {
    stroke(0);
    //fill(0,235, 0);
    fill(c);
    pushMatrix();
    translate(x, y, z);
    box(bitSize);
    popMatrix();
  }
}