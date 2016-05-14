import processing.net.*; 

Client c; 
String dataIn; 
String input;
int data[];

void setup() { 
  size(500, 500); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  c = new Client(this, "192.168.1.8", 1234); 
  textAlign(CENTER, CENTER);
  background(255);
} 

void draw() { 
  stroke(0);
  if (c.available() > 0) { 
    input = c.readString();
    input = input.substring(0, input.indexOf("\n"));  // Only up to the newline
    if (input.equals("erase")) {
      background(255);
    } else {
      data = int(split(input, ' '));  // Split values into an array
      line(data[0], data[1], data[2], data[3]);
    }
  }
}