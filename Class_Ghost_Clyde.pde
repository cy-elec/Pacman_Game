/* Clyde*/

class Clyde extends Ghost{

  Clyde(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Clyde", loadImage("ghost_clyde_right0.png"), loadImage("ghost_clyde_right1.png"), loadImage("ghost_clyde_left0.png"), loadImage("ghost_clyde_left1.png"), loadImage("ghost_clyde_down0.png"), loadImage("ghost_clyde_down1.png"), loadImage("ghost_clyde_up0.png"), loadImage("ghost_clyde_up1.png"), loadImage("ghost_clyde_frightened.png"), loadImage("ghost_clyde_default.png"), position, df);
    this.isAlive=false;
  }
  //tries to stay out of the way -> goes always away from pacman

  void makeMove(int[] pacmanPosition){



  }

}
