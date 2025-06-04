# Diretórios
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

# Nome do executável
TARGET := $(BIN_DIR)/jogo

# Arquivos fonte
ASM_SOURCES := $(wildcard $(SRC_DIR)/*.asm)
OBJ_FILES   := $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(ASM_SOURCES))

# Compilador e flags
NASM := nasm
NASM_FLAGS := -f elf64
LD := ld
LD_FLAGS := 

# Regra principal
all: create_dirs $(TARGET)

# Cria diretórios se não existirem
create_dirs:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR)

# Linkagem para criar o executável
$(TARGET): $(OBJ_FILES)
	$(LD) $(LD_FLAGS) -o $@ $^

# Compilação dos arquivos assembly
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(NASM) $(NASM_FLAGS) -o $@ $<

# Limpeza
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

.PHONY: all create_dirs clean
