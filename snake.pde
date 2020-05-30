/* Work Cited: https://discourse.processing.org/t/how-to-make-the-snake-not-move-constantly/16453
                this Page helped me with the arraylist to make the snakes body follow the head
   This is a Slightly Fancy Snake Game. 
   Arrow Keys to Move
   N to Restart
   I for Instructions
   [spacebar] for pausing 
*/




String TITLE = "Danger Noodle";
boolean showInfo; // information tab on or off switch
color snakeCol1=color(0);//color
color snakeCol2=color(92, 207, 66);
float advance = 100; // checks if everything is reset after you die
int slow = 10; // snake speed
int lastBase = 2; //where the end of the snake is
int cx, cy;// snake head
int moveX = 0;//snake movement
int moveY = 0;
int snakeX = 0;//snake body
int snakeY = 0;
int foodX = -1;//food pos
int foodY = -1;
boolean check = true;//have you eaten the food
int[] snakesX;// array list for snake body
int[] snakesY;
int snakeSize = 3;//starting size of snake
int baseX = 50;// makes sure apples dont spawn in unreachable areas
int baseY = 50;// also used as apple collison area
int windowSize = 400;// size of playing area
boolean gameover = false; // dead
boolean pause=false;// pause 
PImage backIMG; //images
PImage foodIMG;
PImage superfoodIMG;
PImage head0IMG;
PImage head1IMG;
PImage head2IMG;
PImage head3IMG;
PImage bodyIMG;
PImage tailIMG;
int dir=0; // direction snake is heading changes the image used to repersent the snakes head
int foodType = 0; // foodtype 0 = normal foodtype 1 = bonus speed 
void setup()
{
  size(500, 500);
  surface.setTitle(TITLE); 
  smooth();
  frameRate=60;
  backIMG = loadImage("back.png");
  foodIMG = loadImage("food.png");  
  superfoodIMG = loadImage("superfood.png");  
  head0IMG = loadImage("head0.png");    
  head1IMG = loadImage("head1.png");    
  head2IMG = loadImage("head2.png");    
  head3IMG = loadImage("head3.png");      
  imageMode(CENTER);
  textAlign(CENTER);
  advance = 100;
  slow = 10;
  snakesX = new int[100];
  snakesY = new int[100];
  cx = width/2;
  cy = height/2;
  snakeX = cx-5;
  snakeY = cy-5;
  foodX = -1;
  foodY = -1;
  snakeSize = 3;
  gameover = false;
  check = true;
}
void draw()
{

  if (pause==false)
  {
    if (advance%slow == 0)
    {
      runGame();
    }
    advance++;
  } else 
  {
    if (gameover==false)
    {
      fill(255, 128);
      stroke(0);
      rectMode(CENTER);
      rect(width/2, height/2 - 8, 120, 30);
      fill(0);
      text("PAUSE", width/2, height/2);      
      noLoop();
    }
  }
  if (showInfo)
  { 
    infoWindow();
  }
}

void newGame()
{
  snakeX = cx-5;
  snakeY = cy-5;
  check = true;
  snakeSize = 3; 
  moveY = 0;
  moveX = 0;
  slow = 10;
  lastBase = 2;
  dir = 0;
  gameover = false;  
  loop();
}

void runGame()
{
  if (gameover== false)
  {
    image(backIMG, width/2, height/2);    
    fill(255);
    text(snakeSize-3, 24, 64);    
    drawfood();
    drawSnake();
    snakeMove();
    grabFood();
    checkAutoIntersect();
    updateSpeed();
  } else
  {
    fill(255, 128);
    stroke(0);
    rectMode(CENTER);
    rect(width/2, height/2 - 8, 150, 30);
    fill(0);
    text("GAME OVER", width/2, height/2);
    text("Press 'N' to start new game", width/2, height/2+232);
    noLoop();
  }
}

void checkAutoIntersect()
{ 
  if (snakeSize > 3)
  {
    for (int i = 1; i < snakeSize; i++)
    {
      if (snakeX == snakesX[i] && snakeY== snakesY[i])
      {
        gameover = true;
      }
    }
  }
}

void grabFood()
{
  if (foodX == snakeX && foodY == snakeY)
  {
    check = true;
    if (foodType==0) { 
      snakeSize++;
    }
    updateSpeed();
  }
}

void drawfood()
{
  while (check)
  {
    foodType = 0;
    if (snakeSize > 13)
    {
      foodType = (int)random(0, 10);
      if ((foodType==9))
      {
        foodType=1;
      } else
      {
        foodType=0;
      }
    }  

    int x = (int)random(baseX/10+1, -1+(windowSize+baseX)/10);
    int y = (int)random(baseY/10+1, -1+(windowSize+baseY)/10);
    foodX = 5+x*10;
    foodY = 5+y*10;
    for (int i = 0; i < snakeSize; i++)
    { 
      if ((foodX == snakesX[i]) && (foodY == snakesY[i]))
      {
        check = true;
      } else
      {
        check = false;
      }
    }
  }

  if (foodType==0)
  {
    image(foodIMG, foodX, foodY);
  } else  
  {
    image(superfoodIMG, foodX, foodY);
  }
}

