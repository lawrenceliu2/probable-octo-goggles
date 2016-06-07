public class Apple {
 float x, y, z, size;
 
 public Apple(float x, float y, float z, float size) {
   this.x = x;
   this.y = y;
   this.z = z;
   this.size = size;
 }
 
 void move(float x, float y, float z) {
   this.x = x;
   this.y = y;
   this.z = z;
 }
 
 void display() {
   fill(255,0,0);
   pushMatrix();
   translate(x,y,z);
   box(size);
   popMatrix();
 }
 
}