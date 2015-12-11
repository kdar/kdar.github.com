/*
Kevin Darlington - http://outroot.com/blog - 2010
2009 - robert:aT:spitzenpfeil_d*t:org
*/

#define __spi_clock 13   // SCK - hardware SPI
#define __spi_data_in 12 // MISO - hardware SPI (unused)
#define __spi_data 11    // MOSI - hardware SPI
#define __spi_latch 10
#define __LATCH_LOW PORTB &= ~(1 << PB2) // PB2 = Arduino Diecimila pin 10
#define __LATCH_HIGH PORTB |= (1 << PB2) // PB2 = Arduino Diecimila pin 10

#define __display_enable 9
#define __DISPLAY_ON PORTB &= ~(1 << PB1) // PB1 = Arduino Diecimila pin 9
#define __DISPLAY_OFF PORTB |= (1 << PB1) // PB1 = Arduino Diecimila pin 9

#define __rows 8
#define __max_row __rows-1
#define __leds_per_row 8
#define __max_led __leds_per_row-1
#define __brightness_levels 32 // higher numbers at your own risk ;-)
#define __max_brightness __brightness_levels-1

#define __TIMER1_MAX 0xFFFF // 16 bit counter
#define __TIMER1_CNT 0x0022 // 32 levels --> 0x0022

#define __led_pin 4
#define __button_pin 8
#define PRESSED LOW

#define MAX(x,y,z) (max(max(x,y),z))
#define MIN(x,y,z) (min(min(x,y),z))

#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <stdint.h>

byte brightness_red[__rows][__leds_per_row];	/* memory for RED LEDs - valid values: 0 - __max_brightness*/
byte brightness_green[__rows][__leds_per_row];	/* memory for GREEN LEDs */
byte brightness_blue[__rows][__leds_per_row]; 	/* memory for BLUE LEDs */

#define YES 1
#define NO 0
#define DOTCORR NO/* enable/disable dot correction */

#if (DOTCORR == YES)
const int8_t PROGMEM dotcorr_red[__rows][__leds_per_row] = { {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}
};

const int8_t PROGMEM dotcorr_green[__rows][__leds_per_row] = { {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}
};

const int8_t PROGMEM dotcorr_blue[__rows][__leds_per_row] = { {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}, \
  {0,0,0,0,0,0,0,0}
};
#define __fade_delay 0
#else
#define __fade_delay 4
#endif

prog_uint8_t HEART[__rows][__leds_per_row] PROGMEM  = {
  {
    0, 0, 0, 0, 0, 0, 0, 0
  },
  {
    0, 1, 1, 0, 0, 1, 1, 0
  },
  {
    1, 2, 2, 3, 3, 2, 2, 1
  },
  {
    1, 2, 3, 2, 2, 3, 2, 1,
  },
  {
    0, 1, 2, 3, 3, 2, 1, 0
  },
  {
    0, 0, 1, 2, 2, 1, 0, 0
  },
  {
    0, 0, 0, 1, 1, 0, 0, 0
  },
  {
    0, 0, 0, 0, 0, 0, 0, 0
  }
};

#define OUTER_HEART_SIZE 16
prog_uint8_t OUTER_HEART[OUTER_HEART_SIZE] PROGMEM = {
  9, 10, 13, 14,
  16, 19, 20, 23,
  24, 31,
  33, 38,
  42, 45,
  51, 52
};

prog_uint16_t HUE_HEART[__rows][__leds_per_row] PROGMEM = {
  {
    -1, -1, -1, -1, -1, -1, -1, -1
  },
  {
    -1, 360, 360, -1, -1, 360, 360, -1
  },
  {
    360, 360, 360, 360, 360, 360, 360, 360
  },
  {
    360, 360, 360, 360, 360, 360, 360, 360,
  },
  {
    -1, 360, 360, 360, 360, 360, 360, -1
  },
  {
    -1, -1, 360, 360, 360, 360, -1, -1
  },
  {
    -1, -1, -1, 360, 360, -1, -1, -1
  },
  {
    -1, -1, -1, -1, -1, -1, -1, -1
  }
};

prog_uint16_t HUE_I_HEART_U[__rows][__leds_per_row] PROGMEM = {
  {
    360, -1, -1, -1, -1, -1, -1, -1
  },
  {
    360, -1, -1, -1, -1, -1, -1, -1
  },
  {
    -1, 290, 290, -1, -1, 290, 290, -1
  },
  {
    -1, 290, -1, 290, 290, -1, 290, -1,
  },
  {
    -1, -1, 290, -1, -1, 290, -1, -1
  },
  {
    -1, -1, -1, 290, 290, -1, -1, -1
  },
  {
    -1, -1, -1, -1, -1, 360, -1, 360
  },
  {
    -1, -1, -1, -1, -1, 360, 360, 360
  }
};

prog_uint8_t LETTERS_I_LOVE_U[6][3] PROGMEM = {
  {B00000100, B00000100, B00000100}, // I
  {B00000001, B00000001, B00000111}, // L
  {B00000111, B00000101, B00000111}, // O
  {B00000101, B00000101, B00000010}, // V
  {B00000111, B00000011, B00000111}, // E
  {B00000101, B00000101, B00000111}//,  // U
  //{B00000101, B00000101, B00000010}, // V
  //{B00000111, B00000011, B00000111}, // E
  //{B00000111, B00000101, B00000001}, // R
  //{B00000101, B00000111, B0000100}
};


