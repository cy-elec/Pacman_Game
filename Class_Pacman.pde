class Pacman {
  boolean isAlive = true;
  int[] position = new int[2];
  final int[] spawnpoint = {1,1};
  color pacmanColor = color(255, 255, 0);
  int lives = 3;

  String direction = "";
  String oldDirection = "";;


  Pacman(){
    /*DEBUG*/
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
