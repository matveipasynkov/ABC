#include "Reader.h"
#include <__random/random_device.h>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <random>
#include <unistd.h>

// Constructor: Initializes the Reader with an ID, a reference to the library system, and a logger.
Reader::Reader(int reader, LibraryManager *library, Logger *logger) {
    this->id = reader;
    this->library = library;
    this->logger = logger;
}

// Method to choose a random set of books from the library.
std::vector<int> Reader::choose() {
    std::random_device rd; // Seed for random number generation.
    std::mt19937 gen(rd()); // Random number generator.
    int numBooks = gen() % 3 + 1; // Randomly determine the number of books (1-3).
    std::vector<int> chosenBooks;
    chosenBooks.reserve(numBooks);

    // Select unique book IDs.
    while ((int) chosenBooks.size() < numBooks) {
        int bookId = gen() % library->count_of_books;
        if (std::find(chosenBooks.begin(), chosenBooks.end(), bookId) == chosenBooks.end()) {
            chosenBooks.push_back(bookId);
        }
    }
    return chosenBooks;
}

// Method to simulate reading the selected books.
void Reader::read(const std::vector<int> &books) {
    std::random_device rd; // Seed for random delay.
    std::mt19937 gen(rd());

    // Log the books being read.
    std::string msg = "Reader (" + std::to_string(id) + ") is reading books: ";
    for (auto book: books)
        msg += std::to_string(book) + " ";
    msg += "\n";
    logger->log(msg);

    // Simulate reading time with a delay.
    usleep((gen() % 3 + 1) * 1000);
}

// Method to handle books that were not available initially.
void Reader::collectMissed(const std::vector<int> &missed) {
    for (int book: missed) {
        pthread_mutex_lock(&library->mutexes[book]); // Lock the mutex for the book.

        struct timespec timeout;
        timeout.tv_sec = time(nullptr) + 5; // Set a timeout of 5 seconds.
        timeout.tv_nsec = 0;

        // Wait for the book to become available or timeout.
        while (!library->free_books[book]) {
            if (pthread_cond_timedwait(&library->conditions[book], &library->mutexes[book], &timeout) ==
                ETIMEDOUT) {
                // Log timeout event.
                logger->log("Reader (" + std::to_string(id) +
                    ") surpassed the wait time for book " + std::to_string(book) + ".\n");
                pthread_mutex_unlock(&library->mutexes[book]); // Unlock and exit.
                return;
            }
        }

        // Book is now available.
        library->free_books[book] = false;
        logger->log("Reader (" + std::to_string(id) +
            ") was notified about the availability of book " + std::to_string(book) +
            " and successfully took it.\n");
        pthread_mutex_unlock(&library->mutexes[book]); // Unlock the mutex.

        // Read the book.
        read({book});

        // Return the book to the library after reading.
        library->returnBackToLibrary(id, {book});
    }
}

// Main method to simulate the Reader's interaction with the library.
void Reader::run() {
    std::random_device rd; // Seed for random delays.
    std::mt19937 gen(rd());

    // Simulate multiple visits to the library.
    for (int visit = 0; visit < 3; ++visit) { // Number of visits can be adjusted.
        // Choose books for the current visit.
        std::vector<int> required_books = choose();
        std::vector<int> used_books;
        std::vector<int> missed;

        // Attempt to obtain the books from the library.
        library->receiveBooksFromLibrary(id, required_books, used_books, missed);

        // Read the books that were obtained.
        if (!used_books.empty()) {
            read(used_books);
            library->returnBackToLibrary(id, used_books);
        }

        // Handle books that were missed.
        if (!missed.empty()) {
            logger->log("Reader (" + std::to_string(id) + ") is waiting missing books.\n");
            usleep((gen() % 3 + 1) * 1000); // Wait before retrying.
            collectMissed(missed);
        }

        // Simulate delay between visits.
        usleep((gen() % 3 + 1) * 1000);
    }

    // Log the end of the Reader's visits.
    logger->log("Reader (" + std::to_string(id) + ") stopped his visits to the library.\n");
}
