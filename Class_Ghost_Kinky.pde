/* Kinky */


class Kinky extends Ghost{

  int[] target = new int[2];

  Kinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Kinky",color(255,100,0), color(155,50,0), position, df);
  }

  void makeMove(int[] pacmanPosition, String pacmanDirection){

    if(super.isAlive){

      resetSmooth();
      findTarget(pacmanPosition, pacmanDirection);

      int[][] path = AStar(this.position, this.target, gameHandler.map, gameHandler.teleporters);
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

  void findTarget(int[] pacmanPosition, String pacmanDirection) {
    int sPos[] = pacmanPosition.clone();

    boolean loop = true;
    int directionVector[] = new int[2];

    switch(pacmanDirection) {
      case "up": directionVector[1]=-1;break;
      case "down": directionVector[1]=1;break;
      case "left": directionVector[0]=-1;break;
      case "right": directionVector[0]=1;break;
      default : this.target = pacmanPosition; return;
    }

    do {
      sPos[0]+=directionVector[0];
      sPos[1]+=directionVector[1];
      sPos[0] %= gameHandler.map[0].length;
      sPos[1] %= gameHandler.map.length;
      sPos[0] = sPos[0]<0?gameHandler.map[0].length-1:sPos[0];
      sPos[1] = sPos[1]<0?gameHandler.map.length-1:sPos[1];

      if(sPos[0]==this.position[0]&&sPos[1]==this.position[1]) {
        loop = false;
        sPos = pacmanPosition.clone();
      }
      else if(gameHandler.map[sPos[1]][sPos[0]]==1) {
        sPos[0]-=directionVector[0];
        sPos[1]-=directionVector[1];
        sPos[0] %= gameHandler.map[0].length;
        sPos[1] %= gameHandler.map.length;
        sPos[0] = sPos[0]<0?gameHandler.map[0].length-1:sPos[0];
        sPos[1] = sPos[1]<0?gameHandler.map.length-1:sPos[1];
        loop=false;
      }
      else {
        switch(pacmanDirection) {
          case "up": if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1||gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){loop=false;}break;
          case "down": if(gameHandler.map[sPos[1]][((sPos[0]-1)<0?gameHandler.map[0].length-1:sPos[0]-1)]!=1||gameHandler.map[sPos[1]][((sPos[0]+1)%gameHandler.map[0].length)]!=1){loop=false;}break;
          case "left": if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1||gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){loop=false;}break;
          case "right": if(gameHandler.map[((sPos[1]-1)<0?gameHandler.map.length-1:sPos[1]-1)][sPos[0]]!=1||gameHandler.map[((sPos[1]+1)%gameHandler.map.length)][sPos[0]]!=1){loop=false;}break;
        }
      }
    }while(loop);
    this.target=sPos.clone();
  }

}
