import java.util.Random;
import java.lang.Thread;

int lastRecordedTime = 0;
int simulationWidth = 80;
int simulationHeight = 50;
int cellSize = 20;
int simulationWidthPixels = simulationWidth * cellSize;
int simulationHeightPixels = simulationHeight * cellSize;
byte[][] simulation = new byte[simulationWidth][simulationHeight];
int interval = 200;
PImage simulationImage;
boolean pause = false;

float categorySplit = 1.0f/7.0f;
float probOfRandom = categorySplit * 1.0f;
float probOfGlider = categorySplit * 2.0f;
float probOfSmallExploder = categorySplit * 3.0f;
float probOfExploder = categorySplit * 4.0f;
float probOf10CellRow = categorySplit * 5.0f;
float probOfLightweightSpaceship = categorySplit * 6.0f;
float probOfTumbler = categorySplit * 7.0f;
//Make < 0 for random, else = to 1 of the above
float debugChoice = -1;

int randomCentreSize = 10;
float randomBirthRate = 0.2f;

color black = color(0);
color white = color(255);
color zombie = #FF0000;
color borderColour = #FCF108;

int goCounter = 0;
boolean zombiesMode = false;

void setup()
{
  size(1600, 1000);
  simulation = initSimulation();
  simulationImage = recreateSimulationImage();
}

void draw()
{ //<>//
   if (millis()-lastRecordedTime>interval && !pause)
   {
     image(simulationImage, 0, 0);
     if((goCounter % 3) == 0)
     {
       zombiesMode = !zombiesMode;
     }
     goCounter++;
     if(zombiesMode)
     {
      simulation = runGameOfLifeZombies(); 
     }
     else
     {
      simulation = runGameOfLife(); 
     }
     simulationImage = recreateSimulationImage();
     lastRecordedTime = millis();
  }
}

void mouseClicked()
{
  int xBorder = mouseX;
  int yBorder = mouseY;
  while((xBorder % cellSize) != 0)
  {
   xBorder--; 
  }
  while((yBorder % cellSize) != 0)
  {
   yBorder--; 
  }
  System.out.println("xBorder: " + xBorder);
  System.out.println("yBorder: " + yBorder);
  int xCell = xBorder/cellSize;
  int yCell = yBorder/cellSize;
  if(zombiesMode)
  {
   simulation[xCell][yCell] = 2; 
  }
  else
  {
    simulation[xCell][yCell] = 1;
  }
  simulationImage = recreateSimulationImage();
  image(simulationImage, 0, 0);
}

void keyPressed()
{
  if (key==' ')
  {
    pause = !pause;
  } 
}

byte[][] initSimulation()
{
 byte[][] myNewSimulation = new byte[simulationWidth][simulationHeight];
 for(int i = 0; i < simulationWidth; i++)
 {
  for(int j = 0; j < simulationHeight; j++)
  {
   myNewSimulation[i][j] = 0; 
  }
 }
 return addRandomPattern(myNewSimulation);
}

byte[][] addRandomPattern(byte[][] mySimulation)
{
  Random randy = new Random(System.currentTimeMillis());
  float randyVal;
  if(debugChoice < 0)
  {
    randyVal = randy.nextFloat();
  }
  else
  {
   randyVal = debugChoice; 
  }
  if(randyVal <= probOfRandom)
  {
   return addRandom(mySimulation); 
  }
  if(randyVal <= probOfGlider)
  {
   return addGlider(mySimulation); 
  }
  if(randyVal <= probOfSmallExploder)
  {
   return addSmallExploder(mySimulation); 
  }
  if(randyVal <= probOfExploder)
  {
   return addExploder(mySimulation); 
  }
  if(randyVal <= probOf10CellRow)
  {
   return add10CellRow(mySimulation); 
  }
  if(randyVal <= probOfLightweightSpaceship)
  {
   return addLightweightSpaceship(mySimulation); 
  }
  return addTumbler(mySimulation); 
}

byte[][] addRandom(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - (randomCentreSize/2);
  int startHeight = (simulationHeight/2) - (randomCentreSize/2);
  int endWidth = startWidth + (randomCentreSize);
  int endHeight = startHeight + (randomCentreSize);
  Random randy = new Random(System.currentTimeMillis());
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      float randyVal = randy.nextFloat();
      if(randyVal < randomBirthRate)
      {
       newSimulation[i][j] = 1;
      }
    }
  }
  return newSimulation;
}

byte[][] addGlider(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - 1;
  int startHeight = (simulationHeight/2) - 1;
  int endWidth = startWidth + 3;
  int endHeight = startHeight + 3;
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      boolean switchBit = false;
      if(j == endHeight-1)
      {
       switchBit = true; 
      }
      else if(j == (endHeight-2) && i == (endWidth-1))
      {
       switchBit = true; 
      }
      else if(j == startHeight && i == (endWidth-2))
      {
       switchBit = true; 
      }
      if(switchBit)
      {
       newSimulation[i][j] = 1;
      }
    }
  }
  return newSimulation;
}

