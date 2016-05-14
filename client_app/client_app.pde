import processing.net.*; 

Client c; 
String dataIn; 
String input;
int data[];
int brushWidth;

void setup() { 
  size(500, 500); 
  // Connect to the local machine at port 5204.
  // This example will not run if you haven't
  // previously started a server on this port.
  c = new Client(this, "192.168.1.8", 1234); 
  textAlign(CENTER, CENTER);
  background(255);
  brushWidth = 1;
} 

void draw() { 
  stroke(0);
  if (c.available() > 0) { 
    input = c.readString();
    if (input.indexOf("\n")>=0) {
      input = input.substring(0, input.indexOf("\n"));
    }// Only up to the newline
    System.out.println(input);
    parseCommands();
  }
}

void parseCommands() {
  if (input.equals("erase")) {
    background(255);
  } else {
    data = int(split(input, ' '));  // Split values into an array
    if (data.length==5) {
      brushWidth = data[0];
      strokeWeight(brushWidth);
      line(data[1], data[2], data[3], data[4]);
    }
  }
}