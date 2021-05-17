#ifndef _WII_LOG_H
#define _WII_LOG_H

#define WII_PATH                "sd:/msx/"
#define WII_PATH_LOG            WII_PATH "lastrun.log"

void wii_log_start(void);
void wii_log_stop(void);
void wii_log(const char*, const char*);
void wii_log_str(const char*, const char*, char*);
void wii_log_int(const char*, const char*, int);

#endif
