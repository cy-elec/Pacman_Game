class Pacman {
  boolean isAlive=true;
  int[] position = new int[2];

  String direction;
  
  color pacmanColor = color(255, 255, 0);


  Pacman(){
    this.direction="";
    this.position[0]=1;
    this.position[1]=1;
  }
}
