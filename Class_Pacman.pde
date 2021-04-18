class Pacman {
  boolean isAlive = false;
  int[] position = new int[2];
  int[] spawnpoint = new int[2];
  color pacmanColor = color(255, 255, 0);
  int lives = 3;

  String direction = "";
  String oldDirection = "";;


  Pacman(int spawn[]){
    /*DEBUG*/
    this.spawnpoint = spawn.clone();
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Pacman: Initialized pacman");
    this.direction="";
    this.position = this.spawnpoint.clone();

  }

  void reset(){

    this.isAlive = true;
    this.position = this.spawnpoint.clone();
    direction = "";
    oldDirection = "";

  }


}
