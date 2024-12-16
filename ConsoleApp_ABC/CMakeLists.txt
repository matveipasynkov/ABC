cmake_minimum_required(VERSION 3.30)
project(ConsoleApp_ABC)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(ConsoleApp_ABC
    ConsoleApp_ABC.cpp
    Library.cpp
    Library.h
    Logger.cpp
    Logger.h
    Reader.cpp
    Reader.h)
