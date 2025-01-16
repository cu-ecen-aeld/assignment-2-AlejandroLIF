#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <syslog.h>

#define kOk 0
#define kErr 1

void log_usage()
{
    syslog(LOG_INFO, "USAGE: writer filepath strout");
    syslog(LOG_INFO, "\tfilepath: path to the output file.");
    syslog(LOG_INFO, "\t\t* Directory must exist.");
    syslog(LOG_INFO, "\t\t* Will create new file if it does not exist, or overwrite an existing one.");
    syslog(LOG_INFO, "\tstrout: string contents to write to file.");
}

int writer(const char *filepath, const char *strout)
{
    errno = 0;
    const size_t strout_len = strlen(strout);
    FILE *fileout = fopen(filepath, "w");
    int status = kOk;
    size_t bytes_written;
    if (fileout == NULL)
    {
        int err = errno;
        syslog(LOG_ERR, "Failed to open file '%s' for writing. ERRNO='%d'", filepath, err);
        return kErr;
    }
    syslog(LOG_DEBUG, "Writing string %s to file %s", strout, filepath);
    bytes_written = fwrite(strout, 1, strout_len, fileout);
    if (bytes_written != strout_len)
    {
        syslog(LOG_ERR, "Failed to write file contents. Byte count mismatch. "
                        "EXPECTED='%lu' ACTUAL='%lu'",
               strout_len, bytes_written);
        status = kErr;
    }
    fclose(fileout);
    return status;
}

int main(int argc, char **argv)
{
    setlogmask(LOG_UPTO(LOG_DEBUG));
    openlog("aeld-assignment2-writer", LOG_CONS | LOG_PID | LOG_PERROR, LOG_LOCAL0);

    char *filepath;
    char *strout;
    int status = kOk;
    const int kExpectedArgc = 3;
    if (argc != kExpectedArgc)
    {
        syslog(LOG_ERR, "Incorrect argument count. EXPECTED='%d' ACTUAL='%d'", kExpectedArgc, argc);
        log_usage();
        closelog();
        return kErr;
    }

    filepath = argv[1];
    strout = argv[2];
    status = writer(filepath, strout);

    closelog();
    return status;
}
