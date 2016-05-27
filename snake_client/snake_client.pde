import processing.net.*;

Client client;
String input, serverOutput;
int data[];
int ID;

SnakeBody s;//, s2;
//ArrayList<SnakeBody> otherSnakes;
SnakeBody[] otherSnakes;
Apple a;
String mode;
float maxPlaneX, minPlaneX, maxPlaneY, minPlaneY;
Button b;
color c;

void setup() {
  size(500, 500, P3D);
  background(0);
  client = new Client(this, "127.0.0.1", 1234);
  //String  joinConfirmed = client.readString();
  //s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple (360, 60, 0, 20);
  //a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20); 
  b = new Button("PLAY", width/4, height/4, width/2, height/2);
  mode = "PLAYBUTTON";
  serverOutput = "";
}

void draw() {

  if (mode.equals("PLAYBUTTON")) {
    openingScreen();
  }

  if (mode.equals("GAMEPLAY")) {
    lights();
    checkKeys();
    readServer();

    textSize(15);
    text(s.segments.size(), 15, 15);
    background(0);

    //s2.move();
    //s2.display();

    //Move each snake
    if (frameCount%6==0) {
      s.move();
      for (int i = 0; i < otherSnakes.length; i++) {
        if (otherSnakes[i]!=null) {
          otherSnakes[i].move();
        }
      }
    }

    s.display();
    for (int i = 0; i < otherSnakes.length; i++) {
      if (otherSnakes[i]!=null) {
        otherSnakes[i].display();
      }
    }

    //If a snake eats an apple
    if (s.ate(a)) {
      client.write("" + ID + "ate");
      s.grow();
    }
    a.display();
  }
  
  //When snakes die
  if (!inBounds()) {
    client.write("" + ID + ":score"+ (s.segments.size()-5));
    mode = "DEAD";
  }
  if (s.isDead) {
    client.write("" + ID + ":score"+ (s.segments.size()-5));
    s.isDead = !s.isDead;
    mode = "DEAD";
  }
  
  if (mode.equals("DEAD")) {
    deathScreen();
  }
}


public void openingScreen() {
  b.display();
  String serverMessage = client.readString();
  if (serverMessage != null) {
    if (serverMessage.indexOf("wait")<0) {
      if (serverMessage.indexOf("join")>0) {
        ID = int(serverMessage.substring(0, serverMessage.indexOf("join")));
        //c =  color(100+155*sin(ID), 100+155*cos(ID), 100+155*tan(ID));
        s = new SnakeBody((int)(width/40)*20, (int)(height/100 * ID)*20, 0, 20, ID);
      } else {
        int totalPlayers = int(serverMessage.substring(0, serverMessage.indexOf("play")));
        println(totalPlayers);
        otherSnakes = new SnakeBody[totalPlayers];
        int playerID = 1; 
        while (playerID < totalPlayers) {
          if (playerID-1 != ID) {
            otherSnakes[playerID-1] = (new SnakeBody((int)(width/40)*20, (int)(height/100 * playerID)*20, 0, 20, playerID));
            playerID++;
          } else {
            playerID++;
          }
        }
        //client.write((int)(int(serverMessage.substring(0, serverMessage.indexOf("play")))*20));
        s = new SnakeBody((int)(width/40)*20, (int)(int(serverMessage.substring(0, serverMessage.indexOf("play")))*20), 0, 20, ID);
        b.changeText("Play");
        mode = "GAMEPLAY";
      }
    }
  } else {
    b.changeText("Waiting");
  }
}


public void deathScreen(){
  background(0);
  fill(255, 0, 0);
  textSize(width/8);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, height/3);
  textSize(25);
  text("Score: " + (s.segments.size()-5), width/2, height/2);
  b = new Button("Play Again?", width/4, 3 * height/4, width/2, height/8);
  b.display();
  if (b.isClicked()) {
    resetBoard();
  }
}

public void resetBoard() {
  mode = "GAMEPLAY";
  s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, ID);
  //s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20);
}


boolean inBounds() {
  return s.getPosition()[0] - 20 >= 0 && s.getPosition()[0] + 20<= width && s.getPosition()[1] -20 >= 0 && s.getPosition()[1] +20 <= height;
}


void checkKeys() {
  if (keyPressed) {
    if (key == 'w' && s.dy!= 1) {
      client.write(""+ID+":up"+"\n");
    }
    if (key == 'a' && s.dx != 1) {
      client.write(""+ID+":left"+"\n");
    }
    if (key == 's' && s.dy != -1) {
      client.write(""+ID+":down"+"\n");
    }
    if (key == 'd' && s.dx != -1) {
      client.write(""+ID+":right"+"\n");
    }
  }
}

void readServer() {
  String command = client.readString();
  if (command!=null) {
    int target = 0;
    if (command.indexOf(":")>0) {
      target = int(command.substring(0, command.indexOf(":")));
    }
    println(command);
    if (command.indexOf("up") > 0) {//&& target==ID) {//int(command.substring(0, command.indexOf(":up"))) == ID) {
      println("GOING UP");
      if (target==ID) {
        s.turnUp();
      } else {
        //otherSnakes[target].turnUp();
        s.turnUp();
      }
      //s2.turnUp();
    }
    if (command.indexOf("left") > 0 && target==ID) {//int(command.substring(0, command.indexOf(":left"))) == ID) {
      println("GOING LEFT");
      s.turnLeft();
      //s2.turnLeft();
    }
    if (command.indexOf("down") > 0 && target==ID) {//int(command.substring(0, command.indexOf(":down"))) == ID) {
      println("GOING DOWN");
      s.turnDown();
      //s2.turnDown();
    }
    if (command.indexOf("right") > 0 && target==ID) {//int(command.substring(0, command.indexOf(":right"))) == ID) {
      println("GOING RIGHT");
      s.turnRight();
      //s2.turnRight();
    }
    if (command.indexOf(",") > 0){
      println("MOVING APPLE");
      a.move(Integer.parseInt(command.substring(0,command.indexOf(","))),
             Integer.parseInt(command.substring(command.indexOf(",")+1)), 0);
    } 
  }
}