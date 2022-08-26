CROSS_COMPILE = aarch64-linux-gnu-
CC = $(CROSS_COMPILE)gcc

CFLAGS= -ffreestanding $(DIRECTIVES)
CSRCFLAGS= -Wall -Wextra
LFLAGS= -ffreestanding -O2 -nostdlib


OBJ_DIR = build
BIN_DIR = bin

KER_SRCDIR = kernel/src
KER_HEADDIR = kernel/include
KER_SRCS = $(wildcard $(KER_SRCDIR)/*.c)
KER_HEAD = $(wildcard $(KER_HEADDIR)/*.h)
KER_OBJS := $(patsubst $(KER_SRCDIR)/%.c, $(OBJ_DIR)/%.o, $(KER_SRCS))

ASM_SRCS = $(wildcard $(KER_SRCDIR)/*.S)
ASM_OBJS := $(patsubst $(KER_SRCDIR)/%.S, $(OBJ_DIR)/%.o, $(ASM_SRCS))

LIB_SRCDIR = lib/src
LIB_HEADDIR = lib/include
LIB_SRCS = $(wildcard $(LIB_SRCDIR)/*.c)
LIB_HEAD = $(wildcard $(LIB_HEADDIR)/*.h)
LIB_OBJS := $(patsubst $(LIB_SRCDIR)/%.c, $(OBJ_DIR)/%.o, $(LIB_SRCS))


OBJS = $(ASM_OBJS) $(KER_OBJS) $(LIB_OBJS)


all: clean $(ASM_OBJS) $(KER_OBJS) $(LIB_OBJS) link

$(OBJ_DIR)/%.o: $(KER_SRCDIR)/%.S
	@mkdir -p $(@D)
	$(info Building: $@)
	@$(CROSS_COMPILE)as -c $< -o $@

$(OBJ_DIR)/%.o: $(KER_SRCDIR)/%.c
	@mkdir -p $(@D)
	$(info Building: $@)
	@$(CC) $(CFLAGS) -I$(KER_HEADDIR) -c $< -o $@ $(CSRCFLAGS)

$(OBJ_DIR)/%.o: $(LIB_SRCDIR)/%.c
	@mkdir -p $(@D)
	$(info Building: $@)
	@$(CC) $(CFLAGS) -I$(KER_HEADDIR) -I$(LIB_HEADDIR) -c $< -o $@ $(CSRCFLAGS)

link: $(OBJS)
	@echo $(OBJS)

clean:
	rm -rf $(OBJ_DIR)
	rm -rf $(BIN_DIR)