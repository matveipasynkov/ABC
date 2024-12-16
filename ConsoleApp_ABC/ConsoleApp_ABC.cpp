#include <__random/random_device.h>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <iostream>
#include <limits>
#include <pthread.h>
#include <random>
#include <string>
#include <vector>
#include "Library.h"
#include "Logger.h"
#include "Reader.h"

// Structure for passing data to the thread
struct ThreadData {
    Reader *reader;
};

// Function executed by each thread
void *threadFunction(void *arg) {
    auto data = static_cast<ThreadData *>(arg);
    data->reader->run();
    return nullptr;
}

// Function to parse the configuration file
bool parseConfigFile(const std::string &filePath, int &booksCount, int &readersCount, std::string &outputPath) {
    std::ifstream inputFile(filePath);
    if (!inputFile.is_open()) {
        std::cerr << "Error: Unable to open configuration file: " << filePath << std::endl;
        return false;
    }

    std::string currentLine;
    while (std::getline(inputFile, currentLine)) {
        // Ignore lines with comments or empty content
        if (currentLine.empty() || currentLine[0] == '#') {
            continue;
        }

        size_t separatorIndex = currentLine.find('=');
        if (separatorIndex == std::string::npos) {
            continue;
        }

        std::string parameterName = currentLine.substr(0, separatorIndex);
        std::string parameterValue = currentLine.substr(separatorIndex + 1);

        // Remove extra spaces from key and value
        parameterName.erase(std::remove_if(parameterName.begin(), parameterName.end(), ::isspace), parameterName.end());
        parameterValue.erase(std::remove_if(parameterValue.begin(), parameterValue.end(), ::isspace), parameterValue.end());

        if (parameterName == "N") {
            booksCount = std::stoi(parameterValue);
        } else if (parameterName == "M") {
            readersCount = std::stoi(parameterValue);
        } else if (parameterName == "outputFile") {
            outputPath = parameterValue;
        }
    }

    inputFile.close();
    return true;
}

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "Russian");

    // Initialize random number generator
    std::random_device rd;
    std::mt19937 gen(rd());

    int N = 0; // Number of books
    int M = 0; // Number of readers
    std::string outputFile = ""; // Output file path
    std::string configFile = ""; // Configuration file path

    // Process command line arguments
    for (int index = 1; index < argc; ++index) {
        std::string currentArg = argv[index];

        if ((currentArg == "-n" || currentArg == "--books") && index + 1 < argc) {
            N = std::atoi(argv[++index]);
        }
        else if ((currentArg == "-m" || currentArg == "--readers") && index + 1 < argc) {
            M = std::atoi(argv[++index]);
        }
        else if ((currentArg == "-o" || currentArg == "--output") && index + 1 < argc) {
            outputFile = argv[++index];
            std::cout << "Output file specified: " << outputFile << std::endl;
        }
        else if ((currentArg == "-c" || currentArg == "--config") && index + 1 < argc) {
            configFile = argv[++index];
        }
        else if (currentArg == "-h" || currentArg == "--help") {
            std::cout << "Usage: " << argv[0]
                      << " [-n num_books] [-m num_readers] [-o output_file] [-c config_file]\n";
            return 0;
        }
    }

    // If a config file is provided, read from it
    if (!configFile.empty()) {
        if (!parseConfigFile(configFile, N, M, outputFile)) {
            std::cerr << "Failed to load configuration file.\n";
            return 1;
        }
        if (N <= 2) {
            std::cout << "Invalid input. N must be greater or equal than 3. Try again: ";
            while (!(std::cin >> N) || N <= 2) {
                std::cout << "Invalid input. N must be greater or equal than 3. Try again: ";
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            }
        }

        if (M <= 0) {
            std::cout << "Input error. Please enter a positive integer for M: ";
            while (!(std::cin >> M) || M <= 0) {
                std::cout << "Input error. Please enter a positive integer for M: ";
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            }
        }
        if (outputFile.empty()) {
            std::cout << "Provide the output file name: ";
            std::cin >> outputFile;
        } else {
            std::cout << "Output file already set to: " << outputFile << std::endl;
        }
    } else {
        // If no config file, ask for user input
        if (N <= 2) {
            std::cout << "Please specify the number of books (N): ";
            while (!(std::cin >> N) || N <= 2) {
                std::cout << "Invalid input. N must be greater or equal than 3. Try again: ";
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            }
        }

        if (M <= 0) {
            std::cout << "Specify the number of readers (M): ";
            while (!(std::cin >> M) || M <= 0) {
                std::cout << "Input error. Please enter a positive integer for M: ";
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            }
        }

        if (outputFile.empty()) {
            std::cout << "Provide the output file name: ";
            std::cin >> outputFile;
        } else {
            std::cout << "Output file already set to: " << outputFile << std::endl;
        }
    }

    // Open output file
    std::ofstream ofs(outputFile);
    if (!ofs.is_open()) {
        std::cerr << "It's impossible to read output file: " << outputFile << std::endl;
        return 1;
    }

    // Create Logger object
    Logger logger(std::cout, ofs);

    // Create LibraryManager object
    LibraryManager library(N, &logger);

    // Create Reader objects
    std::vector<Reader *> readers;
    readers.reserve(M);
    for (int i = 0; i < M; ++i) {
        readers.push_back(new Reader(i + 1, &library, &logger));
    }

    // Create threads for each reader
    std::vector<pthread_t> threads(M);
    std::vector<ThreadData> threadData(M);
    for (int i = 0; i < M; ++i) {
        threadData[i].reader = readers[i];
        if (pthread_create(&threads[i], nullptr, threadFunction, &threadData[i]) != 0) {
            std::cerr << "It's impossible to make a thread for reader " << i + 1 << std::endl;
            return 1;
        }
    }

    // Wait for threads to finish
    for (int i = 0; i < M; ++i) {
        pthread_join(threads[i], nullptr);
    }

    // Cleanup resources
    for (int i = 0; i < M; ++i) {
        delete readers[i];
    }

    ofs.close();
    std::cout << "Simulation is finished. Results saved in " << outputFile << std::endl;
    return 0;
}
