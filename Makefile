CROSS_COMPILE = aarch64-linux-gnu-
CC = $(CROSS_COMPILE)gcc

CFLAGS= -Wall -O2 -ffreestanding -nostdinc -nostdlib -nostartfiles $(DIRECTIVES)
CSRCFLAGS= -Wall -Wextra -mgeneral-regs-only
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


all: $(ASM_OBJS) $(KER_OBJS) $(LIB_OBJS) link

$(OBJ_DIR)/%.o: $(KER_SRCDIR)/%.S
	@mkdir -p $(@D)
	$(info Building: $@)
	@$(CC) -I$(KER_HEADDIR) -c $< -o $@

$(OBJ_DIR)/%.o: $(KER_SRCDIR)/%.c
	@mkdir -p $(@D)
	$(info Building: $@)
	@$(CC) $(CFLAGS) -I$(KER_HEADDIR) -c $< -o $@ $(CSRCFLAGS)

$(OBJ_DIR)/%.o: $(LIB_SRCDIR)/%.c
	@mkdir -p $(@D)
	$(info Building: $@)
	@$(CC) $(CFLAGS) -I$(KER_HEADDIR) -I$(LIB_HEADDIR) -c $< -o $@ $(CSRCFLAGS)

link: $(OBJS)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)
	@echo $(OBJS)
	@$(CROSS_COMPILE)ld -T $(KER_SRCDIR)/linker.ld -o $(BIN_DIR)/kernel8.elf $(OBJS)
	@$(CROSS_COMPILE)objcopy $(BIN_DIR)/kernel8.elf -O binary $(BIN_DIR)/kernel8.img

clean:
	rm -rf $(OBJ_DIR)
	rm -rf $(BIN_DIR)

run:
	qemu-system-aarch64 -M raspi3b -serial stdio -kernel $(BIN_DIR)/kernel8.img

debug:
	qemu-system-aarch64 -M raspi3b -serial stdio -kernel $(BIN_DIR)/kernel8.elf -s -S