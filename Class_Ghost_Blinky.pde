/* Blinky */

class Blinky extends Ghost{

  Blinky(int position[]) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky",color(255,0,0), position);
  }

  void makeMove(int[] pacmanPosition){
    updateSmooth();
    
    int[][] path = AStar(this.position, pacmanPosition, gameHandler.map, gameHandler.teleporters);
    if (path!=null) {
      int nPos[] = path[1].clone();

      if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
      else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

      if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
      else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}


      this.position = nPos.clone();
    }
  }
}