/*
basic functions to set the LEDs
*/

void set_led_red(byte row, byte led, byte red)
{
#if (DOTCORR == YES)
  int8_t dotcorr = (int8_t)(pgm_read_byte( &dotcorr_red[row][led] )) * red/__brightness_levels;
  uint8_t value;
  if ( red + dotcorr < 0 ) {
    value = 0;
  } else {
    value = red + dotcorr;
  }
  brightness_red[row][led] = value;
#else
  brightness_red[row][led] = red;
  //brightness_red[led][__max_row-row] = red;
#endif
}

void set_led_green(byte row, byte led, byte green)
{
#if (DOTCORR == YES)
  int8_t dotcorr = (int8_t)(pgm_read_byte( &dotcorr_green[row][led] )) * green/__brightness_levels;
  uint8_t value;
  if ( green + dotcorr < 0 ) {
    value = 0;
  } else {
    value = green + dotcorr;
  }
  brightness_green[row][led] = value;
#else
  brightness_green[row][led] = green;
  //brightness_green[led][__max_row-row] = green;
#endif
}

void set_led_blue(byte row, byte led, byte blue)
{
#if (DOTCORR == YES)
  int8_t dotcorr = (int8_t)(pgm_read_byte( &dotcorr_blue[row][led] )) * blue/__brightness_levels;
  uint8_t value;
  if ( blue + dotcorr < 0 ) {
    value = 0;
  } else {
    value = blue + dotcorr;
  }
  brightness_blue[row][led] = value;
#else
  brightness_blue[row][led] = blue;
  //brightness_blue[led][__max_row-row] = blue;
#endif
}

void set_led_rgb(byte row, byte led, byte red, byte green, byte blue)
{
  set_led_red(row,led,red);
  set_led_green(row,led,green);
  set_led_blue(row,led,blue);
}

void set_matrix_rgb(byte red, byte green, byte blue)
{
  byte ctr1;
  byte ctr2;
  for (ctr2 = 0; ctr2 <= __max_row; ctr2++) {
    for (ctr1 = 0; ctr1 <= __max_led; ctr1++) {
      set_led_rgb(ctr2,ctr1,red,green,blue);
    }
  }
}

void set_row_rgb(byte row, byte red, byte green, byte blue)
{
  byte ctr1;
  for (ctr1 = 0; ctr1 <= __max_led; ctr1++) {
    set_led_rgb(row,ctr1,red,green,blue);
  }
}

void set_column_rgb(byte column, byte red, byte green, byte blue)
{
  byte ctr1;
  for (ctr1 = 0; ctr1 <= __max_row; ctr1++) {
    set_led_rgb(ctr1,column,red,green,blue);
  }
}

void RGBtoHSV(byte R, byte G, byte B, int *h, int *s, int *v )
{
  float min, max, delta;
  float r=R/float(__max_brightness), g=G/float(__max_brightness), b=B/float(__max_brightness);
  float H;
  min = MIN( r, g, b );
  max = MAX( r, g, b );
  *v = max * 100;				// v
  delta = max - min;
  if ( max != 0 )
    *s = (delta / max) * 100;		// s
  else {
    // r = g = b = 0		// s = 0, v is undefined
    *s = 0;
    H = -1;
    return;
  }
  if ( r == max )
    H = ( g - b ) / delta;		// between yellow & magenta
  else if ( g == max )
    H = 2 + ( b - r ) / delta;	// between cyan & yellow
  else
    H = 4 + ( r - g ) / delta;	// between magenta & cyan
  H *= 60;				// degrees
  if ( H < 0 )
    H += 360;
  
  *h = (int)H;
}

void HSVtoRGB(int H, int S, int V, byte *r, byte *g, byte *b)
{
  // see wikipeda: HSV
  float s=S/100.0,v=V/100.0,h_i,f,p,q,t,R,G,B;

  H = H%360;
  h_i = H/60;
  f = (float)(H)/60.0 - h_i;
  p = v*(1-s);
  q = v*(1-s*f);
  t = v*(1-s*(1-f));

  if ( h_i == 0 ) {
    R = v;
    G = t;
    B = p;
  } else if ( h_i == 1 ) {
    R = q;
    G = v;
    B = p;
  } else if ( h_i == 2 ) {
    R = p;
    G = v;
    B = t;
  } else if ( h_i == 3 ) {
    R = p;
    G = q;
    B = v;
  } else if ( h_i == 4 ) {
    R = t;
    G = p;
    B = v;
  } else {
    R = v;
    G = p;
    B = q;
  }

  *r = (byte)(R*(float)(__max_brightness));
  *g = (byte)(G*(float)(__max_brightness));
  *b = (byte)(B*(float)(__max_brightness));
}

void set_led_hue(byte row, byte led, int h, int s=100, int v=100)
{
  // see wikipeda: HSV
  byte r, g, b;
  HSVtoRGB(h, s, v, &r, &g, &b);  
  set_led_rgb(row, led, r, g, b);
}

void set_row_byte_hue(byte row, byte data_byte, int hue)
{
  byte led;
  for (led = 0; led <= __max_led; led++) {
    if ( (data_byte>>led)&(B00000001) ) {
      set_led_hue(row,led,hue);
    } else {
      set_led_rgb(row,led,0,0,0);
    }
  }
}

