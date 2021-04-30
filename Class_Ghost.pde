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

  protected color ghostColor;
  protected color ghostColorF;

  Ghost(String name, color c1, color c2, int position[], int df){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Ghost: Initialized Ghost["+name+"]");

    ghostColor=c1;
    ghostColorF=c2;
    this.GHOSTDELAY=df;
    this.GHOSTDELAY_N=df;
    this.name = name;
    this.spawnpoint = position.clone();
    this.oldPosition = position.clone();
    this.position = position.clone();
    this.renderPosition = position.clone();
    this.renderFactor[0] = 0;
    this.renderFactor[1] = 0;
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
