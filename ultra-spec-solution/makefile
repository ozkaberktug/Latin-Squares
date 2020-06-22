BINDIR  := ./bin
INCLUDE := ./include
OBJDIR  := ./obj
SRCDIR  := ./src
SOURCES := main.cu samples.cu utility.cu framework.cu computation.cu test_function.cu
OBJECTS := main.o  samples.o  utility.o  framework.o  computation.o  test_function.o
EXEC := biltek
CC := nvcc
CFLAGS := -I$(INCLUDE) -Wno-deprecated-gpu-targets

_OBJ = $(SOURCES:.cu=.o)
OBJ = $(patsubst %,$(OBJDIR)/%,$(_OBJ))

all: $(BINDIR)/$(EXEC)

$(BINDIR)/$(EXEC): $(OBJ)
	$(CC) -o $(BINDIR)/$(EXEC) $(OBJ) $(CFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cu
	$(CC) -dc -o $@ $< $(CFLAGS)

clean:
	rm -vf $(BINDIR)/$(EXEC) $(OBJ)
