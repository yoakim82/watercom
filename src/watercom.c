#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <linux/types.h>
#include "aircom.h"

#include "dbconnect.h"
#include "gpio.h"
//#include "hdlc.h"
#include <wiringPi.h>

#include <math.h>



//Global Variables

volatile uint32_t pulseCnt = 0;


// myInterrupt:  called every time an event occurs
void myInterrupt(void) 
{
   pulseCnt++;
}


/* ****************************************************************
* Name			: main
*
* Function		: main routine
* Parameters	        : void
* Returns		: int 0
*
***************************************************************** */

#define pulsePin 2

int main(void)
{
  uint132_t pulse = 0, prevPulse = 0;
  float waterFlow = 0.0;
  
  // sets up the wiringPi library
  if (wiringPiSetup () < 0) {
      printf ("Unable to setup wiringPi\n");
      return 1;
  }

  // set Pin 2 generate an interrupt on high-to-low transitions
  // and attach myInterrupt() to the interrupt
  if ( wiringPiISR (PulsePin, INT_EDGE_FALLING, &myInterrupt) < 0 ) {
      printf ("Unable to setup ISR\n");
      return 1;
  }

  // display counter value every second.
  while(1)
  {
    pulse = pulseCnt; 
    waterFlow = (float) (pulse - prevPulse) / 7.5; // in liters / min
    prevPulse = pulse;
    printf("Puls nr %i: %f l/min\n", pulse, power);
    
    /*
    if (waterFlow > 0)
      ret = sendValuesToDB(pulse, waterflow, 0);
    */
    usleep(1000000); // 1 s
  }

}
