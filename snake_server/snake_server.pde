import processing.net.*;

Server s;
int connectedClients;
String mode;
Button playButton;

void setup() {
  size(200, 200);
  s = new Server(this, 1234);
  textAlign(CENTER, CENTER);
  textSize(width/4);
  mode = "WAITING";
  connectedClients=0;
  playButton = new Button(connectedClients, width/4, height/4, width/2, height/2);
}

void draw() {
  background(0);
  if (mode == "PLAYING") {
    playButton.display();
    if (connectedClients==0) {
      mode = "WAITING";
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

/*void disconnectEvent(Client aclient) {
  connectedClients--;
  println("Client disconnect\nConnected clients: " + connectedClients);
}*/