void set_row_hue(byte row, int hue)
{
  byte ctr1;
  for (ctr1 = 0; ctr1 <= __max_led; ctr1++) {
    set_led_hue(row,ctr1,hue);
  }
}

void set_column_hue(byte column, int hue)
{
  byte ctr1;
  for (ctr1 = 0; ctr1 <= __max_row; ctr1++) {
    set_led_hue(ctr1,column,hue);
  }
}

void set_matrix_hue(int hue)
{
  byte ctr1;
  byte ctr2;
  for (ctr2 = 0; ctr2 <= __max_row; ctr2++) {
    for (ctr1 = 0; ctr1 <= __max_led; ctr1++) {
      set_led_hue(ctr2,ctr1,hue);
    }
  }
}



/*
other functions
*/

void art_hue_fade(uint16_t art_hues[__rows][__leds_per_row], unsigned int delay_=10) {
  int current_hues[__rows][__leds_per_row];
  byte current_brightness[__rows][__leds_per_row];
  int h,s,v;
  uint16_t hue;
  
  // Convert current rgb values to hues
  for (int x = 0; x < __rows; x++) {
    for (int y = 0; y < __leds_per_row; y++) {
      RGBtoHSV(brightness_red[x][y], brightness_green[x][y], brightness_blue[x][y], &h, &s, &v);
      current_hues[x][y] = h;
      current_brightness[x][y] = v;
    }
  }
  
  for (int z = 0; z < 360; z++) {
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        if (current_brightness[x][y] < 100) {
          current_brightness[x][y]++;
        }
        
        hue = pgm_read_word(&art_hues[x][y]);
        
        if (hue == -1) {
          if (brightness_red[x][y] > 0) {
            set_led_red(x, y, brightness_red[x][y]-1);
          }
          
          if (brightness_green[x][y] > 0) {
            set_led_green(x, y, brightness_green[x][y]-1);
          }
          
          if (brightness_blue[x][y] > 0) {
            set_led_blue(x, y, brightness_blue[x][y]-1);
          }
        } else if (current_hues[x][y] < hue) {
          current_hues[x][y]++;          
          set_led_hue(x, y, current_hues[x][y], 100, current_brightness[x][y]);
        } else if (current_hues[x][y] > hue) {
          current_hues[x][y]--;
          set_led_hue(x, y, current_hues[x][y], 100, current_brightness[x][y]);
        } else {
          set_led_hue(x, y, current_hues[x][y], 100, current_brightness[x][y]);
        }
      }
    }
    delay(delay_);
  }
}

uint16_t random_hue(uint16_t last_hue)
{
	return (last_hue + random(360)) % 360;
}

void animation_1()
{
  byte heart[__rows] = {
    B00000000,
    B01100110,
    B10011001,
    B10000001,
    B01000010,
    B00100100,
    B00011000,
    B00000000
  };
  
  // 4 states:
  //   0 - no color
  //   1 - color green. moving dot.
  //   2 - color purple, stationary.
  //   3 - color white, but it is a moving green dot next iteration.
  //       after the green dot moves on, it will be purple again.
  int8_t matrix[__rows][__leds_per_row];
  int8_t random_col, last_random_col;
  unsigned long next_dot_time = 0;
  unsigned long next_shift_time = 0;
  int sum = 0;
  int expected_sum = 0;
  bool heart_done = false;
  int shift_then_return = __rows;
  
  // determine the expected sum
  for (int x = 0; x < __rows; x++) {
    for (int y = 0; y < __leds_per_row; y++) {
      if (heart[x] & (1 << (__leds_per_row-1-y))) {
        expected_sum += (x+1)*(y+1);
      }
    }
  }
  
  set_matrix_rgb(0, 0, 0);
  for (int x = 0; x < __rows; x++) {
    memset(matrix[x], 0, sizeof(int8_t)*__leds_per_row);
  }
  
  for (;;) {
    if (next_shift_time == 0 || millis() > next_shift_time) {
      if (next_shift_time != 0) {
        for (int x = __rows-1; x >= 0; x--) {
          for (int y = __leds_per_row-1; y >= 0; y--) {
            if (matrix[x][y] == 1 && (heart[x] & (1 << y))) {
              // Keep track of the sum so we know when the
              // heart has been formed.
              sum += (x+1)*(y+1);
              matrix[x][y] = 3;
            }
            
            // Fixes the last row
            if (x == __rows-1) {
              if (matrix[x][y] == 1) {
                matrix[x][y] = 0;
              }
            } else {              
              if (matrix[x][y] == 1 || matrix[x][y] == 3) {
                // Change the current row appropriately.
                if (matrix[x][y] == 3) {
                  matrix[x][y] = 2;
                } else if (matrix[x][y] == 1) {
                  matrix[x][y] = 0;
                }
                
                // Change the next row appropriately.
                if (matrix[x+1][y] == 0) {
                  matrix[x+1][y] = 1;
                } else if (matrix[x+1][y] == 2) {
                  matrix[x+1][y] = 3;
                }
              }
            }
          }
        }
        
        if (heart_done) {
          if (shift_then_return-- <= 0) {
            return;
          }
        }
      }
      
      next_shift_time = millis() + 300;
    }
    
    // If the heart is not done and it's time to create
    // a new dot, make a random dot and place it.
    if (!heart_done) {
      if (next_dot_time == 0 || millis() > next_dot_time) {
        random_col = (int8_t)random(__leds_per_row);
        if (random_col == last_random_col) {
          random_col = (random_col + 1) % __leds_per_row;
        }
        last_random_col = random_col;
        
        if (matrix[0][random_col] < 2) {
          matrix[0][random_col] = 1;
        }
        next_dot_time = random(1000) + millis();      
      }
    }
    
    // Draw what's in the matrix
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        if (matrix[x][y] == 1) {
          set_led_hue(x, y, 120);
        } else if (matrix[x][y] == 2) {
          set_led_hue(x, y, 290);
        }  else if (matrix[x][y] == 3) {
          set_led_rgb(x, y, 255, 255, 255);          
        } else {
          set_led_rgb(x, y, 0, 0, 0);
        }
      }
    }
    
    // Animation done
    if (sum == expected_sum) {
      heart_done = true;
    }
    
    delay(10);
  }
}


