#include <winsock2.h>
#include <windows.h>
#include <fcntl.h>
#include <io.h>
#include <string>
#include <winnls.h>

#include "ADM_default.h"
#include "ADM_win32.h"
#include "ADM_misc.h"
#include <algorithm>
void redirectStdoutToFile(const char *logFile)
{
    // Don't redirect stdout and stderr if SDL hasn't already hijacked it.
    // This allows us to optionally compile all EXEs as console applications
    // so the output can be printed to the terminal for debugging purposes.

     // Close SDL generated logs and briefly redirect to NUL
     //freopen("NUL", "w", stdout);
     //freopen("NUL", "w", stderr);

    // Remove SDL logs to avoid confusion
    char path[MAX_PATH];
    char stdoutPath[MAX_PATH];
    char stderrPath[MAX_PATH];
    DWORD pathlen = GetModuleFileName(NULL, path, MAX_PATH);

    while (pathlen > 0 && path[pathlen] != '\\')
        pathlen--;

    path[pathlen] = '\0';

    strcpy(stdoutPath, path);
    strcat(stdoutPath, "\\stdout.txt");
    strcpy(stderrPath, path);
    strcat(stderrPath, "\\stderr.txt");

    remove(stdoutPath);
    remove(stderrPath);

    // Redirect output to log file in the user's profile directory
    std::string filePath=std::string(ADM_getLogDir())+std::string(logFile);

    FILE *stream = fopen(filePath.c_str(), "w");

    if (stream)
    {
        fclose(stdout);
        fclose(stderr);

        *stdout = *stream;
        *stderr = *stream;
    }
}
