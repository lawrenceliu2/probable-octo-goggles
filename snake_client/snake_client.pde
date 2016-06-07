import processing.net.*;

Client client;
String input, serverOutput;
int data[];
int ID;
int colore;
boolean keepId, madeSnakes, scoreSent;

//SnakeBody s;//, s2;
//ArrayList<SnakeBody> otherSnakes;
ArrayList <SnakeBody> snakes;
Apple a;
ArrayList <Wall> Walls;
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
  a = new Apple (width/2+10, height/2+10, 0, 20);
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
  scoreSent = false;
}

void draw() {
  if (mode.equals("PLAYBUTTON")) {
    openingScreen();
  } else if (mode.equals("GAMEPLAY")) {
    lights();
    checkKeys();
    readServer();

    textSize(15);
    background(0);
    fill(255);
    text(snakes.get(ID-1).segments.size(), 15, 15);
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

    for (int i = 0; i < snakes.size(); i++) {
      if (snakes.get(i)!=null && i != ID-1) {
        if (snakes.get(i).isDead) {
          snakes.set(i, null);
        }
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
        ID = int(serverMessage.substring(0, serverMessage.indexOf("join")));
        println(ID);
      } else if (serverMessage.indexOf("play")>0 && keepId && !madeSnakes) {
        int totalPlayers = int(serverMessage.substring(0, serverMessage.indexOf("play")));
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
    text("This is your snake's color!", width/2, (int) (height/1.2));
  }
}


public void deathScreen() {
  if (!scoreSent) {
    client.write("" + ID + ":score"+ (snakes.get(ID-1).segments.size()-5));
    scoreSent = true;
  }
  background(0);
  fill(255, 0, 0);
  textSize(width/8);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, height/3);
  textSize(25);
  text("Score: " + (snakes.get(ID-1).segments.size()-5), width/2, height/2);
  b = new Button("Exit", width/4, 3 * height/4, width/2, height/8);
  b.display();
  if (b.isClicked()) {
    client.stop();
    exit();
  }
}

public void resetBoard() {
  mode = "GAMEPLAY";
  //s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, ID);
  //s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20);
}


boolean inBounds() {
  return snakes.get(ID-1).getPosition()[0] - 20 >= 0 && snakes.get(ID-1).getPosition()[0] + 20<= width && snakes.get(ID-1).getPosition()[1] -20 >= 0 && snakes.get(ID-1).getPosition()[1] +20 <= height;
}


void checkKeys() {
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

void readServer() {
  String command = client.readString();
  println(command);
  if (command!=null) {
    int target = 0;
    if (command.indexOf(":")>0) {
      target = int(command.substring(0, command.indexOf(":")));
      println(target);
    }
    println(command);
    if (target-1>=0) {
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
    }
    if (command.indexOf(",") > 0) {
      println("MOVING APPLE: "+command);
      if (command.substring(command.indexOf(",")).indexOf(",")>0) {
        client.write("" + ID + "ate");
        println("did this");
      } else if (command.indexOf(":")<0) {
        println("did that");
        a.move(Integer.parseInt(command.substring(0, command.indexOf(","))), 
          Integer.parseInt(command.substring(command.indexOf(",")+1)), 0);
      }
    }
  }
}