void animation_2()
{ 
  uint16_t prev_hues[OUTER_HEART_SIZE] = {
    290,290,290,290,
    290,290,290,290,
    290,290,
    290,290,
    290,290,
    290,290
  };
  
  uint16_t hues[OUTER_HEART_SIZE];
  
  byte index;
  
  for (int z = 0; z < 6; z++) {
    index = 0;
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        if (pgm_read_byte(&HEART[x][y]) == 1) {
          hues[index] = random_hue(hues[index]);
          index++;
        }
      }
    }
    
    for (int h = 0; h < 300; h++) {
      index = 0;
      for (int x = 0; x < __rows; x++) {
        for (int y = 0; y < __leds_per_row; y++) {
          if (pgm_read_byte(&HEART[x][y]) == 1) {
            if (prev_hues[index] < hues[index]) {
              prev_hues[index]++;
            } else if (prev_hues[index] > hues[index]) {
              prev_hues[index]--;
            }
            set_led_hue(x,y,prev_hues[index++]);
          }
        }
      }
      delay(2);      
    }
    
    for (int x = 0; x < sizeof(hues); x++) {
      prev_hues[x] = hues[x];
    }
  }
}

void animation_3()
{
  art_hue_fade(HUE_HEART);
  delay(8000);
}

 
void animation_4()
{
  art_hue_fade(HUE_I_HEART_U);
  delay(3000);
}

void animation_5()
{ 
  byte art[] = {
    0,
    8,
    17, 18, 21, 22,
    25, 27, 28, 30,
    34, 37,
    43, 44,
    53, 55,
    61, 62, 63
  };
  
  uint16_t prev_hues[] = {
    360,
    360,
    290, 290, 290, 290,
    290, 290, 290, 290,
    290, 290,
    290, 290,
    360, 360,
    360, 360, 360
  };
  
  uint16_t hues[19];
  
  for (int z = 0; z < 6; z++) {
    for (int x = 0; x < sizeof(art); x++) {
      byte row = art[x]/__rows;
      byte led = art[x]%__rows;      
      hues[x] = random_hue(hues[x]);
    }
    
    for (int x = 0; x < 300; x++) {
      for (int y = 0; y < sizeof(art); y++) {
        if (prev_hues[y] < hues[y]) {
          prev_hues[y]++;
        } else if (prev_hues[y] > hues[y]) {
          prev_hues[y]--;
        }
        byte row = art[y]/__rows;
        byte led = art[y]%__rows;
        set_led_hue(row,led,prev_hues[y]);
      }
      delay(2);
    }
    
    for (int x = 0; x < sizeof(hues); x++) {
      prev_hues[x] = hues[x];
    }
  }
}

void animation_6()
{
  uint16_t hue, hue2;
  
  for (int w = 0; w < __max_brightness; w++) {
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        hue = pgm_read_word(&HUE_I_HEART_U[x][y]);
        hue2 = -1;
        if (x < __max_row) {
          hue2 = pgm_read_word(&HUE_I_HEART_U[x+1][y]);
        }
        
        if (hue != -1 && (hue == 360 || hue != hue2)) {
          if (brightness_red[x][y] > 0)
            brightness_red[x][y]--;
          if (brightness_green[x][y] > 0)
            brightness_green[x][y]--;
          if (brightness_blue[x][y] > 0)
            brightness_blue[x][y]--;
        }
        
        if (hue == 290) {
          if (brightness_red[x-1][y] < 213)
            brightness_red[x-1][y]++;
          else if (brightness_red[x-1][y] > 213)
            brightness_red[x-1][y]--;
          if (brightness_green[x-1][y] > 0)
            brightness_green[x-1][y]--;
          if (brightness_blue[x-1][y] < 255)
            brightness_blue[x-1][y]++;
            
        }
      }
    }
    delay(60);
  }
  
  delay(1000);
}

