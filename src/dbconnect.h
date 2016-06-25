#ifndef DB_CONNECT_H
#define DB_CONNECT_H

#include <stdint.h>

int sendValuesToDB(uint16_t pulse, float waterFlow, uint8_t voltage);
uint16_t getLatestPulse();
#endif
