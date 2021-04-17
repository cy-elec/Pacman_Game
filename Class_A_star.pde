
//the node class is essential for the implementation of A*

class Node {

  Node parent;
  int g;//g is the distance from the start
  int[] position = new int[2];//coordinates
  int h = 0;//h is the distance from the end
  Integer f;//f is the final evaluation


  //when calling we need to pass the array position as a variable
  Node(Node parent, int g, int[] position, int h) {

    /*
    basically, the Node class saves its own coordinates(position),
    its distance from the start(g);
    an evaluation (h);
    and its parent node ie the node that came before it (parent)
    furthermore it creates its own final evaluatioin f which is just h + g
    */
    this.parent = parent;
    this.g = g;
    this.position = position.clone();

    this.h = this.h+h;

    this.f = this.g + this.h;
  }

  // we define an equals function to check if two nodes are the same
  //they are the same as long as their positions match
  boolean equals(Node otherNode) {
    if (otherNode.position[0] == this.position[0] && otherNode.position[1] == this.position[1])
      return true;
    else
      return false;
  }




}


//this bubbleSort function was copied from the internet, basically it just sorts stuff
//i only kinda understand how it works so youll just have to google bubble Sort
//Note that this function returns void and changes the array passed to it
/*Edit by Felix: Top index 0 equals the least Node.f value --> best node at top*/
void bubbleSort(Node[] a) {
    boolean sorted = false;
    Node temp;
    while(!sorted) {
        sorted = true;
        for (int i = 0; i < a.length - 1; i++) {
            if (a[i].f > a[i+1].f) {//this line is the only line i altered; i changed a[] to a[].f so that the evaluation is used to sort the nodes
                temp = a[i];
                a[i] = a[i+1];
                a[i+1] = temp;
                sorted = false;
            }
        }
    }
}


// i just translated a python A* algorithm so im recreating python functions
//the function does basically exactly what it says: it checks wether a is in b;
//Note that a has to be a Node and b an array of Nodes
boolean isAinB(Node a, Node[] b){
  for (int i=0; i<b.length;i++){
    if(a.equals(b[i]))
      return true;
  }
  return false;


}


int[][] AStar(int[] position1, int[] position2, int[][] map, int[][][] teleporters){


  //the A* algorithm (it tries to find the best path from position1 to position2)


  // if the two positions are the same we quit the function
  //basically just a failsave
  if (position1[0]==position2[0]&&position1[1]==position2[1])
    return null;


  //we create two arrays, one will house all explored nodes
  //the other will house all adjacent Nodes which we are yet to explored
  //Note that Nodes which are not adjacent to the explored Nodes are present in neither list
  //they will be added to our unexplored list if we find a path to this node ie a node next to it is explored
  Node[] explored = {};
  // the only node so far is our starting point, it has no parent and both its distance from the start and from the end are set to a default value of 0
  //this is because no matter what, it will be explored as it is the only node we have
  Node[] unexplored = {new Node(null, 0, position1,0)};


  // we will loop until there are no unexplored nodes left,
  //if this happens then there is no path to pacman and the ghost does not move
  //this should never happen as our maze is built in a way which connects all empty squares with each other
  while( unexplored.length != 0){

    //first of we sort our unexplored list according to the evaluation we give each node
    //so that the node with the lowest evalutaion ie the node most likely to lead to our goal ist first
    bubbleSort(unexplored);

    // we then save the node to be explored
    Node oldNode = unexplored[0];

    String[] possibleMoves = {"up", "down", "left", "right"};


    //we loop through all steps which can possibly be taken from the old Node and save their positions
    for (int i  = 0; i<4; i++){

       int[] newPosition = {oldNode.position[0], oldNode.position[1]};

      //this is a slightly altered version of the game.move() code
      switch(possibleMoves[i]) {
      case "up":
       newPosition[1]--;
       newPosition[1]= newPosition[1]<0?map.length-1:newPosition[1];
       break;
      case "down":
        newPosition[1]++;
        newPosition[1] %= map.length;
        break;
      case "left":
        newPosition[0]--;
        newPosition[0]= newPosition[0]<0?map[0].length-1:newPosition[0];

        break;

      case "right":
        newPosition[0]++;
        newPosition[0] %= map[0].length;
        break;
      default:break;
      }




      //first we check if our new Nodes position is a wall
      if (map[newPosition[1]][newPosition[0]] != 1){

        //with the new position we then create a new evaluation consisting of the length that we are away from our goal (a**2 + b**2 = c**2)
        int newH = (int)pow((int)pow(abs(newPosition[0] - position2[0]), 2) + (int)pow(abs(newPosition[1] - position2[1]), 2), 0.5);

        for (int j=0; j<teleporters.length; j++){
          //we loop through every teleporter and check, if the distance from position1 to teleporter 1 plus the distance from teleporter2 to position2 is lower than the normal distance
          //(each teleporter consists of two sides teleporter1 and 2)
          int newHTeleporter =(int) pow( (int)pow(abs(newPosition[0] - teleporters[j][0][0]), 2) + (int)pow(abs(newPosition[1] - teleporters[j][0][1]), 2), 0.5)
                              +
                              (int) pow( (int)pow(abs(teleporters[j][1][0] - position2[0]), 2) + (int)pow(abs(teleporters[j][1][1] - position2[1]), 2), 0.5);
          if (newHTeleporter<newH)
            newH=newHTeleporter;

          //then we check the opposite: position1 -> teleporter2 + teleporter1 -> positon2
          newHTeleporter = (int) pow((int) pow( (int)pow(abs(newPosition[0] - teleporters[j][1][0]), 2) + (int)pow(abs(newPosition[1] - teleporters[j][1][1]), 2), 0.5) + (int)pow( (int)pow(abs(teleporters[j][0][0] - position2[0]), 2) + (int)pow(abs(teleporters[j][0][1] - position2[1]), 2), 0.5), 2);

          if (newHTeleporter<newH)
            newH=newHTeleporter;


        }




        // now that we have the new position and the new evalutaion we can create a new node
        //the parent node is our old node and our distance from the start increases by 1
        Node newNode = new Node(oldNode, oldNode.g+1, newPosition, newH);

        //we only check the new node if it has not been explored before and it hasnt already been added to our unexplored list
        if( !(isAinB(newNode, unexplored)||isAinB(newNode, explored))){

          //if our new Node has the position of our end destination, then we are almost done
          if(newNode.position[0]==position2[0] && newNode.position[1]==position2[1]){

            //if we find the end then we just backtrack back to the start
            int[][] path ={position2};

            //we do this by adding the position of the parent node to our path array until the parent node is null ie we've found our start node
            while(newNode.parent!=null){
              newNode= newNode.parent;
              path = (int[][])append(path, newNode.position);
            }
            //return the final and (hopefully) best path
            return (int[][]) reverse(path);
          }
          //if we havent found our goal, we just add the newNode to our unexplored list, so that it can be explored later
          unexplored = (Node[]) append(unexplored, newNode);
        }
      }
    }
    //remove the old node from our unexplored list and add it to our explored list as all its neighbors have been checked
    explored = (Node[]) append(explored, unexplored[0]);
    unexplored = (Node[]) reverse(unexplored);
    unexplored = (Node[]) shorten(unexplored);
    unexplored = (Node[]) reverse(unexplored);
  }

//if we could not find a path we print an error message and return null
//we should not reach this point as we should find a path and leave the function with the return statement in line 195
print("A* algorithm could not find a path \n");
return null;
}