void animation_6b()
{
	for (int x = 0; x < __max_brightness; x++) {
		set_led_rgb(2, 2, 0, x, 0);
		set_led_rgb(2, 5, 0, x, 0);
		delay(20);
	}
	
	byte sequence1[][2] = {{7,3},{7,2},{7,1},{6,1}/*,{5,1},{5,2},{5,3}*/};
	byte sequence2[][2] = {{7,4},{7,5},{7,6},{6,6}/*,{5,6},{5,5},{5,4}*/};
	
	for (int w = 0; w < sizeof(sequence1)/sizeof(sequence1[0]); w++) {
		for (int x = 0; x < __max_brightness; x++) {
			set_led_rgb(sequence1[w][0], sequence1[w][1], 0, 0, x);
			set_led_rgb(sequence2[w][0], sequence2[w][1], 0, 0, x);
			delay(15);
		}
	}
	
	for (int x = 0; x < __max_brightness; x++) {
		set_led_rgb(6, 2, x, x, x);
		set_led_rgb(6, 3, x, x, x);
		set_led_rgb(6, 4, x, x, x);
		set_led_rgb(6, 5, x, x, x);
		delay(20);
	}
	
	delay(5000);
}

void animation_7()
{
  for (int x = 0; x < __rows; x++) {
    for (int y = 6; y < __rows; y++) {
      set_led_rgb(y, x, 0, 0, 1);
    }
    set_led_rgb(5, x, 0, 0, 255);
    delay(50);
  }
}

void animation_x()
{
  byte heart[4] = {
    B01100110,
    B01011010,
    B00100100,
    B00011000
  };
  int heart_bottom = 0;
  
  byte line[__leds_per_row] = {-1};
  byte animation[16] = {
    5, 5, 5, 5, 5,
    6, 6, 6,
    7, 7, 7, 7, 7,
    6, 6, 6
  };
  int8_t count = 0;
  bool end = false;
  int l,x,y;
	
	byte buffer_red[__rows][__leds_per_row];	/* memory for RED LEDs - valid values: 0 - __max_brightness*/
  byte buffer_green[__rows][__leds_per_row];	/* memory for GREEN LEDs */
  byte buffer_blue[__rows][__leds_per_row]; 	/* memory for BLUE LEDs */
	
  for (l = 0; l <= 80; l++) {
    for (int x = 0; x < __rows; x++) {
			for (int y = 0; y < __leds_per_row; y++) {
				buffer_red[x][y] = 0;
				buffer_green[x][y] = 0;
				buffer_blue[x][y] = 0;
			}
		}
    
    for (x = 0; x < sizeof(line); x++) {
      line[sizeof(line)-x-1] = animation[(count+x) % sizeof(animation)];
    }
    count = (count+1) % sizeof(animation);
    
    heart_bottom = max(line[3], line[4]);
    for (x = sizeof(heart)-1; x >= 0; x--) {
      for (y = __leds_per_row; y >= 0; y--) {
        if (heart[x] & 1 << (y-1)) {
          //set_led_rgb(heart_bottom-1-(sizeof(heart)-1-x), __leds_per_row-y, 255, 0, 255);
					buffer_red[heart_bottom-1-(sizeof(heart)-1-x)][__leds_per_row-y] = 255;
					buffer_blue[heart_bottom-1-(sizeof(heart)-1-x)][__leds_per_row-y] = 255;
        }
      }
    }
    
    for (x = 0; x < sizeof(line); x++) {
      if (line[x] != -1) {
        for (y = line[x]+1; y < __rows; y++) {
          //set_led_rgb(y, x, 0, 0, 1);
					buffer_blue[y][x] = 1;
        }
        //set_led_rgb(line[x], x, 0, 0, 255);
				buffer_blue[line[x]][x] = 255;
      }
    }
    delay(110);
    
    if (!end && l == 80) {
      l = 44;
      end = true;
    }
    
    if (end) {
      if (animation[count] > 4) {
        animation[count]--;
        
        if (animation[(count+1) % sizeof(animation)] - animation[count] > 1) {
          animation[(count+1) % sizeof(animation)]--;
        }
      }
    }
		
		for (int x = 0; x < __rows; x++) {
			for (int y = 0; y < __leds_per_row; y++) {
				brightness_red[x][y] = buffer_red[x][y];
				brightness_green[x][y] = buffer_green[x][y];
				brightness_blue[x][y] = buffer_blue[x][y];
			}
		}
  }
}

