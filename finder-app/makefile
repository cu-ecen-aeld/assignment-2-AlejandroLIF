CC = $(CROSS_COMPILE)gcc
CFLAGS = -Wall
SRCDIR = src
OBJDIR = obj

.PHONY : all
all: writer

writer: writer.o
	@$(CC) $(addprefix $(OBJDIR)/, $^) -o $@

writer.o : $(SRCDIR)/writer.c
	@mkdir -p $(OBJDIR)
	$(CC) -o $(addprefix $(OBJDIR)/, $@) -c $^

.PHONY : clean
clean:
	@rm -rf $(OBJDIR)