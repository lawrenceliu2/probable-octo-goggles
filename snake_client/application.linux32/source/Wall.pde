public class Wall{
  float x, y, z, size;
  
  public Wall (float X, float Y, float Z, float Size){
    x = X;
    y = Y;
    z = Z;
    size = Size;
  }
  
   void display() {
   fill(255, 255, 255);
   pushMatrix();
   translate(x,y,z);
   box(size);
   popMatrix();
 }
 
}