//void animation_x()
//{
//  byte heart[4] = {
//    B01100110,
//    B01011010,
//    B00100100,
//    B00011000
//  };
//  int heart_bottom = 0;
//  
//  byte line[__leds_per_row] = {-1};
//  byte animation[16] = {
//    5, 5, 5, 5, 5,
//    6, 6, 6,
//    7, 7, 7, 7, 7,
//    6, 6, 6
//  };
//  int8_t count = 0;
//  bool end = false;
//  int l,x,y;
//  
//  for (l = 0; l <= 80; l++) {
//    set_matrix_rgb(0,0,0);
//    
//    for (x = 0; x < sizeof(line); x++) {
//      line[sizeof(line)-x-1] = animation[(count+x) % sizeof(animation)];
//    }
//    count = (count+1) % sizeof(animation);
//    
//    heart_bottom = max(line[3], line[4]);
//    for (x = sizeof(heart)-1; x >= 0; x--) {
//      for (y = __leds_per_row; y >= 0; y--) {
//        if (heart[x] & 1 << (y-1)) {
//          set_led_rgb(heart_bottom-1-(sizeof(heart)-1-x), __leds_per_row-y, 255, 0, 255);
//        }
//      }
//    }
//    
//    for (x = 0; x < sizeof(line); x++) {
//      if (line[x] != -1) {
//        for (y = line[x]+1; y < __rows; y++) {
//          set_led_rgb(y, x, 0, 0, 1);
//        }
//        set_led_rgb(line[x], x, 0, 0, 255);
//      }
//    }
//    delay(110);
//    
//    if (!end && l == 80) {
//      l = 44;
//      end = true;
//    }
//    
//    if (end) {
//      if (animation[count] > 4) {
//        animation[count]--;
//        
//        if (animation[(count+1) % sizeof(animation)] - animation[count] > 1) {
//          animation[(count+1) % sizeof(animation)]--;
//        }
//      }
//    }
//  }
//  
//  //byte heart_bottom = 0;
//  //
//  //float theta = 0.0;  // Start angle at 0
//  //float amplitude = 2;  // Height of wave
//  //float period = 16;  // How many leds before the wave repeats
//  //float dx;  // Value for incrementing X, a function of period and xspacing
//  //byte yvalues[__leds_per_row];  // Using an array to store height values for the wave  
//  //dx = (2*3.1415 / period);
//  //
//  //while (true) {
//  //  // Increment theta (try different values for 'angular velocity' here
//  //  theta += 0.015;
//  //  if (theta > 2 * 3.1415) {
//  //    theta = 0;
//  //  }
//  //
//  //  // For every x value, calculate a y value with sine function
//  //  float x = theta;
//  //  for (int i = 0; i < sizeof(yvalues); i++) {
//  //    yvalues[i] = (((byte)(sin(x)*amplitude))+6) % __rows;
//  //    x+=dx;
//  //  }
//  //  
//  //  set_matrix_rgb(0,0,0);
//  //  
//  //  heart_bottom = max(yvalues[3], yvalues[4]);
//  //  for (int x = sizeof(heart)-1; x >= 0; x--) {
//  //    for (int y = __leds_per_row; y >= 0; y--) {
//  //      if (heart[x] & 1 << (y-1)) {
//  //        set_led_rgb(heart_bottom-1-(sizeof(heart)-1-x), __leds_per_row-y, 255, 0, 255);
//  //      }
//  //    }
//  //  }
//  //  
//  //  for (int x = 0; x < sizeof(yvalues); x++) {
//  //    set_led_rgb(yvalues[x], x, 0, 0, 255);
//  //  }
//  //}
//}

void animation_x3()
{
  uint16_t hues[3][8][2];
  #define size1 3
  #define size2 8
  
  byte letter = 0;
  byte letter_pos = 0;
  uint8_t data;
  
  byte scroll_count = 2;
  int8_t countdown = -1;
  
  int8_t x, y;
  
  for (x = 0; x < size1; x++) {
    for (y = 0; y < size2; y++) {
      hues[x][y][0] = 240;
      hues[x][y][1] = 5;
    }
  }
  
  for (;;) {
    if (letter_pos < size1 && scroll_count != 0) {
      for (x = 0; x < size1; x++) {
        data = pgm_read_byte(&LETTERS_I_LOVE_U[letter][x]);
        if (data & (1 << letter_pos)) {
          hues[x][0][0] = random(360);
          hues[x][0][1] = 100;
        }
      }
    }
    
    for (x = 0; x < size1; x++) {
      for (y = 0; y < __leds_per_row; y++) {
        set_led_hue(5 + x, __leds_per_row-1-y, hues[x][y][0], 100, hues[x][y][1]);
      }
    }
    
    for (x = 0; x < size1; x++) {
      for (y = size2-2; y >= 0; y--) {
        hues[x][y+1][0] = hues[x][y][0];
        hues[x][y+1][1] = hues[x][y][1];
      }
      
      hues[x][0][0] = 240;
      hues[x][0][1] = 5;
    }
    
    letter_pos++;
    
    if (letter_pos > size1) {
      letter++;
      letter_pos = 0;
    }
    
    if (letter >= sizeof(LETTERS_I_LOVE_U) / sizeof(LETTERS_I_LOVE_U[0])) {
      scroll_count--;
      letter = 0;
    }
    
    if (scroll_count == 0) {
      if (countdown == -1) {
        countdown = 8;
      } else {
        countdown--;
      }
    }
    
    if (countdown == 0) {
      break;
    }
    
    delay(400);
  }
  
  //delay(4000);
}

void animation_final1()
{
  int current_hues[__rows][__leds_per_row];
  byte current_brightness[__rows][__leds_per_row];
  int h,s,v;
  bool keepgoing;
  
  // Convert current rgb values to hues
  for (int x = 0; x < __rows; x++) {
    for (int y = 0; y < __leds_per_row; y++) {
      RGBtoHSV(brightness_red[x][y], brightness_green[x][y], brightness_blue[x][y], &h, &s, &v);
      current_hues[x][y] = h;
      current_brightness[x][y] = v+1;
    }
  }
  
  while (keepgoing) {
    keepgoing = false;
    
    do {
      h = random(8);
      s = random(8);
    } while (current_brightness[h][s] == 0);
    
    if (current_brightness[h][s] != 0) {
      if (current_hues[h][s] == 120) {
        current_brightness[h][s] = 0;
      } else {
        current_hues[h][s] = 120;
      }
    }
    
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        if (current_brightness[x][y] != 0) {
          keepgoing = true;
        }
        
        if (current_brightness[x][y] > 50) {
          set_led_hue(x, y, current_hues[x][y], 100, 100);
        } else {
          set_led_hue(x, y, current_hues[x][y], 100, current_brightness[x][y]);
        }
      }
    }
  }
  
  delay(1000);
}

