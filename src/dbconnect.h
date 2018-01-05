#ifndef DB_CONNECT_H
#define DB_CONNECT_H

#include <stdint.h>

int sendValuesToDB(uint16_t pulse, float waterFlow, uint8_t voltage);
<<<<<<< HEAD

=======
uint16_t getLatestPulse();
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
#endif
