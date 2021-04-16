

class Node {

  Node parent;
  int g;//g is the distance from the start
  int[] position = new int[2];
  int h = 0;//h is the distance from the end
  Integer f;//f is the final evaluation


  //when calling we need to pass the array position as a variable
  Node(Node parent, int g, int[] position, int h) {
    this.parent = parent;
    this.g = g;
    this.position = position.clone();

    this.h = this.h+h;

    this.f = this.g + this.h;
  }

  boolean equals(Node otherNode) {
    if (otherNode.position[0] == this.position[0] && otherNode.position[1] == this.position[1])
      return true;
    else
      return false;
  }

  boolean uneaquals(Node otherNode) {
    return !this.equals(otherNode);
  }


}

void bubbleSort(Node[] a) {
    boolean sorted = false;
    Node temp;
    while(!sorted) {
        sorted = true;
        for (int i = 0; i < a.length - 1; i++) {
            if (a[i].f > a[i+1].f) {
                temp = a[i];
                a[i] = a[i+1];
                a[i+1] = temp;
                sorted = false;
            }
        }
    }
}

boolean isAinB(Node a, Node[] b){
  for (int i=0; i<b.length;i++){
    if(a.equals(b[i]))
      return true;
  }
  return false;


}
