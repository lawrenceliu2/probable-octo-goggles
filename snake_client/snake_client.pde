import processing.net.*;

Client client;
String input;
int data[];
int ID;

SnakeBody s;
Apple a;
float dx, dy, dz;
int mode;
float maxPlaneX, minPlaneX, maxPlaneY, minPlaneY;
Button b;
color c;

void setup() {
  size(500, 500, P3D);
  background(0);
  client = new Client(this, "192.168.1.8", 1234);
  ID = client.read();
  c =  color(random(255/ID), random(255/ID), random(255/ID));
  s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, c);
  a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20); 
  dx = 1;
  dy = 0;
  dz = 0;
  b = new Button("PLAY", width/4, height/4, width/2, height/2);
  mode = 1;
  //frameRate(10);
}

void draw() {
  if (mode == 1) {
    background(0);
    b.display();
    if (b.isClicked()) {
      mode = 2;
    }
  }
  if (mode == 2) {
    //camera(width/2, height/2, height/2/tan(PI/6) + 200, width/2, height/2, 0, 0, 1, 0);
    lights();
    checkKeys();
    if (frameCount%3==0) {
      textSize(15);
      text(s.segments.size(), 15, 15);
      //rotateX(PI/6);
      background(0);
      //drawGrid();
      s.move(dx, dy, dz);
      s.display();
      if (s.ate(a)) {
        a.move(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0); 
        s.grow();
      }
      a.display();
    }
    if (!inBounds()) {
      mode = 3;
      background(0);
    }
    if (s.isDead) {
      mode = 3;
    }
  }
  if (mode == 3) {
    background(0);
    fill(255, 0, 0);
    textSize(width/8);
    textAlign(CENTER, CENTER);
    text("YOU LOSE", width/2, height/3);
    textSize(25);
    text("Score: " + (s.segments.size()-5), width/2, height/2);
    b = new Button("Play Again", width/4, 3 * height/4, width/2, height/8);
    b.display();
    if (b.isClicked()) {
      mode = 2;
      s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, c);
      a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20); 
      dx = 1;
      dy = 0;
      dz = 0;
    }
  }
}

boolean inBounds() {
  return s.getPosition()[0] - 20 >= 0 && s.getPosition()[0] + 20<= width && s.getPosition()[1] -20 >= 0 && s.getPosition()[1] +20 <= height;
}

void drawGrid() {
  stroke(255, 5);
  noFill();
  for (int x = 0; x < height; x+=20) {
    for (int y = 0; y < height; y+=20) {
      for (int z = -60; z <= 60; z+=20) {
        pushMatrix();
        translate(x, y, z);
        box(20);
        popMatrix();
      }
    }
  }
}

void checkKeys() {
  if (keyPressed) {
    if (key == 'w') {
      dx = 0;
      dy = -1;
      dz = 0;
      client.write(""+ID+"up"+"\n");
    }
    if (key == 'a') {
      dx = -1;
      dy = 0;
      dz = 0;
      client.write(""+ID+"left"+"\n");
    }
    if (key == 's') {
      dx = 0;
      dy = 1;
      dz = 0;
      client.write(""+ID+"down"+"\n");
    }
    if (key == 'd') {
      dx = 1;
      dy = 0;
      dz = 0;
      client.write(""+ID+"right"+"\n");
    }/*
    if (key == 'e') {
     dx = 0;
     dy = 0;
     dz = 1;
     }
     if (key == 'f') {
     dx = 0;
     dy = 0;
     dz = -1;
     }*/
    if (key == ' ') {
      dx = 0;
      dy = 0;
      dz = 0;
    }
  }
}