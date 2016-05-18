class Button {
  int label;
  //int value;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  Button(int label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }


  void display() {
    fill(218);
    stroke(0);
    rect(x, y, w, h, 10);
    textSize((w+h)/8);
    textAlign(CENTER, CENTER);
    fill(0);
    if (label>0) {
      text(label, x + (w / 2), y + (h / 2));
    } else if (label == 0) {
      text("Waiting", x + (w/2), y + (h/2));
    } else {
      text("Playing", x + (w/2), y + (h/2));
    }
  }

  void setValue(int value) {
    label = value;
  }

  boolean isClicked() {
    return mousePressed && mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h);
  }
}