import processing.net.*;

Server s;
int connectedClients, c;
String mode;
Button playButton;

void setup() {
  size(500, 500);
  s = new Server(this, 1234);
  textAlign(CENTER, CENTER);
  mode = "WAITING";
  connectedClients=0;
  playButton = new Button(connectedClients, width/3, height/15, width/3, height/3);
  int c = 255;
}

void draw() {
  background(0);
  fill(255);
  textSize(width/20);
  text("Connected Snakes", width/2, height/2-30);
  if (mode == "PLAYING") {
    textSize(width/2);
    playButton.display();
    if (connectedClients==0) {
      mode = "WAITING";
    }
    Client thisClient = s.available();
    if (thisClient!=null) {
      String data = thisClient.readString();
      if (data!=null && data.length() > 1) {
        println(data);
        for (int i = 1; i <= connectedClients; i++){
          c = color(100+155*sin(Integer.parseInt(data.substring(0,data.indexOf(":")))), 
                    100+155*cos(Integer.parseInt(data.substring(0,data.indexOf(":")))),
                    100+155*tan(Integer.parseInt(data.substring(0,data.indexOf(":"))))));
          textSize(width/25);
          println(data);
          fill(c);
          if (data.substring(1,2).equals("s")){
            text("Snake"+data.substring(0,1)+" died! Score: "+data.substring(6,7), width/2, height/2 + i * 20);
          }else{
            text("Snake"+data.substring(0,1)+" is moving "+data.substring(1), width/2, height/2 + i * 20);
            s.write(data);
          }
        }
      }
    }
    else{
      for (int i = 1; i <= connectedClients; i++){
        if (c==0){
          c=255;
        }
        fill (c);
        textSize(width/25);
        text("Snake"+i+" is moving forwards", width/2, height/2 + (i - 1) * 20);
      }
    }
  } else if (mode == "WAITING") {
    for (int i = 1; i <= connectedClients; i++){
      c=255;
      fill (c);
      textSize(width/25);
      text("Snake"+i, width/2, height/2 + (i - 1) * 20);
    }
    Client thisClient = s.available();
    if (thisClient!=null) {
      String message = thisClient.readString();
      if (message!=null) {
        s.write("wait");
      }
    }
    textSize(width/2);
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