import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class snake_client extends PApplet {



Client client;
String input, serverOutput;
int data[];
int ID;
int colore;
boolean keepId, madeSnakes;

//SnakeBody s;//, s2;
//ArrayList<SnakeBody> otherSnakes;
ArrayList <SnakeBody> snakes;
Apple a;
ArrayList <Wall> Walls;
String mode;
float maxPlaneX, minPlaneX, maxPlaneY, minPlaneY;
Button b;
int c;

public void setup() {
  
  background(0);

  client = new Client(this, "127.0.0.1", 1234);
  //String  joinConfirmed = client.readString();
  //s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple ((int) random((width/20)-1)*20+20, (int) random((height/20)-1)*20+20, 0, 20);
  //a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20); 
  b = new Button("PLAY", width/4, height/4, width/2, height/2);
  mode = "PLAYBUTTON";
  serverOutput = "";
  colore = color (random(255), random(255), random(255));
  Walls = new ArrayList<Wall>();
  for (int i = 0; i < width/20; i++) {
    Walls.add(new Wall(20*i, 0, 0, 20));
    Walls.add(new Wall(20*i, height, 0, 20));
  }
  for (int i = 0; i < height/20; i++) {
    Walls.add(new Wall(0, 20*i, 0, 20));
    Walls.add(new Wall(width, 20*i, 0, 20));
  }
  snakes = new ArrayList<SnakeBody>();
  keepId = false;
  madeSnakes = false;
}

public void draw() {
  if (mode.equals("PLAYBUTTON")) {
    openingScreen();
  } else if (mode.equals("GAMEPLAY")) {
    lights();
    checkKeys();
    readServer();

    textSize(15);
    text(snakes.get(ID-1).segments.size(), 15, 15);
    background(0);
    for (Wall blah : Walls) {
      blah.display();
    }

    //s2.move();
    //s2.display();

    //Move each snake
    if (frameCount%6==0) {
      for (int i = 0; i < snakes.size(); i++) {
        if (snakes.get(i)!=null) {
          snakes.get(i).move();
        }
      }
    }

    for (int i = 0; i < snakes.size(); i++) {
      if (snakes.get(i)!=null) {
        snakes.get(i).display();
      }
    }

    //If a snake eats an apple
    if (snakes.get(ID-1).ate(a)) {
      client.write("" + ID + ":ate");
      snakes.get(ID-1).grow();
    }
    a.display();

    //When snakes die
    if (!inBounds()) {
      client.write("" + ID + ":score"+ (snakes.get(ID-1).segments.size()-5));
      mode = "DEAD";
    }
    if (snakes.get(ID-1).isDead) {
      client.write("" + ID + ":score"+ (snakes.get(ID-1).segments.size()-5));
      snakes.get(ID-1).isDead = !snakes.get(ID-1).isDead;
      mode = "DEAD";
    }
  } else if (mode.equals("DEAD")) {
    deathScreen();
  }
}


public void openingScreen() {
  b.display();
  String serverMessage = client.readString();
  if (serverMessage != null) {
    if (serverMessage.indexOf("wait")<0) {
      if (serverMessage.indexOf("join")>0 && !keepId) {
        keepId = true;
        ID = PApplet.parseInt(serverMessage.substring(0, serverMessage.indexOf("join")));
        println(ID);
      } else if (serverMessage.indexOf("play")>0 && keepId && !madeSnakes) {
        int totalPlayers = PApplet.parseInt(serverMessage.substring(0, serverMessage.indexOf("play")));
        println("Total Players: " + totalPlayers);
        int playerID = 0; 
        while (playerID < totalPlayers) {
          snakes.add(new SnakeBody((int)(width/40)*20, (int)(height/100 * (playerID+1))*20, 0, 20, playerID+1));
          playerID++;
        }

        //client.write((int)(int(serverMessage.substring(0, serverMessage.indexOf("play")))*20));
        //s = new SnakeBody((int)(width/40)*20, (int)(int(serverMessage.substring(0, serverMessage.indexOf("play")))*20), 0, 20, ID);
        b.changeText("Play");
        mode = "GAMEPLAY";
      }
    }
  } else {
    b.changeText("Waiting");
    textSize(width/10);
    fill(colore);
    text("Welcome to Snake!", width/2, height/15);
    textSize(width/20);
    text("Please wait for the host to", width/2, height/7);
    text("begin the game", width/2, height/5);
    c = color(100+155*sin(ID), 100+155*cos(ID), 100+155*tan(ID));
    fill(c);
    textSize(width/15);
    text("This is your snake's color!", width/2, (int) (height/1.2f));
  }
}


public void deathScreen() {
  background(0);
  fill(255, 0, 0);
  textSize(width/8);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, height/3);
  textSize(25);
  text("Score: " + (snakes.get(ID-1).segments.size()-5), width/2, height/2);
  b = new Button("Play Again?", width/4, 3 * height/4, width/2, height/8);
  b.display();
  if (b.isClicked()) {
    //exit();
    resetBoard();
  }
}

