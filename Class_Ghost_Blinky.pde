/* Blinky */

class Blinky extends Ghost{

  Blinky() {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky",color(255,0,0));
  }

  void makeMove(int[] pacmanPosition){

    if (this.position[0]==pacmanPosition[0]&&this.position[1]==pacmanPosition[1])
      return;

    //just takes the quickest path to pacman

    Node[] explored = {};
    Node[] unexplored = {new Node(null, 0, super.position,0)};



    while( unexplored.length != 0){

      bubbleSort(unexplored);

      Node oldNode = unexplored[0];

      int[][] possibleMoves = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}};

      for (int i  = 0; i<4; i++){
        int[] newPosition = {oldNode.position[0]+ possibleMoves[i][0], oldNode.position[1]+ possibleMoves[i][1]};
        int newH = (int)pow(abs(newPosition[0] - pacmanPosition[0]), 2) + (int)pow(abs(newPosition[1] - pacmanPosition[1]), 2);
        Node newNode = new Node(oldNode, oldNode.g+1, newPosition, newH);
        if ( (0<= newNode.position[0] && newNode.position[0]<gameHandler.map[0].length) && (0<= newNode.position[1] && newNode.position[1]<gameHandler.map.length)){
          if (gameHandler.map[newNode.position[0]][newNode.position[1]] != 1){
            if( !(isAinB(newNode, unexplored)||isAinB(newNode, explored))){
              if(newNode.position[0]==pacmanPosition[0] && newNode.position[1]==pacmanPosition[1]){
                int[][] path ={};
                while(newNode.parent!=null){
                  newNode= newNode.parent;
                  path = (int[][])append(path, newNode.position);

                }

                this.position[0] = path[path.length-2][1];
                this.position[1] = path[path.length-2][0];
                return;
              }
              unexplored = (Node[]) append(unexplored, newNode);
            }
          }
        }
      }
      explored = (Node[]) append(explored, unexplored[0]);
      unexplored = (Node[]) reverse(unexplored);
      unexplored = (Node[]) shorten(unexplored);
      unexplored = (Node[]) reverse(unexplored);
    }
  print("A* algorithm failed shame on jakob\n");
  return;
  }

}
