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
  PImage Iright;
  PImage Ileft;
  PImage Iup;
  PImage Idown;
  PImage right0 = loadImage("pacman_right0.png");
  PImage left0 = loadImage("pacman_left0.png");
  PImage up0 = loadImage("pacman_up0.png");
  PImage down0 = loadImage("pacman_down0.png");
  PImage right1 = loadImage("pacman_right1.png");
  PImage left1 = loadImage("pacman_left1.png");
  PImage up1 = loadImage("pacman_up1.png");
  PImage down1 = loadImage("pacman_down1.png");
  PImage Idefault = loadImage("pacman_default.png");

  Pacman(int spawn[]){
    /*DEBUG*/
    this.spawnpoint = spawn.clone();
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Pacman: Initialized pacman");
    this.direction="";
    this.position = this.spawnpoint.clone();
    this.oldPosition = this.spawnpoint.clone();
    this.renderPosition = this.spawnpoint.clone();

    this.Iright=this.right0;
    this.Ileft=this.left0;
    this.Iup=this.up0;
    this.Idown=this.down0;

  }

  void toggleImg() {
    if(this.imgToggle) {
      this.Iright=this.right1;
      this.Ileft=this.left1;
      this.Iup=this.up1;
      this.Idown=this.down1;
    }
    else {
      this.Iright=this.right0;
      this.Ileft=this.left0;
      this.Iup=this.up0;
      this.Idown=this.down0;
    }
    this.imgToggle=!this.imgToggle;
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
