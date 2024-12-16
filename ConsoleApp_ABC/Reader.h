#ifndef READER_H
#define READER_H

#include "Library.h"
#include "Logger.h"
#include <vector>

// The Reader class represents a user who interacts with a library system.
class Reader {
public:
    // Constructor initializes a Reader with an ID, a reference to the library system, and a logger.
    Reader(int reader, LibraryManager *library, Logger *logger);

    // Entry point for the Reader's main logic.
    void run();

private:
    int id; // Unique identifier for the Reader.
    LibraryManager* library; // Pointer to the LibraryManager handling library operations.
    Logger* logger; // Pointer to the Logger for recording events.

    // Allows the Reader to choose a set of books from the library.
    std::vector<int> choose();

    // Simulates reading the selected books.
    void read(const std::vector<int>& books);

    // Handles books that could not be obtained during the selection.
    void collectMissed(const std::vector<int>& missed);
};

#endif // READER_H
