class Ghost {
  protected boolean isAlive=true;
  protected String name;
  protected int[] spawnpoint = new int[2];
  protected int[] position = new int[2];

  int GHOSTDELAY=0;
  int GHOSTDELAY_N=0;

  int[] oldPosition = new int[2];
  int[] renderPosition = new int[2];
  float[] renderFactor = new float[2];
  String renderDirection="";

  int renderTime = 0;

  int deadTime = 6;
  int deadCount = 0;

  int dlTime=0;

  boolean frightened=false;


  boolean imgToggle=false;
  PImage Iright;
  PImage Ileft;
  PImage Iup;
  PImage Idown;
  PImage right0;
  PImage left0;
  PImage up0;
  PImage down0;
  PImage right1;
  PImage left1;
  PImage up1;
  PImage down1;
  PImage Idefault;
  PImage Ifrightened;

  Ghost(String name, PImage r0, PImage r1, PImage l0, PImage l1, PImage d0, PImage d1, PImage u0, PImage u1, PImage f, PImage d, int position[], int df){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Ghost: Initialized Ghost["+name+"]");

    this.GHOSTDELAY=df;
    this.GHOSTDELAY_N=df;
    this.name = name;
    this.spawnpoint = position.clone();
    this.oldPosition = position.clone();
    this.position = position.clone();
    this.renderPosition = position.clone();
    this.renderFactor[0] = 0;
    this.renderFactor[1] = 0;


    this.right0=r0;
    this.left0=l0;
    this.up0=u0;
    this.down0=d0;
    this.right1=r1;
    this.left1=l1;
    this.up1=u1;
    this.down1=d1;
    this.Idefault=d;
    this.Ifrightened=f;

    this.Iright=this.right0;
    this.Ileft=this.left0;
    this.Iup=this.up0;
    this.Idown=this.down0;

  }

  int mayMove() {
    if(dlTime==0||millis-dlTime>=this.GHOSTDELAY) {
      dlTime=millis;
      if(this.frightened) this.GHOSTDELAY=this.GHOSTDELAY_N*2;
      else this.GHOSTDELAY=this.GHOSTDELAY_N;

      return 1;
    }
    return 0;
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

  void resetSmooth() {
    this.renderTime = millis;
    this.renderPosition=this.position.clone();
    this.renderFactor[0]=0;
    this.renderFactor[1]=0;
  }

  void makeMove(){
    println("overriding inky didnt work");

  }
  void makeMove(int[] position){
    println("overriding blinky didnt work");

  }
  void makeMove(int[] position, String direction){
    println("overriding pinky or kinky didnt work");
    //kinky isnt in this file yet, will be updated probably later today when felix replies to my discord dms
  }

  void kill(){
    this.frightened=false;
    this.isAlive = false;
    this.oldPosition = this.renderPosition.clone();
    this.renderPosition = this.spawnpoint.clone();
    this.renderDirection="";
    this.renderFactor=new float[2];
    this.position = this.spawnpoint.clone();

  }


}
