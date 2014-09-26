# This makefile is very brief since it intends to make use
# of the built-in knowledge in the make program, as much as possible.
CC = gcc

# -g: store symbols for the debugger
# -O4: optimization level 4
CFLAGS = -g -O4
LOADLIBES = -lm

# The executable "lang" needs the following object files.
mcar: mcar.o ran.o common.o pcorr.o conf.o

# These object files depend on the following header files:
mcar.o common.o vcorr.o conf.o: common.h pcorr.h Vec.h ran.h

ran.o: ran.c ran.h
