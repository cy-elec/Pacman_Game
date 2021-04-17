/* Blinky */

class Blinky extends Ghost{

  Blinky() {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky",color(255,0,0));
  }

  void makeMove(int[] pacmanPosition, int[][][] teleporters){

    int[][] path = AStar(pacmanPosition, this.position, teleporters);
    if (path!=null)
      this.position = path[1].clone();
  }
}