public void resetBoard() {
  mode = "GAMEPLAY";
  //s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, ID);
  //s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20);
}


public boolean inBounds() {
  return snakes.get(ID-1).getPosition()[0] - 20 >= 0 && snakes.get(ID-1).getPosition()[0] + 20<= width && snakes.get(ID-1).getPosition()[1] -20 >= 0 && snakes.get(ID-1).getPosition()[1] +20 <= height;
}


public void checkKeys() {
  if (keyPressed) {
    if (key == 'w' && snakes.get(ID-1).dy!= 1) {
      client.write(""+ID+":up"+"\n");
    }
    if (key == 'a' && snakes.get(ID-1).dx != 1) {
      client.write(""+ID+":left"+"\n");
    }
    if (key == 's' && snakes.get(ID-1).dy != -1) {
      client.write(""+ID+":down"+"\n");
    }
    if (key == 'd' && snakes.get(ID-1).dx != -1) {
      client.write(""+ID+":right"+"\n");
    }
  }
}

public void readServer() {
  String command = client.readString();
  println(command);
  if (command!=null) {
    int target = 0;
    if (command.indexOf(":")>0) {
      target = PApplet.parseInt(command.substring(0, command.indexOf(":")));
      println(target);
    }
    println(command);
    if (command.indexOf("up") > 0) {// && target==ID) {//int(command.substring(0, command.indexOf(":up"))) == ID) {
      println("GOING UP");
      if (command.substring(command.indexOf(":")).indexOf(":")>0) {
        client.write("" + ID + "up");
      } else {
        snakes.get(target-1).turnUp();
      }
      //s2.turnUp();
    }
    if (command.indexOf("left") > 0) {//int(command.substring(0, command.indexOf(":left"))) == ID) {
      println("GOING LEFT");
      if (command.substring(command.indexOf(":")).indexOf(":")>0) {
        client.write("" + ID + "left");
      } else {
        snakes.get(target-1).turnLeft();
      }
      //s2.turnLeft();
    }
    if (command.indexOf("down") > 0) {//int(command.substring(0, command.indexOf(":down"))) == ID) {
      println("GOING DOWN");
      if (command.substring(command.indexOf(":")).indexOf(":")>0) {
        client.write("" + ID + "down");
      } else {
        snakes.get(target-1).turnDown();
      }
      //s2.turnDown();
    }
    if (command.indexOf("right") > 0) {//int(command.substring(0, command.indexOf(":right"))) == ID) {
      println("GOING RIGHT");
      if (command.substring(command.indexOf(":")).indexOf(":")>0) {
        client.write("" + ID + "right");
      } else {
        snakes.get(target-1).turnRight();
      }
      //s2.turnRight();
    }
    if (command.indexOf(",") > 0) {
      println("MOVING APPLE");
      if (command.substring(command.indexOf(",")).indexOf(",")>0) {
        client.write("" + ID + "ate");
      } else {
        a.move(Integer.parseInt(command.substring(0, command.indexOf(","))), 
          Integer.parseInt(command.substring(command.indexOf(",")+1)), 0);
      }
    }
  }
}
public class Apple {
 float x, y, z, size;
 
