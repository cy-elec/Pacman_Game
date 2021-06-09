/* Clyde*/

class Clyde extends Ghost{

  Clyde(int position[], int df) {
    //calls constructor of parent class. Must be first action in child class' constructor
    super("Clyde", ghost_clyde_right0_img, ghost_clyde_right1_img, ghost_clyde_left0_img, ghost_clyde_left1_img, ghost_clyde_down0_img, ghost_clyde_down1_img, ghost_clyde_up0_img, ghost_clyde_up1_img, ghost_clyde_frightened_img, ghost_clyde_default_img, position, df);
  }
  //tries to stay out of the way -> goes always away from pacman

  void makeMove(int[] pacmanPosition){



  }

}
