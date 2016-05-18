import processing.net.*;

Server s;
int connectedClients;
String mode;
Button playButton;

void setup() {
  size(300, 300);
  s = new Server(this, 1234);
<<<<<<< HEAD
  textAlign(CENTER);
  textSize(width/10);
=======
  textAlign(CENTER, CENTER);
  textSize(width/4);
  mode = "WAITING";
>>>>>>> Dan-Dev
  connectedClients=0;
  playButton = new Button(connectedClients, width/4, height/4, width/2, height/2);
}

void draw() {
  background(0);
<<<<<<< HEAD
  Client thisClient = s.available();
  if (thisClient!=null) {
    String data = thisClient.readString();
    if (data!=null) {
      fill(255);
      text("Connected Snakes", width/2, 30);
      for (int i = 0; i<connectedClients;i++){
        //fill( HOW DO I GET THE COLOR OF THE SNAKEEEE
        //text(data, width/2, height/3+40*i);
        text("Snake "+data.substring(0,1)+" "+data.substring(1), width/2, height/3+40*i);
      }
      s.write(data);
=======
  if (mode == "PLAYING") {
    playButton.display();
    if (connectedClients==0) {
      mode = "WAITING";
>>>>>>> Dan-Dev
    }
    Client thisClient = s.available();
    if (thisClient!=null) {
      String data = thisClient.readString();
      if (data!=null) {
        fill(0);
        textSize(width/8);
        println(data);
        text(data, width/2, 3 * height/4);
        s.write(data);
      }
    }
  } else if (mode == "WAITING") {
    Client thisClient = s.available();
    if (thisClient!=null) {
      String message = thisClient.readString();
      if (message!=null) {
        s.write("wait");
      }
    }
    playButton.setValue(connectedClients);
    playButton.display();
    //
    if (playButton.isClicked()) {
      //int[] yvals = new int[connectedClients];
      s.write(""+connectedClients+"play");
      playButton.setValue(-1);
      mode = "PLAYING";
    }
    //textSize(width/16);
    //text(s.ip(),width/2, 2 * height/3);
  }
}

void serverEvent(Server someserver, Client aclient) {
  println("New client joined with IP: " + aclient.ip());
  connectedClients++;
  someserver.write("" + connectedClients + "join");
  //s.write(joinRequest);
}

void disconnectEvent(Client aclient) {
  connectedClients--;
  println("Client disconnect\nConnected clients: " + connectedClients);
}