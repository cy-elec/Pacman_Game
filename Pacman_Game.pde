//Language Reference:  https://processing.org/reference/

int score;
boolean keyMap[] = new boolean[256];

Game gameHandler = new Game();

void setup()
{
  /**/
  size(500, 500);
}

void draw()
{
  gameHandler.renderMap();
  gameHandler.move();
}


void keyPressed()
{
  if(key != CODED) //if we detect a key press which is not a CODED key (=win, alt etc.) the key is marked in our key map
    keyMap[key]=true;
}

void keyReleased() {
  if(key != CODED)//if a key is released, we remeber the key, so that we can release it in our key map next cycle (1cylce= 1 pacman move)
    keyMap[key]=false;
}
