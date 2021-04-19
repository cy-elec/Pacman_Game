/* Inky */

class Inky extends Ghost{

  int[][] leereFelder;



  int[] inkiesGoal = this.position;

  Inky(int position[]) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Inky",color(0,0,255), position);

    leereFelder = this.findeleereFelder();

    

    
  }
    //least predictable of the ghosts (probably just random moves)

  void makeMove(int[] pacmanPosition){
    
    if(this.position[0]==inkiesGoal[0]&&this.position[1]==inkiesGoal[1])
    {
      this.inkiesGoal = leereFelder[random(leereFelder.length)];
    }
    
    int[][] path = AStar(this.position, this.inkiesGoal, gameHandler.map, gameHandler.teleporters);
    if (path!=null) {
      int nPos[] = path[1].clone();
      

      this.position = nPos.clone();


  }

}





int[][] findeleereFelder()
{
  map = gameHandler.map;
    for(int i=0; i<= map.length; i++) 
    {
      for(int j=0; j<= map[0].length; j++)
      {
        if(map[i][j]!=1)
        {
          leereFelder = append(leereFelder, {j, i} );
        }
    }
  }
}
    


  
}
}
