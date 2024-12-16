#ifndef LOGGER_H
#define LOGGER_H

#include <iostream>
#include <fstream>
#include <pthread.h>
#include <string>

// Logger class for logging messages to both console and file
class Logger {
public:
    // Constructor initializes output streams and mutex
    Logger(std::ostream& console, std::ofstream& file);

    // Destructor to clean up any resources
    ~Logger();

    // Method to log messages to both console and file
    void log(const std::string& message);

private:
    std::ostream& console;   // Output stream for console (usually std::cout)
    std::ofstream& file;     // Output file stream
    pthread_mutex_t mutex;   // Mutex for thread synchronization when logging
    Logger(const Logger&) = delete;  // Delete copy constructor to prevent copying
    Logger& operator=(const Logger&) = delete; // Delete copy assignment operator to prevent assignment
};

#endif // LOGGER_H
