class Pacman {
  boolean isAlive=false;
  int[] position = new int[2];
  color pacmanColor = color(255, 255, 0);

  String direction;


  Pacman(){
    /*DEBUG*/
    debugoutput.println(hour()+":"+minute()+":"+second()+": "+"Pacman: Initialized pacman");
    this.direction="";
    this.position[0]=1;
    this.position[1]=1;
  }
}
