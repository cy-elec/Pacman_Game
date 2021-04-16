


class Node implements Comparable< Node >{

  Node parent;
  int g;//g is the distance from the start
  int[] position = new int[2];
  int h = 0;//h is the distance from the end
  int f;//f is the final evaluation


  Node(Node parent, int g, int[] position, int h){
    this.parent = parent;
    this.g = g;
    this.position = position;


    if(h==0) this.f = this.g;

    else {
      this.h = h;
      this.f = this.g + this.h;
    }

  }
  boolean equals(Node otherNode){
    if (otherNode.position[0] == this.position[0] && otherNode.position[1] == this.position[1])
      return true;
    else
      return false;
  }

  boolean uneaquals(Node otherNode){
    return !this.equals(otherNode);




  }

  @Override
  int compareTo(Node otherNode){

    return this.f.compareTo(otherNode.f)
  }





}
