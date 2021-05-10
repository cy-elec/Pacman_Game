/* Pinky */

class Pinky extends Ghost{

  int[] goal;

  Pinky(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Pinky", loadImage("ghost_pinky_right0.png"), loadImage("ghost_pinky_right1.png"), loadImage("ghost_pinky_left0.png"), loadImage("ghost_pinky_left1.png"), loadImage("ghost_pinky_down0.png"), loadImage("ghost_pinky_down1.png"), loadImage("ghost_pinky_up0.png"), loadImage("ghost_pinky_up1.png"), loadImage("ghost_pinky_frightened.png"), loadImage("ghost_pinky_default.png"), position, df);

  }
  //tries to cut off your path off by coming in front of you

  void makeMove(int[] pacmanPosition, String pacmanDirection){

    if(super.isAlive){
      resetSmooth();

      this.goal = findGoal(pacmanPosition, pacmanDirection);




      int[][] path = AStar(this.position, this.goal, gameHandler.map, gameHandler.teleporters);

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

  int[] findGoal(int[] pacmanPosition, String pacmanDirection){
    int[] goal = pacmanPosition.clone();

    //if pinky is infront of pacman, corner him with blinky by chasing him down
    switch(pacmanDirection) {
    case "up":
      if (this.position[1] <= pacmanPosition[1]){
        return goal;
      }
      break;

    case "down":
      if (this.position[1] >= pacmanPosition[1]){
        return goal;
      }
      break;

    case "left":
      if (this.position[0] <= pacmanPosition[0]){
        return goal;
      }
      break;

    case "right":
      if (this.position[0] >= pacmanPosition[0]){
        return goal;
      }
      break;

    default:
      break;
    }



    //immer schauen, wo pacman in 4 schritten ist und da das neue ziel hinsetzen

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

    return goal;



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
      coord[0]=gameHandler.map[0].length;
      hitWall = true;
      return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

    }
    else if(coord[1]>=gameHandler.map.length){
      coord[1]=gameHandler.map.length;
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
          coord[0]=gameHandler.map[0].length;
          hitWall = true;
          return this.getValidPos(coord.clone(), pacmanDirection, hitWall);

        }
        else if(coord[1]>=gameHandler.map.length){
          coord[1]=gameHandler.map.length;
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
