/* Blinky */

class Blinky extends Ghost{

  Blinky() {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky");
  }


  void makeMove(int[] pacmanPosition){

    Node[] explored = {};
    Node[] unexplored = {Node(null, 0, Blinky.position)};

    while unexplored.length != 0{





    }


    // A*




  }

}