 public Apple(float x, float y, float z, float size) {
   this.x = x;
   this.y = y;
   this.z = z;
   this.size = size;
 }
 
 public void move(float x, float y, float z) {
   this.x = x;
   this.y = y;
   this.z = z;
 }
 
 public void display() {
   fill(255,0,0);
   pushMatrix();
   translate(x,y,z);
   box(size);
   popMatrix();
 }
 
}
class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  public void display() {
    fill(218);
    stroke(0);
    rect(x, y, w, h, 10);
    textSize((w+h)/8);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }

  public void changeText(String text) {
    label = text;
  }
  
  public boolean isClicked() {
    return mousePressed && mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h);
  }
}
public class SnakeBit {
  float x, y, z;
  float bitSize;
  int c;
  
  SnakeBit(float x, float y, float z, float bitSize, int c) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.bitSize = bitSize;
    this.c = c;
  }

  public void move(float dx, float dy, float dz) {
    this.x += dx;
    this.y += dy;
    this.z += dz;
  }

  public void display() {
    stroke(0);
    //fill(0,235, 0);
    fill(c);
    pushMatrix();
    translate(x, y, z);
    box(bitSize);
    popMatrix();
  }
}
public class SnakeBody {
  ArrayList<SnakeBit> segments;
  float size;
  boolean isDead;
  SnakeBit head;
  float dx, dy, dz;
  int ID;
  int c;

  SnakeBody(float x, float y, float z, float size, int ID) {
    this.ID = ID;
    c = color(100+155*sin(ID), 100+155*cos(ID), 100+155*tan(ID));
    this.dx=1;
    this.size = size;
    head = new SnakeBit(x, y, z, size, c);
    segments = new ArrayList<SnakeBit>();
    segments.add(head);
    for (int i = 0; i < 4; i++) {
      segments.add(new SnakeBit(x - ((i + 1) * (size + 1)), y, z, size, c));
    }
  }

  public void move() {
    for (int i = 2; i < segments.size(); i++) {
      if (segments.get(0).x == segments.get(i).x && segments.get(0).y == segments.get(i).y) {
        isDead=true;
      }
    }
    segments.add(0, new SnakeBit(segments.get(0).x + (dx * size), segments.get(0).y + (dy * size), segments.get(0).z + (dz * size), size, c));
    //segments.get(0).move(distX * size, distY * size, distZ * size);
    segments.remove(segments.size()-1);
  }

  public void display() {
    for (int i = 0; i < segments.size(); i++) {
      segments.get(i).display();
    }
    if (segments.size() == 1) {
      isDead = true;
    }
  }

  public void grow() {
    segments.add(0, new SnakeBit(segments.get(0).x, segments.get(0).y, segments.get(0).z, size, c));
  }

  public void turnUp() {
    dx = 0;
    dy = -1;
    dz = 0;
  }

  public void turnRight() {
    dx = 1;
    dy = 0;
    dz = 0;
  }

  public void turnDown() {
    dx = 0;
    dy = 1;
    dz = 0;
  }

  public void turnLeft() {
    dx = -1;
    dy = 0;
    dz = 0;
  }

  public float[] getPosition() {
    float[] positions = new float[3];
    positions[0] = segments.get(0).x;
    positions[1] = segments.get(0).y;
    positions[2] = segments.get(0).z;
    return positions;
  }

  public boolean ate(Apple a) {
    return a.x == segments.get(0).x && a.y == segments.get(0).y && a.z == segments.get(0).z;
  }
}
public class Wall{
  float x, y, z, size;
  
  public Wall (float X, float Y, float Z, float Size){
    x = X;
    y = Y;
    z = Z;
    size = Size;
  }
  
   public void display() {
   fill(255, 255, 255);
   pushMatrix();
   translate(x,y,z);
   box(size);
   popMatrix();
 }
 
}
  public void settings() {  size(500, 500, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "snake_client" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