byte[][] addSmallExploder(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - 1;
  int startHeight = (simulationHeight/2) - 2;
  int endWidth = startWidth + 3;
  int endHeight = startHeight + 4;
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      boolean switchBit = false;
      if(j == startHeight && i == (startWidth+1))
      {
       switchBit = true; 
      }
      else if(j == startHeight+1)
      {
       switchBit = true; 
      }
      else if(j == (startHeight+2) && i != (startWidth+1))
      {
       switchBit = true; 
      }
      else if(j == (endHeight-1) && i == (startWidth+1))
      {
       switchBit = true; 
      }
      if(switchBit)
      {
       newSimulation[i][j] = 1;
      }
    }
  }
  return newSimulation;
}

byte[][] addExploder(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - 2;
  int startHeight = (simulationHeight/2) - 2;
  int endWidth = startWidth + 5;
  int endHeight = startHeight + 5;
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      boolean switchBit = false;
      if(i == startWidth)
      {
       switchBit = true; 
      }
      else if(i == endWidth-1)
      {
       switchBit = true; 
      }
      else if(i == (startWidth+2) && j == startHeight)
      {
       switchBit = true; 
      }
      else if(i == (startWidth+2) && j == endHeight-1)
      {
       switchBit = true; 
      }
      if(switchBit)
      {
       newSimulation[i][j] = 1;
      }
    }
  }
  return newSimulation;
}

byte[][] add10CellRow(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - 5;
  int startHeight = (simulationHeight/2);
  int endWidth = startWidth + 10;
  int endHeight = startHeight + 1;
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      newSimulation[i][j] = 1;
    }
  }
  return newSimulation;
}

byte[][] addLightweightSpaceship(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - 2;
  int startHeight = (simulationHeight/2) - 2;
  int endWidth = startWidth + 5;
  int endHeight = startHeight + 4;
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      boolean switchBit = false;
      if(i != startWidth && j == startHeight)
      {
       switchBit = true; 
      }
      else if(i == startWidth && j == startHeight+1)
      {
       switchBit = true; 
      }
      else if(i == endWidth-1 && j == startHeight+1)
      {
       switchBit = true; 
      }
      else if(i == endWidth-1 && j == startHeight+2)
      {
       switchBit = true; 
      }
      else if(i == startWidth && j == endHeight-1)
      {
       switchBit = true; 
      }
      else if(i == endWidth-2 && j == endHeight-1)
      {
       switchBit = true; 
      }
      if(switchBit)
      {
       newSimulation[i][j] = 1;
      }
    }
  }
  return newSimulation;
}

byte[][] addTumbler(byte[][] mySimulation)
{
  byte[][] newSimulation = mySimulation;
  int startWidth = (simulationWidth/2) - 3;
  int startHeight = (simulationHeight/2) - 3;
  int endWidth = startWidth + 7;
  int endHeight = startHeight + 6;
  for(int i = startWidth; i < endWidth; i++)
  {
    for(int j = startHeight; j < endHeight; j++)
    {
      boolean switchBit = false;
      if(i == startWidth && j > startHeight+2)
      {
       switchBit = true; 
      }
      else if(i == startWidth+1 && j < startHeight+2)
      {
       switchBit = true; 
      }
      else if(i == startWidth+1 && j == endHeight-1)
      {
       switchBit = true; 
      }
      else if(i == startWidth+2 && j < endHeight-1)
      {
       switchBit = true; 
      }
      else if(i == endWidth-3 && j < endHeight-1)
      {
       switchBit = true; 
      }
      else if(i == endWidth-2 && j < startHeight+2)
      {
       switchBit = true; 
      }
      else if(i == endWidth-2 && j == endHeight-1)
      {
       switchBit = true; 
      }
      else if(i == endWidth-1 && j > startHeight+2)
      {
       switchBit = true; 
      }
      if(switchBit)
      {
       newSimulation[i][j] = 1;
      }
    }
  }
  return newSimulation;
}

byte[][] runGameOfLife()
{
  byte[][] newSimulation = new byte[simulationWidth][simulationHeight];;
  for(int i = 0; i < simulationWidth; i++)
  {
    for(int j = 0; j < simulationHeight; j++)
    {
      int neighbours = countHumanNeighbours(simulation, i, j);
     if(neighbours == 2)
     {
       newSimulation[i][j] = simulation[i][j];
     }
     else if(neighbours == 3)
     {
       newSimulation[i][j] = 1;
     }
     else
     {
      newSimulation[i][j] = 0; 
     }
    }
  }
  return newSimulation;
}

