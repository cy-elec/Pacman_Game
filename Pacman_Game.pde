/*  Pacman_Game.pde - Project by Elec42, TheJa937 and Flooxxxyy;

*/

//Language Reference:  https://processing.org/reference/

int score;
boolean keyMap[] = new boolean[256];

/*gameHandler is an instance of Game and used for the general game control*/
Game gameHandler = new Game();

void setup()
{

  //display
  surface.setResizable(false);
  surface.setSize(600, 600);
}

/*Update loop*/
void draw()
{

  /*renering Map*/
  gameHandler.renderMap();
  /*updating position of pacman and ghost, as well as handling collisions with ghost, coin, etc*/
  gameHandler.move(keyMap);
}


/*
  Keyboard functions
*/
void keyPressed()
{
  if(key != CODED) //if we detect a key press which is not a CODED key (=win, alt etc.) the key is marked in our key map
    keyMap[key]=true;
}

void keyReleased() {
  if(key != CODED)//if a key is released, we remeber the key, so that we can release it in our key map next cycle (1cylce= 1 pacman move)
    keyMap[key]=false;
}
