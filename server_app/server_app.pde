import processing.net.*;

Server s;
//int port = 5204;
String message = "Hello";
int brushWidth;

void setup() {
  size(500, 500);
  // Starts a myServer on port 5204
  s = new Server(this, 1234);
  background(0);
  brushWidth = 1;
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  if (keyPressed /*&& !mousePressed*/) {
    checkKeys();
  }
  if (mousePressed) {
    // Draw our line
    stroke(255);
    strokeWeight(brushWidth);
    line(pmouseX, pmouseY, mouseX, mouseY); 
    // Send mouse coords to other person
    s.write(brushWidth + " " + pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
  }
  drawSizeIndicator(brushWidth);
}

void drawSizeIndicator(int size) {
  if (size>1) { 
    textSize(size/2);
    strokeWeight(1);
    fill(0);
    stroke(0);
    rect(size/2, size/2, size+PI, size+PI);
    stroke(255);
    fill(255);
    ellipse(size/2, size/2, size, size);
    fill(0);
    stroke(0);
    text(size, size/2, size/2);
  }
}

void checkKeys() {
  if (key == 'e') {
    s.write("erase\n");
    background(0);
  }
  if (key == 'd') {
    brushWidth++;
  }
  if (key == 'a') {
    if (brushWidth>1) {
      brushWidth--;
    }
  }
}