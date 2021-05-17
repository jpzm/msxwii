#include <stdio.h>
#include "WiiLog.h"

void wii_log_start(void)
{
    FILE *WII_LOG_FP = fopen(WII_PATH_LOG, "w");
    fprintf(WII_LOG_FP, "[%s] %s.\n", "log", "start");
    fflush(WII_LOG_FP);
    fclose(WII_LOG_FP);
}

void wii_log_stop(void)
{
    FILE *WII_LOG_FP = fopen(WII_PATH_LOG, "a");
    fprintf(WII_LOG_FP, "[%s] %s.\n", "log", "stop");
    fflush(WII_LOG_FP);
    fclose(WII_LOG_FP);
}

void wii_log(const char* module, const char* info)
{
    FILE *WII_LOG_FP = fopen(WII_PATH_LOG, "a");
    fprintf(WII_LOG_FP, "[%s] %s.\n", module, info);
    fflush(WII_LOG_FP);
    fclose(WII_LOG_FP);
}

void wii_log_str(const char* module, const char* info, char* var)
{
    FILE *WII_LOG_FP = fopen(WII_PATH_LOG, "a");
    fprintf(WII_LOG_FP, "[%s] %s %s.\n", module, info, var);
    fflush(WII_LOG_FP);
    fclose(WII_LOG_FP);
}

void wii_log_int(const char* module, const char* info, int var)
{
    FILE *WII_LOG_FP = fopen(WII_PATH_LOG, "a");
    fprintf(WII_LOG_FP, "[%s] %s %d.\n", module, info, var);
    fflush(WII_LOG_FP);
    fclose(WII_LOG_FP);
}
