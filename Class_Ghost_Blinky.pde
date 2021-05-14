/* Blinky */

class Blinky extends Ghost{

  Blinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky", ghost_blinky_right0_img, ghost_blinky_right1_img, ghost_blinky_left0_img, ghost_blinky_left1_img, ghost_blinky_down0_img, ghost_blinky_down1_img, ghost_blinky_up0_img, ghost_blinky_up1_img, ghost_blinky_frightened_img, ghost_blinky_default_img, position, df);
  }

  void makeMove(int[] pacmanPosition){

    if(super.isAlive){
      resetSmooth();

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
    else{
      if(super.deadCount>=super.deadTime){
        super.deadCount = 0;
        super.isAlive = true;
      }
      else
        super.deadCount++;
    }
  }
}