void animation_final2()
{
  int current_hues[__rows][__leds_per_row];
  byte current_brightness[__rows][__leds_per_row];
  int h,s,v;
  
  // Convert current rgb values to hues
  for (int x = 0; x < __rows; x++) {
    for (int y = 0; y < __leds_per_row; y++) {
      RGBtoHSV(brightness_red[x][y], brightness_green[x][y], brightness_blue[x][y], &h, &s, &v);
      current_hues[x][y] = h;
      current_brightness[x][y] = v+1;
    }
  }
  
  bool reverse = false;
  int row = 0;
  while (true) {
    for (int y = 0; y < __leds_per_row; y++) {
      if (reverse) {
        current_brightness[row][y] = 0;
      } else {
        current_hues[row][y] = (current_hues[row][y] + 180) % 360;
      }
    }
    
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        if (current_brightness[x][y] > 50) {
          set_led_hue(x, y, current_hues[x][y], 100, 100);
        } else {
          set_led_hue(x, y, current_hues[x][y], 100, current_brightness[x][y]);
        }
      }
    }
    
    delay(200);
    if (reverse) {
      if (row == 0) {
        break;
      }
      
      row = (row - 1) % __rows;
    } else {
      row = (row + 1) % __rows;
      if (row+1 == __rows) {
        reverse = true;
      }
    }
  }
  
  delay(1000);
}

void animation_notused1()
{
  for (int whocares = 0; whocares < 10; whocares++) {
    for (int x = 0; x < __rows; x++) {
      for (int y = 0; y < __leds_per_row; y++) {
        if (pgm_read_word(&HUE_HEART[x][y]) == -1) {
          set_led_hue(x, y, 235);
        } else {
          set_led_hue(x,y, 120);
        }
      }
    }
    
    byte square[3] = {3, 3, 2};
    
    for (int z = 0; z < 4; z++) {
      for (int x = 0; x < __rows; x++) {
        for (int y = 0; y < __leds_per_row; y++) {
          if (x >= square[0] && x < square[0] + square[2] && y >= square[1] && y < square[1] + square[2]) {
            if (pgm_read_word(&HUE_HEART[x][y]) != -1) {
              set_led_hue(x, y, 290);
            } else {
              set_led_hue(x, y, 360);
            }
          }
        }
      }
      
      square[0] = square[0]-1;
      square[1] = square[1]-1;
      square[2] = square[2]+2;
      
      delay(500);
    }
  }
}

void animation_notused2()
{
  uint16_t art_hues[__rows][__leds_per_row] = {
    {
      -1, -1, -1, -1, -1, -1, -1, -1
    },
    {
      -1, 360, 360, -1, -1, 360, 360, -1
    },
    {
      360, 360, 360, 360, 360, 360, 360, 360
    },
    {
      360, 360, 360, 360, 360, 360, 360, 360,
    },
    {
      -1, 360, 360, 360, 360, 360, 360, -1
    },
    {
      -1, -1, 360, 360, 360, 360, -1, -1
    },
    {
      -1, -1, -1, 360, 360, -1, -1, -1
    },
    {
      -1, -1, -1, -1, -1, -1, -1, -1
    }
  };
  
  for (int x = 0; x <= 360; x++) {
    for (int y = 0; y < __rows; y++) {
      for (int z = 0; z < __leds_per_row; z++) {
        if (art_hues[y][z] == -1) {
          set_led_hue(y, z, x);
        } else {
          set_led_hue(y, z, art_hues[y][z]);
          art_hues[y][z] = 360 - x;
        }
      }
    }
    delay(10);
  }
  
  for (int x = 360; x >= 0; x--) {
    for (int y = 0; y < __rows; y++) {
      for (int z = 0; z < __leds_per_row; z++) {
        if (art_hues[y][z] == -1) {
          set_led_hue(y, z, x);
        } else {
          set_led_hue(y, z, art_hues[y][z]);
          art_hues[y][z] = 360 - x;
        }
      }
    }
    delay(10);
  }
}

/*
Functions dealing with hardware specific jobs / settings
*/

void setup_hardware_spi(void)
{
  byte clr;
  // spi prescaler:
  // SPI2X SPR1 SPR0
  //   0     0     0    fosc/4
  //   0     0     1    fosc/16
  //   0     1     0    fosc/64
  //   0     1     1    fosc/128
  //   1     0     0    fosc/2
  //   1     0     1    fosc/8
  //   1     1     0    fosc/32
  //   1     1     1    fosc/64
  SPCR |= ( (1<<SPE) | (1<<MSTR) ); // enable SPI as master
  //SPCR |= ( (1<<SPR1) ); // set prescaler bits
  SPCR &= ~ ( (1<<SPR1) | (1<<SPR0) ); // clear prescaler bits
  clr=SPSR; // clear SPI status reg
  clr=SPDR; // clear SPI data reg
  SPSR |= (1<<SPI2X); // set prescaler bits
  //SPSR &= ~(1<<SPI2X); // clear prescaler bits
}

