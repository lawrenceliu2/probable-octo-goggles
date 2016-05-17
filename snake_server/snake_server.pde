import processing.net.*;

Server s;
int connectedClients;

void setup() {
  size(300, 300);
  s = new Server(this, 1234);
  textAlign(CENTER);
  textSize(width/10);
  connectedClients=0;
}

void draw() {
  background(0);
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
    }
    
  }
}

void serverEvent(Server someserver, Client aclient) {
  connectedClients++;
  someserver.write(connectedClients);
}

void disconnectEvent(Client aclient){
  connectedClients--;
  println("Client disconnect\nConnected clients: " + connectedClients);
}