CC=nvcc
CFLAGS=-Wno-deprecated-gpu-targets -I.
OBJ=framework.o utility.o main.o test_func.o

%.o: %.cu
	$(CC) $(CFLAGS) -dc -o $@ $<

all: $(OBJ)
	$(CC) $(CFLAGS) -o biltek $^

.PHONY : clean
clean :
	rm -f biltek $(OBJ)
