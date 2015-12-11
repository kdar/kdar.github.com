//Boduino. Kevin Darlington 11-28-2009.

// Original code from:
//Adapted by phizone from:
//Arduino Tv framebuffer
//Alastair Parker
//2007

// Video out voltage levels
#define _SYNC 0x00
#define _BLACK 0x01
#define _GRAY 0x02
#define _WHITE 0x03

// dimensions of the screen
#define WIDTH 38
#define HEIGHT 14

//number of lines to display
#define DISPLAY_LINES 240

// update speed for the main loop of the game
#define UPDATE_INTERVAL 1

//video pins
#define DATA_PIN 9
#define SYNC_PIN 8

#define BUTTON_PIN 3
#define RELAY_PIN 4
#define LED_GREEN_PIN 5
#define LED_BLUE_PIN 6

#define LED_PWM_ON 10
#define LED_PWM_OFF 0

// the video frameBuffer
byte frameBuffer[WIDTH][HEIGHT];

// loop indices
byte index, index2;

// pal video line loop
byte line;
// current drawing line in framebuffer
byte newLine;

int relayState = 0;
int value = 0;
int lastValue = 0;
int count = 0;

// clear the screen
void clearScreen()
{
  for (index = 0; index < WIDTH; index++) {
    for (index2=0;index2<=HEIGHT;++index2) {
      frameBuffer[index][index2] = _BLACK;
    }
  }
}

// the setup routine
void setup()
{
  cli();
  pinMode (SYNC_PIN, OUTPUT);
  pinMode (DATA_PIN, OUTPUT);
  
  pinMode(BUTTON_PIN, INPUT);
  pinMode(RELAY_PIN, OUTPUT);
  
  digitalWrite (SYNC_PIN, HIGH);
  digitalWrite (DATA_PIN, HIGH);
  
  analogWrite(LED_GREEN_PIN, LED_PWM_ON);
  
  clearScreen();
}

void loop()
{
  // iterate over the lines on the tv
  for (line = 0; line < DISPLAY_LINES; ++line) {
    // HSync
    // front porch (1.5 us)
    PORTB = _BLACK;
    delayMicroseconds(1.5);
    //sync (4.7 us)
    PORTB = _SYNC;
    delayMicroseconds(4.7);
    // breezeway (.6us) + burst (2.5us) + colour back borch (1.6 us)
    PORTB = _BLACK;
    delayMicroseconds(0.6+2.5+1.6);
    
    
    //calculate which line to draw to
    newLine = line >>4;
    delayMicroseconds(1);
    
    //display the array for this line
    // a loop would have been smaller, but it messes the timing up
    PORTB = frameBuffer[0][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[1][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[2][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[3][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[4][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[5][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[6][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[7][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[8][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[9][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[10][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[11][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[12][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[13][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[14][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[15][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[16][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[17][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[18][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[19][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[20][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[21][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[22][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[23][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[24][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[25][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[26][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[27][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[28][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[29][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[30][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[31][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[32][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[33][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[34][newLine];
    delayMicroseconds(1);
    PORTB = frameBuffer[35][newLine];
    delayMicroseconds(1);
    
    // klugdge to correct timings
    PORTB = frameBuffer[36][newLine];
    PORTB=PORTB;
    PORTB=PORTB;
    PORTB=PORTB;
    delayMicroseconds(2);
  }
  
  //vsync
  PORTB = _SYNC;
  
  // wait for the remainder of the sync period
  
  delayMicroseconds(565);
  
  // Sample the button press. This is used to debounce
  // the button in a non-time consuming and non-interrupt
  // way.
  count++;
  if (count == 5) {
    value = digitalRead(BUTTON_PIN);
    if (lastValue != value) {
      if (value == HIGH) {
        // Toggle relay state.
        relayState ^= HIGH;
        digitalWrite(RELAY_PIN, relayState);
        // Set LEDs accordingly.
        if (relayState == HIGH) {
          analogWrite(LED_BLUE_PIN, LED_PWM_ON);
          analogWrite(LED_GREEN_PIN, LED_PWM_OFF);
        } else {
          analogWrite(LED_BLUE_PIN, LED_PWM_OFF);
          analogWrite(LED_GREEN_PIN, LED_PWM_ON);
        }
      }
      lastValue = value;
    }
    count = 0;
  }
}
