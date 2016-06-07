import processing.net.*;

Server s;
int connectedClients, c;
String mode;
Button playButton;
ArrayList<Integer> IDs;

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
  textSize(width/18);
  text("Connected Snakes", width/2, height/2-30);
  
  if (mode == "PLAYING") {
    textSize(width/2);
    playButton.display();
    if (connectedClients==0) {
      mode = "WAITING";
    }
    Client thisClient = s.available();
    //Wait for a client to perform an action
    if (thisClient!=null) {
      String data = thisClient.readString();
      if (data!=null && data.length() > 1) {
        println(data);
        int tempID = Integer.parseInt(data.substring(0,data.indexOf(":")));
        
        //Setup text for each client
        for (int i = 1; i <= connectedClients; i++){
          textSize(width/25);
          println(data);
          fill(c);
          
          //Determine what action took place
          if (data.indexOf("ate")>0 && i==1){
            text("Snake"+ tempID + " ate an apple!", width/2, height/2 + 20);
            s.write("" + ((int)random((width/20)-1)*20+20) + ","
                  + ((int)random((width/20)-1)*20+20));
            //println("Sent apple coordinates");
          }
          else if (data.indexOf("score")>0){
            text("Snake"+ tempID + " died! Score: "+data.substring(data.indexOf("e")+1), width/2, height/2 + i * 20);
            //println("Dead snake");
          }
          else{
            text("Snake"+ tempID + " is moving "+data.substring(data.indexOf(":")+1), width/2, height/2 + i * 20);
            s.write(data);
          }
        }
      }
    }
    
    //If no client performed an action
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
  }
  
  
  else if (mode == "WAITING") {
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

    if (playButton.isClicked()) {
      s.write(""+connectedClients+"play");
      playButton.setValue(-1);
      mode = "PLAYING";
    }
  }
}


void serverEvent(Server someserver, Client aclient) {
  println("New client joined with IP: " + aclient.ip());
  connectedClients++;
  someserver.write("" + connectedClients + "join");
}


void disconnectEvent(Client aclient) {
  connectedClients--;
  println("Client disconnect\nConnected clients: " + connectedClients);
}