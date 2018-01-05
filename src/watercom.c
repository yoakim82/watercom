#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <linux/types.h>
<<<<<<< HEAD
#include "aircom.h"

#include "dbconnect.h"
#include "gpio.h"
=======
#include "watercom.h"

#include "dbconnect.h"
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
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
<<<<<<< HEAD

int main(void)
{
  uint132_t pulse = 0, prevPulse = 0;
  float waterFlow = 0.0;
  
=======
#define controlPin 0
int main(int argc, int** argv)
{
  uint32_t pulse = 0, prevPulse = 0;
  float waterFlow = 0.0, water = 0.0;
  int timeToWater = 5;

  pulse = getLatestPulse(); // returns 0 if no pulses registered today 
  prevPulse = pulse;
  pulseCnt = pulse;
  printf("starting at pulse %i\n", pulse);

  if (argc > 1)
  {
    timeToWater = strtol(argv[1], NULL, 10);
  }
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
  // sets up the wiringPi library
  if (wiringPiSetup () < 0) {
      printf ("Unable to setup wiringPi\n");
      return 1;
  }
<<<<<<< HEAD

  // set Pin 2 generate an interrupt on high-to-low transitions
  // and attach myInterrupt() to the interrupt
  if ( wiringPiISR (PulsePin, INT_EDGE_FALLING, &myInterrupt) < 0 ) {
=======
  if (timeToWater == 0)
  {
    // turn off water valve
    digitalWrite(controlPin, HIGH);
    return 0;
  }


  // set Pin 2 generate an interrupt on high-to-low transitions
  // and attach myInterrupt() to the interrupt
  if ( wiringPiISR (pulsePin, INT_EDGE_FALLING, &myInterrupt) < 0 ) {
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
      printf ("Unable to setup ISR\n");
      return 1;
  }

<<<<<<< HEAD
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
=======
  pinMode(controlPin, OUTPUT);
  digitalWrite(controlPin, LOW);

  // display counter value every second.
  while(timeToWater > 0)
  {
    pulse = pulseCnt; 
    waterFlow = (float) (pulse - prevPulse) / 7.5; // in liters / min
    water = (float) pulse/450.0;
    printf("Puls nr %i: %i pulses = %f l/min, tot: %f l\n", pulse, pulse-prevPulse, waterFlow, water);
    prevPulse = pulse;
    
    
    if (waterFlow > 0)
      sendValuesToDB(pulse, waterFlow, 0);
    
    usleep(1000000); // 1 s
    timeToWater--;
  }
  // turn off water valve
  digitalWrite(controlPin, HIGH);

  // final printout
  pulse = pulseCnt; 
   waterFlow = (float) (pulse - prevPulse) / 7.5; // in liters / min
   water = (float) pulse/450.0;
  prevPulse = pulse;
  if (waterFlow > 0)
    sendValuesToDB(pulse, waterFlow, 0);
  
  printf("Puls nr %i: %f l/min, tot: %f l\n", pulse, waterFlow, water);
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076

}
