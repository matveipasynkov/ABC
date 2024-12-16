#include "Library.h"
#include <algorithm>
#include <unistd.h>

// Constructor: Initializes the LibraryManager with a given number of books and a logger
LibraryManager::LibraryManager(int count, Logger *logger_ptr) {
    count_of_books = count;
    free_books = std::vector<bool>(count, true); // Initialize all books as available (true)
    logger = logger_ptr;
    mutexes.resize(count);   // Resize the mutex vector to match the number of books
    conditions.resize(count); // Resize the condition variable vector to match the number of books

    // Initialize mutexes and condition variables for each book
    for (int i = 0; i < count_of_books; ++i) {
        if (pthread_mutex_init(&mutexes[i], nullptr) != 0) {
            logger->log("Error of mutex's initialization for book: " + std::to_string(i) + "\n");
        }
        if (pthread_cond_init(&conditions[i], nullptr) != 0) {
            logger->log("Error of condition's initialization for book: " + std::to_string(i) + "\n");
        }
    }
}

// Destructor: Destroys mutexes and condition variables for each book
LibraryManager::~LibraryManager() {
    for (int i = 0; i < count_of_books; ++i) {
        pthread_mutex_destroy(&mutexes[i]);
        pthread_cond_destroy(&conditions[i]);
    }
}

// Method to handle a reader's book request (receive books from the library)
void LibraryManager::receiveBooksFromLibrary(int readerId, const std::vector<int> &required_books,
                                             std::vector<int> &used_books, std::vector<int> &missed) {
    // Sort the books the reader wants in ascending order to avoid deadlock
    std::vector<int> sorted = required_books;
    std::sort(sorted.begin(), sorted.end());

    // Try to assign the books to the reader
    for (int book: sorted) {
        pthread_mutex_lock(&mutexes[book]); // Lock the mutex for the current book

        // Check if the book is available
        if (free_books[book]) {
            free_books[book] = false; // Mark the book as taken
            used_books.push_back(book); // Add the book to the list of books taken by the reader
            logger->log("Reader (" + std::to_string(readerId) +
                        ") has taken the book with id: " + std::to_string(book) + ".\n");
        } else {
            missed.push_back(book); // If the book is not available, add it to missed books
            logger->log("Reader (" + std::to_string(readerId) + ") hasn't any opportunities to take book with id:" +
                        std::to_string(book) + "; because it's busy right now.\n");
        }

        pthread_mutex_unlock(&mutexes[book]); // Unlock the mutex for the current book
    }
}

// Method to handle returning books to the library
void LibraryManager::returnBackToLibrary(int readerId, const std::vector<int> &books) {
    // Sort the books in ascending order to avoid deadlock when multiple books are returned
    std::vector<int> sorted = books;
    std::sort(sorted.begin(), sorted.end());

    // Try to return the books
    for (int book: sorted) {
        pthread_mutex_lock(&mutexes[book]); // Lock the mutex for the current book

        free_books[book] = true; // Mark the book as available
        pthread_cond_broadcast(&conditions[book]); // Notify all waiting threads that the book is now available
        logger->log("Reader (" + std::to_string(readerId) + ") got back book with id: " + std::to_string(book) + ".\n");

        pthread_mutex_unlock(&mutexes[book]); // Unlock the mutex for the current book
    }
}
