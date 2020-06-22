NAME = single
OBJ = main.o framework_init.o utility.o test_function.o createLatinSquares.o
CC = gcc
CFLAGS = -I. -Wall -Werror

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

all: $(OBJ)
	$(CC) $(CFLAGS) -o $(NAME) $^

.PHONY: clean
clean:
	rm -f $(NAME) $(OBJ)