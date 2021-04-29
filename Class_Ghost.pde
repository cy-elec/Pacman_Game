class Ghost {
  protected boolean isAlive=true;
  protected String name;
  protected int[] spawnpoint = new int[2];
  protected int[] position = new int[2];

  int[] oldPosition = new int[2];
  int[] renderPosition = new int[2];
  float[] renderFactor = new float[2];
  String renderDirection="";

  int deadTime = 6;
  int deadCount = 0;

  boolean frightened=false;

  protected color ghostColor;

  Ghost(String name, color c1, int position[]){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Ghost: Initialized Ghost["+name+"]");

    ghostColor=c1;
    this.name = name;
    this.spawnpoint = position.clone();
    this.oldPosition = position.clone();
    this.position = position.clone();
    this.renderPosition = position.clone();
    this.renderFactor[0] = 0;
    this.renderFactor[1] = 0;
  }

  void updateSmooth() {
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

    this.isAlive = false;
    this.renderPosition = this.spawnpoint.clone();
    this.renderDirection="";
    this.renderFactor=new float[2];
    this.position = this.spawnpoint.clone();

  }


}
