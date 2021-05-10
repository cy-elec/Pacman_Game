class Pacman {
  boolean isAlive = false;
  int[] position = new int[2];
  int[] oldPosition = new int[2];

  int[] renderPosition = new int[2];
  float[] renderFactor = new float[2];
  String renderDirection="";

  int renderTime = 0;

  int[] spawnpoint = new int[2];
  color pacmanColor = color(255, 255, 0);
  int lives = 3;

  String direction = "";
  String oldDirection = "";

  PImage right = loadImage("right.png");
  PImage left = loadImage("left.png");
  PImage up = loadImage("up.png");
  PImage down = loadImage("down.png");

  Pacman(int spawn[]){
    /*DEBUG*/
    this.spawnpoint = spawn.clone();
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Pacman: Initialized pacman");
    this.direction="";
    this.position = this.spawnpoint.clone();
    this.oldPosition = this.spawnpoint.clone();
    this.renderPosition = this.spawnpoint.clone();

  }

  void reset(){

    this.isAlive = true;
    this.position = this.spawnpoint.clone();
    this.renderPosition = this.spawnpoint.clone();
    this.oldPosition = this.spawnpoint.clone();
    this.renderFactor[0] = 0;
    this.renderFactor[1] = 0;
    this.direction = "";
    this.oldDirection = "";
    this.renderDirection="";
  }

  void resetSmooth(){
    this.renderTime = millis;
    this.renderPosition=this.position.clone();
    this.renderFactor[0]=0;
    this.renderFactor[1]=0;
  }

}
