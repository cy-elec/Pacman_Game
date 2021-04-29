/* Inky */

class Inky extends Ghost{

  int[][] leereFelder = {};
  int[][] path = {};
  int count = 0;



  int[] inkiesGoal = this.position;

  Inky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Inky",color(0,100,255), color(0,50,155), position, df);


  }
    //least predictable of the ghosts (probably just random moves)

  void makeMove(){

    if(this.isAlive){

      updateSmooth();
      if(this.leereFelder.length==0) findeleereFelder();
      if(this.position[0]==inkiesGoal[0]&&this.position[1]==inkiesGoal[1])
      {
        this.inkiesGoal = (int[])leereFelder[(int)random(leereFelder.length)];
        this.path = AStar(this.position, this.inkiesGoal, gameHandler.map, gameHandler.teleporters);
        count = 0;
      }

      if (path!=null) {
        count++;
        int nPos[] = path[count].clone();

        if(nPos[0]-this.position[0]==-1) {this.renderDirection="left";}
        else if(nPos[0]-this.position[0]==1) {this.renderDirection="right";}

        if(nPos[1]-this.position[1]==-1) {this.renderDirection="up";}
        else if(nPos[1]-this.position[1]==1) {this.renderDirection="down";}

        this.position = nPos.clone();
      }
    }

    else{
      if(this.deadCount>=this.deadTime){
        this.deadCount = 0;
        this.inkiesGoal=this.spawnpoint.clone();
        this.isAlive = true;
      }
      else
        super.deadCount++;
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
