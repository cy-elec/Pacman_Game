/* Clyde*/

class Clyde extends Ghost{

  Clyde(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Clyde",color(0,255,0), color(0,155,0), position, df);
  }
  //tries to stay out of the way -> goes always away from pacman

  void makeMove(int[] pacmanPosition){



  }

}
