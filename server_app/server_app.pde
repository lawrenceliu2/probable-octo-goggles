import processing.net.*;

Server s;
//int port = 5204;
String message = "Hello";

void setup() {
  size(500, 500);
  // Starts a myServer on port 5204
  s = new Server(this, 1234);
  background(0);
}

void draw() {
  
  if (mousePressed) {
    // Draw our line
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY); 
    // Send mouse coords to other person
    s.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
  }
}

void keyPressed() {
  if (key == 'e') {
    s.write("erase\n");
    background(0);
  }
}