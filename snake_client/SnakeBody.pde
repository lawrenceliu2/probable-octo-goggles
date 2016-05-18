public class SnakeBody {
  ArrayList<SnakeBit> segments;
  float size;
  boolean isDead;
  SnakeBit head;
  float dx, dy, dz;

  SnakeBody(float x, float y, float z, float size, color c) {
    this.dx=1;
    this.size = size;
    head = new SnakeBit(x, y, z, size, c);
    segments = new ArrayList<SnakeBit>();
    segments.add(head);
    for (int i = 0; i < 4; i++) {
      segments.add(new SnakeBit(x - ((i + 1) * (size + 1)), y, z, size, c));
    }
  }

  void move() {
    for (int i = 2; i < segments.size(); i++) {
      if (segments.get(0).x == segments.get(i).x && segments.get(0).y == segments.get(i).y) {
        isDead=true;
      }
    }
    segments.add(0, new SnakeBit(segments.get(0).x + (dx * size), segments.get(0).y + (dy * size), segments.get(0).z + (dz * size), size, c));
    //segments.get(0).move(distX * size, distY * size, distZ * size);
    segments.remove(segments.size()-1);
  }

  void display() {
    for (int i = 0; i < segments.size(); i++) {
      segments.get(i).display();
    }
    if (segments.size() == 1) {
      isDead = true;
    }
  }

  void grow() {
    segments.add(0, new SnakeBit(segments.get(0).x, segments.get(0).y, segments.get(0).z, size, c));
  }

  void turnUp() {
    dx = 0;
    dy = -1;
    dz = 0;
  }

  void turnRight() {
    dx = 1;
    dy = 0;
    dz = 0;
  }

  void turnDown() {
    dx = 0;
    dy = 1;
    dz = 0;
  }

  void turnLeft() {
    dx = -1;
    dy = 0;
    dz = 0;
  }

  float[] getPosition() {
    float[] positions = new float[3];
    positions[0] = segments.get(0).x;
    positions[1] = segments.get(0).y;
    positions[2] = segments.get(0).z;
    return positions;
  }

  boolean ate(Apple a) {
    return a.x == segments.get(0).x && a.y == segments.get(0).y && a.z == segments.get(0).z;
  }
}