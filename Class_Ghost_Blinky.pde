/* Blinky */

class Blinky extends Ghost{

  Blinky() {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky");
  }

  void makeMove(int[] pacmanPosition){

    //just takes the quickest path to pacman

    Node[] explored = {};
    Node[] unexplored = {new Node(null, 0, super.position,0)};



    while( unexplored.length != 0){

      bubbleSort(unexplored);

      Node oldNode = unexplored[0];

      int[][] possibleMoves = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}};

      for (int i  = 0; i<4; i++){
        int[] newPosition = {oldNode.position[0]+ possibleMoves[i][0], oldNode.position[1]+ possibleMoves[i][1]};
        Node newNode = new Node(oldNode, oldNode.g+1, newPosition, abs(newPosition[0] - pacmanPosition[0]) + abs(newPosition[1] - pacmanPosition[1]));
        if ( (0<= newNode.position[0] && newNode.position[0]<gameHandler.map[0].length) && (0<= newNode.position[1] && newNode.position[1]<gameHandler.map.length))
          if (gameHandler.map[newNode.position[0]][newNode.position[1]] != 1){






          }


      }


    }


    // A*
  }

}
