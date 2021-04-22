/* Pinky */

class Pinky extends Ghost{

  int[] goal;

  Pinky(int position[]) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Blinky",color(255,0,255), position);

    goal = position.clone();
  }
  //tries to cut off your path off by coming in front of you

  void makeMove(int[] pacmanPosition, String pacmanDirection){

    //immer schauen, wo pacman in 4 schritten ist und da das neue ziel hinsetzen

    int[] goal = pacmanPosition.clone();

    switch(pacmanDirection) {
    case "up":
      goal[1]-= 4;
      break;

    case "down":
      goal[1]+=4;
      break;

    case "left":
      goal[0]-=4;
      break;

    case "right":
      goal[0]+=4;
      break;

    default:
      break;
    }

    goal = this.getValidPos(goal.clone(), pacmanDirection, false);

  this.goal = goal;

  int[][] path = AStar(this.position, goal, gameHandler.map, gameHandler.teleporters);

  if (path!=null)
    this.position = path[1].clone();

  }



  int[] getValidPos(int[] coord, String pacmanDirection, boolean hitWall){
    //it takes a given position as its argument and checks wether it is valid (!= out of bounds, !=wall)
    //wall = 1, free = 0




    if(hitWall){
      switch(pacmanDirection) {
      case "up":
        coord[1]++;
        break;

      case "down":
        coord[1]--;
        break;

      case "left":
        coord[0]++;
        break;

      case "right":
        coord[0]--;
        break;

      default:
        break;
      }

      if (gameHandler.map[coord[1]][coord[0]]!=1)
        return coord;
      else
        return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
    }




    if(coord[0]<0){
      coord[0]=0;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
    }
    else if(coord[1]<0) {
      coord[1]=0;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

    }
    else if(coord[0]>=gameHandler.map[0].length){
      coord[0]=gameHandler.map[0].length-1;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

    }
    else if(coord[1]>=gameHandler.map.length){
      coord[1]=gameHandler.map.length-1;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
    }

    else{
      if (gameHandler.map[coord[1]][coord[0]]==1){

        switch(pacmanDirection) {
        case "up":
          coord[1]--;
          break;

        case "down":
          coord[1]++;
          break;

        case "left":
          coord[0]--;
          break;

        case "right":
          coord[0]++;
          break;

        default:
          break;
        }

        if(coord[0]<0){
          coord[0]=0;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
        }
        else if(coord[1]<0) {
          coord[1]=0;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
        else if(coord[0]>=gameHandler.map[0].length){
          coord[0]=gameHandler.map[0].length-1;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
        else if(coord[1]>=gameHandler.map.length){
          coord[1]=gameHandler.map.length-1;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);
        }


        if (gameHandler.map[coord[1]][coord[0]]!=1)
          return coord;

        else
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
    }

    return coord;
  }

}
