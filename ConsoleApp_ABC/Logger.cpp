#include "Logger.h"

// Constructor: Initializes the console and file output streams, and initializes the mutex for thread safety
Logger::Logger(std::ostream &console, std::ofstream &file) : console(console), file(file) {
    pthread_mutex_init(&mutex, nullptr);  // Initialize the mutex for logging synchronization
}

// Destructor: Destroys the mutex when the Logger object is destroyed
Logger::~Logger() {
    pthread_mutex_destroy(&mutex);  // Clean up the mutex
}

// Log method: Logs a message to both console and file, ensuring thread-safety
void Logger::log(const std::string &message) {
    pthread_mutex_lock(&mutex);    // Lock the mutex to ensure thread-safe logging

    // Write the message to both the console and the file
    console << message;
    file << message;

    // Flush the output streams to ensure the message is immediately written to the outputs
    console.flush();
    file.flush();

    pthread_mutex_unlock(&mutex);  // Unlock the mutex after logging
}
