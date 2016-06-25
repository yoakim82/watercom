installing mysql client libs:

sudo apt-get update
sudo apt-get install libmysqlclient-dev

using it:

#include <mysql/mysql.h>

Add flags to LIBS and CFLAGS sections of makefile:

`mysql_config --libs`

`mysql_config --cflags`