byte[][] runGameOfLifeZombies()
{
  byte[][] newSimulation = new byte[simulationWidth][simulationHeight];;
  for(int i = 0; i < simulationWidth; i++)
  {
    for(int j = 0; j < simulationHeight; j++)
    {
      int zombies = countZombieNeighbours(simulation, i, j);
      if(zombies > 0 && simulation[i][j] == 1)
      {
        newSimulation[i][j] = 2;
      }
      else
      {
       int neighbours = countHumanNeighbours(simulation, i, j);
       if(neighbours == 2)
       {
         newSimulation[i][j] = simulation[i][j];
       }
       else if(neighbours == 3)
       {
         newSimulation[i][j] = 1;
       }
       else
       {
        newSimulation[i][j] = 0; 
       }
     }
    }
  }
  return newSimulation;
}

int countHumanNeighbours(byte[][] newSimulation, int x, int y)
{
  int counter = 0;
  int neighbourHoodWidth = 3;
  int xStart = x-1;
  int neighbourHoodHeight = 3;
  int yStart = y-1;
  if(x == 0)
  {
   neighbourHoodWidth -= 1;
   xStart = x;
  }
  if(x == (simulationWidth-1))
  {
    neighbourHoodWidth -= 1;
    xStart = x-1;
  }
  if(y == 0)
  {
   neighbourHoodHeight -= 1;
   yStart = y;
  }
  if(y == (simulationHeight-1))
  {
    neighbourHoodHeight -= 1;
   yStart = y-1;
  }
  for(int i = xStart; i < (xStart + neighbourHoodWidth); i++)
  {
    for(int j = yStart; j < (yStart + neighbourHoodHeight); j++)
    {
      if(!(i == x && j == y) && newSimulation[i][j] == 1)
      {
       counter++; 
      }
    }
  }
  return counter;
}

int countZombieNeighbours(byte[][] newSimulation, int x, int y)
{
  int counter = 0;
  int neighbourHoodWidth = 5;
  int xStart = x-2;
  int neighbourHoodHeight = 5;
  int yStart = y-2;
  if(x == 0)
  {
   neighbourHoodWidth -= 2;
   xStart = x;
  }
  if(x == 1)
  {
   neighbourHoodWidth -= 1;
   xStart = x-1;
  }
  if(x == (simulationWidth-1))
  {
    neighbourHoodWidth -= 3;
  }
  if(x == (simulationWidth-2))
  {
    neighbourHoodWidth -= 2;
  }
  if(x == (simulationWidth-1))
  {
    neighbourHoodWidth -= 2;
    xStart = x-2;
  }
  if(y == 0)
  {
   neighbourHoodHeight -= 2;
   yStart = y;
  }
  if(y == 1)
  {
   neighbourHoodHeight -= 1;
   yStart = y-1;
  }
  if(y == (simulationHeight-1))
  {
    neighbourHoodHeight -= 3;
  }
  if(y == (simulationHeight-2))
  {
    neighbourHoodHeight -= 2;
  }
  for(int i = xStart; i < (xStart + neighbourHoodWidth); i++)
  {
    for(int j = yStart; j < (yStart + neighbourHoodHeight); j++)
    {
      if(!(i == x && j == y) && newSimulation[i][j] == 2)
      {
       counter++; 
      }
    }
  }
  return counter;
}

PImage recreateSimulationImage()
{
  int imageWidth = simulationWidth * cellSize;
  int imageHeight = simulationHeight * cellSize;
  PImage newImage = createImage(imageWidth, imageHeight, RGB);
  for(int i = 0; i < simulation.length; i++)
  {
    for(int j = 0; j < simulation[i].length; j++)
    {
      if(simulation[i][j] == 0)
      {
        newImage.set(i * cellSize, j * cellSize, createCell(black));
      }
      else if(simulation[i][j] == 1)
      { //<>//
        newImage.set(i * cellSize, j * cellSize, createCell(white));
      }
      else
      {
        newImage.set(i * cellSize, j * cellSize, createCell(zombie));
      }
    }
  }
  return tablifyImage(newImage);
}

PImage createCell(final color colour)
{
 PImage cell = createImage(cellSize, cellSize, RGB);
 for(int i = 0; i < cell.pixels.length; i++)
 {
  cell.pixels[i] = colour; 
 }
 return cell;
}

PImage tablifyImage(final PImage myImage)
{
  PImage tablifiedImage = myImage;
  int imageWidth = simulationWidth * cellSize;
  int imageHeight = simulationHeight * cellSize;
 for(int i = 0; i < imageWidth; i+=cellSize)
 {
   for(int j = 0; j < imageHeight; j++)
   {
     tablifiedImage.set(i, j, borderColour);
   }
 }
 for(int i = 0; i < imageHeight; i+=cellSize)
 {
   for(int j = 0; j < imageWidth; j++)
   {
     tablifiedImage.set(j, i, borderColour); 
   }
 }
 return tablifiedImage;
}