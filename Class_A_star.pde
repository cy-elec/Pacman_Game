
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
//the function does basically exactly what it says: it checks wether a is in break;
//Note that a has to be a Node and b an array of Nodes
boolean isAinB(Node a, Node[] b){
  for (int i=0; i<b.length;i++){
    if(a.equals(b[i]))
      return true;
  }
  return false;


}
