/* Blinky */

class Blinky extends Ghost{

  Blinky(int position[]) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky",color(255,0,0), position);
  }

  void makeMove(int[] pacmanPosition){

    int[][] path = AStar(this.position, pacmanPosition, gameHandler.map, gameHandler.teleporters);
    if (path!=null)
      this.position = path[1].clone();
  }
}
