#include <my_global.h>
#include <mysql.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
<<<<<<< HEAD

=======
#include "conf.h"

uint16_t getLatestPulse()
{
  char query_str[100];
  uint16_t pulses = 0;

  MYSQL *con = mysql_init(NULL);
	
  if (con == NULL) 
  {
    fprintf(stderr, "%s\n", mysql_error(con));
    printf("init connection: %s\n", mysql_error(con));
    return 1;
  }
	
  if (mysql_real_connect(con, SERVER_IP, USER, PWD, 
			  "logs", 0, NULL, 0) == NULL) 
  {
    fprintf(stderr, "%s\n", mysql_error(con));
    printf("real connection: %s\n", mysql_error(con));
    mysql_close(con);
    return 1;
  }

  sprintf(query_str, "select pulses from `water_flow` where date(`time`) = date(now()) ORDER by `time` DESC LIMIT 1");


  if (mysql_query(con, query_str)) 
  {
    //fprintf(stderr, "%s\n", mysql_error(con));
    printf("query: %s\n", mysql_error(con));
    mysql_close(con);
    //return 1;
  }

  MYSQL_RES *res = mysql_use_result(con);

  MYSQL_ROW row;
  if ((row = mysql_fetch_row (res))) 
  {
    /* Each field in represented by the string row[i] */
    /* If the field you want to extract is an int, so you need to convert it */
    pulses = atoi(row[0]);
  }

  mysql_close(con);
  return pulses;

}
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
int sendValuesToDB(uint16_t pulse, float waterFlow, uint8_t voltage)
{
	char query_str[100], query_cleanup[100];

	//printf("MySQL client version: %s\n", mysql_get_client_info());
	
	MYSQL *con = mysql_init(NULL);
	
	if (con == NULL) 
	{
<<<<<<< HEAD
		//fprintf(stderr, "%s\n", mysql_error(con));
=======
		fprintf(stderr, "%s\n", mysql_error(con));
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
		printf("init connection: %s\n", mysql_error(con));
		return 1;
	}
	
	if (mysql_real_connect(con, "192.168.1.78", "pi", "raspberry", 
			  "logs", 0, NULL, 0) == NULL) 
	{
<<<<<<< HEAD
		//fprintf(stderr, "%s\n", mysql_error(con));
=======
		fprintf(stderr, "%s\n", mysql_error(con));
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
		printf("real connection: %s\n", mysql_error(con));
		mysql_close(con);
		return 1;
	}
	
<<<<<<< HEAD
	sprintf(query_str, "insert into water_flow (pulses, waterflow, time) values (%u, %u, now())", pulse, waterFlow);
	
	//printf("q: %s\n", query_str);
	}
=======
	sprintf(query_str, "insert into water_flow (pulses, waterflow, time) values (%u, %f, now())", pulse, waterFlow);
	
	//printf("q: %s\n", query_str);
	
	if (mysql_query(con, query_str)) 
	{
		//fprintf(stderr, "%s\n", mysql_error(con));
		printf("query: %s\n", mysql_error(con));
		mysql_close(con);
		//return 1;
	}
	
>>>>>>> 5ef658a2952c847d06e09304367bf02b62013076
	//printf("055\n");
	//printf("successful q: %s\n", query_str);
	
	// cleanup old values
	sprintf(query_cleanup, "delete from water_flow where time < (now() - interval 1 day)");
	
	//printf("q: %s\n", query_cleanup);
	//printf("040\n");
	if (mysql_query(con, query_cleanup)) 
	{
		//fprintf(stderr, "%s\n", mysql_error(con));
		printf("query cleanup: %s\n", mysql_error(con));
		mysql_close(con);
		//return 1;
	}
	//printf("successful q: %s\n", query_cleanup);
	mysql_close(con);
	
	
	return 0;
}
