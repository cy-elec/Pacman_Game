/* Blinky */

class Blinky extends Ghost{

  Blinky() {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky",color(255,0,0));
  }

  void makeMove(int[] pacmanPosition){

    //the A* algorithm (it finds the best path to pacman)
    // Im thinking of moving this into the A* file and making it a public functioin, so that all ghosts have acces to it


    // if we are already on pacman we quit the function
    //basically just a failsave
    if (this.position[0]==pacmanPosition[0]&&this.position[1]==pacmanPosition[1])
      return;


    //we create two arrays, one will house all explored nodes
    //the other will house all adjacent Nodes which we are yet to explored
    //Note that Nodes which are not adjacent to the explored Nodes are present in neither list
    //they will be added to our unexplored list if we find a path to this node ie a node next to it is explored
    Node[] explored = {};
    // the only node so far is our starting point, it has no parent and both its distance from the start and from the end are 0
    //this is because no matter what, it will be explored as it is the only node we have
    Node[] unexplored = {new Node(null, 0, super.position,0)};


    // we will loop until there are no unexplored nodes left,
    //if this happens then there is no path to pacman and the ghost does not move
    //this should never happen as our maze is built in a way which connects all empty squares with each otherNode
    while( unexplored.length != 0){

      //first of we sort our unexplored list according to the evaluation we give each node
      bubbleSort(unexplored);

      // we then save the node to be explored
      Node oldNode = unexplored[0];

      String[] possibleMoves = {"up", "down", "left", "right"};


      //we loop through all steps which can possibly be taken from the old Node and save their positions
      for (int i  = 0; i<4; i++){

         int[] newPosition = {oldNode.position[0], oldNode.position[1]};

        switch(possibleMoves[i]) {
        case "up":
         newPosition[1]--;
         newPosition[1]= newPosition[1]<0?gameHandler.map.length-1:newPosition[1];
         break;
        case "down":
          newPosition[1]++;
          newPosition[1] %= gameHandler.map.length;
          break;
        case "left":
          newPosition[0]--;
          newPosition[0]= newPosition[0]<0?gameHandler.map[0].length-1:newPosition[0];

          break;

        case "right":
          newPosition[0]++;
          newPosition[0] %= gameHandler.map[0].length;
          break;
        default:break;
        }




        //first we check if our new Nodes position is a wall
        if (gameHandler.map[newPosition[1]][newPosition[0]] != 1){

          //with the new position we then create a new evaluation consisting of the length from pacman
          //Note that this means that the ghosts dont like taking teleporters, as it means that you have to increase your distance from pacman first, to reach said teleporter
          //this is a huge flaw that results in the algorithm being kinda ineffective
          int newH = (int)abs(newPosition[0] - pacmanPosition[0]) + (int)abs(newPosition[1] - pacmanPosition[1]);

          // now that we have the new position and the new evalutaion we can create a new node
          //the parent node is our old node and our distance from the start increases by 1
          Node newNode = new Node(oldNode, oldNode.g+1, newPosition, newH);

          //we only check the new node if it has not been explored before and it hasnt already been added to our unexplored list
          if( !(isAinB(newNode, unexplored)||isAinB(newNode, explored))){

            //if our new Node has the position of our end destination, then we are almost done
            //otherwise we just add the newNode to our unexplored list
            if(newNode.position[0]==pacmanPosition[0] && newNode.position[1]==pacmanPosition[1]){

              //if we find the end then we just backtrack back to the start
              int[][] path ={pacmanPosition};

              //we do this by adding the position of the parent node to our path array until the parent node is null ie we've found our start node
              while(newNode.parent!=null){
                newNode= newNode.parent;
                path = (int[][])append(path, newNode.position);
              }
              //then we update Blinkys position to take the first step of the path
              this.position = path[path.length-2].clone();
              return;
            }
            unexplored = (Node[]) append(unexplored, newNode);
          }
        }
      }
                  //remove the old node from our unexplored list and add it to our explored list as all its neighbors are not the end position
      explored = (Node[]) append(explored, unexplored[0]);
      unexplored = (Node[]) reverse(unexplored);
      unexplored = (Node[]) shorten(unexplored);
      unexplored = (Node[]) reverse(unexplored);
    }
  print("A* algorithm could not find a path");
  return;
  }

}
