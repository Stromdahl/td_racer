class Racer {
  GameBoard gb;
  PVector pos;
  PVector vel;
  PVector acc;
  float heading;
  float size;
  int startingChunkID;
  int currentChunkID;
  int score;
  Racer(GameBoard gb) {
    this.gb = gb;
    this.pos = gb.getStartingPos();
    this.vel = new PVector();
    this.acc = new PVector();
    this.heading = gb.getStartingHeading();
    this.size = 10;
    startingChunkID = gb.getCurrentChunkID(this.pos.x, this.pos.y);
    currentChunkID = startingChunkID;
  }

  void update() {
    PVector newVel = PVector.fromAngle(heading);
    newVel.setMag(this.vel.mag());
    newVel.add(this.acc);
    newVel.mult(0.99);
    this.vel = newVel.copy();
    this.pos.add(this.vel);
    this.acc.mult(0);
    getControlls();
    
    
    
    int lastChunkID = currentChunkID;
    currentChunkID = gb.getCurrentChunkID(this.pos.x, this.pos.y);
    
    Chunk currentChunk = gb.getCurrentChunk(currentChunkID);
    if(!currentChunk.onTrack(this.pos.x, this.pos.y)){
      reset();
    }
    
    if(lastChunkID != currentChunkID){
      score++;
      println(score);
    }
  }
  
  void reset(){
    this.pos = gb.getStartingPos();
    this.heading = gb.getStartingHeading();
    this.score = 0;
    this.vel.mult(0);
  }
  
  void getControlls() {
    if (input_keys.contains('w')) {
      this.accelerate();
    }
    if (input_keys.contains('s')) {
      this.decelerate();
    }
    if (input_keys.contains('a')) {
      this.heading -= 0.05;
    }
    if (input_keys.contains('d')) {
      this.heading += 0.05;
    }
  }
  
  
  void display() {
    noFill();
    strokeWeight(1);
    pushMatrix();
    translate(this.pos.x + gb.gamePosX, this.pos.y + gb.gamePosY);
    rotate(this.heading);
    triangle(size, 0, -size, size / 2, -size, -size / 2);
    popMatrix();
  }
  void accelerate() {
    PVector force = PVector.fromAngle(this.heading);
    force.setMag(0.1);
    addForce(force);
  }
  void decelerate() {
    PVector force = PVector.fromAngle(this.heading + PI);
    force.setMag(0.1);
    addForce(force);
  }
  void addForce(PVector force) {
    this.acc.add(force);
  }
}