void setup_timer1_ovf(void)
{
  // Arduino runs at 16 Mhz...
  // Timer1 (16bit) Settings:
  // prescaler (frequency divider) values:   CS12    CS11   CS10
  //                                           0       0      0    stopped
  //                                           0       0      1      /1
  //                                           0       1      0      /8
  //                                           0       1      1      /64
  //                                           1       0      0      /256
  //                                           1       0      1      /1024
  //                                           1       1      0      external clock on T1 pin, falling edge
  //                                           1       1      1      external clock on T1 pin, rising edge
  //
  TCCR1B &= ~ ( (1<<CS11) );
  TCCR1B |= ( (1<<CS12) | (1<<CS10) );
  //normal mode
  TCCR1B &= ~ ( (1<<WGM13) | (1<<WGM12) );
  TCCR1A &= ~ ( (1<<WGM11) | (1<<WGM10) );
  //Timer1 Overflow Interrupt Enable
  TIMSK1 |= (1<<TOIE1);
  TCNT1 = __TIMER1_MAX - __TIMER1_CNT;
  // enable all interrupts
  sei();
}

// Rotates the display 90 degrees.
//ISR(TIMER1_OVF_vect)   /* Framebuffer interrupt routine */
//{
//  TCNT1 = __TIMER1_MAX - __TIMER1_CNT;
//  uint8_t pwm_cycle;
//  static uint8_t row = 0;
//
//  __DISPLAY_ON;
//
//  for (pwm_cycle=0; pwm_cycle <=__max_brightness; pwm_cycle++) {
//
//    byte led;
//    byte red = B11111111;		// off
//    byte green = B11111111;           // off
//    byte blue = B11111111;		// off
//
//    for (led = 0; led <= __max_led; led++) {
//      if (pwm_cycle < brightness_red[__max_led-led][__max_row-row]) {
//        red &= ~(1<<led);
//      }
//
//      if (pwm_cycle < brightness_green[__max_led-led][__max_row-row]) {
//        green &= ~(1<<led);
//      }
//
//      if (pwm_cycle < brightness_blue[__max_led-led][__max_row-row]) {
//        blue &= ~(1<<led);
//      }
//    }
//
//    __LATCH_LOW;
//    spi_transfer(B00000001<<__max_row-row);
//    spi_transfer(blue);
//    spi_transfer(green);
//    spi_transfer(red);
//    __LATCH_HIGH;
//
//  }
//
//  __DISPLAY_OFF;
//
//  row++; // next time the ISR runs, the next row will be dealt with
//
//  if (row > __max_row) {
//    row = 0;
//  }
//}

ISR(TIMER1_OVF_vect)   /* Framebuffer interrupt routine */
{  
  TCNT1 = __TIMER1_MAX - __TIMER1_CNT;
  uint8_t pwm_cycle;
  static uint8_t row = 0;

  __DISPLAY_ON;

  for (pwm_cycle=0; pwm_cycle <=__max_brightness; pwm_cycle++) {

    byte led;
    byte red = B11111111;		// off
    byte green = B11111111;           // off
    byte blue = B11111111;		// off

    for (led = 0; led <= __max_led; led++) {
      if (pwm_cycle < brightness_red[row][led]) {
        red &= ~(1<<led);
      }
      //else {
      //  red |= (1<<led);
      //}

      if (pwm_cycle < brightness_green[row][led]) {
        green &= ~(1<<led);
      }
      //else {
      //  green |= (1<<led);
      //}

      if (pwm_cycle < brightness_blue[row][led]) {
        blue &= ~(1<<led);
      }
      //else {
      //  blue |= (1<<led);
      //}
    }

    __LATCH_LOW;
    spi_transfer(B00000001<<row);
    spi_transfer(blue);
    spi_transfer(green);
    spi_transfer(red);
    __LATCH_HIGH;

  }

  __DISPLAY_OFF;

  row++; // next time the ISR runs, the next row will be dealt with

  if (row > __max_row) {
    row = 0;
  }

}

byte spi_transfer(byte data)
{
  SPDR = data;                    // Start the transmission
  while (!(SPSR & (1<<SPIF))) {   // Wait the end of the transmission
  };
  return SPDR;                    // return the received byte. (we don't need that here)
}

void setup(void)
{
  randomSeed(556);
  pinMode(__spi_clock,OUTPUT);
  pinMode(__spi_latch,OUTPUT);
  pinMode(__spi_data,OUTPUT);
  pinMode(__spi_data_in,INPUT);
  pinMode(__display_enable,OUTPUT);
  pinMode(__button_pin,INPUT);
  digitalWrite(__button_pin,HIGH);		/* turn on pullup */
  pinMode(__led_pin,OUTPUT);
  digitalWrite(__spi_latch,LOW);
  digitalWrite(__spi_data,LOW);
  digitalWrite(__spi_clock,LOW);
  setup_hardware_spi();
  delay(10);
  set_matrix_rgb(0,0,0);			/* set the display to BLACK */
  setup_timer1_ovf();				/* enable the framebuffer display */
  //Serial.begin(9600);
}

void loop(void)
{
  //static byte final_count = 0;
  animation_1();
  animation_2();
  animation_3();
  animation_4();
  animation_5();
  animation_6();
	animation_6b();
  animation_7();
  animation_x();
  animation_x3();
  
  animation_final1();
  
  //typedef void (*animation_final)();
  //animation_final animations[] = {
  //  &animation_final1,
  //  &animation_final2
  //};
  //
  ////(*animations[random(sizeof(animations))])();
  //(*animations[final_count])();
  //final_count = (final_count+1) % sizeof(animations);
  
  //animation_notused1();
  //animation_notused2();
}