void drawSnake()
{
  stroke(49, 121, 11);
  for (int i = 0; i < snakeSize; i++) 
  {
    int X = snakesX[i];
    int Y = snakesY[i];
    noStroke();
    if (i==0)
    { 
      if (dir==0) { 
        image(head0IMG, X, Y-6);
      }
      if (dir==1) { 
        image(head1IMG, X+6, Y);
      }
      if (dir==2) { 
        image(head2IMG, X, Y+6);
      }      
      if (dir==3) { 
        image(head3IMG, X-6, Y);
      }
    } else
    {          
      if (i == snakeSize-1)
      {
        fill(38, 110, 7);        
        ellipse(X, Y, 9, 9);
        fill(206, 232, 114);      
        ellipse(X, Y, 5, 5);             
        fill(44, 50, 25);
        ellipse(X, Y, 2, 2);
      } else
      {
        fill(38, 110, 7);        
        ellipse(X, Y, 11, 11);
        fill(206, 232, 114);      
        ellipse(X, Y, 7, 7);             
        fill(44, 50, 25);
        ellipse(X, Y, 3, 3);
      }
    }
  }

  for (int i = snakeSize; i > 0; i--)
  {
    snakesX[i] = snakesX[i-1];
    snakesY[i] = snakesY[i-1];
  }
}
void snakeMove()
{
  snakeX += moveX;
  snakeY += moveY;
  if ((snakeX > windowSize+baseX) || (snakeX < baseX) || (snakeY > windowSize+baseY) || (snakeY < baseY))
  { 
    gameover = true;
  }
  snakesX[0] = snakeX;
  snakesY[0] = snakeY;
}
void updateSpeed()
{
  if (foodType==1)
  {
    slow = slow + 2;
  } else
  {  
    if ((snakeSize-lastBase) > 2)
    {
      slow--;
      lastBase=snakeSize;
    }
  }
  if (slow > 10) { 
    slow=10;
  } 
  if (slow < 2) { 
    slow=2;
  }
}  
void keyPressed() 
{
  if (keyCode == UP)    
  { 
    if (snakesY[1] != snakesY[0]-10) 
    {  
      moveY = -10; 
      moveX = 0; 
      dir=0;
    }
  }

  if (keyCode == DOWN)  
  { 
    if (snakesY[1] != snakesY[0]+10) 
    {
      moveY = 10;  
      moveX = 0; 
      dir=2;
    }
  }

  if (keyCode == LEFT)  
  { 
    if (snakesX[1] != snakesX[0]-10) 
    {
      moveX = -10; 
      moveY = 0; 
      dir=3;
    }
  }

  if (keyCode == RIGHT) 
  { 
    if (snakesX[1] != snakesX[0]+10) 
    {
      moveX = 10;
      moveY = 0; 
      dir=1;
    }
  }
  if ((key == 'N') || (key=='n'))  
  { 
    newGame();
  }
  if ((key==' ') || (key == 'P') || (key=='p'))  
  { 
    if ((showInfo==false) && (gameover==false))
    {
      pause=!(pause); 
      loop();
    }
  } 
  if (key=='i' || key=='I')
  {
    if ((pause==false)  && (gameover==false))
    {
      showInfo = !(showInfo);
      if (showInfo==false)
      { 
        loop();
      }
    }
  }

  if (keyCode==ESC)
  {
    key=0;
  }
}

void mousePressed()
{

  if ((mouseX > 481) && (mouseX < 498) && (mouseY > 481) && (mouseY < 498))
  {
    if ((pause==false)  && (gameover==false))
    {
      showInfo = !(showInfo);
      if (showInfo==false)
      { 
        loop();
      }
    }
  }
}
void mouseMoved()
{
  if ((mouseX > 481) && (mouseX < 498) && (mouseY > 481) && (mouseY < 498))
  {
    cursor(HAND);
  } else
  { 
    cursor(ARROW);
  }
}
void infoWindow()
{
  fill(0, 210);
  rectMode(CENTER);
  textAlign(CENTER);
  noStroke();
  rect(width/2, height/2, 250, 150);
  fill(240);
  text("SNAKE", width/2, height/2-54);
  text("The game of Snake.", width/2, height/2-32);        
  textAlign(LEFT);
  text("[N] key: start new game", width/2-114, height/2-10);
  text("[arrows] key: up,right,down,left", width/2-114, height/2+6);  
  text("[space] key: pause game", width/2-114, height/2+22);
  text("[I] key: show/hide info", width/2-114, height/2+38);
  text("__________________________________", width/2-119, height/2+66);
  textAlign(CENTER);
  noLoop();
}  
