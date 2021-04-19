/* Inky */

class Inky extends Ghost{

  int[][] leereFelder = {};



  int[] inkiesGoal = this.position;

  Inky(int position[]) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Inky",color(0,100,255), position);


  }
    //least predictable of the ghosts (probably just random moves)

  void makeMove(int[] pacmanPosition){
    updateSmooth();

    if(this.position[0]==inkiesGoal[0]&&this.position[1]==inkiesGoal[1])
    {
      while(leereFelder.length>0)leereFelder=(int[][])shorten(leereFelder);
      findeleereFelder();
      this.inkiesGoal = (int[])leereFelder[(int)random(leereFelder.length)];
    }


    int[][] path = AStar(this.position, this.inkiesGoal, gameHandler.map, gameHandler.teleporters);
    if (path!=null) {
      int nPos[] = path[1].clone();

      if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
      else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

      if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
      else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}

      this.position = nPos.clone();
    }

  }


  void findeleereFelder()
  {
      for(int i=0; i< gameHandler.map.length; i++)
      {
        for(int j=0; j< gameHandler.map[0].length; j++)
        {
          if(gameHandler.map[i][j]!=1)
          {
            this.leereFelder = (int[][])append(this.leereFelder, new int[] {j,i});
          }
      }
    }
  }

}
