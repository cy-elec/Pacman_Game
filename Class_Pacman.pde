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

  boolean imgToggle=false;
  PImage right;
  PImage left;
  PImage up;
  PImage down;
  PImage right0 = loadImage("pacman_right0.png");
  PImage left0 = loadImage("pacman_left0.png");
  PImage up0 = loadImage("pacman_up0.png");
  PImage down0 = loadImage("pacman_down0.png");
  PImage right1 = loadImage("pacman_right1.png");
  PImage left1 = loadImage("pacman_left1.png");
  PImage up1 = loadImage("pacman_up1.png");
  PImage down1 = loadImage("pacman_down1.png");
  PImage defaultI = loadImage("pacman_default.png");

  Pacman(int spawn[]){
    /*DEBUG*/
    this.spawnpoint = spawn.clone();
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Pacman: Initialized pacman");
    this.direction="";
    this.position = this.spawnpoint.clone();
    this.oldPosition = this.spawnpoint.clone();
    this.renderPosition = this.spawnpoint.clone();

    this.right=this.right0;
    this.left=this.left0;
    this.up=this.up0;
    this.down=this.down0;

  }

  void toggleImg() {
    if(imgToggle) {
      this.right=this.right1;
      this.left=this.left1;
      this.up=this.up1;
      this.down=this.down1;
    }
    else {
      this.right=this.right0;
      this.left=this.left0;
      this.up=this.up0;
      this.down=this.down0;
    }
    imgToggle=!imgToggle;
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
