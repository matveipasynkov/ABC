#ifndef LIBRARY_H
#define LIBRARY_H

#include <pthread.h>
#include <vector>
#include <string>
#include "Logger.h"

class LibraryManager {
public:
    int count_of_books;                  // Total number of books in the library
    std::vector<bool> free_books;        // A vector to track which books are free (true = available, false = taken)
    std::vector<pthread_mutex_t> mutexes; // Mutexes for each book to prevent race conditions
    std::vector<pthread_cond_t> conditions; // Condition variables for synchronization (e.g., wait for book availability)

    // Constructor, initializes the library with the number of books and a logger object
    LibraryManager(int count, Logger* logger_ptr);

    // Destructor
    ~LibraryManager();

    // Method to receive books from the library: takes a reader's ID, the books they want, and returns info about what was taken or missed
    void receiveBooksFromLibrary(int readerId, const std::vector<int>& required_books, std::vector<int>& used_books, std::vector<int>& missed);

    // Method for returning books to the library
    void returnBackToLibrary(int readerId, const std::vector<int>& books);

private:
    Logger* logger;  // Pointer to a logger object, assuming it's used to log activities

    // Delete copy constructor and assignment operator to avoid copying the LibraryManager object
    LibraryManager(const LibraryManager&) = delete;
    LibraryManager& operator=(const LibraryManager&) = delete;
};

#endif // LIBRARY_H
