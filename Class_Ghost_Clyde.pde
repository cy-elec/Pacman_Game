/* Clyde*/

class Clyde extends Ghost{

  Clyde(int position[]) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Clyde",color(0,255,0), position);
  }
  //tries to stay out of the way -> goes always away from pacman

  void makeMove(int[] pacmanPosition){



  }

}
